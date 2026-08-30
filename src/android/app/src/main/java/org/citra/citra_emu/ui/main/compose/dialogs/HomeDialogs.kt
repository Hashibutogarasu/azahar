// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose.dialogs

import android.content.Intent
import android.net.Uri
import android.widget.Toast
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Checkbox
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import org.citra.citra_emu.R
import org.citra.citra_emu.ui.compose.HtmlText
import org.citra.citra_emu.utils.PermissionsHandler
import org.citra.citra_emu.viewmodel.HomeViewModel
import org.citra.citra_emu.viewmodel.TaskViewModel

/**
 * A one-button informational dialog. Mirrors the legacy `MessageDialogFragment`.
 */
@Composable
fun MessageDialog(
    titleId: Int,
    description: String,
    helpLinkId: Int,
    onDismiss: () -> Unit
) {
    val context = LocalContext.current
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(titleId)) },
        text = { if (description.isNotEmpty()) Text(description) },
        confirmButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(R.string.close)) }
        },
        dismissButton = if (helpLinkId != 0) {
            {
                TextButton(onClick = {
                    context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(context.getString(helpLinkId))))
                }) { Text(stringResource(R.string.learn_more)) }
            }
        } else {
            null
        }
    )
}

/**
 * Asks the user to confirm skipping an unfinished, skippable setup step.
 * Mirrors the legacy `SetupWarningDialogFragment`.
 */
@Composable
fun SetupWarningDialog(
    titleId: Int,
    descriptionId: Int,
    helpLinkId: Int,
    onSkip: () -> Unit,
    onCancel: () -> Unit
) {
    val context = LocalContext.current
    AlertDialog(
        onDismissRequest = onCancel,
        title = { Text(if (titleId != 0) stringResource(titleId) else "") },
        text = { if (descriptionId != 0) Text(stringResource(descriptionId)) },
        confirmButton = {
            TextButton(onClick = onSkip) { Text(stringResource(R.string.warning_skip)) }
        },
        dismissButton = {
            Row {
                if (helpLinkId != 0) {
                    TextButton(onClick = {
                        context.startActivity(
                            Intent(Intent.ACTION_VIEW, Uri.parse(context.getString(helpLinkId)))
                        )
                    }) { Text(stringResource(R.string.warning_help)) }
                }
                TextButton(onClick = onCancel) { Text(stringResource(R.string.warning_cancel)) }
            }
        }
    )
}

/**
 * Confirms the freshly picked Citra directory, optionally offering to move data from the
 * previous one. Mirrors the legacy `CitraDirectoryDialogFragment`.
 */
@Composable
fun CitraDirectoryDialog(
    path: Uri,
    showMoveDataCheckbox: Boolean,
    onConfirm: (moveData: Boolean) -> Unit,
    onCancel: () -> Unit
) {
    var moveData by remember(path) { mutableStateOf(false) }
    AlertDialog(
        onDismissRequest = onCancel,
        title = { Text(stringResource(R.string.select_citra_user_folder)) },
        text = {
            Column {
                Text(path.path.orEmpty())
                if (showMoveDataCheckbox) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier
                            .fillMaxWidth()
                            .selectable(
                                selected = moveData,
                                onClick = { moveData = !moveData },
                                role = Role.Checkbox
                            )
                    ) {
                        Checkbox(checked = moveData, onCheckedChange = null)
                        Text(stringResource(R.string.move_data))
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = { onConfirm(moveData) }) { Text(stringResource(android.R.string.ok)) }
        },
        dismissButton = {
            TextButton(onClick = onCancel) { Text(stringResource(android.R.string.cancel)) }
        }
    )
}

/**
 * Prompts the user to grant folder access when write permission has been lost.
 * Mirrors the legacy `SelectUserDirectoryDialogFragment`.
 */
@Composable
fun SelectUserDirectoryDialog(onConfirm: () -> Unit) {
    AlertDialog(
        onDismissRequest = {},
        title = { Text(stringResource(R.string.select_citra_user_folder)) },
        text = { HtmlText(stringResource(R.string.selecting_user_directory_without_write_permissions)) },
        confirmButton = {
            TextButton(onClick = onConfirm) { Text(stringResource(android.R.string.ok)) }
        }
    )
}

/**
 * Lets the user pick between the current Azahar directory and a prior Lime3DS one after a
 * migration. Mirrors the legacy `UpdateUserDirectoryDialogFragment`.
 */
@Composable
fun UpdateUserDirectoryDialog(
    currentPath: String,
    priorPath: String,
    onConfirm: (selected: Int) -> Unit
) {
    var selected by remember { mutableIntStateOf(-1) }
    val choices = listOf(
        stringResource(R.string.keep_current_azahar_directory) to currentPath,
        stringResource(R.string.use_prior_lime3ds_directory) to priorPath
    )
    AlertDialog(
        onDismissRequest = {},
        title = { Text(stringResource(R.string.select_citra_user_folder)) },
        text = {
            Column(Modifier.selectableGroup()) {
                choices.forEachIndexed { index, (label, subtext) ->
                    Column(
                        Modifier
                            .fillMaxWidth()
                            .selectable(
                                selected = selected == index,
                                onClick = { selected = index },
                                role = Role.RadioButton
                            )
                            .padding(vertical = 8.dp)
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            RadioButton(selected = selected == index, onClick = null)
                            Text(label)
                        }
                        Text(
                            subtext,
                            modifier = Modifier.padding(start = 48.dp),
                            style = MaterialTheme.typography.bodySmall
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = { onConfirm(selected) }) { Text(stringResource(android.R.string.ok)) }
        }
    )
}

/**
 * Shows the progress of moving files from the previous Citra directory to a newly picked one.
 * Mirrors the legacy `CopyDirProgressDialog`; dismisses itself once the copy completes.
 */
@Composable
fun CopyDirProgressDialog(homeViewModel: HomeViewModel) {
    val messageText by homeViewModel.messageText.collectAsStateWithLifecycle()
    val dirProgress by homeViewModel.dirProgress.collectAsStateWithLifecycle()
    val maxDirProgress by homeViewModel.maxDirProgress.collectAsStateWithLifecycle()
    val copyComplete by homeViewModel.copyComplete.collectAsStateWithLifecycle()
    val context = LocalContext.current

    LaunchedEffect(copyComplete) {
        if (copyComplete) {
            homeViewModel.setUserDir(
                context as FragmentActivity,
                PermissionsHandler.citraDirectory.path!!
            )
            homeViewModel.setCopyInProgress(false)
            homeViewModel.setPickingUserDir(false)
            Toast.makeText(context, R.string.copy_complete, Toast.LENGTH_SHORT).show()
        }
    }

    Dialog(
        onDismissRequest = {},
        properties = DialogProperties(dismissOnBackPress = false, dismissOnClickOutside = false)
    ) {
        Surface(shape = MaterialTheme.shapes.extraLarge) {
            Column(Modifier.padding(24.dp)) {
                Text(stringResource(R.string.moving_data), style = MaterialTheme.typography.headlineSmall)
                Spacer(Modifier.height(16.dp))
                Text(messageText, maxLines = 4)
                Spacer(Modifier.height(12.dp))
                LinearProgressIndicator(
                    progress = {
                        if (maxDirProgress > 0) dirProgress / maxDirProgress.toFloat() else 0f
                    },
                    modifier = Modifier.fillMaxWidth()
                )
            }
        }
    }
}

/**
 * Blocks interaction while GPU drivers are still being loaded/deleted.
 * Mirrors the legacy `DriversLoadingDialogFragment`.
 */
@Composable
fun DriversLoadingDialog() {
    Dialog(
        onDismissRequest = {},
        properties = DialogProperties(dismissOnBackPress = false, dismissOnClickOutside = false)
    ) {
        Surface(shape = MaterialTheme.shapes.extraLarge) {
            Column(Modifier.padding(24.dp)) {
                Text(stringResource(R.string.loading), style = MaterialTheme.typography.headlineSmall)
                Spacer(Modifier.height(16.dp))
                LinearProgressIndicator(Modifier.fillMaxWidth())
            }
        }
    }
}

/**
 * Runs [TaskViewModel.task] in the background behind an indeterminate progress dialog.
 * Mirrors the legacy `IndeterminateProgressDialogFragment`, minus the `MessageDialogFragment`
 * result branch, since none of this migration's callers ever return one.
 */
@Composable
fun IndeterminateProgressDialog(
    taskViewModel: TaskViewModel,
    titleId: Int,
    cancellable: Boolean,
    onComplete: (Any) -> Unit,
    onDismiss: () -> Unit
) {
    val isComplete by taskViewModel.isComplete.collectAsStateWithLifecycle()
    val cancelled by taskViewModel.cancelled.collectAsStateWithLifecycle()

    LaunchedEffect(Unit) {
        if (!taskViewModel.isRunning.value) {
            taskViewModel.runTask()
        }
    }
    LaunchedEffect(isComplete) {
        if (isComplete) {
            onComplete(taskViewModel.result.value)
            taskViewModel.clear()
            onDismiss()
        }
    }

    AlertDialog(
        onDismissRequest = {},
        title = { Text(stringResource(if (cancelled) R.string.cancelling else titleId)) },
        text = { LinearProgressIndicator(Modifier.fillMaxWidth()) },
        confirmButton = {},
        dismissButton = if (cancellable) {
            {
                TextButton(onClick = { taskViewModel.setCancelled(true) }) {
                    Text(stringResource(android.R.string.cancel))
                }
            }
        } else {
            null
        }
    )
}
