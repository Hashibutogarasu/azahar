// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils

import android.content.Context
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequest
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager

/** Installs CIA files in the background with [CiaInstallWorker], which reports each result. */
object CiaInstaller {
    /** Queues the CIA files at [paths], which are plain paths or content URIs, for install. */
    fun install(context: Context, paths: List<String>) {
        if (paths.isEmpty()) return
        WorkManager.getInstance(context).enqueueUniqueWork(
            "installCiaWork",
            ExistingWorkPolicy.APPEND_OR_REPLACE,
            OneTimeWorkRequest.Builder(CiaInstallWorker::class.java)
                .setInputData(Data.Builder().putStringArray("CIA_FILES", paths.toTypedArray()).build())
                .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                .build()
        )
    }
}
