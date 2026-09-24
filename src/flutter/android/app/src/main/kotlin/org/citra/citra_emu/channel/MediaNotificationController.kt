package org.citra.citra_emu.channel

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.BitmapFactory
import android.support.v4.media.MediaMetadataCompat
import android.support.v4.media.session.MediaSessionCompat
import android.support.v4.media.session.PlaybackStateCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.media.app.NotificationCompat as MediaNotificationCompat
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.EmulationActivity
import org.citra.citra_emu.emucore.R

class MediaNotificationController(private val context: Context) {
    private var session: MediaSessionCompat? = null
    private var title: String = ""
    private var artworkPath: String? = null
    private var isPlaying = true
    private var receiverRegistered = false
    private var stopEventSink: EventChannel.EventSink? = null

    private val stopReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action == ACTION_STOP) {
                stopEventSink?.success(null)
            }
        }
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

    private fun contentPendingIntent(): PendingIntent {
        val intent = EmulationActivity.createLaunchIntent(context, "").apply {
            flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        return PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
    }

    private fun deletePendingIntent(): PendingIntent {
        val intent = Intent(ACTION_STOP).setPackage(context.packageName)
        return PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
    }

    private fun artworkBitmap() = artworkPath?.let { BitmapFactory.decodeFile(it) }

    private fun buildMetadata(): MediaMetadataCompat {
        val builder = MediaMetadataCompat.Builder()
            .putString(MediaMetadataCompat.METADATA_KEY_TITLE, title)
        artworkBitmap()?.let { builder.putBitmap(MediaMetadataCompat.METADATA_KEY_ALBUM_ART, it) }
        return builder.build()
    }

    private fun buildPlaybackState(): PlaybackStateCompat {
        val state = if (isPlaying) PlaybackStateCompat.STATE_PLAYING else PlaybackStateCompat.STATE_PAUSED
        return PlaybackStateCompat.Builder()
            .setState(state, PlaybackStateCompat.PLAYBACK_POSITION_UNKNOWN, 1.0f)
            .build()
    }

    private fun updateNotification() {
        val mediaSession = session ?: return
        val builder = NotificationCompat.Builder(context, context.getString(R.string.app_notification_channel_id))
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setSmallIcon(R.drawable.ic_stat_notification_logo)
            .setContentTitle(title)
            .setOngoing(isPlaying)
            .setContentIntent(contentPendingIntent())
            .setDeleteIntent(deletePendingIntent())
            .setStyle(MediaNotificationCompat.MediaStyle().setMediaSession(mediaSession.sessionToken))
        artworkBitmap()?.let { builder.setLargeIcon(it) }
        NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, builder.build())
    }

    private inner class ActivateMediaNotification : AzaharMethodHandler {
        override val name = "activateMediaNotification"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            title = call.argument<String>("title") ?: ""
            artworkPath = call.argument<String>("artworkPath")
            isPlaying = call.argument<Boolean>("isPlaying") ?: true

            session?.release()
            session = MediaSessionCompat(context, SESSION_TAG).apply {
                setMetadata(buildMetadata())
                setPlaybackState(buildPlaybackState())
                isActive = true
            }
            if (!receiverRegistered) {
                ContextCompat.registerReceiver(
                    context,
                    stopReceiver,
                    IntentFilter(ACTION_STOP),
                    ContextCompat.RECEIVER_NOT_EXPORTED
                )
                receiverRegistered = true
            }
            updateNotification()
            result.success(null)
        }
    }

    private inner class UpdateMediaNotificationPlaybackState : AzaharMethodHandler {
        override val name = "updateMediaNotificationPlaybackState"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            isPlaying = call.argument<Boolean>("isPlaying") ?: true
            session?.setPlaybackState(buildPlaybackState())
            updateNotification()
            result.success(null)
        }
    }

    private inner class DeactivateMediaNotification : AzaharMethodHandler {
        override val name = "deactivateMediaNotification"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            if (receiverRegistered) {
                context.unregisterReceiver(stopReceiver)
                receiverRegistered = false
            }
            session?.isActive = false
            session?.release()
            session = null
            NotificationManagerCompat.from(context).cancel(NOTIFICATION_ID)
            result.success(null)
        }
    }

    companion object {
        private const val NOTIFICATION_ID = 0x617a6168
        private const val SESSION_TAG = "AzaharEmulationSession"
        private const val ACTION_STOP = "org.citra.citra_emu.action.MEDIA_NOTIFICATION_STOP"
    }
}
