// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import android.app.Activity
import android.content.ContentResolver
import android.content.Intent
import android.net.Uri
import androidx.activity.result.ActivityResultLauncher
import androidx.documentfile.provider.DocumentFile
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.profiles.ProfileStore
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.profiles.ProfilesDocumentsProvider
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.NativeLibrary
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.DirectoryInitialization
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.DirectoryInitialization.DirectoryInitializationState
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.FileUtil
import com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils.PermissionsHandler

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
        if (uri == null) {
            result?.success(null)
            return
        }
        contentResolver.takePersistableUriPermission(
            uri,
            Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
        )
        result?.success(uri.toString())
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
        OpenGamesDirectory(),
        SetProfiles(),
        ProfileTreeUri(),
        InitializeProfileDirectory()
    )

    private inner class SetProfiles : AzaharMethodHandler {
        override val name = "setProfiles"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val profiles = call.argument<List<Map<String, Any>>>("profiles") ?: emptyList()
            ProfilesDocumentsProvider.setProfiles(
                activity,
                profiles.map {
                    ProfileStore.Entry(
                        hash = it["hash"] as String,
                        name = it["name"] as String,
                        isBuiltIn = it["isBuiltIn"] as Boolean,
                        location = Uri.parse(it["location"] as String)
                    )
                }
            )
            result.success(null)
        }
    }

    private inner class ProfileTreeUri : AzaharMethodHandler {
        override val name = "profileTreeUri"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val hash = call.argument<String>("hash")!!
            result.success(ProfilesDocumentsProvider.treeUri(activity, hash).toString())
        }
    }

    private inner class InitializeProfileDirectory : AzaharMethodHandler {
        override val name = "initializeProfileDirectory"
        override fun execute(call: MethodCall, result: MethodChannel.Result) {
            val uri = Uri.parse(call.argument<String>("uri")!!)
            Thread {
                try {
                    val root = DocumentFile.fromTreeUri(activity, uri)
                        ?: throw IllegalArgumentException("Cannot open $uri")
                    listOf("config", "nand", "sdmc", "sysdata", "cheats", "log").forEach {
                        if (root.findFile(it) == null) {
                            root.createDirectory(it)
                        }
                    }
                    activity.runOnUiThread { result.success(null) }
                } catch (e: Exception) {
                    activity.runOnUiThread {
                        result.error("initializeProfileDirectory", e.message, null)
                    }
                }
            }.start()
        }
    }

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
            val isProfileTree =
                parsed.authority == ProfilesDocumentsProvider.authority(activity)
            if (uri != previousUri && !isProfileTree) {
                contentResolver.takePersistableUriPermission(
                    parsed,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                )
            }

            fun commit() {
                PermissionsHandler.setCitraDirectory(uri)
                DirectoryInitialization.resetCitraDirectoryState()
                if (DirectoryInitialization.start() ==
                    DirectoryInitializationState.CITRA_DIRECTORIES_INITIALIZED
                ) {
                    NativeLibrary.reloadSettings()
                }
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
