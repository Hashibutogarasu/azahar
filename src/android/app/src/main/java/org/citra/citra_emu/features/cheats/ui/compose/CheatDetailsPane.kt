// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.cheats.ui.compose

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import org.citra.citra_emu.R
import org.citra.citra_emu.features.cheats.model.Cheat
import org.citra.citra_emu.features.cheats.model.CheatsViewModel

/**
 * Details/edit pane of the cheats master-detail screen. Mirrors
 * `CheatDetailsFragment`: view mode shows the selected cheat's fields
 * read-only with Delete/Edit actions, edit mode (either editing the
 * selection or adding a new cheat) makes the fields editable with
 * Cancel/OK actions.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CheatDetailsPane(
    cheatsViewModel: CheatsViewModel,
    onClose: () -> Unit,
    modifier: Modifier = Modifier
) {
    val selectedCheat by cheatsViewModel.selectedCheat.collectAsStateWithLifecycle()
    val isEditing by cheatsViewModel.isEditing.collectAsStateWithLifecycle()
    val isAdding by cheatsViewModel.isAdding.collectAsStateWithLifecycle()
    val context = LocalContext.current

    var name by rememberSaveable { mutableStateOf("") }
    var notes by rememberSaveable { mutableStateOf("") }
    var code by rememberSaveable { mutableStateOf("") }
    var nameError by remember { mutableStateOf<String?>(null) }
    var codeError by remember { mutableStateOf<String?>(null) }
    var pendingDelete by remember { mutableStateOf(false) }

    val okFocusRequester = remember { FocusRequester() }
    val deleteFocusRequester = remember { FocusRequester() }

    // Mirrors CheatDetailsFragment.onSelectedCheatUpdated: skip repopulating the
    // fields while a fragment-recreation-triggered re-collection lands mid-edit,
    // so in-progress, unsaved keystrokes are never clobbered.
    LaunchedEffect(selectedCheat) {
        nameError = null
        codeError = null
        if (!isEditing) {
            name = selectedCheat?.getName().orEmpty()
            notes = selectedCheat?.getNotes().orEmpty()
            code = selectedCheat?.getCode().orEmpty()
        }
    }

    fun onOkClicked() {
        nameError = null
        codeError = null
        if (name.isEmpty()) {
            nameError = context.getString(R.string.cheats_error_no_name)
            return
        }
        if (code.isEmpty()) {
            codeError = context.getString(R.string.cheats_error_no_code_lines)
            return
        }
        val validityResult = Cheat.isValidGatewayCode(code)
        if (validityResult != 0) {
            codeError = context.getString(R.string.cheats_error_on_line, validityResult)
            return
        }
        val newCheat = Cheat.createGatewayCode(name, notes, code)
        if (isAdding) {
            cheatsViewModel.finishAddingCheat(newCheat)
        } else {
            cheatsViewModel.updateSelectedCheat(newCheat)
        }
    }

    fun onCancelClicked() {
        cheatsViewModel.setIsEditing(false)
        nameError = null
        codeError = null
        name = selectedCheat?.getName().orEmpty()
        notes = selectedCheat?.getNotes().orEmpty()
        code = selectedCheat?.getCode().orEmpty()
    }

    Scaffold(
        modifier = modifier,
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.cheats)) },
                navigationIcon = {
                    IconButton(onClick = onClose) {
                        Icon(painterResource(R.drawable.ic_back), contentDescription = null)
                    }
                }
            )
        }
    ) { contentPadding ->
        Column(
            modifier = Modifier
                .padding(contentPadding)
                .fillMaxSize()
                .imePadding()
        ) {
            Column(
                modifier = Modifier
                    .weight(1f)
                    .verticalScroll(rememberScrollState())
                    .padding(horizontal = 16.dp)
            ) {
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text(stringResource(R.string.cheats_name)) },
                    enabled = isEditing,
                    isError = nameError != null,
                    supportingText = { nameError?.let { Text(it) } },
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(imeAction = ImeAction.Next),
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 12.dp, bottom = 4.dp)
                )
                OutlinedTextField(
                    value = notes,
                    onValueChange = { notes = it },
                    label = { Text(stringResource(R.string.cheats_notes)) },
                    enabled = isEditing,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 4.dp)
                )
                OutlinedTextField(
                    value = code,
                    onValueChange = { code = it },
                    label = { Text(stringResource(R.string.cheats_code)) },
                    enabled = isEditing,
                    isError = codeError != null,
                    supportingText = { codeError?.let { Text(it) } },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 4.dp)
                )
            }

            HorizontalDivider()

            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                if (isEditing) {
                    TextButton(onClick = ::onCancelClicked, modifier = Modifier.weight(1f)) {
                        Text(stringResource(android.R.string.cancel))
                    }
                    Button(
                        onClick = ::onOkClicked,
                        modifier = Modifier
                            .weight(1f)
                            .focusRequester(okFocusRequester)
                    ) {
                        Text(stringResource(android.R.string.ok))
                    }
                } else {
                    TextButton(
                        onClick = { pendingDelete = true },
                        modifier = Modifier
                            .weight(1f)
                            .focusRequester(deleteFocusRequester)
                    ) {
                        Text(stringResource(R.string.cheats_delete))
                    }
                    Button(
                        onClick = {
                            cheatsViewModel.setIsEditing(true)
                            okFocusRequester.requestFocus()
                        },
                        modifier = Modifier.weight(1f)
                    ) {
                        Text(stringResource(R.string.cheats_edit))
                    }
                }
            }
        }
    }

    if (pendingDelete) {
        AlertDialog(
            onDismissRequest = { pendingDelete = false },
            text = { Text(stringResource(R.string.cheats_delete_confirmation, name)) },
            confirmButton = {
                TextButton(onClick = {
                    pendingDelete = false
                    cheatsViewModel.deleteSelectedCheat()
                }) {
                    Text(stringResource(android.R.string.ok))
                }
            },
            dismissButton = {
                TextButton(onClick = { pendingDelete = false }) {
                    Text(stringResource(android.R.string.cancel))
                }
            }
        )
    }
}
