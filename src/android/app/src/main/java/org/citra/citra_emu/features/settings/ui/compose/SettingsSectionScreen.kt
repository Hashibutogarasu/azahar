// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.ui.compose

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.viewinterop.AndroidView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootGraph
import com.ramcosta.composedestinations.generated.destinations.LanguageSettingsScreenDestination
import com.ramcosta.composedestinations.generated.destinations.SettingsSectionScreenDestination
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import org.citra.citra_emu.R
import org.citra.citra_emu.features.settings.model.AbstractSetting
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.features.settings.model.SettingsViewModel
import org.citra.citra_emu.features.settings.model.view.SettingsItem
import org.citra.citra_emu.features.settings.ui.SettingsActivity
import org.citra.citra_emu.features.settings.ui.SettingsActivityView
import org.citra.citra_emu.features.settings.ui.SettingsAdapter
import org.citra.citra_emu.features.settings.ui.SettingsFragmentPresenter
import org.citra.citra_emu.features.settings.ui.SettingsFragmentView
import org.citra.citra_emu.features.settings.utils.SettingsFile

/**
 * Hosts one section of the settings list (the root menu, or a sub-section such as
 * General/System/Camera/...) as a compose-destinations push/pop destination. Mirrors the legacy
 * `SettingsFragment`: item list construction and rendering (`SettingsFragmentPresenter`/
 * `SettingsAdapter`) is unchanged and reused as-is via [AndroidView].
 */
@Destination<RootGraph>
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsSectionScreen(
    menuTag: String,
    gameId: String,
    navigator: DestinationsNavigator,
    settingsViewModel: SettingsViewModel,
    modifier: Modifier = Modifier
) {
    val activity = LocalContext.current as SettingsActivity

    var items by remember(menuTag, gameId) { mutableStateOf<ArrayList<SettingsItem>?>(null) }
    var isLoading by remember(menuTag, gameId) { mutableStateOf(true) }

    val (fragmentView, presenter) = remember(menuTag, gameId) {
        lateinit var presenterRef: SettingsFragmentPresenter
        val view = object : SettingsFragmentView {
            override var activityView: SettingsActivityView? = activity

            override fun showSettingsList(settingsList: ArrayList<SettingsItem>) {
                items = settingsList
            }

            override fun loadSettingsList() {
                // Driven explicitly by this screen once EmulatorSettingsRepository/Service
                // finish loading, not by the presenter itself.
            }

            override fun loadSubMenu(menuKey: String) {
                if (menuKey == Settings.SECTION_LANGUAGE) {
                    navigator.navigate(LanguageSettingsScreenDestination)
                } else {
                    navigator.navigate(SettingsSectionScreenDestination(menuTag = menuKey, gameId = gameId))
                }
            }

            override fun showToastMessage(message: String?, is_long: Boolean) {
                activityView!!.showToastMessage(message!!, is_long)
            }

            override fun putSetting(setting: AbstractSetting) {
                presenterRef.putSetting(setting)
            }

            override fun onSettingChanged() {
                activityView!!.onSettingChanged()
            }
        }
        presenterRef = SettingsFragmentPresenter(view).apply { onCreate(menuTag, gameId) }
        view to presenterRef
    }

    LaunchedEffect(menuTag, gameId) {
        isLoading = true
        settingsViewModel.prepareSection(menuTag, gameId, activity)
        isLoading = false
        presenter.loadSettingsList()
    }

    Scaffold(
        modifier = modifier,
        topBar = {
            TopAppBar(
                title = { Text(activity.currentToolbarTitle) },
                navigationIcon = {
                    IconButton(
                        onClick = {
                            if (menuTag == SettingsFile.FILE_NAME_CONFIG) {
                                activity.finish()
                            } else {
                                navigator.navigateUp()
                            }
                        }
                    ) {
                        Icon(painterResource(R.drawable.ic_back), contentDescription = null)
                    }
                }
            )
        }
    ) { contentPadding ->
        if (isLoading) {
            Box(Modifier.fillMaxSize().padding(contentPadding), contentAlignment = Alignment.Center) {
                CircularProgressIndicator()
            }
        } else {
            AndroidView(
                modifier = Modifier.fillMaxSize().padding(contentPadding),
                factory = { context ->
                    RecyclerView(context).apply {
                        layoutManager = LinearLayoutManager(context)
                        val settingsAdapter = SettingsAdapter(fragmentView, context)
                        presenter.onViewCreated(settingsAdapter)
                        adapter = settingsAdapter
                    }
                },
                update = { recyclerView ->
                    (recyclerView.adapter as SettingsAdapter).setSettingsList(items ?: arrayListOf())
                }
            )
        }
    }
}
