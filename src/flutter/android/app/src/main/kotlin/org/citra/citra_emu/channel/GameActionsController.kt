package org.citra.citra_emu.channel

import android.content.Context
import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Icon
import androidx.core.graphics.scale
import androidx.documentfile.provider.DocumentFile
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.EmulationActivity
import org.citra.citra_emu.MainActivity

/**
 * Backs the game long-press menu (Open Folder / Uninstall / Delete Shader Cache /
 * Create Shortcut) shown by the Flutter game list, mirroring the Compose client's
 * `GamesScreen.kt` (`getGameDirectories`, `OpenFolderMenuButton`, `UninstallMenuButton`,
 * `deleteShaderCache`, `CreateShortcutDialog`).
 */
class GameActionsController(private val activity: MainActivity) {
    val handlers: List<AzaharMethodHandler> = listOf(
        GetGameFolderStatus(),
        OpenGameFolder(),
        DeleteGameFolder(),
        DeleteShaderCache(),
        CreateGameShortcut()
    )

    private data class GameDirectories(
        val gameDir: String,
        val saveDir: String,
        val modsDir: String,
        val texturesDir: String,
        val appDir: String,
        val dlcDir: String,
        val updatesDir: String,
        val extraDir: String
    )

    private fun getGameDirectories(titleId: Long, path: String): GameDirectories {
        val basePath =
            "sdmc/Nintendo 3DS/00000000000000000000000000000000/00000000000000000000000000000000"
        val titleIdHex = String.format("%016x", titleId).lowercase()
        val titleIdHexUpper = String.format("%016X", titleId)
        return GameDirectories(
            gameDir = path.substringBeforeLast("/"),
            saveDir = "$basePath/title/${titleIdHex.substring(0, 8)}/${titleIdHex.substring(8)}" +
                "/data/00000001",
            modsDir = "load/mods/$titleIdHexUpper",
            texturesDir = "load/textures/$titleIdHexUpper",
            appDir = path.substringBeforeLast("/").split("/").filter { it.isNotEmpty() }
                .joinToString("/"),
            dlcDir = "$basePath/title/0004008c/${titleIdHex.substring(8)}/content",
            updatesDir = "$basePath/title/0004000e/${titleIdHex.substring(8)}/content",
            extraDir = "$basePath/extdata/00000000/" +
                titleIdHexUpper.substring(8, 14).padStart(8, '0')
        )
    }

    private fun folderFor(dirs: GameDirectories, folder: String): String? = when (folder) {
        "app" -> dirs.appDir
        "save" -> dirs.saveDir
        "updates" -> dirs.updatesDir
        "dlc" -> dirs.dlcDir
        "extra" -> dirs.extraDir
        "textures" -> dirs.texturesDir
        "mods" -> dirs.modsDir
        else -> null
    }

    private fun uninstallTargetFor(dirs: GameDirectories, target: String): String? = when (target) {
        "cia" -> dirs.gameDir
        "updates" -> dirs.updatesDir
        "dlc" -> dirs.dlcDir
        else -> null
    }

    private fun titleIdArgument(call: MethodCall): Long =
        (call.argument<Number>("titleId") ?: 0L).toLong()

    /**
     * Returns whether each of a game's well-known folders exists, as a flat list of booleans in
     * the fixed order [app, save, updates, dlc, extra, textures, mods] — the same order as the
     * Dart-side `GameFolderKind` enum, so the two sides never need to agree on string keys.
     */
    private inner class GetGameFolderStatus : AzaharMethodHandler {
        override val name = "getGameFolderStatus"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val titleId = titleIdArgument(call)
            val path = call.argument<String>("path") ?: ""
            val dirs = getGameDirectories(titleId, path)
            val checkedDirs =
                listOf(dirs.appDir, dirs.saveDir, dirs.updatesDir, dirs.dlcDir, dirs.extraDir)
            Thread {
                val checkedStatus = checkedDirs.map { dir ->
                    CitraApplication.documentsTree.folderUriHelper(dir)?.let {
                        DocumentFile.fromTreeUri(activity, it)?.exists()
                    } ?: false
                }
                val status = checkedStatus + listOf(true, true)
                activity.runOnUiThread { result.success(status) }
            }.start()
        }
    }

    private inner class OpenGameFolder : AzaharMethodHandler {
        override val name = "openGameFolder"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val titleId = titleIdArgument(call)
            val path = call.argument<String>("path") ?: ""
            val folder = call.argument<String>("folder") ?: ""
            val dirs = getGameDirectories(titleId, path)
            val dir = folderFor(dirs, folder)
            if (dir == null) {
                result.success(false)
                return
            }
            val createIfNotExists = folder == "textures" || folder == "mods"
            val uri = CitraApplication.documentsTree.folderUriHelper(dir, createIfNotExists)
            if (uri == null) {
                result.success(false)
                return
            }
            activity.startActivity(
                Intent(Intent.ACTION_VIEW)
                    .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    .setDataAndType(uri, "*/*")
            )
            result.success(true)
        }
    }

    private inner class DeleteGameFolder : AzaharMethodHandler {
        override val name = "deleteGameFolder"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val titleId = titleIdArgument(call)
            val path = call.argument<String>("path") ?: ""
            val target = call.argument<String>("target") ?: ""
            val dirs = getGameDirectories(titleId, path)
            val dir = uninstallTargetFor(dirs, target)
            if (dir == null) {
                result.success(false)
                return
            }
            result.success(CitraApplication.documentsTree.deleteDocument(dir))
        }
    }

    private inner class DeleteShaderCache : AzaharMethodHandler {
        override val name = "deleteShaderCache"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val titleId = titleIdArgument(call)
            val backend = call.argument<String>("backend") ?: "vulkan"
            Thread {
                val tree = CitraApplication.documentsTree
                val titleIdHex = String.format("%016X", titleId)
                when (backend) {
                    "opengl" -> {
                        listOf("separable", "conventional").forEach { cacheType ->
                            tree.deleteDocument(
                                "shaders/opengl/precompiled/$cacheType/$titleIdHex.bin"
                            )
                        }
                        tree.deleteDocument("shaders/opengl/transferable/$titleIdHex.bin")
                    }

                    else -> {
                        listOf("vs", "fs", "gs", "pl").forEach { cacheType ->
                            tree.deleteDocument(
                                "shaders/vulkan/transferable/${titleIdHex}_$cacheType.vkch"
                            )
                        }
                        tree.getFilesName("shaders/vulkan/pipeline")
                            .filterNotNull()
                            .filter { it.startsWith(titleIdHex) }
                            .forEach { tree.deleteDocument("shaders/vulkan/pipeline/$it") }
                    }
                }
                activity.runOnUiThread { result.success(true) }
            }.start()
        }
    }

    private inner class CreateGameShortcut : AzaharMethodHandler {
        override val name = "createGameShortcut"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val path = call.argument<String>("path") ?: ""
            val shortcutName = call.argument<String>("name") ?: ""
            val iconFilePath = call.argument<String>("iconFilePath")
            val stretch = call.argument<Boolean>("stretch") ?: false
            if (shortcutName.isEmpty()) {
                result.error("invalid_argument", "name is required", null)
                return
            }
            Thread {
                val icon = iconFilePath?.let {
                    BitmapFactory.decodeFile(it)?.let { bitmap -> scaleShortcutIcon(bitmap, stretch) }
                }
                val shortcutManager = activity.getSystemService(ShortcutManager::class.java)
                val shortcut = ShortcutInfo.Builder(activity, shortcutName)
                    .setShortLabel(shortcutName)
                    .apply { if (icon != null) setIcon(Icon.createWithBitmap(icon)) }
                    .setIntent(buildShortcutIntent(activity, path))
                    .build()
                shortcutManager?.requestPinShortcut(shortcut, null)
                activity.runOnUiThread { result.success(null) }
            }.start()
        }
    }

    /**
     * Mirrors `GameAdapter.refreshShortcutDialogIcon`/Compose's `scaleShortcutIcon`: [stretch]
     * squashes the whole image onto the 108x108 adaptive-icon canvas, otherwise the image is
     * scaled to cover the canvas and center-cropped to it.
     */
    private fun scaleShortcutIcon(source: Bitmap, stretch: Boolean): Bitmap {
        val targetSize = 108
        if (stretch) {
            return source.scale(targetSize, targetSize)
        }
        val width = source.width
        val height = source.height
        return if (width > height) {
            val scaleFactor = targetSize.toFloat() / height
            val scaledWidth = (width * scaleFactor).toInt()
            val scaled = source.scale(scaledWidth, targetSize)
            val startX = (scaledWidth - targetSize) / 2
            Bitmap.createBitmap(scaled, startX, 0, targetSize, targetSize)
        } else {
            val scaleFactor = targetSize.toFloat() / width
            val scaledHeight = (height * scaleFactor).toInt()
            val scaled = source.scale(targetSize, scaledHeight)
            val startY = (scaledHeight - targetSize) / 2
            Bitmap.createBitmap(scaled, 0, startY, targetSize, targetSize)
        }
    }

    private fun buildShortcutIntent(context: Context, path: String): Intent =
        EmulationActivity.createLaunchIntent(context, path).apply {
            action = Intent.ACTION_VIEW
            putExtra("launched_from_shortcut", true)
        }
}
