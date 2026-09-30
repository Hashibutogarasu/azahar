// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.cheats.ui.compose

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.windowInsetsBottomHeight
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
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
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import org.citra.citra_emu.R
import org.citra.citra_emu.features.cheats.model.Cheat
import org.citra.citra_emu.features.cheats.model.CheatsViewModel
import org.citra.citra_emu.utils.InsetsHelper
import org.citra.citra_emu.utils.ThemeUtil

/**
 * Master-detail cheats widget: composes its UI purely from [cheatsViewModel]'s
 * state, delegating every user action (select/add/edit/delete) back to the
 * view model. On wide screens both panes are shown side by side at all
 * times, on narrow screens only one pane is shown and the system back
 * button closes the details pane before leaving the screen.
 *
 * @param onNavigateBack invoked when the user backs out of the list pane
 * itself (finish the hosting Activity, or pop the hosting back stack when
 * embedded as a destination inside another Activity's navigation graph).
 * @param twoPaneMinWidth screen width at or above which both panes are
 * shown side by side instead of one at a time.
 */
@Composable
fun CheatsWidget(
    cheatsViewModel: CheatsViewModel,
    onNavigateBack: () -> Unit,
    modifier: Modifier = Modifier,
    twoPaneMinWidth: Dp = 600.dp
) {
    val selectedCheat by cheatsViewModel.selectedCheat.collectAsStateWithLifecycle()
    val isEditing by cheatsViewModel.isEditing.collectAsStateWithLifecycle()
    val isAdding by cheatsViewModel.isAdding.collectAsStateWithLifecycle()

    val detailsOpen = selectedCheat != null || isEditing || isAdding
    val onCloseDetails: () -> Unit = { cheatsViewModel.setSelectedCheat(null, -1) }

    Box(modifier.fillMaxSize()) {
        BoxWithConstraints(Modifier.fillMaxSize()) {
            if (maxWidth >= twoPaneMinWidth) {
                Row(Modifier.fillMaxSize()) {
                    CheatListPane(
                        cheatsViewModel,
                        onNavigateBack = onNavigateBack,
                        modifier = Modifier.weight(1f)
                    )
                    CheatDetailsPane(
                        cheatsViewModel,
                        onClose = onCloseDetails,
                        modifier = Modifier.weight(1f)
                    )
                }
            } else {
                BackHandler(enabled = detailsOpen, onBack = onCloseDetails)
                if (detailsOpen) {
                    CheatDetailsPane(
                        cheatsViewModel,
                        onClose = onCloseDetails,
                        modifier = Modifier.fillMaxSize()
                    )
                } else {
                    CheatListPane(
                        cheatsViewModel,
                        onNavigateBack = onNavigateBack,
                        modifier = Modifier.fillMaxSize()
                    )
                }
            }
        }

        val context = LocalContext.current
        if (InsetsHelper.getSystemGestureType(context) != InsetsHelper.GESTURE_NAVIGATION) {
            Box(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .fillMaxWidth()
                    .windowInsetsBottomHeight(WindowInsets.navigationBars)
                    .background(
                        MaterialTheme.colorScheme.surface.copy(alpha = ThemeUtil.SYSTEM_BAR_ALPHA)
                    )
            )
        }
    }
}

/**
 * List pane of the cheats master-detail widget: an app bar, the list of
 * cheats for the running title, and a FAB to add a new one.
 *
 * The cheat array itself is read straight from [CheatsViewModel.cheats] (a
 * plain, non-observable field) and re-snapshotted whenever the view model
 * pulses one of its add/change/delete events.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun CheatListPane(
    cheatsViewModel: CheatsViewModel,
    onNavigateBack: () -> Unit,
    modifier: Modifier = Modifier
) {
    var cheats by remember { mutableStateOf(cheatsViewModel.cheats.toList()) }

    val addedEvent by cheatsViewModel.cheatAddedEvent.collectAsStateWithLifecycle()
    val changedEvent by cheatsViewModel.cheatChangedEvent.collectAsStateWithLifecycle()
    val deletedEvent by cheatsViewModel.cheatDeletedEvent.collectAsStateWithLifecycle()
    LaunchedEffect(addedEvent, changedEvent, deletedEvent) {
        cheats = cheatsViewModel.cheats.toList()
    }

    Scaffold(
        modifier = modifier,
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.cheats)) },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(painterResource(R.drawable.ic_back), contentDescription = null)
                    }
                }
            )
        },
        floatingActionButton = {
            FloatingActionButton(onClick = { cheatsViewModel.startAddingCheat() }) {
                Icon(
                    painterResource(R.drawable.ic_add),
                    contentDescription = stringResource(R.string.cheats_add)
                )
            }
        }
    ) { contentPadding ->
        LazyColumn(
            modifier = Modifier
                .padding(contentPadding)
                .fillMaxSize()
        ) {
            itemsIndexed(cheats) { index, cheat ->
                CheatRow(
                    name = cheat.getName(),
                    enabled = cheat.getEnabled(),
                    onToggle = { cheat.setEnabled(it) },
                    onClick = { cheatsViewModel.setSelectedCheat(cheat, index) }
                )
                HorizontalDivider()
            }
        }
    }
}

/**
 * A single cheat row: its name and an enabled/disabled switch. Takes plain
 * values rather than a `Cheat` so it stays previewable without a native
 * cheat object backing it.
 */
@Composable
fun CheatRow(
    name: String,
    enabled: Boolean,
    onToggle: (Boolean) -> Unit,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    var switchState by remember(name) { mutableStateOf(enabled) }
    Row(
        modifier = modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(horizontal = 20.dp, vertical = 16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = name,
            style = MaterialTheme.typography.titleMedium,
            modifier = Modifier
                .weight(1f)
                .padding(end = 16.dp)
        )
        Switch(
            checked = switchState,
            onCheckedChange = {
                onToggle(it)
                switchState = it
            }
        )
    }
}

/**
 * Details/edit pane of the cheats master-detail widget: view mode shows the
 * selected cheat's fields read-only with Delete/Edit actions, edit mode
 * (either editing the selection or adding a new cheat) makes the fields
 * editable with Cancel/OK actions.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun CheatDetailsPane(
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

    // Skip repopulating the fields while a recomposition-triggered
    // re-collection lands mid-edit, so in-progress, unsaved keystrokes are
    // never clobbered.
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

/**
 * Registered with the Showkase component browser (see `ShowkaseLauncherActivity`)
 * under the "Cheats" group. Plain `@Preview` rather than Showkase's own
 * `@ShowkaseComposable` annotation because Showkase's annotation library is a
 * debug-only dependency and this file is compiled into every build variant;
 * Showkase auto-collects `@Preview`-annotated composables just the same.
 */
@Preview(name = "Cheat row (enabled)", group = "Cheats", showBackground = true)
@Composable
internal fun CheatRowEnabledPreview() {
    MaterialTheme {
        CheatRow(name = "Max Lives after losing 1", enabled = true, onToggle = {}, onClick = {})
    }
}

@Preview(name = "Cheat row (disabled)", group = "Cheats", showBackground = true)
@Composable
internal fun CheatRowDisabledPreview() {
    MaterialTheme {
        CheatRow(name = "Infinite Rupees", enabled = false, onToggle = {}, onClick = {})
    }
}
