package org.citra.citra_emu.channel

import android.content.Context
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.PlaybackService

class MediaNotificationController(private val context: Context) {
    private var stopEventSink: EventChannel.EventSink? = null
    private var playPauseEventSink: EventChannel.EventSink? = null

    init {
        PlaybackService.onStopRequested = { stopEventSink?.success(null) }
        PlaybackService.onPlayPauseRequested = { playing -> playPauseEventSink?.success(playing) }
    }

    val handlers: List<AzaharMethodHandler> = listOf(
        ActivateMediaNotification(),
        UpdateMediaNotificationPlaybackState(),
        DeactivateMediaNotification()
    )

    fun createStopEventStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                stopEventSink = events
            }

            override fun onCancel(arguments: Any?) {
                stopEventSink = null
            }
        }
    }

    fun createPlayPauseEventStreamHandler(): EventChannel.StreamHandler {
        return object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                playPauseEventSink = events
            }

            override fun onCancel(arguments: Any?) {
                playPauseEventSink = null
            }
        }
    }

    private inner class ActivateMediaNotification : AzaharMethodHandler {
        override val name = "activateMediaNotification"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val title = call.argument<String>("title") ?: ""
            val artworkPath = call.argument<String>("artworkPath")
            val isPlaying = call.argument<Boolean>("isPlaying") ?: true
            PlaybackService.activate(context, title, artworkPath, isPlaying)
            result.success(null)
        }
    }

    private inner class UpdateMediaNotificationPlaybackState : AzaharMethodHandler {
        override val name = "updateMediaNotificationPlaybackState"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val isPlaying = call.argument<Boolean>("isPlaying") ?: true
            PlaybackService.updatePlaybackState(isPlaying)
            result.success(null)
        }
    }

    private inner class DeactivateMediaNotification : AzaharMethodHandler {
        override val name = "deactivateMediaNotification"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            PlaybackService.deactivate()
            result.success(null)
        }
    }
}
