// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.features.cheats.model.Cheat
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.features.cheats.model.CheatEngine

/** Exposes the native cheat engine of the running title to Dart. */
class CheatsController {
    val handlers: List<AzaharMethodHandler> = listOf(
        LoadCheatFile(),
        SaveCheatFile(),
        GetCheats(),
        SetCheatEnabled(),
        AddCheat(),
        ValidateCheatCode()
    )

    private fun MethodCall.titleId(): Long? = argument<Number>("titleId")?.toLong()

    private inner class LoadCheatFile : BackgroundMethodHandler() {
        override val name = "loadCheatFile"
        override fun run(call: MethodCall): Any? {
            val titleId = call.titleId()
                ?: throw IllegalArgumentException("titleId is required")
            CheatEngine.loadCheatFile(titleId)
            return null
        }
    }

    private inner class SaveCheatFile : BackgroundMethodHandler() {
        override val name = "saveCheatFile"
        override fun run(call: MethodCall): Any? {
            val titleId = call.titleId()
                ?: throw IllegalArgumentException("titleId is required")
            CheatEngine.saveCheatFile(titleId)
            return null
        }
    }

    private inner class GetCheats : AzaharMethodHandler {
        override val name = "getCheats"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            result.success(
                CheatEngine.getCheats().map { cheat ->
                    mapOf(
                        "name" to cheat.getName(),
                        "notes" to cheat.getNotes(),
                        "code" to cheat.getCode(),
                        "enabled" to cheat.getEnabled()
                    )
                }
            )
        }
    }

    private inner class SetCheatEnabled : AzaharMethodHandler {
        override val name = "setCheatEnabled"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val index = call.argument<Int>("index")
            val enabled = call.argument<Boolean>("enabled")
            val cheats = CheatEngine.getCheats()
            if (index == null || enabled == null || index !in cheats.indices) {
                result.error("invalid_argument", "index and enabled are required", null)
                return
            }
            cheats[index].setEnabled(enabled)
            result.success(null)
        }
    }

    private inner class AddCheat : AzaharMethodHandler {
        override val name = "addCheat"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val cheatName = call.argument<String>("name")
            val notes = call.argument<String>("notes") ?: ""
            val code = call.argument<String>("code")
            if (cheatName == null || code == null) {
                result.error("invalid_argument", "name and code are required", null)
                return
            }
            CheatEngine.addCheat(Cheat.createGatewayCode(cheatName, notes, code))
            result.success(null)
        }
    }

    private inner class ValidateCheatCode : AzaharMethodHandler {
        override val name = "validateCheatCode"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val code = call.argument<String>("code")
            if (code == null) {
                result.error("invalid_argument", "code is required", null)
                return
            }
            result.success(Cheat.isValidGatewayCode(code))
        }
    }
}
