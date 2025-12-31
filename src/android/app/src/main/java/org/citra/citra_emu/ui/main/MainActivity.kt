// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.
package org.citra.citra_emu.ui.main
import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.view.View
import android.view.ViewGroup.MarginLayoutParams
import android.view.WindowManager
import android.view.animation.PathInterpolator
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.core.view.ViewCompat
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import androidx.navigation.NavController
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import androidx.preference.PreferenceManager
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequest
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import com.google.android.material.color.MaterialColors
import com.google.android.material.navigation.NavigationBarView
import kotlinx.coroutines.launch
import org.citra.citra_emu.BuildConfig
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.R
import org.citra.citra_emu.contracts.OpenFileResultContract
import androidx.activity.compose.setContent
import org.citra.citra_emu.databinding.ContentMainBinding
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.features.settings.model.SettingsViewModel
import org.citra.citra_emu.features.settings.ui.SettingsActivity
import org.citra.citra_emu.features.settings.utils.SettingsFile
import org.citra.citra_emu.fragments.GrantMissingFilesystemPermissionFragment
import org.citra.citra_emu.fragments.SelectUserDirectoryDialogFragment
import org.citra.citra_emu.fragments.UpdateUserDirectoryDialogFragment
import org.citra.citra_emu.utils.CiaInstallWorker
import org.citra.citra_emu.utils.CitraDirectoryHelper
import org.citra.citra_emu.utils.CitraDirectoryUtils
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.FileBrowserHelper
import org.citra.citra_emu.utils.InsetsHelper
import org.citra.citra_emu.utils.RefreshRateUtil
import org.citra.citra_emu.utils.PermissionsHandler
import org.citra.citra_emu.utils.ThemeUtil
import org.citra.citra_emu.viewmodel.GamesViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel
import androidx.compose.ui.platform.ViewCompositionStrategy
import org.citra.citra_emu.ui.components.AppDrawer
import org.citra.citra_emu.ui.components.DrawerDestination
import org.citra.citra_emu.ui.theme.CitraTheme
class MainActivity : AppCompatActivity(), ThemeProvider {
    var drawerOpener: (() -> Unit)? = null
    private val homeViewModel: HomeViewModel by viewModels()
    private val gamesViewModel: GamesViewModel by viewModels()
    private val settingsViewModel: SettingsViewModel by viewModels()
    override var themeId: Int = 0
    fun openDrawer() {
        drawerOpener?.invoke()
    }
    fun onSettingsReselected() {
        SettingsActivity.launch(
            this,
            SettingsFile.FILE_NAME_CONFIG,
            ""
        )
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        RefreshRateUtil.enforceRefreshRate(this)
        val splashScreen = installSplashScreen()
        CitraDirectoryUtils.attemptAutomaticUpdateDirectory()
        splashScreen.setKeepOnScreenCondition {
            !DirectoryInitialization.areCitraDirectoriesReady() &&
                    PermissionsHandler.hasWriteAccess(this) &&
                    !CitraDirectoryUtils.needToUpdateManually()
        }
        if (PermissionsHandler.hasWriteAccess(applicationContext) &&
            DirectoryInitialization.areCitraDirectoriesReady() &&
            !CitraDirectoryUtils.needToUpdateManually()) {
            settingsViewModel.settings.loadSettings()
        }
        ThemeUtil.ThemeChangeListener(this)
        ThemeUtil.setTheme(this)
        super.onCreate(savedInstanceState)
        setContent {
            CitraTheme {
                MainScreen(
                    homeViewModel = homeViewModel,
                    onNavControllerReady = { navController ->
                        setUpNavigation(navController)
                    }
                )
            }
        }
        WindowCompat.setDecorFitsSystemWindows(window, false)
        window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING)
        window.statusBarColor =
            ContextCompat.getColor(applicationContext, android.R.color.transparent)
        window.navigationBarColor =
            ContextCompat.getColor(applicationContext, android.R.color.transparent)
    }
    override fun onResume() {
        checkUserPermissions()
        ThemeUtil.setCorrectTheme(this)
        super.onResume()
    }
    override fun onDestroy() {
        super.onDestroy()
    }
    override fun setTheme(resId: Int) {
        super.setTheme(resId)
        themeId = resId
    }
    private fun checkUserPermissions() {
        val firstTimeSetup = PreferenceManager.getDefaultSharedPreferences(applicationContext)
            .getBoolean(Settings.PREF_FIRST_APP_LAUNCH, true)
        if (firstTimeSetup) {
            return
        }
        @Suppress("KotlinConstantConditions", "SimplifyBooleanWithConstants")
        if (BuildConfig.FLAVOR != "googlePlay") {
            fun requestMissingFilesystemPermission() =
                GrantMissingFilesystemPermissionFragment.newInstance()
                    .show(supportFragmentManager, GrantMissingFilesystemPermissionFragment.TAG)
            if (supportFragmentManager.findFragmentByTag(GrantMissingFilesystemPermissionFragment.TAG) == null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    if (!Environment.isExternalStorageManager()) {
                        requestMissingFilesystemPermission()
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(
                            this,
                            Manifest.permission.WRITE_EXTERNAL_STORAGE
                        ) != PackageManager.PERMISSION_GRANTED
                    ) {
                        requestMissingFilesystemPermission()
                    }
                }
            }
        }
        if (homeViewModel.isPickingUserDir.value) {
            return
        }
        if (!PermissionsHandler.hasWriteAccess(this)) {
            SelectUserDirectoryDialogFragment.newInstance(this)
                .show(supportFragmentManager, SelectUserDirectoryDialogFragment.TAG)
            return
        } else if (CitraDirectoryUtils.needToUpdateManually()) {
            UpdateUserDirectoryDialogFragment.newInstance(this)
                .show(supportFragmentManager,UpdateUserDirectoryDialogFragment.TAG)
            return
        }
        @Suppress("KotlinConstantConditions", "SimplifyBooleanWithConstants")
        if (BuildConfig.FLAVOR != "googlePlay") {
            if (supportFragmentManager.findFragmentByTag(SelectUserDirectoryDialogFragment.TAG) == null) {
                if (NativeLibrary.getUserDirectory() == "") {
                    SelectUserDirectoryDialogFragment.newInstance(this)
                        .show(supportFragmentManager, SelectUserDirectoryDialogFragment.TAG)
                }
            }
        }
    }
    fun finishSetup(navController: NavController) {
        navController.navigate(R.id.action_firstTimeSetupFragment_to_gamesFragment)
    }
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(org.citra.citra_emu.utils.LocaleUtil.applyLocalizedContext(base))
    }
    private fun setUpNavigation(navController: NavController) {
        val firstTimeSetup = PreferenceManager.getDefaultSharedPreferences(applicationContext)
            .getBoolean(Settings.PREF_FIRST_APP_LAUNCH, true)
        if (firstTimeSetup && !homeViewModel.navigatedToSetup) {
            navController.navigate(R.id.firstTimeSetupFragment)
            homeViewModel.navigatedToSetup = true
        }
    }
    private fun createOpenCitraDirectoryLauncher(
        permissionsLost: Boolean
    ): ActivityResultLauncher<Uri?> {
        return registerForActivityResult(ActivityResultContracts.OpenDocumentTree()) { result: Uri? ->
            if (result == null) {
                return@registerForActivityResult
            }
            if (NativeLibrary.getUserDirectory(result) == "") {
                SelectUserDirectoryDialogFragment.newInstance(
                    this,
                    R.string.invalid_selection,
                    R.string.invalid_user_directory
                ).show(supportFragmentManager, SelectUserDirectoryDialogFragment.TAG)
                return@registerForActivityResult
            }
            CitraDirectoryHelper(this@MainActivity, permissionsLost)
                .showCitraDirectoryDialog(result, buttonState = {})
        }
    }
    val openCitraDirectory = createOpenCitraDirectoryLauncher(permissionsLost = false)
    val openCitraDirectoryLostPermission = createOpenCitraDirectoryLauncher(permissionsLost = true)
    val ciaFileInstaller = registerForActivityResult(
        OpenFileResultContract()
    ) { result: Intent? ->
        if (result == null) {
            return@registerForActivityResult
        }
        val selectedFiles =
            FileBrowserHelper.getSelectedFiles(result, applicationContext, listOf("cia", "zcia"))
        if (selectedFiles == null) {
            Toast.makeText(applicationContext, R.string.cia_file_not_found, Toast.LENGTH_LONG)
                .show()
            return@registerForActivityResult
        }
        val workManager = WorkManager.getInstance(applicationContext)
        workManager.enqueueUniqueWork(
            "installCiaWork", ExistingWorkPolicy.APPEND_OR_REPLACE,
            OneTimeWorkRequest.Builder(CiaInstallWorker::class.java)
                .setInputData(
                    Data.Builder().putStringArray("CIA_FILES", selectedFiles)
                        .build()
                )
                .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                .build()
        )
    }
}
