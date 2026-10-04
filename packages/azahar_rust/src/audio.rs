//! Audio output played through Oboe on Android.
//!
//! The core pushes 32728 Hz signed 16 bit stereo frames through a lock-free
//! ring buffer. A dedicated thread owns the Oboe stream (which is not `Send`),
//! reopens it when the device disconnects, and is joined when the
//! [`AudioOutput`] is dropped.

use std::panic::{AssertUnwindSafe, catch_unwind};
use std::sync::atomic::{AtomicBool, AtomicU32, Ordering};
use std::sync::mpsc::{self, Sender};
use std::sync::{Arc, Mutex};
use std::thread::JoinHandle;

use oboe::{
    AudioOutputCallback, AudioOutputStream, AudioOutputStreamSafe, AudioStream, AudioStreamAsync,
    AudioStreamBuilder, ContentType, DataCallbackResult, Output, PerformanceMode, SharingMode,
    Stereo, Usage,
};
use ringbuf::traits::{Consumer, Observer, Producer, Split};
use ringbuf::{HeapCons, HeapProd, HeapRb};

use crate::error::{AzaharError, Result};

/// Sample rate of the 3DS DSP output.
pub const SOURCE_SAMPLE_RATE: u32 = 32728;
const CHANNELS: usize = 2;
const BUFFER_FRAMES: usize = 8192;

struct Shared {
    producer: Mutex<HeapProd<i16>>,
    paused: AtomicBool,
    volume_bits: AtomicU32,
}

enum Control {
    Pause,
    Resume,
    /// The stream was closed by Oboe, usually because the device disconnected. The consumer of
    /// the ring buffer is handed back so a new stream can take it over.
    Reopen(HeapCons<i16>),
    Stop,
}

type OboeStream = AudioStreamAsync<Output, OboeCallback>;

/// Plays the audio of one session through Oboe.
pub struct AudioOutput {
    shared: Arc<Shared>,
    control: Sender<Control>,
    thread: Option<JoinHandle<()>>,
}

impl AudioOutput {
    /// Opens a low latency Oboe stream on the default output device and starts playback.
    pub fn new() -> Result<Self> {
        let ring = HeapRb::<i16>::new(BUFFER_FRAMES * CHANNELS);
        let (producer, consumer) = ring.split();
        let shared = Arc::new(Shared {
            producer: Mutex::new(producer),
            paused: AtomicBool::new(false),
            volume_bits: AtomicU32::new(1.0f32.to_bits()),
        });

        let (control, control_rx) = mpsc::channel();
        let (ready_tx, ready_rx) = mpsc::sync_channel::<std::result::Result<(), String>>(1);
        let thread_shared = Arc::clone(&shared);
        let thread_control = control.clone();
        let thread = std::thread::Builder::new()
            .name("azahar-audio".into())
            .spawn(move || {
                let opened = catch_unwind(AssertUnwindSafe(|| {
                    open_stream(consumer, &thread_shared, &thread_control)
                }));
                let mut stream = match opened {
                    Ok(Ok(stream)) => {
                        let _ = ready_tx.send(Ok(()));
                        Some(stream)
                    }
                    Ok(Err(error)) => {
                        let _ = ready_tx.send(Err(error));
                        return;
                    }
                    Err(payload) => {
                        let _ = ready_tx.send(Err(panic_message(payload.as_ref())));
                        return;
                    }
                };
                let mut retired: Option<OboeStream> = None;
                while let Ok(message) = control_rx.recv() {
                    match message {
                        Control::Pause => {
                            if let Some(stream) = stream.as_mut() {
                                let _ = stream.pause();
                            }
                        }
                        Control::Resume => {
                            if let Some(stream) = stream.as_mut() {
                                let _ = stream.start();
                            }
                        }
                        Control::Reopen(consumer) => {
                            retired = stream.take();
                            stream = catch_unwind(AssertUnwindSafe(|| {
                                open_stream(consumer, &thread_shared, &thread_control)
                            }))
                            .ok()
                            .and_then(|opened| opened.ok());
                        }
                        Control::Stop => break,
                    }
                }
                drop(stream);
                drop(retired);
            })
            .map_err(|error| AzaharError::Audio(error.to_string()))?;

        match ready_rx.recv() {
            Ok(Ok(())) => Ok(Self {
                shared,
                control,
                thread: Some(thread),
            }),
            Ok(Err(message)) => {
                let _ = thread.join();
                Err(AzaharError::Audio(message))
            }
            Err(_) => {
                let _ = thread.join();
                Err(AzaharError::Audio("audio thread exited early".into()))
            }
        }
    }

    /// Queues frames from the core. Frames are dropped while paused or when
    /// the buffer is full.
    pub fn push(&self, frames: &[i16]) {
        if self.shared.paused.load(Ordering::Acquire) {
            return;
        }
        if let Ok(mut producer) = self.shared.producer.lock() {
            producer.push_slice(frames);
        }
    }

    pub fn pause(&self) {
        self.shared.paused.store(true, Ordering::Release);
        let _ = self.control.send(Control::Pause);
    }

    pub fn resume(&self) {
        self.shared.paused.store(false, Ordering::Release);
        let _ = self.control.send(Control::Resume);
    }

    /// Sets the linear output gain, clamped to `0.0..=1.0`.
    pub fn set_volume(&self, volume: f32) {
        self.shared
            .volume_bits
            .store(volume.clamp(0.0, 1.0).to_bits(), Ordering::Release);
    }
}

impl Drop for AudioOutput {
    fn drop(&mut self) {
        let _ = self.control.send(Control::Stop);
        if let Some(thread) = self.thread.take() {
            let _ = thread.join();
        }
    }
}

fn panic_message(payload: &(dyn std::any::Any + Send)) -> String {
    if let Some(message) = payload.downcast_ref::<&str>() {
        return format!("the audio backend panicked: {message}");
    }
    if let Some(message) = payload.downcast_ref::<String>() {
        return format!("the audio backend panicked: {message}");
    }
    "the audio backend panicked".into()
}

/// Opens a low latency stereo float stream that reads from `consumer`, and starts it unless
/// the session is paused.
///
/// The stream keeps the rate the device prefers, so Oboe stays on its low latency path, and
/// the 3DS output is resampled to it in the data callback.
fn open_stream(
    consumer: HeapCons<i16>,
    shared: &Arc<Shared>,
    control: &Sender<Control>,
) -> std::result::Result<OboeStream, String> {
    let callback = OboeCallback {
        resampler: Some(Resampler::new(consumer)),
        shared: Arc::clone(shared),
        control: control.clone(),
    };
    let mut stream = AudioStreamBuilder::default()
        .set_performance_mode(PerformanceMode::LowLatency)
        .set_sharing_mode(SharingMode::Exclusive)
        .set_usage(Usage::Game)
        .set_content_type(ContentType::Music)
        .set_f32()
        .set_channel_count::<Stereo>()
        .set_callback(callback)
        .open_stream()
        .map_err(|error| format!("failed to open the Oboe stream: {error}"))?;
    if !shared.paused.load(Ordering::Acquire) {
        stream
            .start()
            .map_err(|error| format!("failed to start the Oboe stream: {error}"))?;
    }
    Ok(stream)
}

/// Data and error callbacks of one Oboe stream.
struct OboeCallback {
    resampler: Option<Resampler>,
    shared: Arc<Shared>,
    control: Sender<Control>,
}

impl AudioOutputCallback for OboeCallback {
    type FrameType = (f32, Stereo);

    fn on_audio_ready(
        &mut self,
        audio_stream: &mut dyn AudioOutputStreamSafe,
        audio_data: &mut [(f32, f32)],
    ) -> DataCallbackResult {
        let paused = self.shared.paused.load(Ordering::Acquire);
        let volume = f32::from_bits(self.shared.volume_bits.load(Ordering::Acquire));
        let Some(resampler) = self.resampler.as_mut() else {
            audio_data.fill((0.0, 0.0));
            return DataCallbackResult::Continue;
        };
        resampler.set_device_rate(audio_stream.get_sample_rate());
        for frame in audio_data.iter_mut() {
            let (left, right) = if paused {
                (0.0, 0.0)
            } else {
                resampler.next_frame()
            };
            *frame = (left * volume, right * volume);
        }
        DataCallbackResult::Continue
    }

    fn on_error_after_close(
        &mut self,
        _audio_stream: &mut dyn AudioOutputStreamSafe,
        _error: oboe::Error,
    ) {
        if let Some(resampler) = self.resampler.take() {
            let _ = self.control.send(Control::Reopen(resampler.into_consumer()));
        }
    }
}

struct Resampler {
    consumer: HeapCons<i16>,
    device_rate: i32,
    step: f64,
    position: f64,
    previous: (f32, f32),
    next: (f32, f32),
}

impl Resampler {
    fn new(consumer: HeapCons<i16>) -> Self {
        Self {
            consumer,
            device_rate: SOURCE_SAMPLE_RATE as i32,
            step: 1.0,
            position: 1.0,
            previous: (0.0, 0.0),
            next: (0.0, 0.0),
        }
    }

    /// Follows the rate of the device, which is only known once the stream has opened.
    fn set_device_rate(&mut self, device_rate: i32) {
        if device_rate <= 0 || device_rate == self.device_rate {
            return;
        }
        self.device_rate = device_rate;
        self.step = SOURCE_SAMPLE_RATE as f64 / device_rate as f64;
    }

    fn into_consumer(self) -> HeapCons<i16> {
        self.consumer
    }

    fn pop_frame(&mut self) -> (f32, f32) {
        if self.consumer.occupied_len() < CHANNELS {
            return (0.0, 0.0);
        }
        let left = self.consumer.try_pop().unwrap_or(0) as f32 / 32768.0;
        let right = self.consumer.try_pop().unwrap_or(0) as f32 / 32768.0;
        (left, right)
    }

    fn next_frame(&mut self) -> (f32, f32) {
        while self.position >= 1.0 {
            self.previous = self.next;
            self.next = self.pop_frame();
            self.position -= 1.0;
        }
        let t = self.position as f32;
        let left = self.previous.0 + (self.next.0 - self.previous.0) * t;
        let right = self.previous.1 + (self.next.1 - self.previous.1) * t;
        self.position += self.step;
        (left, right)
    }
}
