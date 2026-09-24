package org.citra.citra_emu

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.core.content.ContextCompat
import androidx.media3.common.MediaItem
import androidx.media3.common.MediaMetadata
import androidx.media3.common.Player
import androidx.media3.common.SimpleBasePlayer
import androidx.media3.common.util.UnstableApi
import androidx.media3.session.MediaSession
import androidx.media3.session.MediaSessionService
import com.google.common.util.concurrent.Futures
import com.google.common.util.concurrent.ListenableFuture
import java.io.File

@UnstableApi
class PlaybackService : MediaSessionService() {
    private var mediaSession: MediaSession? = null
    private lateinit var player: EmulationPlayer

    override fun onCreate() {
        super.onCreate()
        instance = this
        player = EmulationPlayer()
        val session = MediaSession.Builder(this, player).build()
        mediaSession = session
        addSession(session)
        pendingTitle?.let { player.updateMetadata(it, pendingArtworkPath) }
        player.updatePlaybackState(pendingIsPlaying)
    }

    override fun onGetSession(controllerInfo: MediaSession.ControllerInfo): MediaSession? = mediaSession

    override fun onDestroy() {
        mediaSession?.let {
            removeSession(it)
            player.release()
            it.release()
        }
        mediaSession = null
        instance = null
        super.onDestroy()
    }

    fun updateMetadata(title: String, artworkPath: String?) = player.updateMetadata(title, artworkPath)

    fun updatePlaybackState(isPlaying: Boolean) = player.updatePlaybackState(isPlaying)

    inner class EmulationPlayer : SimpleBasePlayer(mainLooper) {
        private var metadata = MediaMetadata.EMPTY
        private var isPlaying = true

        fun updateMetadata(title: String, artworkPath: String?) {
            metadata = MediaMetadata.Builder()
                .setTitle(title)
                .setArtworkUri(artworkPath?.let { Uri.fromFile(File(it)) })
                .build()
            invalidateState()
        }

        fun updatePlaybackState(playing: Boolean) {
            isPlaying = playing
            invalidateState()
        }

        override fun getState(): State {
            return State.Builder()
                .setAvailableCommands(Player.Commands.Builder().addAllCommands().build())
                .setPlayWhenReady(isPlaying, Player.PLAY_WHEN_READY_CHANGE_REASON_USER_REQUEST)
                .setPlaybackState(Player.STATE_READY)
                .setCurrentMediaItemIndex(0)
                .setPlaylist(
                    listOf(
                        MediaItemData.Builder("emulation")
                            .setMediaItem(
                                MediaItem.Builder().setMediaId("emulation").setMediaMetadata(metadata).build()
                            )
                            .setMediaMetadata(metadata)
                            .build()
                    )
                )
                .build()
        }

        override fun handleSetPlayWhenReady(playWhenReady: Boolean): ListenableFuture<*> =
            Futures.immediateVoidFuture()

        override fun handleStop(): ListenableFuture<*> {
            onStopRequested?.invoke()
            return Futures.immediateVoidFuture()
        }

        override fun handlePrepare(): ListenableFuture<*> = Futures.immediateVoidFuture()

        override fun handleRelease(): ListenableFuture<*> = Futures.immediateVoidFuture()
    }

    companion object {
        var instance: PlaybackService? = null
            private set
        var onStopRequested: (() -> Unit)? = null
        private var pendingTitle: String? = null
        private var pendingArtworkPath: String? = null
        private var pendingIsPlaying: Boolean = true

        fun activate(context: Context, title: String, artworkPath: String?, isPlaying: Boolean) {
            pendingTitle = title
            pendingArtworkPath = artworkPath
            pendingIsPlaying = isPlaying
            val running = instance
            if (running != null) {
                running.updateMetadata(title, artworkPath)
                running.updatePlaybackState(isPlaying)
                return
            }
            ContextCompat.startForegroundService(context, Intent(context, PlaybackService::class.java))
        }

        fun updatePlaybackState(isPlaying: Boolean) {
            pendingIsPlaying = isPlaying
            instance?.updatePlaybackState(isPlaying)
        }

        fun deactivate() {
            pendingTitle = null
            pendingArtworkPath = null
            instance?.stopSelf()
        }
    }
}
