// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.integerResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.documentfile.provider.DocumentFile
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.preference.PreferenceManager
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequest
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootGraph
import com.ramcosta.composedestinations.generated.destinations.AboutScreenDestination
import com.ramcosta.composedestinations.generated.destinations.DriverManagerScreenDestination
import com.ramcosta.composedestinations.generated.destinations.SystemFilesScreenDestination
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.R
import org.citra.citra_emu.contracts.OpenFileResultContract
import org.citra.citra_emu.features.settings.ui.SettingsActivity
import org.citra.citra_emu.features.settings.utils.SettingsFile
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.model.HomeSetting
import org.citra.citra_emu.repository.EmulationLaunchRepository
import org.citra.citra_emu.ui.main.compose.dialogs.MessageDialog
import org.citra.citra_emu.utils.CiaInstallWorker
import org.citra.citra_emu.utils.CitraDirectoryHelper
import org.citra.citra_emu.utils.FileBrowserHelper
import org.citra.citra_emu.utils.GameHelper
import org.citra.citra_emu.utils.GpuDriverHelper
import org.citra.citra_emu.utils.Log
import org.citra.citra_emu.utils.PermissionsHandler
import org.citra.citra_emu.viewmodel.DriverViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel

/**
 * The home tab's grid of app-level settings and shortcuts. Mirrors the legacy
 * `HomeSettingsFragment` + `HomeSettingAdapter`, reusing the existing [HomeSetting] model.
 */
@Destination<RootGraph>
@Composable
fun HomeSettingsScreen(
    navigator: DestinationsNavigator,
    homeViewModel: HomeViewModel,
    driverViewModel: DriverViewModel,
    modifier: Modifier = Modifier
) {
    LaunchedEffect(Unit) {
        homeViewModel.setNavigationVisibility(visible = true, animated = true)
        homeViewModel.setStatusBarShadeVisibility(visible = true)
        driverViewModel.loadDrivers()
    }

    val context = LocalContext.current
    val activity = context as AppCompatActivity
    val emulationLaunchRepository = remember { EmulationLaunchRepository() }
    var showArticDialog by remember { mutableStateOf(false) }
    var disabledOption by remember { mutableStateOf<HomeSetting?>(null) }

    val onOpenSettings: () -> Unit = { SettingsActivity.launch(context, SettingsFile.FILE_NAME_CONFIG, "") }
    val onOpenThemeSettings: () -> Unit = { SettingsActivity.launch(context, Settings.SECTION_THEME, "") }
    val onNavigateToSystemFiles: () -> Unit =
        { navigator.navigate(SystemFilesScreenDestination) { launchSingleTop = true } }
    val onNavigateToDriverManager: () -> Unit =
        { navigator.navigate(DriverManagerScreenDestination) { launchSingleTop = true } }
    val onNavigateToAbout: () -> Unit =
        { navigator.navigate(AboutScreenDestination) { launchSingleTop = true } }
    val onConnectArticBase: (String) -> Unit = { address ->
        val articBaseGame =
            Game(title = context.getString(R.string.artic_base), path = "articbase://$address", filename = "")
        context.startActivity(emulationLaunchRepository.createLaunchIntent(articBaseGame))
    }

    val ciaFileInstaller = rememberLauncherForActivityResult(OpenFileResultContract()) { result: Intent? ->
        if (result != null) {
            val selectedFiles = FileBrowserHelper.getSelectedFiles(result, context, listOf("cia"))
            if (selectedFiles == null) {
                Toast.makeText(context, R.string.cia_file_not_found, Toast.LENGTH_LONG).show()
            } else {
                WorkManager.getInstance(context).enqueueUniqueWork(
                    "installCiaWork",
                    ExistingWorkPolicy.APPEND_OR_REPLACE,
                    OneTimeWorkRequest.Builder(CiaInstallWorker::class.java)
                        .setInputData(Data.Builder().putStringArray("CIA_FILES", selectedFiles).build())
                        .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                        .build()
                )
            }
        }
    }
    val onInstallCia: () -> Unit = { ciaFileInstaller.launch(true) }

    val openCitraDirectory = rememberLauncherForActivityResult(
        ActivityResultContracts.OpenDocumentTree()
    ) { uri: Uri? ->
        if (uri != null) {
            CitraDirectoryHelper(activity).showCitraDirectoryDialog(uri)
        }
    }
    val onOpenCitraDirectory: () -> Unit = { openCitraDirectory.launch(null) }

    val getGamesDirectory = rememberLauncherForActivityResult(
        ActivityResultContracts.OpenDocumentTree()
    ) { uri: Uri? ->
        if (uri != null) {
            context.contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
                .edit().putString(GameHelper.KEY_GAME_PATH, uri.toString()).apply()
            Toast.makeText(context, R.string.games_dir_selected, Toast.LENGTH_LONG).show()
            homeViewModel.setGamesDir(activity, uri.path!!)
        }
    }
    val onOpenGamesDirectory: () -> Unit = {
        getGamesDirectory.launch(Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).data)
    }

    val options = remember {
        listOf(
            HomeSetting(
                R.string.grid_menu_core_settings,
                R.string.settings_description,
                R.drawable.ic_settings,
                onOpenSettings
            ),
            HomeSetting(
                R.string.artic_base_connect,
                R.string.artic_base_connect_description,
                R.drawable.ic_network,
                { showArticDialog = true }
            ),
            HomeSetting(
                R.string.install_game_content,
                R.string.install_game_content_description,
                R.drawable.ic_install,
                onInstallCia
            ),
            HomeSetting(
                R.string.setup_system_files,
                R.string.setup_system_files_description,
                R.drawable.ic_system_update,
                onNavigateToSystemFiles
            ),
            HomeSetting(
                R.string.share_log,
                R.string.share_log_description,
                R.drawable.ic_share,
                { shareLog(context) }
            ),
            HomeSetting(
                R.string.gpu_driver_manager,
                R.string.install_gpu_driver_description,
                R.drawable.ic_install_driver,
                onNavigateToDriverManager,
                { GpuDriverHelper.supportsCustomDriverLoading() },
                R.string.custom_driver_not_supported,
                R.string.custom_driver_not_supported_description,
                driverViewModel.selectedDriverMetadata
            ),
            HomeSetting(
                R.string.select_citra_user_folder,
                R.string.select_citra_user_folder_home_description,
                R.drawable.ic_home,
                onOpenCitraDirectory,
                details = homeViewModel.userDir
            ),
            HomeSetting(
                R.string.select_games_folder,
                R.string.select_games_folder_description,
                R.drawable.ic_add,
                onOpenGamesDirectory,
                details = homeViewModel.gamesDir
            ),
            HomeSetting(
                R.string.preferences_theme,
                R.string.theme_and_color_description,
                R.drawable.ic_palette,
                onOpenThemeSettings
            ),
            HomeSetting(
                R.string.about,
                R.string.about_description,
                R.drawable.ic_info_outline,
                onNavigateToAbout
            )
        )
    }

    LazyVerticalGrid(
        columns = GridCells.Fixed(integerResource(R.integer.game_grid_columns)),
        modifier = modifier.fillMaxWidth(),
        contentPadding = PaddingValues(vertical = 24.dp)
    ) {
        items(options) { option ->
            HomeOptionCard(option = option, onDisabledClick = { disabledOption = option })
        }
    }

    disabledOption?.let { option ->
        MessageDialog(
            titleId = option.disabledTitleId,
            description = stringResource(option.disabledMessageId),
            helpLinkId = 0,
            onDismiss = { disabledOption = null }
        )
    }

    if (showArticDialog) {
        ArticBaseConnectDialog(
            onConfirm = {
                showArticDialog = false
                onConnectArticBase(it)
            },
            onDismiss = { showArticDialog = false }
        )
    }
}

@Composable
private fun HomeOptionCard(
    option: HomeSetting,
    onDisabledClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val enabled = option.isEnabled()
    val alpha = if (enabled) 1f else 0.5f
    val detail by option.details.collectAsStateWithLifecycle()

    Card(
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant),
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 12.dp, vertical = 12.dp)
            .clickable { if (enabled) option.onClick() else onDisabledClick() }
    ) {
        Row(
            Modifier.padding(vertical = 10.dp, horizontal = 20.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                painterResource(option.iconId),
                contentDescription = null,
                modifier = Modifier
                    .size(24.dp)
                    .alpha(alpha)
            )
            Column(Modifier.padding(start = 20.dp)) {
                Text(
                    stringResource(option.titleId),
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.alpha(alpha)
                )
                Text(
                    stringResource(option.descriptionId),
                    style = MaterialTheme.typography.bodySmall,
                    modifier = Modifier.alpha(alpha)
                )
                if (detail.isNotEmpty()) {
                    Text(
                        detail,
                        style = MaterialTheme.typography.labelMedium,
                        fontWeight = FontWeight.Bold,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                        modifier = Modifier.alpha(alpha)
                    )
                }
            }
        }
    }
}

@Composable
private fun ArticBaseConnectDialog(onConfirm: (String) -> Unit, onDismiss: () -> Unit) {
    val preferences = remember {
        PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
    }
    var address by remember { mutableStateOf(preferences.getString("last_artic_base_addr", "") ?: "") }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(stringResource(R.string.artic_base_enter_address)) },
        text = {
            OutlinedTextField(value = address, onValueChange = { address = it }, singleLine = true)
        },
        confirmButton = {
            TextButton(onClick = {
                if (address.isNotEmpty()) {
                    preferences.edit().putString("last_artic_base_addr", address).apply()
                    onConfirm(address)
                }
            }) { Text(stringResource(android.R.string.ok)) }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text(stringResource(android.R.string.cancel)) }
        }
    )
}

private fun shareLog(context: Context) {
    val logDirectory = DocumentFile.fromTreeUri(context, PermissionsHandler.citraDirectory)
        ?.findFile("log")
    val currentLog = logDirectory?.findFile("azahar_log.txt")
    val oldLog = logDirectory?.findFile("azahar_log.old.txt")

    val intent = Intent().apply {
        action = Intent.ACTION_SEND
        type = "text/plain"
    }
    when {
        !Log.gameLaunched && oldLog?.exists() == true -> {
            intent.putExtra(Intent.EXTRA_STREAM, oldLog.uri)
            context.startActivity(Intent.createChooser(intent, context.getText(R.string.share_log)))
        }
        currentLog?.exists() == true -> {
            intent.putExtra(Intent.EXTRA_STREAM, currentLog.uri)
            context.startActivity(Intent.createChooser(intent, context.getText(R.string.share_log)))
        }
        else -> {
            Toast.makeText(
                context,
                context.getText(R.string.share_log_not_found),
                Toast.LENGTH_SHORT
            ).show()
        }
    }
}
