//! Audio output owned by the session.
//!
//! The core pushes 32728 Hz signed 16 bit stereo frames through a lock-free
//! ring buffer. A dedicated thread owns the `cpal` stream (which is not
//! `Send`) and is joined when the [`AudioOutput`] is dropped.

use std::panic::{AssertUnwindSafe, catch_unwind};
use std::sync::atomic::{AtomicBool, AtomicU32, Ordering};
use std::sync::mpsc::{self, Sender};
use std::sync::{Arc, Mutex};
use std::thread::JoinHandle;

use cpal::traits::{DeviceTrait, HostTrait, StreamTrait};
use cpal::{FromSample, SampleFormat, SizedSample, StreamConfig};
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
    Stop,
}

/// Plays the audio of one session on the default output device.
pub struct AudioOutput {
    shared: Arc<Shared>,
    control: Sender<Control>,
    thread: Option<JoinHandle<()>>,
}

impl AudioOutput {
    /// Opens the default output device and starts playback.
    pub fn new() -> Result<Self> {
        prepare_platform();
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
        let thread = std::thread::Builder::new()
            .name("azahar-audio".into())
            .spawn(move || {
                let built = catch_unwind(AssertUnwindSafe(|| {
                    build_stream(consumer, thread_shared)
                }));
                let stream = match built {
                    Ok(Ok(stream)) => {
                        let _ = ready_tx.send(Ok(()));
                        stream
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
                while let Ok(message) = control_rx.recv() {
                    match message {
                        Control::Pause => {
                            let _ = stream.pause();
                        }
                        Control::Resume => {
                            let _ = stream.play();
                        }
                        Control::Stop => break,
                    }
                }
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

/// Makes the Android context known to the audio backend, which queries the audio system through
/// it. There is nothing to prepare elsewhere.
#[cfg(target_os = "android")]
fn prepare_platform() {
    use std::ffi::c_void;
    use std::sync::Once;

    unsafe extern "C" {
        fn azahar_host_java_vm() -> *mut c_void;
        fn azahar_host_application_context() -> *mut c_void;
    }

    static INITIALIZED: Once = Once::new();
    INITIALIZED.call_once(|| unsafe {
        let java_vm = azahar_host_java_vm();
        let context = azahar_host_application_context();
        if !java_vm.is_null() && !context.is_null() {
            ndk_context::initialize_android_context(java_vm, context);
        }
    });
}

#[cfg(not(target_os = "android"))]
fn prepare_platform() {}

fn build_stream(
    consumer: HeapCons<i16>,
    shared: Arc<Shared>,
) -> std::result::Result<cpal::Stream, String> {
    let device = cpal::default_host()
        .default_output_device()
        .ok_or_else(|| "no output device".to_string())?;
    let supported = device
        .default_output_config()
        .map_err(|error| error.to_string())?;
    let format = supported.sample_format();
    let config: StreamConfig = supported.config();

    let stream = match format {
        SampleFormat::F32 => build_typed::<f32>(&device, &config, consumer, shared),
        SampleFormat::I16 => build_typed::<i16>(&device, &config, consumer, shared),
        SampleFormat::U16 => build_typed::<u16>(&device, &config, consumer, shared),
        other => Err(format!("unsupported sample format {other:?}")),
    }?;
    stream.play().map_err(|error| error.to_string())?;
    Ok(stream)
}

fn build_typed<T>(
    device: &cpal::Device,
    config: &StreamConfig,
    consumer: HeapCons<i16>,
    shared: Arc<Shared>,
) -> std::result::Result<cpal::Stream, String>
where
    T: SizedSample + FromSample<f32>,
{
    let channels = config.channels as usize;
    let mut resampler = Resampler::new(consumer, config.sample_rate.0);
    device
        .build_output_stream(
            config,
            move |output: &mut [T], _| {
                let paused = shared.paused.load(Ordering::Acquire);
                let volume = f32::from_bits(shared.volume_bits.load(Ordering::Acquire));
                for frame in output.chunks_mut(channels) {
                    let (left, right) = if paused {
                        (0.0, 0.0)
                    } else {
                        resampler.next_frame()
                    };
                    let (left, right) = (left * volume, right * volume);
                    for (index, sample) in frame.iter_mut().enumerate() {
                        let value = match (channels, index) {
                            (1, _) => (left + right) * 0.5,
                            (_, 0) => left,
                            (_, 1) => right,
                            _ => 0.0,
                        };
                        *sample = T::from_sample(value);
                    }
                }
            },
            |_error| {},
            None,
        )
        .map_err(|error| error.to_string())
}

struct Resampler {
    consumer: HeapCons<i16>,
    step: f64,
    position: f64,
    previous: (f32, f32),
    next: (f32, f32),
}

impl Resampler {
    fn new(consumer: HeapCons<i16>, device_rate: u32) -> Self {
        Self {
            consumer,
            step: SOURCE_SAMPLE_RATE as f64 / device_rate as f64,
            position: 1.0,
            previous: (0.0, 0.0),
            next: (0.0, 0.0),
        }
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
