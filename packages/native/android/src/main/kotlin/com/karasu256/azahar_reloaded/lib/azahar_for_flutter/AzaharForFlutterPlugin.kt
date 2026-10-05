// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter

import android.Manifest
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.IntentCompat
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.NativeLibrary
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.CiaInstaller
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.FileUtil

/**
 * Flutter plugin that exposes the Azahar native layer to Dart.
 *
 * The host activity must extend `FlutterFragmentActivity`, which is the
 * default of a new Flutter Android project. Games run inside the process and
 * the engine of the host activity.
 */
class AzaharForFlutterPlugin : FlutterPlugin, ActivityAware {
    private var flutterBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var session: MainEngineSession? = null

    private val permissionListener =
        PluginRegistry.RequestPermissionsResultListener { requestCode, _, grantResults ->
            val granted = grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
            when (requestCode) {
                NativeLibrary.REQUEST_CODE_NATIVE_CAMERA -> NativeLibrary.cameraPermissionResult(granted)
                NativeLibrary.REQUEST_CODE_NATIVE_MIC -> NativeLibrary.micPermissionResult(granted)
                NativeLibrary.REQUEST_CODE_NATIVE_WIFI -> NativeLibrary.wifiPermissionResult(granted)
                REQUEST_CODE_NOTIFICATION_PERMISSION -> Unit
                else -> return@RequestPermissionsResultListener false
            }
            true
        }

    private val newIntentListener = PluginRegistry.NewIntentListener { intent ->
        takeGamePath(intent)?.let { session?.requestLaunch(it) }
        activityBinding?.activity?.let { installCiaFiles(it, intent) }
        false
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Class.forName(NativeLibrary::class.java.name)
        NativeLibrary.setApplicationContext(flutterPluginBinding.applicationContext)
        flutterBinding = flutterPluginBinding
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterBinding = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        attachSession(binding)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        attachSession(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        detachSession()
    }

    override fun onDetachedFromActivity() {
        detachSession()
    }

    private fun attachSession(binding: ActivityPluginBinding) {
        val flutterBinding = flutterBinding ?: return
        val activity = binding.activity
        if (activity !is FragmentActivity) {
            Log.e(TAG, "azahar_for_flutter requires a FlutterFragmentActivity host")
            return
        }
        detachSession()
        activityBinding = binding
        binding.addRequestPermissionsResultListener(permissionListener)
        binding.addOnNewIntentListener(newIntentListener)
        requestNotificationPermission(activity)
        session = MainEngineSession(activity, flutterBinding).also {
            it.pendingLaunch = takeGamePath(activity.intent)
            it.attach()
        }
        installCiaFiles(activity, activity.intent)
    }

    private fun detachSession() {
        activityBinding?.removeRequestPermissionsResultListener(permissionListener)
        activityBinding?.removeOnNewIntentListener(newIntentListener)
        activityBinding = null
        session?.detach()
        session = null
    }

    private fun requestNotificationPermission(activity: FragmentActivity) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.POST_NOTIFICATIONS) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            REQUEST_CODE_NOTIFICATION_PERMISSION
        )
    }

    private fun takeGamePath(intent: Intent?): String? {
        val path = intent?.getStringExtra(EXTRA_GAME_PATH)
        intent?.removeExtra(EXTRA_GAME_PATH)
        return path?.takeIf { it.isNotEmpty() }
    }

    /**
     * Installs the CIA files [intent] opens or shares, such as from the "Install application" entry
     * of a file manager or of the share menu, and marks the intent as handled so it is not
     * installed again when the activity is attached anew. Files whose name does not end in `.cia`
     * are left out, since the generic binary type the entry accepts also matches other files.
     */
    private fun installCiaFiles(context: Context, intent: Intent?) {
        intent ?: return
        val uris = when (intent.action) {
            Intent.ACTION_VIEW -> listOfNotNull(intent.data)
            Intent.ACTION_SEND -> listOfNotNull(
                IntentCompat.getParcelableExtra(intent, Intent.EXTRA_STREAM, Uri::class.java)
            )
            Intent.ACTION_SEND_MULTIPLE -> IntentCompat.getParcelableArrayListExtra(
                intent,
                Intent.EXTRA_STREAM,
                Uri::class.java
            ).orEmpty()
            else -> return
        }
        intent.action = null
        CiaInstaller.install(
            context,
            uris.filter { isCiaFile(it) }.map { it.toString() }
        )
    }

    private fun isCiaFile(uri: Uri): Boolean {
        val name = if (uri.scheme == ContentResolver.SCHEME_CONTENT) {
            FileUtil.getFilename(uri)
        } else {
            uri.lastPathSegment.orEmpty()
        }
        return name.endsWith(CIA_EXTENSION, ignoreCase = true)
    }

    companion object {
        private const val CIA_EXTENSION = ".cia"

        /** Intent extra that asks the host activity to launch the game at the given path. */
        const val EXTRA_GAME_PATH = "gamePath"

        private const val TAG = "AzaharForFlutter"
        private const val REQUEST_CODE_NOTIFICATION_PERMISSION = 0x617a6169
    }
}
