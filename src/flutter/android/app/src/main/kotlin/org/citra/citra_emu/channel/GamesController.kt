package org.citra.citra_emu.channel

import android.graphics.Bitmap
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import org.citra.citra_emu.EmulationActivity
import org.citra.citra_emu.MainActivity
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.utils.GameHelper
import org.citra.citra_emu.utils.gameIconBitmap

class GamesController(private val activity: MainActivity, private val cacheDir: File) {
    val handlers: List<AzaharMethodHandler> = listOf(GetGames(), LaunchEmulationActivity())

    private fun Game.toChannelMap(): Map<String, Any?> {
        val iconPath = gameIconBitmap(icon)?.let { bitmap ->
            val file = File(cacheDir, "${path.hashCode()}.png")
            FileOutputStream(file).use { bitmap.compress(Bitmap.CompressFormat.PNG, 100, it) }
            file.absolutePath
        }
        return mapOf(
            "title" to title,
            "description" to description,
            "path" to path,
            "titleId" to titleId,
            "company" to company,
            "regions" to regions,
            "isInstalled" to isInstalled,
            "isSystemTitle" to isSystemTitle,
            "isVisibleSystemTitle" to isVisibleSystemTitle,
            "filename" to filename,
            "iconPath" to iconPath
        )
    }

    private inner class GetGames : AzaharMethodHandler {
        override val name = "getGames"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            Thread {
                val games = GameHelper.getGames().map { it.toChannelMap() }
                activity.runOnUiThread { result.success(games) }
            }.start()
        }
    }

    private inner class LaunchEmulationActivity : AzaharMethodHandler {
        override val name = "launchEmulationActivity"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val path = call.argument<String>("path")
            if (path == null) {
                result.error("invalid_argument", "path is required", null)
                return
            }
            EmulationActivity.start(activity, path)
            result.success(null)
        }
    }
}
