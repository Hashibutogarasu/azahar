// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import android.app.Activity
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.RadioButton
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
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.preference.PreferenceManager
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootGraph
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.R
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.repository.EmulationLaunchRepository
import org.citra.citra_emu.repository.SystemSaveGameRepository
import org.citra.citra_emu.ui.compose.HtmlText
import org.citra.citra_emu.viewmodel.GamesViewModel

private sealed class SystemFilesDialog {
    data object None : SystemFilesDialog()
    data object Detecting : SystemFilesDialog()
    data class AddressEntry(val o3dsInstalled: Boolean, val n3dsInstalled: Boolean) : SystemFilesDialog()
    data object Preparing : SystemFilesDialog()
    data object UnlinkConfirm : SystemFilesDialog()
}

/**
 * Mirrors the legacy `SystemFilesFragment`: system save-game setup toggles, the multi-step
 * "set up system files" flow (detect installed titles, pick O3DS/N3DS + Artic address, install),
 * and the home menu launcher.
 */
@Destination<RootGraph>
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SystemFilesScreen(
    gamesViewModel: GamesViewModel,
    modifier: Modifier = Modifier
) {
    val systemSaveGameRepository = remember { SystemSaveGameRepository() }
    var runSystemSetup by remember { mutableStateOf(false) }

    LaunchedEffect(Unit) {
        systemSaveGameRepository.ensureLoaded()
        runSystemSetup = systemSaveGameRepository.isSystemSetupNeeded()
    }

    val context = LocalContext.current
    val emulationLaunchRepository = remember { EmulationLaunchRepository() }
    val onNavigateBack: () -> Unit = { (context as Activity).finish() }
    val onLaunchEmulation: (Game) -> Unit =
        { game -> context.startActivity(emulationLaunchRepository.createLaunchIntent(game)) }
    val preferences = remember {
        PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
    }
    val scope = rememberCoroutineScope()

    val showApps by gamesViewModel.showHomeApps.collectAsStateWithLifecycle()
    var consoleLinked by remember { mutableStateOf(NativeLibrary.isFullConsoleLinked()) }
    var dialog by remember { mutableStateOf<SystemFilesDialog>(SystemFilesDialog.None) }
    var articAddress by remember {
        mutableStateOf(preferences.getString("last_artic_base_addr", "") ?: "")
    }
    var setupStateCached by remember { mutableStateOf<BooleanArray?>(null) }

    val regionValues = remember { context.resources.getIntArray(R.array.systemFileRegionValues) }
    val regionEntries = remember { context.resources.getStringArray(R.array.systemFileRegions) }
    val homeMenuMap = remember {
        regionValues.indices.associate { i ->
            regionEntries[i] to NativeLibrary.getHomeMenuPath(regionValues[i])
        }.filterValues { it.isNotEmpty() }
    }
    var selectedRegion by remember { mutableStateOf(homeMenuMap.keys.firstOrNull().orEmpty()) }

    Scaffold(
        modifier = modifier,
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.setup_system_files)) },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(painterResource(R.drawable.ic_back), contentDescription = null)
                    }
                }
            )
        }
    ) { contentPadding ->
        Column(
            Modifier
                .padding(contentPadding)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp)
        ) {
            Text(
                stringResource(R.string.setup_system_files),
                style = MaterialTheme.typography.titleMedium,
                modifier = Modifier.padding(top = 16.dp)
            )
            HtmlText(
                stringResource(R.string.setup_system_files_preamble),
                style = MaterialTheme.typography.titleSmall,
                modifier = Modifier.padding(top = 16.dp)
            )

            Button(
                onClick = { dialog = SystemFilesDialog.Detecting },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp)
            ) { Text(stringResource(R.string.setup_tool_connect)) }

            Button(
                onClick = { dialog = SystemFilesDialog.UnlinkConfirm },
                enabled = consoleLinked,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp)
            ) { Text(stringResource(R.string.delete_system_files)) }

            HorizontalDivider(Modifier.padding(top = 24.dp))

            Text(
                stringResource(R.string.boot_home_menu),
                style = MaterialTheme.typography.titleMedium,
                modifier = Modifier.padding(top = 24.dp)
            )

            var regionDropdownExpanded by remember { mutableStateOf(false) }
            ExposedDropdownMenuBox(
                expanded = regionDropdownExpanded,
                onExpandedChange = { regionDropdownExpanded = it },
                modifier = Modifier.padding(top = 16.dp)
            ) {
                OutlinedTextField(
                    value = selectedRegion,
                    onValueChange = {},
                    readOnly = true,
                    enabled = homeMenuMap.isNotEmpty(),
                    label = { Text(stringResource(R.string.emulated_region)) },
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = regionDropdownExpanded) },
                    modifier = Modifier
                        .fillMaxWidth()
                        .menuAnchor()
                )
                ExposedDropdownMenu(
                    expanded = regionDropdownExpanded,
                    onDismissRequest = { regionDropdownExpanded = false }
                ) {
                    homeMenuMap.keys.forEach { region ->
                        DropdownMenuItem(
                            text = { Text(region) },
                            onClick = {
                                selectedRegion = region
                                regionDropdownExpanded = false
                            }
                        )
                    }
                }
            }

            Button(
                onClick = {
                    val menuPath = homeMenuMap[selectedRegion]
                    if (menuPath != null) {
                        onLaunchEmulation(Game(title = context.getString(R.string.home_menu), path = menuPath, filename = ""))
                    }
                },
                enabled = homeMenuMap.isNotEmpty(),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp)
            ) { Text(stringResource(R.string.start)) }

            SwitchRow(
                titleId = R.string.run_system_setup,
                checked = runSystemSetup,
                onCheckedChange = {
                    runSystemSetup = it
                    systemSaveGameRepository.setSystemSetupNeeded(it)
                }
            )
            SwitchRow(
                titleId = R.string.show_home_apps,
                checked = showApps,
                onCheckedChange = { gamesViewModel.setShowHomeApps(it) }
            )
        }
    }

    when (val d = dialog) {
        is SystemFilesDialog.None -> {}

        is SystemFilesDialog.Detecting -> {
            LaunchedEffect(Unit) {
                val setupState = setupStateCached ?: withContext(Dispatchers.IO) {
                    NativeLibrary.areSystemTitlesInstalled()
                }.also { setupStateCached = it }
                dialog = SystemFilesDialog.AddressEntry(setupState[0], setupState[1])
            }
            ProgressDialog(
                titleId = R.string.setup_system_files,
                messageId = R.string.setup_system_files_detect
            )
        }

        is SystemFilesDialog.AddressEntry -> {
            AddressEntryDialog(
                address = articAddress,
                onAddressChange = { articAddress = it },
                o3dsInstalled = d.o3dsInstalled,
                n3dsInstalled = d.n3dsInstalled,
                onDismiss = { dialog = SystemFilesDialog.None },
                onConfirm = { installO3ds ->
                    preferences.edit().putString("last_artic_base_addr", articAddress).apply()
                    dialog = SystemFilesDialog.Preparing
                    scope.launch {
                        withContext(Dispatchers.IO) {
                            NativeLibrary.uninstallSystemFiles(installO3ds)
                        }
                        setupStateCached = null
                        consoleLinked = NativeLibrary.isFullConsoleLinked()
                        dialog = SystemFilesDialog.None
                        val path = if (installO3ds) "articinio://$articAddress" else "articinin://$articAddress"
                        onLaunchEmulation(Game(title = context.getString(R.string.artic_base), path = path, filename = ""))
                    }
                }
            )
        }

        is SystemFilesDialog.Preparing -> {
            ProgressDialog(
                titleId = R.string.setup_system_files,
                messageId = R.string.setup_system_files_preparing
            )
        }

        is SystemFilesDialog.UnlinkConfirm -> {
            AlertDialog(
                onDismissRequest = { dialog = SystemFilesDialog.None },
                title = { Text(stringResource(R.string.delete_system_files)) },
                text = { HtmlText(context.getString(R.string.delete_system_files_description)) },
                confirmButton = {
                    TextButton(onClick = {
                        NativeLibrary.unlinkConsole()
                        consoleLinked = NativeLibrary.isFullConsoleLinked()
                        dialog = SystemFilesDialog.None
                    }) { Text(stringResource(android.R.string.ok)) }
                },
                dismissButton = {
                    TextButton(onClick = { dialog = SystemFilesDialog.None }) {
                        Text(stringResource(android.R.string.cancel))
                    }
                }
            )
        }
    }
}

@Composable
private fun SwitchRow(titleId: Int, checked: Boolean, onCheckedChange: (Boolean) -> Unit) {
    Row(
        Modifier
            .fillMaxWidth()
            .padding(top = 16.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(stringResource(titleId), modifier = Modifier.weight(1f))
        Switch(checked = checked, onCheckedChange = onCheckedChange)
    }
}

@Composable
private fun ProgressDialog(titleId: Int, messageId: Int) {
    AlertDialog(
        onDismissRequest = {},
        title = { Text(stringResource(titleId)) },
        text = {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Text(stringResource(messageId))
                CircularProgressIndicator(Modifier.padding(top = 16.dp))
            }
        },
        confirmButton = {}
    )
}

@Composable
private fun AddressEntryDialog(
    address: String,
    onAddressChange: (String) -> Unit,
    o3dsInstalled: Boolean,
    n3dsInstalled: Boolean,
    onDismiss: () -> Unit,
    onConfirm: (installO3ds: Boolean) -> Unit
) {
    var selectedO3ds by remember { mutableStateOf(false) }
    var selectedN3ds by remember { mutableStateOf(false) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.setup_system_files_enter_address)) },
        text = {
            Column {
                OutlinedTextField(
                    value = address,
                    onValueChange = onAddressChange,
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Uri)
                )
                Column(Modifier.selectableGroup().padding(top = 12.dp)) {
                    Row(
                        Modifier
                            .fillMaxWidth()
                            .selectable(
                                selected = selectedO3ds,
                                enabled = true,
                                onClick = { selectedO3ds = true; selectedN3ds = false }
                            ),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        RadioButton(selected = selectedO3ds, onClick = null)
                        Text(stringResource(R.string.setup_system_files_o3ds))
                    }
                    Text(
                        stringResource(
                            if (!o3dsInstalled) R.string.setup_system_files_possible
                            else R.string.setup_system_files_completed
                        ),
                        style = MaterialTheme.typography.labelSmall,
                        modifier = Modifier.padding(start = 48.dp)
                    )

                    Row(
                        Modifier
                            .fillMaxWidth()
                            .selectable(
                                selected = selectedN3ds,
                                enabled = o3dsInstalled,
                                onClick = { selectedN3ds = true; selectedO3ds = false }
                            ),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        RadioButton(selected = selectedN3ds, onClick = null, enabled = o3dsInstalled)
                        Text(stringResource(R.string.setup_system_files_n3ds))
                    }
                    Text(
                        stringResource(
                            when {
                                !o3dsInstalled -> R.string.setup_system_files_o3ds_needed
                                !n3dsInstalled -> R.string.setup_system_files_possible
                                else -> R.string.setup_system_files_completed
                            }
                        ),
                        style = MaterialTheme.typography.labelSmall,
                        modifier = Modifier.padding(start = 48.dp)
                    )
                }
            }
        },
        confirmButton = {
            TextButton(
                onClick = { onConfirm(selectedO3ds) },
                enabled = address.isNotEmpty() && (selectedO3ds || selectedN3ds)
            ) { Text(stringResource(android.R.string.ok)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(android.R.string.cancel)) }
        }
    )
}
