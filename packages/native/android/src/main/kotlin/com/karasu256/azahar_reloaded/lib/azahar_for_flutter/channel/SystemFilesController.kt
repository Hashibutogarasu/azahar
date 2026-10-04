// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import io.flutter.plugin.common.MethodCall
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.NativeLibrary
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.SystemSaveGame

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

    private inner class IsFullConsoleLinked : BackgroundMethodHandler() {
        override val name = "isFullConsoleLinked"
        override fun run(call: MethodCall): Any = NativeLibrary.isFullConsoleLinked()
    }

    private inner class AreSystemTitlesInstalled : BackgroundMethodHandler() {
        override val name = "areSystemTitlesInstalled"
        override fun run(call: MethodCall): Any {
            val installed = NativeLibrary.areSystemTitlesInstalled()
            return listOf(installed[0], installed[1])
        }
    }

    private inner class InstallSystemFiles : BackgroundMethodHandler() {
        override val name = "installSystemFiles"
        override fun run(call: MethodCall): Any? {
            val old3ds = call.argument<Boolean>("old3ds")!!
            NativeLibrary.uninstallSystemFiles(old3ds)
            return null
        }
    }

    private inner class UnlinkConsole : BackgroundMethodHandler() {
        override val name = "unlinkConsole"
        override fun run(call: MethodCall): Any? {
            NativeLibrary.unlinkConsole()
            return null
        }
    }

    private inner class GetHomeMenuPath : BackgroundMethodHandler() {
        override val name = "getHomeMenuPath"
        override fun run(call: MethodCall): Any? {
            val region = call.argument<Int>("region")!!
            return NativeLibrary.getHomeMenuPath(region)
        }
    }

    private inner class IsSystemSetupNeeded : BackgroundMethodHandler() {
        override val name = "isSystemSetupNeeded"
        override fun run(call: MethodCall): Any {
            SystemSaveGame.load()
            return SystemSaveGame.getIsSystemSetupNeeded()
        }
    }

    private inner class SetSystemSetupNeeded : BackgroundMethodHandler() {
        override val name = "setSystemSetupNeeded"
        override fun run(call: MethodCall): Any? {
            val needed = call.argument<Boolean>("needed")!!
            SystemSaveGame.load()
            SystemSaveGame.setSystemSetupNeeded(needed)
            return null
        }
    }
}
