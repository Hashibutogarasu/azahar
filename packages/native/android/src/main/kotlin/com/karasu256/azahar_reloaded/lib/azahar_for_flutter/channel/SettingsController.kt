// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.NativeLibrary
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.EmulatorSettingsFile
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.SystemSaveGame

class SettingsController {
    val handlers: List<AzaharMethodHandler> = listOf(
        ReadConfig(),
        WriteConfig(),
        ReloadNativeSettings(),
        ReadSystemSaveGame(),
        WriteSystemSaveGame(),
        RegenerateConsoleId(),
        RegenerateMac(),
        GetCountryCompatibility(),
        SetConsoleLogEnabled()
    )

    private inner class SetConsoleLogEnabled : AzaharMethodHandler {
        override val name = "setConsoleLogEnabled"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val enabled = call.argument<Boolean>("enabled")
            if (enabled == null) {
                result.error("invalid_argument", "enabled is required", null)
                return
            }
            NativeLibrary.setConsoleLogEnabled(enabled)
            result.success(null)
        }
    }

    private inner class ReadConfig : BackgroundMethodHandler() {
        override val name = "readEmulatorConfig"
        override fun run(call: MethodCall): Any = EmulatorSettingsFile.read()
    }

    private inner class WriteConfig : BackgroundMethodHandler() {
        override val name = "writeEmulatorConfig"
        override fun run(call: MethodCall): Any? {
            @Suppress("UNCHECKED_CAST")
            val sections = call.arguments as? Map<String, Map<String, String>>
                ?: throw IllegalArgumentException("a map of sections is required")
            EmulatorSettingsFile.write(sections)
            return null
        }
    }

    private inner class ReloadNativeSettings : BackgroundMethodHandler() {
        override val name = "reloadEmulatorSettings"
        override fun run(call: MethodCall): Any? {
            NativeLibrary.reloadSettings()
            return null
        }
    }

    private inner class ReadSystemSaveGame : BackgroundMethodHandler() {
        override val name = "readSystemSaveGame"
        override fun run(call: MethodCall): Any {
            SystemSaveGame.load()
            val birthday = SystemSaveGame.getBirthday()
            return mapOf(
                "username" to SystemSaveGame.getUsername(),
                "birthdayMonth" to birthday[0].toInt(),
                "birthdayDay" to birthday[1].toInt(),
                "systemLanguage" to SystemSaveGame.getSystemLanguage(),
                "soundOutputMode" to SystemSaveGame.getSoundOutputMode(),
                "countryCode" to SystemSaveGame.getCountryCode().toInt(),
                "playCoins" to SystemSaveGame.getPlayCoins(),
                "consoleId" to "0x${SystemSaveGame.getConsoleId().toULong().toString(16).uppercase()}",
                "mac" to SystemSaveGame.getMac()
            )
        }
    }

    private inner class WriteSystemSaveGame : BackgroundMethodHandler() {
        override val name = "writeSystemSaveGame"
        override fun run(call: MethodCall): Any? {
            @Suppress("UNCHECKED_CAST")
            val fields = call.arguments as? Map<String, Any?>
                ?: throw IllegalArgumentException("a map of fields is required")
            (fields["username"] as? String)?.let { SystemSaveGame.setUsername(it) }
            val birthdayMonth = (fields["birthdayMonth"] as? Number)?.toShort()
            val birthdayDay = (fields["birthdayDay"] as? Number)?.toShort()
            if (birthdayMonth != null || birthdayDay != null) {
                val current = SystemSaveGame.getBirthday()
                SystemSaveGame.setBirthday(
                    birthdayMonth ?: current[0],
                    birthdayDay ?: current[1]
                )
            }
            (fields["systemLanguage"] as? Number)?.let {
                SystemSaveGame.setSystemLanguage(it.toInt())
            }
            (fields["soundOutputMode"] as? Number)?.let {
                SystemSaveGame.setSoundOutputMode(it.toInt())
            }
            (fields["countryCode"] as? Number)?.let {
                SystemSaveGame.setCountryCode(it.toShort())
            }
            (fields["playCoins"] as? Number)?.let { SystemSaveGame.setPlayCoins(it.toInt()) }
            SystemSaveGame.save()
            return null
        }
    }

    private inner class RegenerateConsoleId : BackgroundMethodHandler() {
        override val name = "regenerateConsoleId"
        override fun run(call: MethodCall): Any {
            SystemSaveGame.regenerateConsoleId()
            SystemSaveGame.save()
            return "0x${SystemSaveGame.getConsoleId().toULong().toString(16).uppercase()}"
        }
    }

    private inner class RegenerateMac : BackgroundMethodHandler() {
        override val name = "regenerateMac"
        override fun run(call: MethodCall): Any {
            SystemSaveGame.regenerateMac()
            SystemSaveGame.save()
            return SystemSaveGame.getMac()
        }
    }

    private inner class GetCountryCompatibility : BackgroundMethodHandler() {
        override val name = "getCountryCompatibility"
        override fun run(call: MethodCall): Any {
            val region = (call.arguments as? Number)?.toInt()
                ?: throw IllegalArgumentException("a region int is required")
            return SystemSaveGame.getCountryCompatibility(region)
        }
    }
}
