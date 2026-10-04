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

    private inner class ReadConfig : AzaharMethodHandler {
        override val name = "readEmulatorConfig"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            result.success(EmulatorSettingsFile.read())
        }
    }

    private inner class WriteConfig : AzaharMethodHandler {
        override val name = "writeEmulatorConfig"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            @Suppress("UNCHECKED_CAST")
            val sections = call.arguments as? Map<String, Map<String, String>>
            if (sections == null) {
                result.error("invalid_argument", "a map of sections is required", null)
                return
            }
            EmulatorSettingsFile.write(sections)
            result.success(null)
        }
    }

    private inner class ReloadNativeSettings : AzaharMethodHandler {
        override val name = "reloadEmulatorSettings"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            NativeLibrary.reloadSettings()
            result.success(null)
        }
    }

    private inner class ReadSystemSaveGame : AzaharMethodHandler {
        override val name = "readSystemSaveGame"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            SystemSaveGame.load()
            val birthday = SystemSaveGame.getBirthday()
            result.success(
                mapOf(
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
            )
        }
    }

    private inner class WriteSystemSaveGame : AzaharMethodHandler {
        override val name = "writeSystemSaveGame"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            @Suppress("UNCHECKED_CAST")
            val fields = call.arguments as? Map<String, Any?>
            if (fields == null) {
                result.error("invalid_argument", "a map of fields is required", null)
                return
            }
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
            result.success(null)
        }
    }

    private inner class RegenerateConsoleId : AzaharMethodHandler {
        override val name = "regenerateConsoleId"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            SystemSaveGame.regenerateConsoleId()
            SystemSaveGame.save()
            result.success(
                "0x${SystemSaveGame.getConsoleId().toULong().toString(16).uppercase()}"
            )
        }
    }

    private inner class RegenerateMac : AzaharMethodHandler {
        override val name = "regenerateMac"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            SystemSaveGame.regenerateMac()
            SystemSaveGame.save()
            result.success(SystemSaveGame.getMac())
        }
    }

    private inner class GetCountryCompatibility : AzaharMethodHandler {
        override val name = "getCountryCompatibility"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val region = (call.arguments as? Number)?.toInt()
            if (region == null) {
                result.error("invalid_argument", "a region int is required", null)
                return
            }
            result.success(SystemSaveGame.getCountryCompatibility(region))
        }
    }
}
