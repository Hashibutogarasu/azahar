// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.cheats.ui.compose

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.clickable
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import org.citra.citra_emu.R
import org.citra.citra_emu.features.cheats.model.CheatsViewModel

/**
 * List pane of the cheats master-detail screen: an app bar, the list of
 * cheats for the running title, and a FAB to add a new one.
 *
 * Mirrors the legacy `CheatListFragment`/`CheatsAdapter` pair: the cheat
 * array itself is read straight from [CheatsViewModel.cheats] (a plain,
 * non-observable field) and re-snapshotted whenever the view model pulses
 * one of its add/change/delete events, exactly as the RecyclerView adapter
 * used to be told to refresh via `notifyItemInserted`/`notifyItemChanged`/
 * `notifyItemRemoved`.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CheatListPane(
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
