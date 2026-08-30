// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.ui.compose

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import org.citra.citra_emu.R
import org.citra.citra_emu.features.settings.model.SettingsViewModel
import java.util.Locale

/**
 * Lets the user pick the app's own display language, reading and writing
 * [SettingsViewModel.appSettings] as the single source of truth (shared with the OS's own
 * per-app language screen on API 33+). Selecting a language only updates that repository's
 * pending selection; [SettingsActivityPresenter] applies it once the user leaves the settings
 * screen entirely.
 */
@Destination<RootGraph>
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LanguageSettingsScreen(navigator: DestinationsNavigator, settingsViewModel: SettingsViewModel) {
    val context = LocalContext.current
    val languageTags = remember {
        settingsViewModel.appSettings.getSupportedLanguageTags(context)
            .map { it.replace('_', '-') }
    }
    var selectedTag by remember {
        mutableStateOf(settingsViewModel.appSettings.getPendingOrCurrentLanguageTag())
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.preferences_language)) },
                navigationIcon = {
                    IconButton(onClick = navigator::navigateUp) {
                        Icon(painterResource(R.drawable.ic_back), contentDescription = null)
                    }
                }
            )
        }
    ) { contentPadding ->
        fun select(tag: String) {
            selectedTag = tag
            settingsViewModel.appSettings.selectPendingLanguage(tag)
        }

        LazyColumn(modifier = Modifier.padding(contentPadding).fillMaxSize()) {
            item {
                LanguageRow(
                    name = stringResource(R.string.system_default_language),
                    selected = selectedTag.isEmpty(),
                    onClick = { select("") }
                )
            }
            items(languageTags) { tag ->
                val locale = remember(tag) { Locale.forLanguageTag(tag) }
                LanguageRow(
                    name = locale.getDisplayName(locale),
                    selected = selectedTag == tag,
                    onClick = { select(tag) }
                )
            }
        }
    }
}

@Composable
private fun LanguageRow(name: String, selected: Boolean, onClick: () -> Unit) {
    Row(
        Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(horizontal = 20.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        RadioButton(selected = selected, onClick = onClick)
        Text(name, Modifier.padding(start = 16.dp))
    }
}
