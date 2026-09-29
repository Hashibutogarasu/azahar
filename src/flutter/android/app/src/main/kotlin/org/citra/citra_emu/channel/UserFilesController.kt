package org.citra.citra_emu.channel

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.ParcelFileDescriptor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.CitraApplication
import java.util.concurrent.Executors

/**
 * Reads and writes files inside the user directory at paths chosen by Dart. Paths are relative
 * to the user directory, which is a document tree on Android and cannot be opened with plain
 * file APIs from Dart.
 */
class UserFilesController(private val activity: Activity) {
    private val executor = Executors.newSingleThreadExecutor()
    private val documentsTree get() = CitraApplication.documentsTree

    val handlers: List<AzaharMethodHandler> = listOf(
        AppendUserFile(),
        RotateUserFile(),
        UserFileExists(),
        ShareUserFile()
    )

    private fun runOffMainThread(result: MethodChannel.Result, task: () -> Boolean) {
        executor.execute {
            val succeeded = try {
                task()
            } catch (e: Exception) {
                false
            }
            activity.runOnUiThread { result.success(succeeded) }
        }
    }

    private fun ensureDirectory(directory: String): Boolean {
        var current = ""
        for (segment in directory.split('/').filter { it.isNotEmpty() }) {
            if (!documentsTree.createDir(current, segment)) {
                return false
            }
            current = if (current.isEmpty()) segment else "$current/$segment"
        }
        return true
    }

    private fun append(path: String, text: String): Boolean {
        val directory = path.substringBeforeLast('/', "")
        val filename = path.substringAfterLast('/')
        if (!ensureDirectory(directory) || !documentsTree.createFile(directory, filename)) {
            return false
        }
        val fd = documentsTree.openContentUri(path, "rwa")
        if (fd < 0) {
            return false
        }
        ParcelFileDescriptor.AutoCloseOutputStream(ParcelFileDescriptor.adoptFd(fd)).use {
            it.write(text.toByteArray(Charsets.UTF_8))
        }
        return true
    }

    private fun rotate(path: String, previousPath: String): Boolean {
        if (!documentsTree.exists(path)) {
            return true
        }
        documentsTree.deleteDocument(previousPath)
        return documentsTree.renameFile(path, previousPath.substringAfterLast('/'))
    }

    private inner class AppendUserFile : AzaharMethodHandler {
        override val name = "appendUserFile"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val path = call.argument<String>("path")!!
            val text = call.argument<String>("text")!!
            runOffMainThread(result) { append(path, text) }
        }
    }

    private inner class RotateUserFile : AzaharMethodHandler {
        override val name = "rotateUserFile"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val path = call.argument<String>("path")!!
            val previousPath = call.argument<String>("previousPath")!!
            runOffMainThread(result) { rotate(path, previousPath) }
        }
    }

    private inner class UserFileExists : AzaharMethodHandler {
        override val name = "userFileExists"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val path = call.argument<String>("path")!!
            runOffMainThread(result) { documentsTree.exists(path) }
        }
    }

    private inner class ShareUserFile : AzaharMethodHandler {
        override val name = "shareUserFile"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val path = call.argument<String>("path")!!
            val uri = documentsTree.getUri(path)
            if (uri == Uri.EMPTY) {
                result.success(false)
                return
            }
            val sendIntent = Intent(Intent.ACTION_SEND).apply {
                type = "text/plain"
                putExtra(Intent.EXTRA_STREAM, uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            activity.startActivity(Intent.createChooser(sendIntent, null))
            result.success(true)
        }
    }
}
