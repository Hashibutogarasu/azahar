package org.citra.citra_emu.channel

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.utils.SystemSaveGame

class SystemFilesController {
    val handlers: List<AzaharMethodHandler> = listOf(
        IsFullConsoleLinked(),
        AreSystemTitlesInstalled(),
        InstallSystemFiles(),
        UnlinkConsole(),
        GetHomeMenuPath(),
        IsSystemSetupNeeded(),
        SetSystemSetupNeeded()
    )

    private inner class IsFullConsoleLinked : AzaharMethodHandler {
        override val name = "isFullConsoleLinked"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            result.success(NativeLibrary.isFullConsoleLinked())
        }
    }

    private inner class AreSystemTitlesInstalled : AzaharMethodHandler {
        override val name = "areSystemTitlesInstalled"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val installed = NativeLibrary.areSystemTitlesInstalled()
            result.success(listOf(installed[0], installed[1]))
        }
    }

    private inner class InstallSystemFiles : AzaharMethodHandler {
        override val name = "installSystemFiles"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val old3ds = call.argument<Boolean>("old3ds")!!
            NativeLibrary.uninstallSystemFiles(old3ds)
            result.success(null)
        }
    }

    private inner class UnlinkConsole : AzaharMethodHandler {
        override val name = "unlinkConsole"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            NativeLibrary.unlinkConsole()
            result.success(null)
        }
    }

    private inner class GetHomeMenuPath : AzaharMethodHandler {
        override val name = "getHomeMenuPath"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val region = call.argument<Int>("region")!!
            result.success(NativeLibrary.getHomeMenuPath(region))
        }
    }

    private inner class IsSystemSetupNeeded : AzaharMethodHandler {
        override val name = "isSystemSetupNeeded"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            SystemSaveGame.load()
            result.success(SystemSaveGame.getIsSystemSetupNeeded())
        }
    }

    private inner class SetSystemSetupNeeded : AzaharMethodHandler {
        override val name = "setSystemSetupNeeded"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val needed = call.argument<Boolean>("needed")!!
            SystemSaveGame.load()
            SystemSaveGame.setSystemSetupNeeded(needed)
            result.success(null)
        }
    }
}
