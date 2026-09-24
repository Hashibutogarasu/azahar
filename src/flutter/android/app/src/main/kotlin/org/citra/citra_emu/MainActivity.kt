package org.citra.citra_emu

import android.app.ActivityManager
import android.content.Context
import android.os.Bundle
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.applets.MiiSelector
import org.citra.citra_emu.applets.SoftwareKeyboard
import org.citra.citra_emu.camera.StillImageCameraHelper
import org.citra.citra_emu.channel.AzaharMethodHandler
import org.citra.citra_emu.channel.CiaInstallController
import org.citra.citra_emu.channel.DirectoryController
import org.citra.citra_emu.channel.EmulationController
import org.citra.citra_emu.channel.GameActionsController
import org.citra.citra_emu.channel.GamesController
import org.citra.citra_emu.channel.GpuDriverController
import org.citra.citra_emu.channel.SettingsController
import org.citra.citra_emu.channel.ShowMiiSelector
import org.citra.citra_emu.channel.SystemFilesController
import org.citra.citra_emu.utils.AppletBridge
import org.citra.citra_emu.utils.DiskShaderCacheProgress

class MainActivity : FlutterFragmentActivity() {
    private val openUserDirectoryLauncher =
        registerForActivityResult(ActivityResultContracts.OpenDocumentTree()) { uri ->
            directoryController.onUserDirectoryPicked(uri)
        }

    private val openGamesDirectoryLauncher =
        registerForActivityResult(ActivityResultContracts.OpenDocumentTree()) { uri ->
            directoryController.onGamesDirectoryPicked(uri)
        }

    private val pickImageLauncher =
        registerForActivityResult(ActivityResultContracts.PickVisualMedia()) { uri ->
            StillImageCameraHelper.OnFilePickerResult(uri?.toString())
        }

    private val directoryController: DirectoryController by lazy {
        DirectoryController(this, contentResolver, openUserDirectoryLauncher, openGamesDirectoryLauncher)
    }
    private val gamesController: GamesController by lazy { GamesController(this, cacheDir) }
    private val gameActionsController: GameActionsController by lazy { GameActionsController(this) }
    private val settingsController = SettingsController()
    private val gpuDriverController = GpuDriverController()
    private val ciaInstallController by lazy { CiaInstallController(this) }
    private val systemFilesController = SystemFilesController()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState == null && isEmulationProcessRunning()) {
            EmulationActivity.start(this, "")
        }
    }

    private fun isEmulationProcessRunning(): Boolean {
        val emulationProcessName = packageName + EmulationActivity.PROCESS_SUFFIX
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        return activityManager.runningAppProcesses.orEmpty()
            .any { it.processName == emulationProcessName }
    }

    override fun onResume() {
        super.onResume()
        NativeLibrary.setEmulationActivity(this)
        StillImageCameraHelper.launcher = {
            pickImageLauncher.launch(
                PickVisualMediaRequest.Builder()
                    .setMediaType(ActivityResultContracts.PickVisualMedia.ImageOnly)
                    .build()
            )
        }
    }

    override fun onPause() {
        NativeLibrary.clearEmulationActivity()
        StillImageCameraHelper.launcher = null
        super.onPause()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val emulationController = EmulationController(flutterEngine.renderer)
        val handlers: Map<String, AzaharMethodHandler> =
            (directoryController.handlers + gamesController.handlers +
                gameActionsController.handlers +
                emulationController.handlers + settingsController.handlers +
                gpuDriverController.handlers + ciaInstallController.handlers +
                systemFilesController.handlers)
                .associateBy { it.name }

        val appletChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APPLET_CHANNEL)
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

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, COPY_PROGRESS_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    directoryController.copyProgressSink = events
                }

                override fun onCancel(arguments: Any?) {
                    directoryController.copyProgressSink = null
                }
            })

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SHADER_PROGRESS_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                private var installedListener: DiskShaderCacheProgress.Listener? = null

                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    val listener = DiskShaderCacheProgress.Listener { stage, progress, max ->
                        events.success(
                            mapOf("stage" to stage.name, "progress" to progress, "max" to max)
                        )
                    }
                    installedListener = listener
                    DiskShaderCacheProgress.listener = listener
                }

                override fun onCancel(arguments: Any?) {
                    if (DiskShaderCacheProgress.listener === installedListener) {
                        DiskShaderCacheProgress.listener = null
                    }
                    installedListener = null
                }
            })

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                handlers[call.method]?.execute(call, result) ?: result.notImplemented()
            }
    }

    companion object {
        private const val CHANNEL = "org.citra.citra_emu/azahar_bridge"
        private const val SHADER_PROGRESS_CHANNEL = "org.citra.citra_emu/azahar_bridge/shader_progress"
        private const val APPLET_CHANNEL = "org.citra.citra_emu/azahar_bridge/applet"
        private const val COPY_PROGRESS_CHANNEL = "org.citra.citra_emu/azahar_bridge/copy_progress"
    }
}
