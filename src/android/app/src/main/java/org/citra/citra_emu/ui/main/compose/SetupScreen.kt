// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Build
import androidx.activity.compose.BackHandler
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Snackbar
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import androidx.preference.PreferenceManager
import kotlinx.coroutines.launch
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.R
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.model.SetupCallback
import org.citra.citra_emu.model.SetupPage
import org.citra.citra_emu.model.StepState
import org.citra.citra_emu.ui.main.compose.dialogs.MessageDialog
import org.citra.citra_emu.ui.main.compose.dialogs.SetupWarningDialog
import org.citra.citra_emu.utils.CitraDirectoryHelper
import org.citra.citra_emu.utils.GameHelper
import org.citra.citra_emu.utils.PermissionsHandler
import org.citra.citra_emu.viewmodel.HomeViewModel
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootGraph
import com.ramcosta.composedestinations.generated.destinations.GamesScreenDestination
import com.ramcosta.composedestinations.generated.destinations.SetupScreenDestination
import com.ramcosta.composedestinations.navigation.DestinationsNavigator

/**
 * First-time-launch onboarding flow. Mirrors the legacy `SetupFragment` + `SetupAdapter`,
 * using [HorizontalPager] instead of `ViewPager2`.
 */
@Destination<RootGraph>
@Composable
fun SetupScreen(
    navigator: DestinationsNavigator,
    homeViewModel: HomeViewModel,
    modifier: Modifier = Modifier
) {
    LaunchedEffect(Unit) {
        homeViewModel.setNavigationVisibility(visible = false, animated = false)
    }

    val context = LocalContext.current
    val activity = context as FragmentActivity
    val onFinishSetup: () -> Unit = {
        navigator.navigate(GamesScreenDestination) {
            popUpTo(SetupScreenDestination) { inclusive = true }
        }
    }
    val onFinish: () -> Unit = { activity.finish() }
    val preferences = remember {
        PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
    }
    val scope = rememberCoroutineScope()
    val snackbarHostState = remember { SnackbarHostState() }

    val pages = remember { buildSetupPages(context, preferences) }
    val userDirPageIdx = remember { pages.indexOfFirst { it.titleId == R.string.select_citra_user_folder } }
    val gamesDirPageIdx = remember { pages.indexOfFirst { it.titleId == R.string.games } }

    val completedPages = remember {
        mutableStateListOf<Int>().apply {
            pages.forEachIndexed { i, p -> if (p.stepCompleted() == StepState.STEP_COMPLETE) add(i) }
        }
    }
    val hasBeenWarned = remember { mutableStateListOf(*BooleanArray(pages.size).toTypedArray()) }

    var pendingPermissionField by remember { mutableStateOf(0) }
    val permissionLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted ->
        if (granted) {
            completedPages.add(pendingPermissionField)
        } else {
            scope.launch {
                snackbarHostState.showSnackbar(context.getString(R.string.permission_denied))
            }
        }
    }

    val citraDirectoryHelper = remember { CitraDirectoryHelper(activity) }
    val openCitraDirectory = rememberLauncherForActivityResult(
        ActivityResultContracts.OpenDocumentTree()
    ) { uri ->
        if (uri != null) {
            citraDirectoryHelper.showCitraDirectoryDialog(uri, object : SetupCallback {
                override fun onStepCompleted() {
                    completedPages.add(userDirPageIdx)
                }
            })
        }
    }

    val getGamesDirectory = rememberLauncherForActivityResult(
        ActivityResultContracts.OpenDocumentTree()
    ) { uri ->
        if (uri != null) {
            context.contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            preferences.edit().putString(GameHelper.KEY_GAME_PATH, uri.toString()).apply()
            homeViewModel.setGamesDir(activity, uri.path!!)
            completedPages.add(gamesDirPageIdx)
        }
    }

    val pagerState = rememberPagerState(pageCount = { pages.size })
    var pendingWarningPage by remember { mutableStateOf(-1) }
    var pendingUnskippableWarning by remember { mutableStateOf(-1) }

    fun pageForward() {
        scope.launch { pagerState.animateScrollToPage(pagerState.currentPage + 1) }
    }

    fun onNextClicked() {
        val index = pagerState.currentPage
        val page = pages[index]
        if (page.hasWarning || page.isUnskippable) {
            val stepState = if (index in completedPages) StepState.STEP_COMPLETE else page.stepCompleted()
            if (stepState == StepState.STEP_COMPLETE || stepState == StepState.STEP_UNDEFINED) {
                pageForward()
                return
            }
            if (page.isUnskippable) {
                pendingUnskippableWarning = index
                return
            }
            if (!hasBeenWarned[index]) {
                pendingWarningPage = index
                return
            }
        }
        pageForward()
    }

    BackHandler {
        if (pagerState.currentPage > 0) {
            scope.launch { pagerState.animateScrollToPage(pagerState.currentPage - 1) }
        } else {
            onFinish()
        }
    }

    Box(modifier.fillMaxSize()) {
        Column(Modifier.fillMaxSize()) {
            HorizontalPager(
                state = pagerState,
                modifier = Modifier.weight(1f),
                userScrollEnabled = false
            ) { index ->
                SetupPageContent(
                    page = pages[index],
                    completed = index in completedPages,
                    onAction = {
                        when (index) {
                            userDirPageIdx -> openCitraDirectory.launch(null)
                            gamesDirPageIdx -> getGamesDirectory.launch(Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).data)
                            else -> {
                                val page = pages[index]
                                when (page.titleId) {
                                    R.string.notifications -> {
                                        pendingPermissionField = index
                                        permissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
                                    }
                                    R.string.microphone_permission -> {
                                        pendingPermissionField = index
                                        permissionLauncher.launch(Manifest.permission.RECORD_AUDIO)
                                    }
                                    R.string.camera_permission -> {
                                        pendingPermissionField = index
                                        permissionLauncher.launch(Manifest.permission.CAMERA)
                                    }
                                    R.string.welcome -> pageForward()
                                    R.string.done -> {
                                        preferences.edit().putBoolean(Settings.PREF_FIRST_APP_LAUNCH, false).apply()
                                        onFinishSetup()
                                    }
                                }
                            }
                        }
                    }
                )
            }

            Row(Modifier.padding(8.dp)) {
                AnimatedVisibility(visible = pagerState.currentPage > 0) {
                    TextButton(onClick = {
                        scope.launch { pagerState.animateScrollToPage(pagerState.currentPage - 1) }
                    }) { Text(stringResource(R.string.back)) }
                }
                Spacer(Modifier.weight(1f))
                AnimatedVisibility(visible = pagerState.currentPage in 1 until pages.size - 1) {
                    TextButton(onClick = ::onNextClicked) { Text(stringResource(R.string.next)) }
                }
            }
        }

        SnackbarHost(snackbarHostState, modifier = Modifier.align(Alignment.BottomCenter)) {
            Snackbar(it)
        }
    }

    if (pendingWarningPage >= 0) {
        val page = pages[pendingWarningPage]
        SetupWarningDialog(
            titleId = page.warningTitleId,
            descriptionId = page.warningDescriptionId,
            helpLinkId = page.warningHelpLinkId,
            onSkip = {
                hasBeenWarned[pendingWarningPage] = true
                val warned = pendingWarningPage
                pendingWarningPage = -1
                scope.launch { pagerState.animateScrollToPage(warned + 1) }
            },
            onCancel = { pendingWarningPage = -1 }
        )
    }

    if (pendingUnskippableWarning >= 0) {
        val page = pages[pendingUnskippableWarning]
        MessageDialog(
            titleId = page.warningTitleId,
            description = if (page.warningDescriptionId != 0) stringResource(page.warningDescriptionId) else "",
            helpLinkId = page.warningHelpLinkId,
            onDismiss = { pendingUnskippableWarning = -1 }
        )
    }
}

private fun buildSetupPages(
    context: Context,
    preferences: SharedPreferences
): List<SetupPage> = buildList {
    add(
        SetupPage(
            R.drawable.ic_citra_full,
            R.string.welcome,
            R.string.welcome_description,
            0,
            true,
            R.string.get_started,
            { }
        )
    )
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        add(
            SetupPage(
                R.drawable.ic_notification,
                R.string.notifications,
                R.string.notifications_description,
                0,
                false,
                R.string.give_permission,
                { },
                false,
                true,
                {
                    if (NotificationManagerCompat.from(context).areNotificationsEnabled()) {
                        StepState.STEP_COMPLETE
                    } else {
                        StepState.STEP_INCOMPLETE
                    }
                },
                R.string.notification_warning,
                R.string.notification_warning_description,
                0
            )
        )
    }
    add(
        SetupPage(
            R.drawable.ic_microphone,
            R.string.microphone_permission,
            R.string.microphone_permission_description,
            0,
            false,
            R.string.give_permission,
            { },
            false,
            false,
            {
                if (ContextCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO) ==
                    PackageManager.PERMISSION_GRANTED
                ) {
                    StepState.STEP_COMPLETE
                } else {
                    StepState.STEP_INCOMPLETE
                }
            }
        )
    )
    add(
        SetupPage(
            R.drawable.ic_camera,
            R.string.camera_permission,
            R.string.camera_permission_description,
            0,
            false,
            R.string.give_permission,
            { },
            false,
            false,
            {
                if (ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) ==
                    PackageManager.PERMISSION_GRANTED
                ) {
                    StepState.STEP_COMPLETE
                } else {
                    StepState.STEP_INCOMPLETE
                }
            }
        )
    )
    add(
        SetupPage(
            R.drawable.ic_home,
            R.string.select_citra_user_folder,
            R.string.select_citra_user_folder_description,
            0,
            true,
            R.string.select,
            { },
            true,
            true,
            {
                if (PermissionsHandler.hasWriteAccess(context)) StepState.STEP_COMPLETE else StepState.STEP_INCOMPLETE
            },
            R.string.cannot_skip,
            R.string.cannot_skip_directory_description,
            R.string.cannot_skip_directory_help
        )
    )
    add(
        SetupPage(
            R.drawable.ic_controller,
            R.string.games,
            R.string.games_description,
            0,
            true,
            R.string.select,
            { },
            false,
            true,
            {
                if (preferences.getString(GameHelper.KEY_GAME_PATH, "")!!.isNotEmpty()) {
                    StepState.STEP_COMPLETE
                } else {
                    StepState.STEP_INCOMPLETE
                }
            },
            R.string.add_games_warning,
            R.string.add_games_warning_description,
            R.string.add_games_warning_help
        )
    )
    add(
        SetupPage(
            R.drawable.ic_check,
            R.string.done,
            R.string.done_description,
            R.drawable.ic_arrow_forward,
            false,
            R.string.text_continue,
            { }
        )
    )
}

@Composable
private fun SetupPageContent(page: SetupPage, completed: Boolean, onAction: () -> Unit) {
    Column(
        Modifier
            .fillMaxSize()
            .padding(horizontal = 24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Icon(
            painterResource(page.iconId),
            contentDescription = null,
            modifier = Modifier.size(150.dp),
            tint = Color.Unspecified
        )
        Text(
            stringResource(page.titleId),
            style = MaterialTheme.typography.displaySmall,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(top = 24.dp)
        )
        Text(
            stringResource(page.descriptionId),
            style = MaterialTheme.typography.titleLarge,
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(top = 16.dp)
        )
        if (completed) {
            Text(
                stringResource(R.string.step_complete),
                style = MaterialTheme.typography.titleLarge,
                textAlign = TextAlign.Center,
                modifier = Modifier.padding(top = 24.dp)
            )
        } else {
            Button(onClick = onAction, modifier = Modifier.padding(top = 24.dp)) {
                Text(stringResource(page.buttonTextId))
                if (page.buttonIconId != 0) {
                    Icon(
                        painterResource(page.buttonIconId),
                        contentDescription = null,
                        modifier = Modifier.padding(start = 8.dp)
                    )
                }
            }
        }
    }
}
