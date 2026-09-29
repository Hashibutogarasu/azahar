package com.karasu256.azahar_reloaded.lib.azahar_for_flutter

import android.app.Activity
import android.app.ActivityManager
import android.app.Application
import android.content.ContentProvider
import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.EmulationActivity

/**
 * Initializes the native runtime before the host application is created.
 *
 * Content providers are created in every process of the application before
 * `Application.onCreate`, so the host application needs no custom `Application`
 * class. The provider also brings the emulation activity to the front when the
 * main activity is started while a game is still running in the emulation
 * process.
 */
open class AzaharInitProvider : ContentProvider() {
    override fun onCreate(): Boolean {
        val application = context?.applicationContext as? Application ?: return false
        CitraApplication.initialize(application)
        application.registerActivityLifecycleCallbacks(ResumeEmulationCallbacks())
        return true
    }

    override fun query(
        uri: Uri,
        projection: Array<String>?,
        selection: String?,
        selectionArgs: Array<String>?,
        sortOrder: String?
    ): Cursor? = null

    override fun getType(uri: Uri): String? = null

    override fun insert(uri: Uri, values: ContentValues?): Uri? = null

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String>?): Int = 0

    override fun update(
        uri: Uri,
        values: ContentValues?,
        selection: String?,
        selectionArgs: Array<String>?
    ): Int = 0

    private class ResumeEmulationCallbacks : Application.ActivityLifecycleCallbacks {
        override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
            if (savedInstanceState != null) return
            if (activity !is FlutterActivity || activity is EmulationActivity) return
            if (isEmulationProcessRunning(activity)) {
                EmulationActivity.start(activity, "")
            }
        }

        private fun isEmulationProcessRunning(context: Context): Boolean {
            val emulationProcessName = context.packageName + EmulationActivity.PROCESS_SUFFIX
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            return activityManager.runningAppProcesses.orEmpty()
                .any { it.processName == emulationProcessName }
        }

        override fun onActivityStarted(activity: Activity) = Unit
        override fun onActivityResumed(activity: Activity) = Unit
        override fun onActivityPaused(activity: Activity) = Unit
        override fun onActivityStopped(activity: Activity) = Unit
        override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) = Unit
        override fun onActivityDestroyed(activity: Activity) = Unit
    }
}
