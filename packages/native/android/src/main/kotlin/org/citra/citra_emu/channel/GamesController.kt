package org.citra.citra_emu.channel

import android.app.Activity
import android.graphics.Bitmap
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.utils.GameHelper
import org.citra.citra_emu.utils.InstalledTitlePath
import org.citra.citra_emu.utils.gameIconBitmap

class GamesController(private val activity: Activity, private val cacheDir: File) {
    val handlers: List<AzaharMethodHandler> = listOf(GetGames())

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
            val gamesDirectory = call.argument<String>("gamesDirectory")
            @Suppress("UNCHECKED_CAST")
            val installedTitlePaths = (call.argument<List<Map<String, String>>>(
                "installedTitlePaths"
            ) ?: emptyList()).map { InstalledTitlePath(it.getValue("root"), it.getValue("path")) }
            Thread {
                try {
                    val games = GameHelper.getGames(gamesDirectory, installedTitlePaths)
                        .map { it.toChannelMap() }
                    activity.runOnUiThread { result.success(games) }
                } catch (e: Exception) {
                    activity.runOnUiThread { result.error("getGames", e.message, null) }
                }
            }.start()
        }
    }
}
