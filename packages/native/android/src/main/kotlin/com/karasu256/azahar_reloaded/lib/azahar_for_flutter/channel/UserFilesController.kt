// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.ParcelFileDescriptor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.CitraApplication

/**
 * Reads and writes files inside the user directory at paths chosen by Dart. Paths are relative
 * to the user directory, which is a document tree on Android and cannot be opened with plain
 * file APIs from Dart.
 */
class UserFilesController(private val activity: Activity) {
    private val documentsTree get() = CitraApplication.documentsTree

    val handlers: List<AzaharMethodHandler> = listOf(
        AppendUserFile(),
        RotateUserFile(),
        UserFileExists(),
        ShareUserFile()
    )

    /** Reports a failed file operation as `false` instead of an error, as Dart expects. */
    private fun succeeded(task: () -> Boolean): Boolean = try {
        task()
    } catch (e: Exception) {
        false
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

    private inner class AppendUserFile : BackgroundMethodHandler() {
        override val name = "appendUserFile"
        override fun run(call: MethodCall): Any {
            val path = call.argument<String>("path")!!
            val text = call.argument<String>("text")!!
            return succeeded { append(path, text) }
        }
    }

    private inner class RotateUserFile : BackgroundMethodHandler() {
        override val name = "rotateUserFile"
        override fun run(call: MethodCall): Any {
            val path = call.argument<String>("path")!!
            val previousPath = call.argument<String>("previousPath")!!
            return succeeded { rotate(path, previousPath) }
        }
    }

    private inner class UserFileExists : BackgroundMethodHandler() {
        override val name = "userFileExists"
        override fun run(call: MethodCall): Any {
            val path = call.argument<String>("path")!!
            return succeeded { documentsTree.exists(path) }
        }
    }

    private inner class ShareUserFile : BackgroundMethodHandler() {
        override val name = "shareUserFile"
        override fun run(call: MethodCall): Any {
            val path = call.argument<String>("path")!!
            return documentsTree.getUri(path)
        }

        override fun deliver(value: Any?, result: MethodChannel.Result) {
            val uri = value as Uri
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
