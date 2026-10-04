package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SystemVolumeController(context: Context) {
    private val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    private val appContext = context.applicationContext

    companion object {
        private const val VOLUME_CHANGED_ACTION = "android.media.VOLUME_CHANGED_ACTION"
        private const val EXTRA_VOLUME_STREAM_TYPE = "android.media.EXTRA_VOLUME_STREAM_TYPE"
    }

    private fun currentVolume(): Double {
        val current = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
        val max = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        return if (max == 0) 0.0 else current.toDouble() / max.toDouble()
    }

    val handlers: List<AzaharMethodHandler> = listOf(GetSystemMediaVolume(), SetSystemMediaVolume())

    private inner class GetSystemMediaVolume : AzaharMethodHandler {
        override val name = "getSystemMediaVolume"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            result.success(currentVolume())
        }
    }

    private inner class SetSystemMediaVolume : AzaharMethodHandler {
        override val name = "setSystemMediaVolume"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val volume = call.argument<Double>("volume") ?: 0.0
            val max = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
            val target = (volume.coerceIn(0.0, 1.0) * max).toInt()
            audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, target, 0)
            result.success(null)
        }
    }

    fun createVolumeChangeStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {
            private var receiver: BroadcastReceiver? = null

            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                val newReceiver = object : BroadcastReceiver() {
                    override fun onReceive(context: Context, intent: Intent) {
                        if (intent.action != VOLUME_CHANGED_ACTION) return
                        val streamType = intent.getIntExtra(EXTRA_VOLUME_STREAM_TYPE, -1)
                        if (streamType != AudioManager.STREAM_MUSIC) return
                        events.success(currentVolume())
                    }
                }
                receiver = newReceiver
                ContextCompat.registerReceiver(
                    appContext,
                    newReceiver,
                    IntentFilter(VOLUME_CHANGED_ACTION),
                    ContextCompat.RECEIVER_NOT_EXPORTED
                )
            }

            override fun onCancel(arguments: Any?) {
                receiver?.let { appContext.unregisterReceiver(it) }
                receiver = null
            }
        }
    }
}
