package org.citra.citra_emu.channel

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.utils.EmulatorSettingsFile

class SettingsController {
    val handlers: List<AzaharMethodHandler> = listOf(
        ReadConfig(),
        WriteConfig(),
        ReloadNativeSettings()
    )

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
}
