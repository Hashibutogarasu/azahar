// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.utils

import android.app.NotificationManager
import android.content.Context
import android.net.Uri
import androidx.core.app.NotificationCompat
import androidx.work.ForegroundInfo
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.io.File
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream
import org.citra.citra_emu.R
import org.citra.citra_emu.utils.FileUtil.outputStream

/**
 * Zips the per-frame binary dumps produced by a memory recording session and copies the
 * result to a user-chosen [Uri], as a [Worker] so the operation survives the originating
 * Fragment's view being destroyed and can show progress/cancel through a notification.
 */
class MemoryRecordingExportWorker(
    private val context: Context,
    params: WorkerParameters
) : Worker(context, params) {
    private var lastNotifiedTime: Long = 0

    private val notificationManager = context.getSystemService(NotificationManager::class.java)
    private val progressBuilder = NotificationCompat.Builder(
        context,
        context.getString(R.string.app_notification_channel_id)
    )
        .setContentTitle(context.getString(R.string.memory_recording_export_notification_title))
        .setSmallIcon(R.drawable.ic_stat_notification_logo)
        .setOngoing(true)
        .addAction(
            0,
            context.getString(R.string.memory_recording_export_notification_cancel),
            WorkManager.getInstance(context).createCancelPendingIntent(id)
        )

    override fun doWork(): Result {
        val tempDir = File(inputData.getString(KEY_TEMP_DIR_PATH)!!)
        val destinationUri = Uri.parse(inputData.getString(KEY_DESTINATION_URI)!!)
        val stagingFile = File(context.cacheDir, "memory_recording_export_${id}.zip.tmp")

        val frameFiles = tempDir.listFiles()
            ?.filter { it.isFile && it.length() > 0 }
            ?.sortedBy { it.name }
            ?: emptyList()

        try {
            setProgress(frameFiles.size, 0)
            val zipped = zipFrames(frameFiles, stagingFile)
            if (!zipped) {
                notifyResult(R.string.memory_recording_export_notification_cancelled)
                return Result.failure()
            }

            destinationUri.outputStream().use { destination ->
                stagingFile.inputStream().use { it.copyTo(destination) }
            }

            notifyResult(R.string.memory_recording_export_notification_success)
            return Result.success()
        } catch (_: Exception) {
            notifyResult(R.string.memory_recording_export_error)
            return Result.failure()
        } finally {
            notificationManager.cancel(PROGRESS_NOTIFICATION_ID)
            stagingFile.delete()
            tempDir.deleteRecursively()
        }
    }

    /** Returns false if the work was stopped (cancelled) before finishing. */
    private fun zipFrames(frameFiles: List<File>, stagingFile: File): Boolean {
        stagingFile.outputStream().use { fos ->
            ZipOutputStream(fos).use { zip ->
                frameFiles.forEachIndexed { index, frameFile ->
                    if (isStopped) {
                        return false
                    }
                    zip.putNextEntry(ZipEntry(frameFile.name))
                    frameFile.inputStream().use { input -> input.copyTo(zip) }
                    zip.closeEntry()
                    setProgress(frameFiles.size, index + 1)
                }
            }
        }
        return !isStopped
    }

    private fun setProgress(max: Int, progress: Int) {
        val currentTime = System.currentTimeMillis()
        if (currentTime - lastNotifiedTime < NOTIFICATION_UPDATE_INTERVAL_MS) {
            return
        }
        lastNotifiedTime = currentTime
        progressBuilder.setProgress(max, progress, false)
        notificationManager.notify(PROGRESS_NOTIFICATION_ID, progressBuilder.build())
    }

    private fun notifyResult(messageRes: Int) {
        val resultNotification = NotificationCompat.Builder(
            context,
            context.getString(R.string.app_notification_channel_id)
        )
            .setContentTitle(context.getString(messageRes))
            .setSmallIcon(R.drawable.ic_stat_notification_logo)
            .setAutoCancel(true)
            .build()
        notificationManager.notify(RESULT_NOTIFICATION_ID, resultNotification)
    }

    override fun getForegroundInfo(): ForegroundInfo =
        ForegroundInfo(PROGRESS_NOTIFICATION_ID, progressBuilder.build())

    companion object {
        const val KEY_TEMP_DIR_PATH = "TEMP_DIR_PATH"
        const val KEY_DESTINATION_URI = "DESTINATION_URI"
        const val UNIQUE_WORK_NAME = "memory_recording_export"

        private const val PROGRESS_NOTIFICATION_ID = 0xE6E00000.toInt()
        private const val RESULT_NOTIFICATION_ID = PROGRESS_NOTIFICATION_ID + 1
        private const val NOTIFICATION_UPDATE_INTERVAL_MS = 500L
    }
}
