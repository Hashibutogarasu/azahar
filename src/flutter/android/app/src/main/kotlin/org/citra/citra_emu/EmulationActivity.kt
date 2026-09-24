package org.citra.citra_emu

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.os.Process
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.applets.MiiSelector
import org.citra.citra_emu.applets.SoftwareKeyboard
import org.citra.citra_emu.camera.StillImageCameraHelper
import org.citra.citra_emu.channel.AzaharMethodHandler
import org.citra.citra_emu.channel.EmulationController
import org.citra.citra_emu.channel.MediaNotificationController
import org.citra.citra_emu.channel.SettingsController
import org.citra.citra_emu.channel.ShowMiiSelector
import org.citra.citra_emu.channel.SystemVolumeController
import org.citra.citra_emu.utils.AppletBridge
import org.citra.citra_emu.utils.DiskShaderCacheProgress

class EmulationActivity : FlutterFragmentActivity() {
    private var gamePath: String = ""

    private val pickImageLauncher =
        registerForActivityResult(ActivityResultContracts.PickVisualMedia()) { uri ->
            StillImageCameraHelper.OnFilePickerResult(uri?.toString())
        }

    override fun getInitialRoute(): String = "/__emulation__/" + Uri.encode(gamePath)

    override fun onCreate(savedInstanceState: Bundle?) {
        gamePath = intent.getStringExtra(EXTRA_GAME_PATH) ?: ""
        super.onCreate(savedInstanceState)
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

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        when (requestCode) {
            NativeLibrary.REQUEST_CODE_NATIVE_CAMERA ->
                NativeLibrary.cameraPermissionResult(
                    grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
                )

            NativeLibrary.REQUEST_CODE_NATIVE_MIC ->
                NativeLibrary.micPermissionResult(
                    grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
                )

            NativeLibrary.REQUEST_CODE_NATIVE_WIFI ->
                NativeLibrary.wifiPermissionResult(
                    grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
                )

            else -> super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val emulationController = EmulationController(flutterEngine.renderer)
        val systemVolumeController = SystemVolumeController(this)
        val settingsController = SettingsController()
        val mediaNotificationController = MediaNotificationController(this)
        val handlers: Map<String, AzaharMethodHandler> =
            (emulationController.handlers + systemVolumeController.handlers +
                settingsController.handlers + mediaNotificationController.handlers +
                TerminateProcess())
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

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SYSTEM_VOLUME_CHANNEL)
            .setStreamHandler(systemVolumeController.createVolumeChangeStreamHandler())

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_NOTIFICATION_STOP_CHANNEL)
            .setStreamHandler(mediaNotificationController.createStopEventStreamHandler())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                handlers[call.method]?.execute(call, result) ?: result.notImplemented()
            }
    }

    private inner class TerminateProcess : AzaharMethodHandler {
        override val name = "terminateProcess"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            result.success(null)
            finishAndRemoveTask()
            Process.killProcess(Process.myPid())
        }
    }

    companion object {
        const val PROCESS_SUFFIX = ":emulation"
        private const val EXTRA_GAME_PATH = "gamePath"
        private const val CHANNEL = "org.citra.citra_emu/azahar_bridge"
        private const val SHADER_PROGRESS_CHANNEL = "org.citra.citra_emu/azahar_bridge/shader_progress"
        private const val APPLET_CHANNEL = "org.citra.citra_emu/azahar_bridge/applet"
        private const val SYSTEM_VOLUME_CHANNEL = "org.citra.citra_emu/azahar_bridge/system_volume"
        private const val MEDIA_NOTIFICATION_STOP_CHANNEL =
            "org.citra.citra_emu/azahar_bridge/media_notification_stop"

        fun start(context: Context, gamePath: String) {
            context.startActivity(createLaunchIntent(context, gamePath))
        }

        fun createLaunchIntent(context: Context, gamePath: String): Intent =
            Intent(context, EmulationActivity::class.java)
                .putExtra(EXTRA_GAME_PATH, gamePath)
    }
}
