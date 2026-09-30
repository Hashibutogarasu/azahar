package com.karasu256.azahar_reloaded.lib.azahar_for_flutter

import android.util.Log
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import org.citra.citra_emu.EmulationActivity

/**
 * Flutter plugin that exposes the Azahar native layer to Dart.
 *
 * The host activity must extend `FlutterFragmentActivity`, which is the
 * default of a new Flutter Android project. The emulation activity of this
 * library configures its own engine and is skipped here.
 */
class AzaharForFlutterPlugin : FlutterPlugin, ActivityAware {
    private var flutterBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var session: MainEngineSession? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
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
        if (activity is EmulationActivity) return
        if (activity !is FragmentActivity) {
            Log.e(TAG, "azahar_for_flutter requires a FlutterFragmentActivity host")
            return
        }
        detachSession()
        session = MainEngineSession(activity, flutterBinding).also { it.attach() }
    }

    private fun detachSession() {
        session?.detach()
        session = null
    }

    private companion object {
        const val TAG = "AzaharForFlutter"
    }
}
