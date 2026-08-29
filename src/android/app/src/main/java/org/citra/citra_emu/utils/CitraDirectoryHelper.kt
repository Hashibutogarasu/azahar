// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.utils

import android.content.Intent
import android.net.Uri
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.model.SetupCallback
import org.citra.citra_emu.viewmodel.HomeViewModel

/**
 * Citra directory initialization ui flow controller.
 *
 * Rather than showing a `DialogFragment` directly, this sets state on
 * [HomeViewModel] that `MainScreen` observes to render the
 * `CitraDirectoryDialog`/`CopyDirProgressDialog` composables.
 */
class CitraDirectoryHelper(private val fragmentActivity: FragmentActivity) {
    fun showCitraDirectoryDialog(result: Uri, callback: SetupCallback? = null) {
        val viewModel = ViewModelProvider(fragmentActivity)[HomeViewModel::class.java]
        viewModel.directoryListener = HomeViewModel.DirectoryDialogListener { moveData, path ->
            val previous = PermissionsHandler.citraDirectory
            // Do nothing if user selects the previous path.
            if (path == previous) {
                return@DirectoryDialogListener
            }

            val takeFlags = Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                    Intent.FLAG_GRANT_READ_URI_PERMISSION
            fragmentActivity.contentResolver.takePersistableUriPermission(path, takeFlags)
            if (!moveData || previous.toString().isEmpty()) {
                initializeCitraDirectory(path)
                callback?.onStepCompleted()
                viewModel.setUserDir(fragmentActivity, path.path!!)
                viewModel.setPickingUserDir(false)
                return@DirectoryDialogListener
            }

            // If user checked move data, kick off the copy; MainScreen shows its progress
            // dialog for as long as HomeViewModel.copyInProgress stays true.
            startCopyDir(viewModel, previous, path, callback)
        }
        viewModel.setPendingDirectoryPath(result)
    }

    private fun startCopyDir(
        viewModel: HomeViewModel,
        previous: Uri,
        path: Uri,
        callback: SetupCallback?
    ) {
        if (viewModel.copyInProgress) {
            return
        }
        viewModel.clearCopyInfo()
        viewModel.setCopyInProgress(true)

        fragmentActivity.lifecycleScope.launch {
            withContext(Dispatchers.IO) {
                FileUtil.copyDir(
                    previous.toString(),
                    path.toString(),
                    object : FileUtil.CopyDirListener {
                        override fun onSearchProgress(directoryName: String) {
                            viewModel.onUpdateSearchProgress(
                                CitraApplication.appContext.resources,
                                directoryName
                            )
                        }

                        override fun onCopyProgress(filename: String, progress: Int, max: Int) {
                            viewModel.onUpdateCopyProgress(
                                CitraApplication.appContext.resources,
                                filename,
                                progress,
                                max
                            )
                        }

                        override fun onComplete() {
                            initializeCitraDirectory(path)
                            callback?.onStepCompleted()
                            viewModel.setCopyComplete(true)
                        }
                    }
                )
            }
        }
    }

    companion object {
        fun initializeCitraDirectory(path: Uri) {
            PermissionsHandler.setCitraDirectory(path.toString())
            DirectoryInitialization.resetCitraDirectoryState()
            DirectoryInitialization.start()
        }
    }
}
