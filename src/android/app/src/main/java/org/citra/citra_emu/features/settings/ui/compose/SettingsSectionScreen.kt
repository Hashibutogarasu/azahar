// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.settings.ui.compose

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
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
import org.citra.citra_emu.features.settings.model.view.SettingsItem
import org.citra.citra_emu.features.settings.ui.SettingsActivity
import org.citra.citra_emu.features.settings.ui.SettingsActivityView
import org.citra.citra_emu.features.settings.ui.SettingsAdapter
import org.citra.citra_emu.features.settings.ui.SettingsFragmentPresenter
import org.citra.citra_emu.features.settings.ui.SettingsFragmentView
import org.citra.citra_emu.features.settings.utils.SettingsFile

/**
 * Hosts one section of the settings list (the root menu, or a sub-section such as
 * General/System/Camera/...) as a compose-destinations push/pop destination. Item list
 * construction and rendering (`SettingsFragmentPresenter`/`SettingsAdapter`) is reused as-is
 * from the legacy `SettingsFragment` via [AndroidView], built synchronously rather than in a
 * `LaunchedEffect`, since [SettingsActivity] already awaits every setting any section could
 * need before this screen becomes reachable.
 */
@Destination<RootGraph>
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsSectionScreen(
    menuTag: String,
    gameId: String,
    navigator: DestinationsNavigator,
    modifier: Modifier = Modifier
) {
    val activity = LocalContext.current as SettingsActivity

    val (fragmentView, presenter, loadedItemsState) = remember(menuTag, gameId) {
        lateinit var presenterRef: SettingsFragmentPresenter
        val loadedItemsState = mutableStateOf<ArrayList<SettingsItem>>(arrayListOf())
        val view = object : SettingsFragmentView {
            override var activityView: SettingsActivityView? = activity

            override fun showSettingsList(settingsList: ArrayList<SettingsItem>) {
                loadedItemsState.value = settingsList
            }

            override fun loadSettingsList() {
                presenterRef.loadSettingsList()
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
                loadSettingsList()
            }
        }
        presenterRef = SettingsFragmentPresenter(view).apply {
            onCreate(menuTag, gameId)
            loadSettingsList()
        }
        Triple(view, presenterRef, loadedItemsState)
    }
    val items by loadedItemsState

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
                (recyclerView.adapter as SettingsAdapter).setSettingsList(items)
            }
        )
    }
}
