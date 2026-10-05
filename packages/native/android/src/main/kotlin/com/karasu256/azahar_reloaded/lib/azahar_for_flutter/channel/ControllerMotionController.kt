// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.hardware.input.InputManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.InputDevice
import io.flutter.plugin.common.EventChannel

/**
 * Reports the motion sensors built into a connected game controller on the controller motion
 * event channel, in m/s² for the accelerometer and rad/s for the gyroscope.
 *
 * The sensors of a controller are only reachable from Android 12 (API 31), so nothing is reported
 * on earlier versions. The sensors are only read while Dart listens to the channel, and the first
 * controller that has both sensors is used.
 */
class ControllerMotionController(context: Context) {
    private val inputManager = context.getSystemService(Context.INPUT_SERVICE) as InputManager
    private val handler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null
    private var sensorManager: SensorManager? = null
    private var accel: FloatArray? = null

    private val sensorListener = object : SensorEventListener {
        override fun onSensorChanged(event: SensorEvent) {
            when (event.sensor.type) {
                Sensor.TYPE_ACCELEROMETER -> accel = event.values.copyOf(3)
                Sensor.TYPE_GYROSCOPE -> {
                    val latestAccel = accel ?: return
                    eventSink?.success(
                        mapOf(
                            "accel" to latestAccel.map { it.toDouble() },
                            "gyro" to event.values.copyOf(3).map { it.toDouble() }
                        )
                    )
                }
            }
        }

        override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) = Unit
    }

    private val deviceListener = object : InputManager.InputDeviceListener {
        override fun onInputDeviceAdded(deviceId: Int) = restart()
        override fun onInputDeviceRemoved(deviceId: Int) = restart()
        override fun onInputDeviceChanged(deviceId: Int) = restart()
    }

    /** Creates the handler of the controller motion event channel. */
    fun createStreamHandler(): EventChannel.StreamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
            eventSink = events
            inputManager.registerInputDeviceListener(deviceListener, handler)
            start()
        }

        override fun onCancel(arguments: Any?) {
            inputManager.unregisterInputDeviceListener(deviceListener)
            stop()
            eventSink = null
        }
    }

    private fun restart() {
        stop()
        if (eventSink != null) start()
    }

    private fun start() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return
        for (id in InputDevice.getDeviceIds()) {
            val device = InputDevice.getDevice(id) ?: continue
            if (device.sources and InputDevice.SOURCE_GAMEPAD != InputDevice.SOURCE_GAMEPAD) {
                continue
            }
            val manager = device.sensorManager
            val accelerometer = manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER) ?: continue
            val gyroscope = manager.getDefaultSensor(Sensor.TYPE_GYROSCOPE) ?: continue
            manager.registerListener(
                sensorListener,
                accelerometer,
                SensorManager.SENSOR_DELAY_GAME,
                handler
            )
            manager.registerListener(
                sensorListener,
                gyroscope,
                SensorManager.SENSOR_DELAY_GAME,
                handler
            )
            sensorManager = manager
            return
        }
    }

    private fun stop() {
        sensorManager?.unregisterListener(sensorListener)
        sensorManager = null
        accel = null
    }
}
