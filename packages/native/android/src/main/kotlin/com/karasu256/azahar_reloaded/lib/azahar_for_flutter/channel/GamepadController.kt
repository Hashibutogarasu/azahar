package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.NativeLibrary

/**
 * Gives the gamepad and motion sensor input sent by Dart to the core, and reports each input it
 * handled on the gamepad event channel.
 */
class GamepadController {
    private var eventSink: EventChannel.EventSink? = null

    val handlers: List<AzaharMethodHandler> = listOf(SendGamePadEvent())

    /** Creates the handler of the gamepad event channel. */
    fun createStreamHandler(): EventChannel.StreamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
            eventSink = events
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }
    }

    private fun MethodCall.number(key: String): Number? = argument<Number>(key)

    private fun MethodCall.vector(key: String): FloatArray? =
        argument<List<Number>>(key)?.takeIf { it.size == 3 }?.map { it.toFloat() }?.toFloatArray()

    private inner class SendGamePadEvent : AzaharMethodHandler {
        override val name = "sendGamePadEvent"

        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val handled = when (call.argument<String>("kind")) {
                "button" -> sendButton(call)
                "axis" -> sendAxis(call)
                "motion" -> sendMotion(call)
                else -> false
            }
            if (!handled) {
                result.error("invalid_argument", "unknown gamepad event", null)
                return
            }
            @Suppress("UNCHECKED_CAST")
            eventSink?.success(call.arguments as Map<String, Any?>)
            result.success(null)
        }

        private fun sendButton(call: MethodCall): Boolean {
            val code = call.number("code")?.toInt() ?: return false
            val pressed = call.argument<Boolean>("pressed") ?: return false
            NativeLibrary.onGamePadEvent("", code, if (pressed) 1 else 0)
            return true
        }

        private fun sendAxis(call: MethodCall): Boolean {
            val code = call.number("code")?.toInt() ?: return false
            val x = call.number("x")?.toFloat() ?: return false
            val y = call.number("y")?.toFloat() ?: return false
            NativeLibrary.onGamePadMoveEvent("", code, x, -y)
            return true
        }

        private fun sendMotion(call: MethodCall): Boolean {
            val accel = call.vector("accel") ?: return false
            val gyro = call.vector("gyro") ?: return false
            NativeLibrary.setMotion(accel[0], accel[1], accel[2], gyro[0], gyro[1], gyro[2])
            return true
        }
    }
}
