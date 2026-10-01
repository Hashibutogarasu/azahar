// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.channel

import android.app.Activity
import android.content.ContentResolver
import android.content.Intent
import android.net.Uri
import androidx.activity.result.ActivityResultLauncher
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.FileUtil
import org.citra.citra_emu.utils.PermissionsHandler

class DirectoryController(
    private val activity: Activity,
    private val contentResolver: ContentResolver,
    private val openUserDirectoryLauncher: ActivityResultLauncher<Uri?>,
    private val openGamesDirectoryLauncher: ActivityResultLauncher<Uri?>
) {
    private var pendingUserDirectoryResult: MethodChannel.Result? = null
    private var pendingGamesDirectoryResult: MethodChannel.Result? = null
    var copyProgressSink: EventChannel.EventSink? = null

    fun onUserDirectoryPicked(uri: Uri?) {
        val result = pendingUserDirectoryResult
        pendingUserDirectoryResult = null
        result?.success(uri?.toString())
    }

    fun onGamesDirectoryPicked(uri: Uri?) {
        val result = pendingGamesDirectoryResult
        pendingGamesDirectoryResult = null
        if (uri == null) {
            result?.success(null)
            return
        }
        contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
        result?.success(uri.toString())
    }

    val handlers: List<AzaharMethodHandler> = listOf(
        OpenUserDirectory(),
        ConfirmUserDirectory(),
        HasUserDirectoryWriteAccess(),
        OpenGamesDirectory()
    )

    private inner class OpenUserDirectory : AzaharMethodHandler {
        override val name = "openUserDirectory"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            pendingUserDirectoryResult = result
            openUserDirectoryLauncher.launch(null)
        }
    }

    private inner class OpenGamesDirectory : AzaharMethodHandler {
        override val name = "openGamesDirectory"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            pendingGamesDirectoryResult = result
            openGamesDirectoryLauncher.launch(null)
        }
    }

    private inner class HasUserDirectoryWriteAccess : AzaharMethodHandler {
        override val name = "hasUserDirectoryWriteAccess"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            result.success(PermissionsHandler.hasWriteAccess(activity))
        }
    }

    private inner class ConfirmUserDirectory : AzaharMethodHandler {
        override val name = "confirmUserDirectory"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val uri = call.argument<String>("uri")!!
            val previousUri = call.argument<String>("previousUri")
            val moveData = call.argument<Boolean>("moveData") ?: false
            val parsed = Uri.parse(uri)
            if (uri != previousUri) {
                contentResolver.takePersistableUriPermission(
                    parsed,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                )
            }

            fun commit() {
                PermissionsHandler.setCitraDirectory(uri)
                DirectoryInitialization.resetCitraDirectoryState()
                DirectoryInitialization.start()
                result.success(null)
            }

            if (moveData && previousUri != null) {
                Thread {
                    FileUtil.copyDir(previousUri, uri, object : FileUtil.CopyDirListener {
                        override fun onSearchProgress(directoryName: String) {
                            activity.runOnUiThread {
                                copyProgressSink?.success(
                                    mapOf("phase" to "search", "name" to directoryName)
                                )
                            }
                        }

                        override fun onCopyProgress(filename: String, progress: Int, max: Int) {
                            activity.runOnUiThread {
                                copyProgressSink?.success(
                                    mapOf(
                                        "phase" to "copy",
                                        "name" to filename,
                                        "progress" to progress,
                                        "max" to max
                                    )
                                )
                            }
                        }

                        override fun onComplete() {
                            activity.runOnUiThread { commit() }
                        }
                    })
                }.start()
            } else {
                commit()
            }
        }
    }
}
