// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import android.content.Context
import android.net.Uri
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.Card
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.integerResource
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import org.citra.citra_emu.R
import org.citra.citra_emu.ui.main.compose.dialogs.DriversLoadingDialog
import org.citra.citra_emu.ui.main.compose.dialogs.IndeterminateProgressDialog
import org.citra.citra_emu.utils.FileUtil.inputStream
import org.citra.citra_emu.utils.GpuDriverHelper
import org.citra.citra_emu.utils.GpuDriverMetadata
import org.citra.citra_emu.viewmodel.DriverViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel
import org.citra.citra_emu.viewmodel.TaskViewModel
import java.io.IOException

/** Mirrors the legacy `DriverManagerFragment` + `DriverAdapter`. */
@Destination<RootGraph>
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DriverManagerScreen(
    navigator: DestinationsNavigator,
    homeViewModel: HomeViewModel,
    driverViewModel: DriverViewModel,
    taskViewModel: TaskViewModel,
    modifier: Modifier = Modifier
) {
    LaunchedEffect(Unit) {
        homeViewModel.setNavigationVisibility(visible = false, animated = true)
        homeViewModel.setStatusBarShadeVisibility(visible = false)
        driverViewModel.loadDrivers()
    }
    DisposableEffect(Unit) {
        onDispose { driverViewModel.onCloseDriverManager() }
    }

    val context = LocalContext.current
    val onNavigateBack: () -> Unit = { navigator.navigateUp() }
    val drivers by driverViewModel.driverList.collectAsStateWithLifecycle()
    val selectedDriver by driverViewModel.selectedDriverFlow.collectAsStateWithLifecycle()
    val areDriversLoading by driverViewModel.areDriversLoading.collectAsStateWithLifecycle()
    val isDriverReady by driverViewModel.isDriverReady.collectAsStateWithLifecycle()
    val isDeletingDrivers by driverViewModel.isDeletingDrivers.collectAsStateWithLifecycle()
    val isInteractionAllowed = !areDriversLoading && isDriverReady && !isDeletingDrivers

    var installTaskRunning by remember { mutableStateOf(false) }
    val getDriver = rememberLauncherForActivityResult(ActivityResultContracts.OpenDocument()) { uri ->
        if (uri != null) {
            taskViewModel.task = { installDriver(driverViewModel, context, uri) }
            installTaskRunning = true
        }
    }

    Box(modifier.fillMaxSize()) {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text(stringResource(R.string.gpu_driver_manager)) },
                    navigationIcon = {
                        IconButton(onClick = onNavigateBack) {
                            Icon(painterResource(R.drawable.ic_back), contentDescription = null)
                        }
                    }
                )
            },
            floatingActionButton = {
                ExtendedFloatingActionButton(
                    onClick = { getDriver.launch(arrayOf("application/zip")) },
                    icon = { Icon(painterResource(R.drawable.ic_add), contentDescription = null) },
                    text = { Text(stringResource(R.string.install)) }
                )
            }
        ) { contentPadding ->
            LazyVerticalGrid(
                columns = GridCells.Fixed(integerResource(R.integer.game_grid_columns)),
                modifier = Modifier
                    .padding(contentPadding)
                    .fillMaxSize(),
                contentPadding = PaddingValues(8.dp)
            ) {
                items(drivers, key = { it.first }) { driverData ->
                    val index = drivers.indexOf(driverData)
                    DriverCard(
                        driver = driverData.second,
                        selected = selectedDriver == index,
                        onSelect = { driverViewModel.setSelectedDriverIndex(index) },
                        onDelete = {
                            if (selectedDriver > index) {
                                driverViewModel.setSelectedDriverIndex(selectedDriver - 1)
                            }
                            if (GpuDriverHelper.customDriverData == driverData.second) {
                                driverViewModel.setSelectedDriverIndex(0)
                            }
                            driverViewModel.driversToDelete.add(driverData.first)
                            driverViewModel.removeDriver(driverData)
                        }
                    )
                }
            }
        }
    }

    if (!isInteractionAllowed) {
        DriversLoadingDialog()
    }

    if (installTaskRunning) {
        IndeterminateProgressDialog(
            taskViewModel = taskViewModel,
            titleId = R.string.installing_driver,
            cancellable = false,
            onComplete = { result ->
                if (result is String) {
                    Toast.makeText(context, result, Toast.LENGTH_LONG).show()
                }
            },
            onDismiss = { installTaskRunning = false }
        )
    }
}

private fun installDriver(driverViewModel: DriverViewModel, context: Context, uri: Uri): Any {
    val driverFile = try {
        GpuDriverHelper.copyDriverToExternalStorage(uri) ?: throw IOException("Driver failed validation!")
    } catch (_: IOException) {
        return context.getString(R.string.select_gpu_driver_error)
    }

    val driverData = GpuDriverHelper.getMetadataFromZip(driverFile.inputStream())
    val driverInList = driverViewModel.driverList.value.firstOrNull { it.second == driverData }
    return if (driverInList != null) {
        driverFile.delete()
        context.getString(R.string.driver_already_installed)
    } else {
        driverViewModel.addDriver(Pair(driverFile.uri, driverData))
        driverViewModel.setNewDriverInstalled(true)
        Any()
    }
}

@Composable
private fun DriverCard(
    driver: GpuDriverMetadata,
    selected: Boolean,
    onSelect: () -> Unit,
    onDelete: () -> Unit,
    modifier: Modifier = Modifier
) {
    val isSystemDriver = driver.name == null
    Card(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 12.dp)
            .clickable(onClick = onSelect)
    ) {
        Row(
            Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            RadioButton(selected = selected, onClick = null)
            Column(
                Modifier
                    .weight(1f)
                    .padding(start = 8.dp)
            ) {
                Text(
                    if (isSystemDriver) stringResource(R.string.system_gpu_driver) else driver.name!!,
                    style = MaterialTheme.typography.titleMedium,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                if (!isSystemDriver) {
                    Text(
                        driver.version.orEmpty(),
                        style = MaterialTheme.typography.bodyMedium,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                        modifier = Modifier.padding(top = 6.dp)
                    )
                    Text(
                        driver.description.orEmpty(),
                        style = MaterialTheme.typography.bodyMedium,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                        modifier = Modifier.padding(top = 6.dp)
                    )
                }
            }
            if (!isSystemDriver) {
                IconButton(onClick = onDelete) {
                    Icon(painterResource(R.drawable.ic_delete), contentDescription = stringResource(R.string.delete))
                }
            }
        }
    }
}
