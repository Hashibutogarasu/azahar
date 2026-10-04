// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.R
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.DirectoryInitialization
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.DocumentsTree
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.Log
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.MemoryUtil
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.PermissionsHandler

/**
 * Process-wide holder of the application context and the documents tree.
 *
 * The host application does not need a custom `Application` class. The
 * library initializes this object from `AzaharInitProvider` before the host
 * application is created, in every process it runs in.
 */
object CitraApplication {
    private var context: Context? = null

    /** The application context of the current process. */
    val appContext: Context get() = context!!

    /** Access to the user directory backed by the Storage Access Framework. */
    @SuppressLint("StaticFieldLeak")
    lateinit var documentsTree: DocumentsTree

    /**
     * Initializes the native runtime state once per process.
     *
     * @param applicationContext the application context of the current process.
     */
    @Synchronized
    fun initialize(applicationContext: Context) {
        if (context != null) return
        context = applicationContext
        documentsTree = DocumentsTree()
        if (PermissionsHandler.hasWriteAccess(applicationContext)) {
            DirectoryInitialization.start()
        }

        NativeLibrary.logDeviceInfo()
        logDeviceInfo()
        createNotificationChannels(applicationContext)
    }

    private fun createNotificationChannels(context: Context) {
        with(context.getSystemService(NotificationManager::class.java)) {
            val generalChannel = NotificationChannel(
                context.getString(R.string.app_notification_channel_id),
                context.getString(R.string.app_notification_channel_name),
                NotificationManager.IMPORTANCE_LOW
            )
            generalChannel.description =
                context.getString(R.string.app_notification_channel_description)
            generalChannel.setSound(null, null)
            generalChannel.vibrationPattern = null
            createNotificationChannel(generalChannel)

            val ciaChannel = NotificationChannel(
                context.getString(R.string.cia_install_notification_channel_id),
                context.getString(R.string.cia_install_notification_channel_name),
                NotificationManager.IMPORTANCE_DEFAULT
            )
            ciaChannel.description =
                context.getString(R.string.cia_install_notification_channel_description)
            ciaChannel.setSound(null, null)
            ciaChannel.vibrationPattern = null
            createNotificationChannel(ciaChannel)
        }
    }

    private fun logDeviceInfo() {
        Log.info("Device Manufacturer - ${Build.MANUFACTURER}")
        Log.info("Device Model - ${Build.MODEL}")
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.R) {
            Log.info("SoC Manufacturer - ${Build.SOC_MANUFACTURER}")
            Log.info("SoC Model - ${Build.SOC_MODEL}")
        }
        Log.info("Total System Memory - ${MemoryUtil.getDeviceRAM()}")
    }
}
