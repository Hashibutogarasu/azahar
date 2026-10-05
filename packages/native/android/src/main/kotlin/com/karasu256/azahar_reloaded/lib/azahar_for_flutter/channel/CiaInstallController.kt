// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.CiaInstaller

class CiaInstallController(private val context: Context) {
    val handlers: List<AzaharMethodHandler> = listOf(InstallCiaFiles())

    private inner class InstallCiaFiles : AzaharMethodHandler {
        override val name = "installCiaFiles"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            CiaInstaller.install(context, call.argument<List<String>>("paths")!!)
            result.success(null)
        }
    }
}
