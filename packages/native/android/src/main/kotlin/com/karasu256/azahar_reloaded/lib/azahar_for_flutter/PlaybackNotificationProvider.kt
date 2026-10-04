// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Bundle
import androidx.core.app.NotificationCompat
import androidx.media3.common.util.UnstableApi
import androidx.media3.session.CommandButton
import androidx.media3.session.DefaultMediaNotificationProvider
import androidx.media3.session.MediaNotification
import androidx.media3.session.MediaSession
import androidx.media3.session.MediaStyleNotificationHelper
import com.google.common.collect.ImmutableList
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.R

@UnstableApi
class PlaybackNotificationProvider(private val context: Context) : MediaNotification.Provider {
    override fun createNotification(
        mediaSession: MediaSession,
        customLayout: ImmutableList<CommandButton>,
        actionFactory: MediaNotification.ActionFactory,
        onNotificationChangedCallback: MediaNotification.Provider.Callback
    ): MediaNotification {
        val metadata = mediaSession.player.mediaMetadata
        val builder = NotificationCompat.Builder(context, context.getString(R.string.app_notification_channel_id))
            .setSmallIcon(R.drawable.ic_stat_notification_logo)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setContentTitle(metadata.title)
            .setContentIntent(mediaSession.sessionActivity)
            .setDeleteIntent(deletePendingIntent())
            .setOngoing(mediaSession.player.playWhenReady)
            .setStyle(MediaStyleNotificationHelper.MediaStyle(mediaSession))
        metadata.artworkUri?.path?.let { path ->
            BitmapFactory.decodeFile(path)?.let { builder.setLargeIcon(it) }
        }
        return MediaNotification(DefaultMediaNotificationProvider.DEFAULT_NOTIFICATION_ID, builder.build())
    }

    override fun handleCustomCommand(session: MediaSession, action: String, extras: Bundle) = false

    private fun deletePendingIntent(): PendingIntent {
        val intent = Intent(ACTION_STOP).setPackage(context.packageName)
        return PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
    }

    companion object {
        const val ACTION_STOP = "org.citra.citra_emu.action.MEDIA_NOTIFICATION_STOP"
    }
}
