// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.
package org.citra.citra_emu.fragments

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.SharedPreferences
import android.net.Uri
import android.os.BatteryManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.Choreographer
import android.view.LayoutInflater
import android.view.Surface
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.OnBackPressedCallback
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.compose.ui.res.stringResource
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import androidx.preference.PreferenceManager
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.EmulationNavigationDirections
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.R
import org.citra.citra_emu.activities.EmulationActivity
import org.citra.citra_emu.display.ScreenAdjustmentUtil
import org.citra.citra_emu.features.settings.model.BooleanSetting
import org.citra.citra_emu.features.settings.model.SettingsViewModel
import org.citra.citra_emu.features.settings.ui.SettingsActivity
import org.citra.citra_emu.features.settings.utils.SettingsFile
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.overlay.InputOverlay
import org.citra.citra_emu.ui.game.EmulationMenuItem
import org.citra.citra_emu.ui.game.EmulationScreen
import org.citra.citra_emu.ui.game.LoadingState
import org.citra.citra_emu.ui.theme.CitraTheme
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.DirectoryInitialization.DirectoryInitializationState
import org.citra.citra_emu.utils.EmulationLifecycleUtil
import org.citra.citra_emu.utils.FileUtil
import org.citra.citra_emu.utils.GameHelper
import org.citra.citra_emu.utils.Log
import org.citra.citra_emu.viewmodel.EmulationViewModel

class EmulationFragment : Fragment(), SurfaceHolder.Callback, Choreographer.FrameCallback {
    private val preferences: SharedPreferences
        get() = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
    private lateinit var emulationState: EmulationState
    private var perfStatsUpdater: Runnable? = null
    private lateinit var emulationActivity: EmulationActivity
    private val args by navArgs<EmulationFragmentArgs>()
    private lateinit var game: Game
    private lateinit var screenAdjustmentUtil: ScreenAdjustmentUtil
    private val emulationViewModel: EmulationViewModel by activityViewModels()
    private val settingsViewModel: SettingsViewModel by viewModels()
    private val settings get() = settingsViewModel.settings
    private val onPause = Runnable { togglePause() }
    private val onShutdown = Runnable { emulationState.stop() }

    // States for Compose
    private var performanceText by mutableStateOf<String?>(null)
    private var isPaused by mutableStateOf(false)
    private var menuDrawerState by mutableStateOf(false)
    private var isSaveStateMenuOpen by mutableStateOf(false)
    private var isLayoutMenuOpen by mutableStateOf(false)

    // View references captured from Compose
    private var surfaceView: SurfaceView? = null
    private var inputOverlay: InputOverlay? = null

    override fun onAttach(context: Context) {
        super.onAttach(context)
        if (context is EmulationActivity) {
            emulationActivity = context
            NativeLibrary.setEmulationActivity(context)
        } else {
            throw IllegalStateException("EmulationFragment must have EmulationActivity parent")
        }
    }

    /**
     * Initialize anything that doesn't depend on the layout / views in here.
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent = requireActivity().intent
        val intentUri: Uri? = intent.data
        val oldIntentInfo = Pair(
            intent.getStringExtra("SelectedGame"),
            intent.getStringExtra("SelectedTitle")
        )
        var intentGame: Game? = null
        if (intentUri != null) {
            intentGame = if (Game.extensions.contains(FileUtil.getExtension(intentUri))) {
                GameHelper.getGame(intentUri, isInstalled = false, addedToLibrary = false)
            } else {
                null
            }
        } else if (oldIntentInfo.first != null) {
            val gameUri = Uri.parse(oldIntentInfo.first)
            intentGame = if (Game.extensions.contains(FileUtil.getExtension(gameUri))) {
                GameHelper.getGame(gameUri, isInstalled = false, addedToLibrary = false)
            } else {
                null
            }
        }
        try {
            game = args.game ?: intentGame!!
        } catch (e: NullPointerException) {
            Toast.makeText(
                requireContext(),
                R.string.no_game_present,
                Toast.LENGTH_SHORT
            ).show()
            requireActivity().finish()
            return
        }
        // So this fragment doesn't restart on configuration changes; i.e. rotation.
        retainInstance = true
        emulationState = EmulationState(game.path)
        emulationActivity = requireActivity() as EmulationActivity
        screenAdjustmentUtil =
            ScreenAdjustmentUtil(requireContext(), requireActivity().windowManager, settings)
        EmulationLifecycleUtil.addPauseResumeHook(onPause)
        EmulationLifecycleUtil.addShutdownHook(onShutdown)

        // Reset emulation started state to ensure loading screen shows
        emulationViewModel.setEmulationStarted(false)

        requireActivity().onBackPressedDispatcher.addCallback(
            this,
            object : OnBackPressedCallback(true) {
                override fun handleOnBackPressed() {
                    when {
                        menuDrawerState -> menuDrawerState = false
                        isSaveStateMenuOpen -> isSaveStateMenuOpen = false
                        isLayoutMenuOpen -> isLayoutMenuOpen = false
                        else -> menuDrawerState = true
                    }
                }
            }
        )
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
            setContent {
                val menuItems = rememberMenuItems()
                val shaderProgress by emulationViewModel.shaderProgress.collectAsState(0)
                val totalShaders by emulationViewModel.totalShaders.collectAsState(0)
                val shaderMessage by emulationViewModel.shaderMessage.collectAsState("")
                val emulationStarted by emulationViewModel.emulationStarted.collectAsState(false)

                val loadingState = if (emulationStarted) {
                    LoadingState.Hidden
                } else if (totalShaders > 0 && shaderProgress < totalShaders) {
                    LoadingState.Visible(
                        title = stringResource(R.string.building_shaders),
                        description = String.format("%d/%d", shaderProgress, totalShaders),
                        progress = shaderProgress,
                        max = totalShaders
                    )
                } else if (shaderMessage.isNotEmpty()) {
                    LoadingState.Visible(
                        title = stringResource(R.string.load_settings),
                        description = shaderMessage,
                        progress = null,
                        max = null
                    )
                } else {
                    LoadingState.Visible(
                        title = stringResource(R.string.load_settings),
                        description = "",
                        progress = null,
                        max = null
                    )
                }

                CitraTheme {
                    EmulationScreen(
                        game = game,
                        isDrawerOpen = menuDrawerState,
                        onCloseDrawer = { menuDrawerState = false },
                        isSaveStateMenuOpen = isSaveStateMenuOpen,
                        onCloseSaveStateMenu = { isSaveStateMenuOpen = false },
                        isLayoutMenuOpen = isLayoutMenuOpen,
                        onCloseLayoutMenu = { isLayoutMenuOpen = false },
                        onSurfaceCreated = { view ->
                            surfaceView = view
                            view.holder.addCallback(this@EmulationFragment)
                        },
                        onOverlayCreated = { view ->
                            inputOverlay = view
                            view.visibility = View.VISIBLE
                        },
                        menuItems = menuItems,
                        loadingState = loadingState,
                        performanceText = performanceText
                    )
                }
            }
        }
    }

    fun isDrawerOpen(): Boolean {
        return menuDrawerState
    }

    private fun togglePause() {
        if (emulationState.isPaused) {
            emulationState.unpause()
        } else {
            emulationState.pause()
        }
        isPaused = emulationState.isPaused
    }

    override fun onResume() {
        super.onResume()
        Choreographer.getInstance().postFrameCallback(this)
        if (NativeLibrary.isRunning()) {
            emulationState.pause()
            isPaused = true
            return
        }
        if (DirectoryInitialization.areCitraDirectoriesReady()) {
            emulationState.run(emulationActivity.isActivityRecreated)
        } else {
            setupCitraDirectoriesThenStartEmulation()
        }
    }

    override fun onPause() {
        if (NativeLibrary.isRunning()) {
            emulationState.pause()
        }
        Choreographer.getInstance().removeFrameCallback(this)
        super.onPause()
    }

    override fun onDetach() {
        NativeLibrary.clearEmulationActivity()
        super.onDetach()
    }

    override fun onDestroy() {
        emulationState.stop()
        EmulationLifecycleUtil.removeHook(onPause)
        EmulationLifecycleUtil.removeHook(onShutdown)
        super.onDestroy()
    }

    private fun setupCitraDirectoriesThenStartEmulation() {
        val directoryInitializationState = DirectoryInitialization.start()
        if (directoryInitializationState ===
            DirectoryInitializationState.CITRA_DIRECTORIES_INITIALIZED
        ) {
            emulationState.run(emulationActivity.isActivityRecreated)
        } else if (directoryInitializationState ===
            DirectoryInitializationState.EXTERNAL_STORAGE_PERMISSION_NEEDED
        ) {
            Toast.makeText(context, R.string.write_permission_needed, Toast.LENGTH_SHORT)
                .show()
        } else if (directoryInitializationState ===
            DirectoryInitializationState.CANT_FIND_EXTERNAL_STORAGE
        ) {
            Toast.makeText(
                context,
                R.string.external_storage_not_mounted,
                Toast.LENGTH_SHORT
            ).show()
        }
    }

    @Composable
    private fun rememberMenuItems(): List<EmulationMenuItem> {
        val context = androidx.compose.ui.platform.LocalContext.current
        val isPaused = emulationState.isPaused

        return remember(isPaused) {
            listOf(
                EmulationMenuItem.Action(
                    titleId = if (isPaused) R.string.resume_emulation else R.string.pause_emulation,
                    iconId = if (isPaused) R.drawable.ic_play else R.drawable.ic_pause,
                    action = { togglePause() }
                ),
                EmulationMenuItem.Action(
                    titleId = R.string.savestates,
                    iconId = R.drawable.ic_save,
                    action = {
                        menuDrawerState = false
                        isSaveStateMenuOpen = true
                    }
                ),
                EmulationMenuItem.Action(
                    titleId = R.string.emulation_overlay_options,
                    iconId = R.drawable.ic_controller,
                    action = { /* TODO: Implement Overlay Dialog */ }
                ),
                EmulationMenuItem.Action(
                    titleId = R.string.menu_emulation_amiibo,
                    iconId = R.drawable.ic_nfc,
                    action = { /* TODO: Implement Amiibo Dialog */ }
                ),
                EmulationMenuItem.Action(
                    titleId = R.string.emulation_switch_screen_layout,
                    iconId = R.drawable.ic_splitscreen,
                    action = {
                        menuDrawerState = false
                        isLayoutMenuOpen = true
                    }
                ),
                EmulationMenuItem.Action(
                    titleId = R.string.emulation_swap_screens,
                    iconId = R.drawable.ic_restore, // Placeholder, swap icon missing
                    action = { screenAdjustmentUtil.swapScreen() }
                ),
                EmulationMenuItem.Action(
                    titleId = R.string.emulation_rotate_upright,
                    iconId = R.drawable.ic_rotate_up_right,
                    action = { screenAdjustmentUtil.toggleScreenUpright() }
                ),
                EmulationMenuItem.Action(
                    titleId = R.string.emulation_open_cheats,
                    iconId = R.drawable.ic_code,
                    action = {
                        // Capture fragment instance for navigation
                        val action = EmulationNavigationDirections
                            .actionGlobalCheatsActivity(NativeLibrary.getRunningTitleId())
                        this@EmulationFragment.findNavController().navigate(action)
                    }
                ),
                EmulationMenuItem.Action(
                    titleId = R.string.preferences_settings,
                    iconId = R.drawable.ic_settings,
                    action = {
                        SettingsActivity.launch(
                            context,
                            SettingsFile.FILE_NAME_CONFIG,
                            ""
                        )
                    }
                ),
                EmulationMenuItem.Action(
                    titleId = R.string.emulation_close_game,
                    iconId = R.drawable.ic_exit,
                    action = {
                        emulationState.pause()
                        MaterialAlertDialogBuilder(context)
                            .setTitle(R.string.emulation_close_game)
                            .setMessage(R.string.emulation_close_game_message)
                            .setPositiveButton(android.R.string.ok) { _, _ ->
                                EmulationLifecycleUtil.closeGame()
                            }
                            .setNegativeButton(android.R.string.cancel) { _, _ ->
                                emulationState.unpause()
                            }
                            .setOnCancelListener { emulationState.unpause() }
                            .show()
                    }
                )
            )
        }
    }

    private fun setControlScale(scale: Int, target: String) {
        preferences.edit()
            .putInt(target, scale)
            .apply()
        inputOverlay?.refreshControls()
    }

    private fun resetScale(target: String) {
        preferences.edit().putInt(
            target,
            50
        ).apply()
    }

    private fun resetAllScales() {
        resetScale("controlScale")
        resetScale("controlScale-" + NativeLibrary.ButtonType.BUTTON_A)
        resetScale("controlScale-" + NativeLibrary.ButtonType.BUTTON_B)
        resetScale("controlScale-" + NativeLibrary.ButtonType.BUTTON_X)
        resetScale("controlScale-" + NativeLibrary.ButtonType.BUTTON_Y)
        resetScale("controlScale-" + NativeLibrary.ButtonType.TRIGGER_L)
        resetScale("controlScale-" + NativeLibrary.ButtonType.TRIGGER_R)
        resetScale("controlScale-" + NativeLibrary.ButtonType.BUTTON_ZL)
        resetScale("controlScale-" + NativeLibrary.ButtonType.BUTTON_ZR)
        resetScale("controlScale-" + NativeLibrary.ButtonType.BUTTON_START)
        resetScale("controlScale-" + NativeLibrary.ButtonType.BUTTON_SELECT)
        resetScale("controlScale-" + NativeLibrary.ButtonType.DPAD)
        resetScale("controlScale-" + NativeLibrary.ButtonType.STICK_LEFT)
        resetScale("controlScale-" + NativeLibrary.ButtonType.STICK_C)
        resetScale("controlScale-" + NativeLibrary.ButtonType.BUTTON_HOME)
        resetScale("controlScale-" + NativeLibrary.ButtonType.BUTTON_SWAP)
        inputOverlay?.refreshControls()
    }

    private fun setControlOpacity(opacity: Int) {
        preferences.edit()
            .putInt("controlOpacity", opacity)
            .apply()
        inputOverlay?.refreshControls()
    }

    private fun resetInputOverlay() {
        resetAllScales()
        preferences.edit()
            .putInt("controlOpacity", 50)
            .apply()
        val editor = preferences.edit()
        for (i in 0 until 16) {
            var defaultValue = true
            when (i) {
                6, 7, 12, 13, 14, 15 -> defaultValue = false
            }
            editor.putBoolean("buttonToggle$i", defaultValue)
        }
        editor.apply()
        inputOverlay?.resetButtonPlacement()
    }

    fun updatePerformanceStats() {
        if (perfStatsUpdater != null) {
            perfStatsUpdateHandler.removeCallbacks(perfStatsUpdater!!)
        }
        if (BooleanSetting.PERF_OVERLAY_ENABLE.boolean) {
            val SYSTEM_FPS = 0
            val FPS = 1
            val SPEED = 2
            val FRAMETIME = 3
            val TIME_SVC = 4
            val TIME_IPC = 5
            val TIME_GPU = 6
            val TIME_SWAP = 7
            val TIME_REM = 8
            perfStatsUpdater = Runnable {
                val sb = StringBuilder()
                val perfStats = NativeLibrary.getPerfStats()
                val dividerString = "\u00A0\u2502 "
                if (perfStats[FPS] > 0) {
                    if (BooleanSetting.PERF_OVERLAY_SHOW_FPS.boolean) {
                        sb.append(
                            requireContext().getString(
                                R.string.perf_fps,
                                (perfStats[FPS] + 0.5).toInt()
                            )
                        )
                    }
                    if (BooleanSetting.PERF_OVERLAY_SHOW_FRAMETIME.boolean) {
                        if (sb.isNotEmpty()) sb.append(dividerString)
                        sb.append(
                            requireContext().getString(
                                R.string.perf_frame_time,
                                (perfStats[FRAMETIME] * 1000.0f).toFloat(),
                                (perfStats[TIME_GPU] * 1000.0f).toFloat(),
                                (perfStats[TIME_SWAP] * 1000.0f).toFloat(),
                                (perfStats[TIME_IPC] * 1000.0f).toFloat(),
                                (perfStats[TIME_SVC] * 1000.0f).toFloat(),
                                (perfStats[TIME_REM] * 1000.0f).toFloat()
                            )
                        )
                    }
                    if (BooleanSetting.PERF_OVERLAY_SHOW_SPEED.boolean) {
                        if (sb.isNotEmpty()) sb.append(dividerString)
                        sb.append(
                            requireContext().getString(
                                R.string.perf_speed,
                                (perfStats[SPEED] * 100.0 + 0.5).toInt()
                            )
                        )
                    }
                    // Update state instead of View
                    performanceText = sb.toString()
                }
                perfStatsUpdateHandler.postDelayed(perfStatsUpdater!!, 1000)
            }
            perfStatsUpdateHandler.post(perfStatsUpdater!!)
        } else {
            performanceText = null
        }
    }

    private fun getBatteryTemperature(): Float {
        try {
            val batteryIntent =
                requireContext().registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            // Temperature in tenths of a degree Celsius
            val temperature = batteryIntent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) ?: 0
            // Convert to degrees Celsius
            return temperature / 10.0f
        } catch (e: Exception) {
            return 0.0f
        }
    }

    private fun celsiusToFahrenheit(celsius: Float): Float {
        return (celsius * 9 / 5) + 32
    }

    override fun surfaceCreated(holder: SurfaceHolder) {
        // We purposely don't do anything here.
        // All work is done in surfaceChanged, which we are guaranteed to get even for surface creation.
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
        Log.debug("[EmulationFragment] Surface changed. Resolution: " + width + "x" + height)
        emulationState.newSurface(holder.surface)
    }

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        emulationState.clearSurface()
    }

    override fun doFrame(frameTimeNanos: Long) {
        Choreographer.getInstance().postFrameCallback(this)
        NativeLibrary.doFrame()
    }

    private class EmulationState(private val gamePath: String) {
        private var state: State
        private var surface: Surface? = null

        init {
            // Starting state is stopped.
            state = State.STOPPED
        }

        @get:Synchronized
        val isStopped: Boolean
            get() = state == State.STOPPED

        @get:Synchronized
        val isPaused: Boolean
            // Getters for the current state
            get() = state == State.PAUSED

        @get:Synchronized
        val isRunning: Boolean
            get() = state == State.RUNNING

        @Synchronized
        fun stop() {
            if (state != State.STOPPED) {
                Log.debug("[EmulationFragment] Stopping emulation.")
                state = State.STOPPED
                NativeLibrary.stopEmulation()
            } else {
                Log.warning("[EmulationFragment] Stop called while already stopped.")
            }
        }

        // State changing methods
        @Synchronized
        fun pause() {
            if (state != State.PAUSED) {
                state = State.PAUSED
                Log.debug("[EmulationFragment] Pausing emulation.")
                // Release the surface before pausing, since emulation has to be running for that.
                NativeLibrary.surfaceDestroyed()
                NativeLibrary.pauseEmulation()
                NativeLibrary.playTimeManagerStop()
            } else {
                Log.warning("[EmulationFragment] Pause called while already paused.")
            }
        }

        @Synchronized
        fun unpause() {
            if (state != State.RUNNING) {
                state = State.RUNNING
                Log.debug("[EmulationFragment] Unpausing emulation.")
                NativeLibrary.unPauseEmulation()
                NativeLibrary.playTimeManagerStart(NativeLibrary.playTimeManagerGetCurrentTitleId())
            } else {
                Log.warning("[EmulationFragment] Unpause called while already running.")
            }
        }

        @Synchronized
        fun run(isActivityRecreated: Boolean) {
            if (isActivityRecreated) {
                if (NativeLibrary.isRunning()) {
                    state = State.PAUSED
                }
            } else {
                Log.debug("[EmulationFragment] activity resumed or fresh start")
            }
            // If the surface is set, run now. Otherwise, wait for it to get set.
            if (surface != null) {
                runWithValidSurface()
            }
        }

        // Surface callbacks
        @Synchronized
        fun newSurface(surface: Surface?) {
            this.surface = surface
            if (this.surface != null) {
                runWithValidSurface()
            }
        }

        @Synchronized
        fun clearSurface() {
            if (surface == null) {
                Log.warning("[EmulationFragment] clearSurface called, but surface already null.")
            } else {
                surface = null
                Log.debug("[EmulationFragment] Surface destroyed.")
                when (state) {
                    State.RUNNING -> {
                        NativeLibrary.surfaceDestroyed()
                        state = State.PAUSED
                    }

                    State.PAUSED -> {
                        Log.warning("[EmulationFragment] Surface cleared while emulation paused.")
                    }

                    else -> {
                        Log.warning("[EmulationFragment] Surface cleared while emulation stopped.")
                    }
                }
            }
        }

        private fun runWithValidSurface() {
            NativeLibrary.surfaceChanged(surface!!)
            when (state) {
                State.STOPPED -> {
                    Thread({
                        Log.debug("[EmulationFragment] Starting emulation thread.")
                        NativeLibrary.run(gamePath)
                    }, "NativeEmulation").start()
                }

                State.PAUSED -> {
                    Log.debug("[EmulationFragment] Resuming emulation.")
                    unpause()
                }

                else -> {
                    Log.debug("[EmulationFragment] Bug, run called while already running.")
                }
            }
            state = State.RUNNING
        }

        private enum class State {
            STOPPED,
            RUNNING,
            PAUSED
        }
    }

    companion object {
        private val perfStatsUpdateHandler = Handler(Looper.myLooper()!!)
    }
}
