package org.citra.citra_emu.channel

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.utils.EmulatorSettingsFile

class SettingsController {
    val handlers: List<AzaharMethodHandler> = listOf(
        ReadConfig(),
        WriteConfigValue(),
        ReloadNativeSettings()
    )

    private inner class ReadConfig : AzaharMethodHandler {
        override val name = "readEmulatorConfig"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            result.success(EmulatorSettingsFile.read())
        }
    }

    private inner class WriteConfigValue : AzaharMethodHandler {
        override val name = "writeEmulatorConfigValue"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val section = call.argument<String>("section")
            val key = call.argument<String>("key")
            val value = call.argument<String>("value")
            if (section == null || key == null || value == null) {
                result.error("invalid_argument", "section, key and value are required", null)
                return
            }
            EmulatorSettingsFile.write(section, key, value)
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
}
