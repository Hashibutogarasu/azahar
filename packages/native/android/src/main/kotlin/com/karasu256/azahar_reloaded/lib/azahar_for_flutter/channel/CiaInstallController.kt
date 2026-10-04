package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import android.content.Context
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequest
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.CiaInstallWorker

class CiaInstallController(private val context: Context) {
    val handlers: List<AzaharMethodHandler> = listOf(InstallCiaFiles())

    private inner class InstallCiaFiles : AzaharMethodHandler {
        override val name = "installCiaFiles"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val paths = call.argument<List<String>>("paths")!!
            WorkManager.getInstance(context).enqueueUniqueWork(
                "installCiaWork",
                ExistingWorkPolicy.APPEND_OR_REPLACE,
                OneTimeWorkRequest.Builder(CiaInstallWorker::class.java)
                    .setInputData(Data.Builder().putStringArray("CIA_FILES", paths.toTypedArray()).build())
                    .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                    .build()
            )
            result.success(null)
        }
    }
}
