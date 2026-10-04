// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter

import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.NativeLibrary
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.applets.MiiSelector
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.applets.SoftwareKeyboard
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.camera.StillImageCameraHelper
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.AzaharMethodHandler
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.CheatsController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.CiaInstallController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.DirectoryController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.EmulationController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.GameActionsController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.GamepadController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.GamesController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.GpuDriverController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.LogStreamHandler
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.MediaNotificationController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.SettingsController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.ShowMiiSelector
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.SystemFilesController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.SystemVolumeController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.UserFilesController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel.WifiController
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.AppletBridge

/**
 * Binds the native controllers to the Flutter engine of the host activity.
 *
 * One session lives as long as the host activity is attached to the engine.
 * It registers the method and event channels, forwards the applet requests of
 * the emulator to Dart and keeps [NativeLibrary] informed about the resumed
 * activity.
 *
 * @param activity the host activity that owns the engine.
 * @param binding the plugin binding of the engine.
 */
internal class MainEngineSession(
    private val activity: FragmentActivity,
    private val binding: FlutterPlugin.FlutterPluginBinding
) {
    private val lifecycle: Lifecycle = activity.lifecycle
    private val messenger = binding.binaryMessenger
    private val pickImageLauncher = activity.activityResultRegistry.register(
        "azahar_for_flutter.pick_image",
        ActivityResultContracts.PickVisualMedia()
    ) { uri -> StillImageCameraHelper.OnFilePickerResult(uri?.toString()) }
    private val openUserDirectoryLauncher = activity.activityResultRegistry.register(
        "azahar_for_flutter.open_user_directory",
        ActivityResultContracts.OpenDocumentTree()
    ) { uri -> directoryController.onUserDirectoryPicked(uri) }
    private val openGamesDirectoryLauncher = activity.activityResultRegistry.register(
        "azahar_for_flutter.open_games_directory",
        ActivityResultContracts.OpenDocumentTree()
    ) { uri -> directoryController.onGamesDirectoryPicked(uri) }

    private val directoryController: DirectoryController = DirectoryController(
        activity,
        activity.contentResolver,
        openUserDirectoryLauncher,
        openGamesDirectoryLauncher
    )
    private val gamesController = GamesController(activity, activity.cacheDir)
    private val gameActionsController = GameActionsController(activity)
    private val settingsController = SettingsController()
    private val gpuDriverController = GpuDriverController()
    private val ciaInstallController = CiaInstallController(activity)
    private val systemFilesController = SystemFilesController()
    private val wifiController = WifiController()
    private val userFilesController = UserFilesController(activity)
    private val emulationController = EmulationController(binding.textureRegistry)
    private val cheatsController = CheatsController()
    private val systemVolumeController = SystemVolumeController(activity)
    private val mediaNotificationController = MediaNotificationController(activity)
    private val gamepadController = GamepadController()

    /** The game the host activity was started to launch, until Dart takes it. */
    @Volatile
    var pendingLaunch: String? = null

    private val methodChannel = MethodChannel(messenger, CHANNEL)
    private val appletChannel = MethodChannel(messenger, APPLET_CHANNEL)
    private val eventChannels = mutableListOf<EventChannel>()

    private val lifecycleObserver = object : DefaultLifecycleObserver {
        override fun onResume(owner: LifecycleOwner) {
            NativeLibrary.setEmulationActivity(activity)
            StillImageCameraHelper.launcher = {
                pickImageLauncher.launch(
                    PickVisualMediaRequest.Builder()
                        .setMediaType(ActivityResultContracts.PickVisualMedia.ImageOnly)
                        .build()
                )
            }
        }

        override fun onPause(owner: LifecycleOwner) {
            NativeLibrary.clearEmulationActivity()
            StillImageCameraHelper.launcher = null
        }
    }

    /** Registers every channel and starts observing the activity lifecycle. */
    fun attach() {
        val handlers: Map<String, AzaharMethodHandler> =
            (directoryController.handlers + gamesController.handlers +
                gameActionsController.handlers +
                emulationController.handlers + cheatsController.handlers +
                settingsController.handlers +
                gpuDriverController.handlers + ciaInstallController.handlers +
                systemFilesController.handlers + wifiController.handlers +
                userFilesController.handlers + systemVolumeController.handlers +
                mediaNotificationController.handlers + gamepadController.handlers +
                TakePendingLaunch())
                .associateBy { it.name }

        val showMiiSelector = ShowMiiSelector(appletChannel)
        AppletBridge.listener = object : AppletBridge.Listener {
            override fun showKeyboard(
                config: SoftwareKeyboard.KeyboardConfig,
                callback: (button: Int, text: String) -> Unit
            ) {
                appletChannel.invokeMethod(
                    "showKeyboard",
                    mapOf(
                        "buttonConfig" to config.buttonConfig,
                        "maxTextLength" to config.maxTextLength,
                        "multilineMode" to config.multilineMode,
                        "hintText" to config.hintText,
                        "buttonText" to config.buttonText.toList()
                    ),
                    object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            val map = (result as Map<*, *>)
                            callback((map["button"] as Number).toInt(), map["text"] as String)
                        }

                        override fun error(code: String, message: String?, details: Any?) {
                            callback(0, "")
                        }

                        override fun notImplemented() {
                            callback(0, "")
                        }
                    }
                )
            }

            override fun showMiiSelector(
                config: MiiSelector.MiiSelectorConfig,
                callback: (returnCode: Long, index: Int) -> Unit
            ) = showMiiSelector.execute(config, callback)

            override fun showKeyboardError(message: String) {
                appletChannel.invokeMethod("showKeyboardError", mapOf("message" to message))
            }
        }

        registerEventChannel(COPY_PROGRESS_CHANNEL, object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                directoryController.copyProgressSink = events
            }

            override fun onCancel(arguments: Any?) {
                directoryController.copyProgressSink = null
            }
        })

        registerEventChannel(LOG_LINES_CHANNEL, LogStreamHandler())
        registerEventChannel(
            SYSTEM_VOLUME_CHANNEL,
            systemVolumeController.createVolumeChangeStreamHandler()
        )
        registerEventChannel(
            MEDIA_NOTIFICATION_STOP_CHANNEL,
            mediaNotificationController.createStopEventStreamHandler()
        )
        registerEventChannel(
            MEDIA_NOTIFICATION_PLAY_PAUSE_CHANNEL,
            mediaNotificationController.createPlayPauseEventStreamHandler()
        )
        registerEventChannel(GAMEPAD_CHANNEL, gamepadController.createStreamHandler())

        methodChannel.setMethodCallHandler { call, result ->
            handlers[call.method]?.execute(call, result) ?: result.notImplemented()
        }

        lifecycle.addObserver(lifecycleObserver)
        if (lifecycle.currentState.isAtLeast(Lifecycle.State.RESUMED)) {
            lifecycleObserver.onResume(activity)
        }
    }

    /** Unregisters every channel and stops observing the activity lifecycle. */
    fun detach() {
        lifecycle.removeObserver(lifecycleObserver)
        lifecycleObserver.onPause(activity)
        pickImageLauncher.unregister()
        openUserDirectoryLauncher.unregister()
        openGamesDirectoryLauncher.unregister()
        methodChannel.setMethodCallHandler(null)
        eventChannels.forEach { it.setStreamHandler(null) }
        eventChannels.clear()
        AppletBridge.listener = null
    }

    /** Asks Dart to launch the game at [path] while the app is running. */
    fun requestLaunch(path: String) {
        methodChannel.invokeMethod("launchGame", mapOf("path" to path))
    }

    private fun registerEventChannel(name: String, handler: EventChannel.StreamHandler) {
        eventChannels += EventChannel(messenger, name).also { it.setStreamHandler(handler) }
    }

    private inner class TakePendingLaunch : AzaharMethodHandler {
        override val name = "takePendingLaunch"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val path = pendingLaunch
            pendingLaunch = null
            result.success(path)
        }
    }

    private companion object {
        const val CHANNEL = "org.citra.citra_emu/azahar_bridge"
        const val APPLET_CHANNEL = "org.citra.citra_emu/azahar_bridge/applet"
        const val COPY_PROGRESS_CHANNEL = "org.citra.citra_emu/azahar_bridge/copy_progress"
        const val LOG_LINES_CHANNEL = "org.citra.citra_emu/azahar_bridge/log_lines"
        const val GAMEPAD_CHANNEL = "org.citra.citra_emu/azahar_bridge/gamepad_events"
        const val SYSTEM_VOLUME_CHANNEL = "org.citra.citra_emu/azahar_bridge/system_volume"
        const val MEDIA_NOTIFICATION_STOP_CHANNEL =
            "org.citra.citra_emu/azahar_bridge/media_notification_stop"
        const val MEDIA_NOTIFICATION_PLAY_PAUSE_CHANNEL =
            "org.citra.citra_emu/azahar_bridge/media_notification_play_pause"
    }
}
