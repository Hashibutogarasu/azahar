package org.citra.citra_emu.channel

import android.content.ContentResolver
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.citra.citra_emu.MainActivity
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.FileUtil
import org.citra.citra_emu.utils.PermissionsHandler

class DirectoryController(
    private val activity: MainActivity,
    private val contentResolver: ContentResolver
) {
    var copyProgressSink: EventChannel.EventSink? = null

    val handlers: List<AzaharMethodHandler> = listOf(
        ConfirmUserDirectory(),
        HasUserDirectoryWriteAccess()
    )

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
