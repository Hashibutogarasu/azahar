package org.citra.citra_emu.ui.settings
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import org.citra.citra_emu.features.settings.domain.SettingAction
import org.citra.citra_emu.features.settings.ui.SettingsEvent
import org.citra.citra_emu.features.settings.ui.SettingsViewModel
@Composable
fun SettingsScreen(
    viewModel: SettingsViewModel = viewModel(),
    userDir: String? = null,
    gamesDir: String? = null,
    driverName: String? = null,
    onEvent: (SettingsEvent) -> Unit
) {
    val settingsList by viewModel.settingsList.collectAsState()
    val events = viewModel.events
    LaunchedEffect(Unit) {
        events.collect { event ->
            onEvent(event)
        }
    }
    Scaffold(
        modifier = Modifier.fillMaxSize()
    ) { innerPadding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding),
            contentPadding = PaddingValues(bottom = 80.dp)
        ) {
            items(settingsList) { item ->
                val details = when (item.action) {
                    SettingAction.USER_FOLDER -> userDir
                    SettingAction.GAMES_FOLDER -> gamesDir
                    SettingAction.GPU_DRIVER -> driverName
                    else -> null
                }
                SettingsTile(
                    item = item,
                    details = details,
                    onClick = { viewModel.onSettingClicked(item) }
                )
            }
        }
    }
}
