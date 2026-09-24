// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.fragments

import android.annotation.SuppressLint
import android.content.Context
import android.content.DialogInterface
import android.content.SharedPreferences
import android.hardware.input.InputManager
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.text.Editable
import android.text.TextWatcher
import android.view.Choreographer
import android.view.InputDevice
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.Surface
import android.view.View
import android.view.ViewGroup
import android.widget.PopupMenu
import android.widget.Toast
import androidx.activity.OnBackPressedCallback
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.runtime.mutableStateOf
import androidx.core.graphics.Insets
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.drawerlayout.widget.DrawerLayout
import androidx.drawerlayout.widget.DrawerLayout.DrawerListener
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import androidx.navigation.findNavController
import androidx.navigation.fragment.navArgs
import androidx.preference.PreferenceManager
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.slider.Slider
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.EmulationNavigationDirections
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.R
import org.citra.citra_emu.activities.EmulationActivity
import org.citra.citra_emu.databinding.DialogCheckboxBinding
import org.citra.citra_emu.databinding.DialogSliderBinding
import org.citra.citra_emu.databinding.FragmentEmulationBinding
import org.citra.citra_emu.display.PortraitScreenLayout
import org.citra.citra_emu.display.ScreenAdjustmentUtil
import org.citra.citra_emu.display.ScreenLayout
import org.citra.citra_emu.features.settings.model.BooleanSetting
import org.citra.citra_emu.features.settings.model.IntSetting
import org.citra.citra_emu.features.settings.model.ScaledFloatSetting
import org.citra.citra_emu.features.settings.model.SettingsViewModel
import org.citra.citra_emu.features.settings.ui.SettingsActivity
import org.citra.citra_emu.features.settings.utils.SettingsFile
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.ui.emulation.compose.EmulationWidget
import org.citra.citra_emu.ui.emulation.compose.SidebarActions
import org.citra.citra_emu.ui.emulation.compose.SidebarSavestateSlot
import org.citra.citra_emu.ui.emulation.compose.SidebarWidget
import org.citra.citra_emu.ui.compose.theme.AzaharTheme
import org.citra.citra_emu.utils.DirectoryInitialization
import org.citra.citra_emu.utils.DirectoryInitialization.DirectoryInitializationState
import org.citra.citra_emu.utils.FileUtil.outputStream
import java.io.File
import org.citra.citra_emu.utils.EmulationMenuSettings
import org.citra.citra_emu.utils.FileUtil
import org.citra.citra_emu.utils.GameHelper
import org.citra.citra_emu.utils.GameIconUtils
import org.citra.citra_emu.utils.EmulationLifecycleUtil
import org.citra.citra_emu.utils.Log
import org.citra.citra_emu.utils.MemoryRecordingExportWorker
import org.citra.citra_emu.utils.ViewUtils
import org.citra.citra_emu.viewmodel.EmulationViewModel
import org.citra.citra_emu.viewmodel.SidebarViewModel

class EmulationFragment : Fragment(), Choreographer.FrameCallback {
    private val preferences: SharedPreferences
        get() = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)

    private lateinit var emulationState: EmulationState
    private var perfStatsUpdater: Runnable? = null

    private lateinit var emulationActivity: EmulationActivity

    private var _binding: FragmentEmulationBinding? = null
    private val binding get() = _binding!!

    private val args by navArgs<EmulationFragmentArgs>()

    private lateinit var game: Game
    private lateinit var screenAdjustmentUtil: ScreenAdjustmentUtil

    /**
     * Which of the two screen Composables is displayed first. Toggled by [ScreenAdjustmentUtil]'s
     * swapScreen(), which owns no view state of its own.
     */
    private val topFirstState = mutableStateOf(!EmulationMenuSettings.swapScreens)

    private val sidebarViewModel: SidebarViewModel by viewModels()

    /**
     * Whether a memory recording session ([NativeLibrary.startMemoryRecording]) is currently
     * active.
     */
    private var isRecordingMemory = false

    /**
     * Directory holding the per-frame memory dumps of the in-progress recording session, if any.
     */
    private var memoryRecordingTempDir: File? = null

    /**
     * Memory dump bytes awaiting a user-chosen destination from [saveMemoryDumpLauncher].
     */
    private var pendingMemoryDump: ByteArray? = null

    private val saveMemoryDumpLauncher =
        registerForActivityResult(ActivityResultContracts.CreateDocument("application/octet-stream")) { uri ->
            uri?.let { writeMemoryDumpToUri(it) }
        }

    private val saveMemoryRecordingLauncher =
        registerForActivityResult(ActivityResultContracts.CreateDocument("application/zip")) { uri ->
            uri?.let { exportMemoryRecordingZipToUri(it) } ?: memoryRecordingTempDir?.let {
                it.deleteRecursively()
                memoryRecordingTempDir = null
            }
        }

    private val emulationViewModel: EmulationViewModel by activityViewModels()
    private val settingsViewModel: SettingsViewModel by viewModels()

    private val inputManager: InputManager
        get() = requireContext().getSystemService(Context.INPUT_SERVICE) as InputManager

    /**
     * Auto-hides the virtual controller overlay when a physical game controller connects.
     * Deliberately does not restore the overlay on [onInputDeviceRemoved]; it is only ever
     * restored by [InputOverlay.setAutoHidden] in response to a touch.
     */
    private val controllerDeviceListener = object : InputManager.InputDeviceListener {
        override fun onInputDeviceAdded(deviceId: Int) {
            if (!isGameController(deviceId) || !EmulationMenuSettings.autoDisableOverlayOnController) {
                return
            }
            binding.surfaceInputOverlay.setAutoHidden(true)
        }

        override fun onInputDeviceRemoved(deviceId: Int) {}

        override fun onInputDeviceChanged(deviceId: Int) {}
    }

    /**
     * Hides or restores the virtual controller overlay. Safe to call before the view is created.
     */
    fun setOverlayAutoHidden(hidden: Boolean) {
        _binding?.surfaceInputOverlay?.setAutoHidden(hidden)
    }

    private fun isGameController(deviceId: Int): Boolean {
        val device = InputDevice.getDevice(deviceId) ?: return false
        val sources = device.sources
        return sources and InputDevice.SOURCE_GAMEPAD == InputDevice.SOURCE_GAMEPAD ||
            sources and InputDevice.SOURCE_JOYSTICK == InputDevice.SOURCE_JOYSTICK
    }

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

        retainInstance = true
        emulationState = EmulationState(game.path)
        emulationActivity = requireActivity() as EmulationActivity
        screenAdjustmentUtil = emulationActivity.screenAdjustmentUtil
        screenAdjustmentUtil.onScreenSwapped = { topFirstState.value = !topFirstState.value }
        EmulationLifecycleUtil.addShutdownHook(hook = { emulationState.stop() })
        EmulationLifecycleUtil.addPauseResumeHook(hook = { togglePause() })
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentEmulationBinding.inflate(inflater)
        return binding.root
    }

    @SuppressLint("UnsafeRepeatOnLifecycleDetector")
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        if (requireActivity().isFinishing) {
            return
        }

        binding.composeEmulationScreens.setContent {
            EmulationWidget(
                topFirst = topFirstState.value,
                onTopSurfaceChanged = { emulationState.newSurface(it) },
                onTopSurfaceDestroyed = { emulationState.clearSurface() },
                onBottomSurfaceChanged = { emulationState.newSecondarySurface(it) },
                onBottomSurfaceDestroyed = { emulationState.clearSecondarySurface() },
                onBottomScreenBoundsChanged = { bounds ->
                    binding.surfaceInputOverlay.bottomScreenBoundsInWindow = bounds
                }
            )
        }
        binding.surfaceInputOverlay.onSwapScreenRequested = { screenAdjustmentUtil.swapScreen() }
        binding.doneControlConfig.setOnClickListener {
            binding.doneControlConfig.visibility = View.GONE
            binding.surfaceInputOverlay.setIsInEditMode(false)
        }

        updateShowFpsOverlay()

        binding.drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED)
        binding.drawerLayout.addDrawerListener(object : DrawerListener {
            override fun onDrawerSlide(drawerView: View, slideOffset: Float) {
                binding.surfaceInputOverlay.dispatchTouchEvent(
                    MotionEvent.obtain(
                        SystemClock.uptimeMillis(),
                        SystemClock.uptimeMillis() + 100,
                        MotionEvent.ACTION_UP,
                        0f,
                        0f,
                        0
                    )
                )
            }

            override fun onDrawerOpened(drawerView: View) {
                binding.drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED)
                binding.surfaceInputOverlay.isClickable = false
                binding.surfaceInputOverlay.isFocusable = false
                binding.surfaceInputOverlay.isFocusableInTouchMode = false
            }

            override fun onDrawerClosed(drawerView: View) {
                binding.drawerLayout.setDrawerLockMode(EmulationMenuSettings.drawerLockMode)
                binding.surfaceInputOverlay.isClickable = true
                binding.surfaceInputOverlay.isFocusable = true
                binding.surfaceInputOverlay.isFocusableInTouchMode = true
            }

            override fun onDrawerStateChanged(newState: Int) {
            }
        })
        sidebarViewModel.setPaused(emulationState.isPaused)
        sidebarViewModel.setSavestatesAvailable(NativeLibrary.getSavestateInfo() != null)
        binding.inGameMenu.setContent {
            AzaharTheme {
                SidebarWidget(
                    gameTitle = game.title,
                    viewModel = sidebarViewModel,
                    savestateSlotsProvider = { buildSavestateSlots() },
                    actions = SidebarActions(
                        onPauseResume = {
                            if (emulationState.isPaused) {
                                emulationState.unpause()
                                sidebarViewModel.setPaused(false)
                            } else {
                                emulationState.pause()
                                sidebarViewModel.setPaused(true)
                            }
                        },
                        onAdvanceFrame = { NativeLibrary.advanceFrame() },
                        onSwapScreens = { screenAdjustmentUtil.swapScreen() },
                        onHapticFeedbackChanged = {
                            sidebarViewModel.toggleHapticFeedback()
                        },
                        onAutoDisableOverlayChanged = {
                            sidebarViewModel.toggleAutoDisableOverlayOnController()
                            if (!sidebarViewModel.autoDisableOverlayOnController.value) {
                                binding.surfaceInputOverlay.setAutoHidden(false)
                            }
                        },
                        onDrawerLockChanged = {
                            sidebarViewModel.toggleDrawerLock()
                        },
                        onCheats = {
                            val action = EmulationNavigationDirections
                                .actionGlobalCheatsActivity(NativeLibrary.getRunningTitleId())
                            binding.root.findNavController().navigate(action)
                        },
                        onSaveMemory = {
                            pendingMemoryDump = NativeLibrary.dumpCurrentMemory()
                            saveMemoryDumpLauncher.launch("memory_dump.bin")
                        },
                        onRecordMemory = {
                            toggleMemoryRecording()
                        },
                        onSettings = {
                            SettingsActivity.launch(
                                requireContext(),
                                SettingsFile.FILE_NAME_CONFIG,
                                ""
                            )
                        },
                        onCloseGame = {
                            NativeLibrary.pauseEmulation()
                            MaterialAlertDialogBuilder(requireContext())
                                .setTitle(R.string.emulation_close_game)
                                .setMessage(R.string.emulation_close_game_message)
                                .setPositiveButton(android.R.string.ok) { _: DialogInterface?, _: Int ->
                                    EmulationLifecycleUtil.closeGame()
                                }
                                .setNegativeButton(android.R.string.cancel) { _: DialogInterface?, _: Int ->
                                    NativeLibrary.unPauseEmulation()
                                }
                                .setOnCancelListener { NativeLibrary.unPauseEmulation() }
                                .show()
                        },
                        onSaveState = { slot -> NativeLibrary.saveState(slot) },
                        onLoadState = { slot ->
                            NativeLibrary.loadState(slot)
                            binding.drawerLayout.close()
                            Toast.makeText(
                                context,
                                getString(R.string.quickload_loading),
                                Toast.LENGTH_SHORT
                            ).show()
                        },
                        onShowOverlayChanged = {
                            sidebarViewModel.toggleShowOverlay()
                            binding.surfaceInputOverlay.refreshControls()
                        },
                        onShowFpsChanged = {
                            sidebarViewModel.toggleShowFps()
                            updateShowFpsOverlay()
                        },
                        onEditLayout = {
                            editControlsPlacement()
                            binding.drawerLayout.close()
                        },
                        onToggleControls = { showToggleControlsDialog() },
                        onAdjustScale = { target -> showAdjustScaleDialog(target) },
                        onResetAllScales = { resetAllScales() },
                        onAdjustOpacity = { showAdjustOpacityDialog() },
                        onJoystickRelCenterChanged = { sidebarViewModel.toggleJoystickRelCenter() },
                        onDpadSlideChanged = { sidebarViewModel.toggleDpadSlide() },
                        onResetOverlay = { showResetOverlayDialog() },
                        onLoadAmiibo = { emulationActivity.openFileLauncher.launch(false) },
                        onRemoveAmiibo = { NativeLibrary.removeAmiibo() }
                    )
                )
            }
        }

        requireActivity().onBackPressedDispatcher.addCallback(
            viewLifecycleOwner,
            object : OnBackPressedCallback(true) {
                override fun handleOnBackPressed() {
                    if (!emulationViewModel.emulationStarted.value) {
                        return
                    }

                    if (binding.drawerLayout.isOpen) {
                        binding.drawerLayout.close()
                    } else {
                        binding.drawerLayout.open()
                    }
                }
            }
        )

        GameIconUtils.loadGameIcon(requireActivity(), game, binding.loadingImage)
        binding.loadingTitle.text = game.title

        viewLifecycleOwner.lifecycleScope.apply {
            launch {
                repeatOnLifecycle(Lifecycle.State.CREATED) {
                    emulationViewModel.shaderProgress.collectLatest {
                        if (it > 0 && it != emulationViewModel.totalShaders.value) {
                            binding.loadingProgressIndicator.isIndeterminate = false
                            binding.loadingProgressText.visibility = View.VISIBLE
                            binding.loadingProgressText.text = String.format(
                                "%d/%d",
                                emulationViewModel.shaderProgress.value,
                                emulationViewModel.totalShaders.value
                            )

                            if (it < binding.loadingProgressIndicator.max) {
                                binding.loadingProgressIndicator.progress = it
                            }
                        }

                        if (it == emulationViewModel.totalShaders.value) {
                            binding.loadingText.setText(R.string.loading)
                            binding.loadingProgressIndicator.isIndeterminate = true
                            binding.loadingProgressText.visibility = View.GONE
                        }
                    }
                }
            }
            launch {
                repeatOnLifecycle(Lifecycle.State.CREATED) {
                    emulationViewModel.totalShaders.collectLatest {
                        binding.loadingProgressIndicator.max = it
                    }
                }
            }
            launch {
                repeatOnLifecycle(Lifecycle.State.CREATED) {
                    emulationViewModel.shaderMessage.collectLatest {
                        if (it != "") {
                            binding.loadingText.text = it
                        }
                    }
                }
            }
            launch {
                repeatOnLifecycle(Lifecycle.State.CREATED) {
                    emulationViewModel.emulationStarted.collectLatest { started ->
                        if (started) {
                            ViewUtils.hideView(binding.loadingIndicator)
                            ViewUtils.showView(binding.surfaceInputOverlay)
                            sidebarViewModel.setSavestatesAvailable(
                                NativeLibrary.getSavestateInfo() != null
                            )
                            binding.drawerLayout.setDrawerLockMode(EmulationMenuSettings.drawerLockMode)
                        }
                    }
                }
            }
        }

        setInsets()
    }

    fun isDrawerOpen(): Boolean {
        return binding.drawerLayout.isOpen
    }

    private fun togglePause() {
        if (emulationState.isPaused) {
            emulationState.unpause()
            sidebarViewModel.setPaused(false)
        } else {
            emulationState.pause()
            sidebarViewModel.setPaused(true)
        }
    }

    override fun onResume() {
        super.onResume()
        Choreographer.getInstance().postFrameCallback(this)
        inputManager.registerInputDeviceListener(controllerDeviceListener, null)
        if (EmulationMenuSettings.autoDisableOverlayOnController &&
            InputDevice.getDeviceIds().any { isGameController(it) }
        ) {
            binding.surfaceInputOverlay.setAutoHidden(true)
        }
        if (NativeLibrary.isRunning()) {
            NativeLibrary.unPauseEmulation()
            sidebarViewModel.setPaused(false)
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
            sidebarViewModel.setPaused(true)
        }
        inputManager.unregisterInputDeviceListener(controllerDeviceListener)
        Choreographer.getInstance().removeFrameCallback(this)
        super.onPause()
    }

    override fun onDetach() {
        NativeLibrary.clearEmulationActivity()
        super.onDetach()
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

    private fun buildSavestateSlots(): List<SidebarSavestateSlot> {
        val occupied = NativeLibrary.getSavestateInfo()?.associateBy { it.slot } ?: emptyMap()
        return (0 until NativeLibrary.SAVESTATE_SLOT_COUNT).map { slot ->
            val isQuickSave = slot == NativeLibrary.QUICKSAVE_SLOT
            val info = occupied[slot]
            val emptyLabel = if (isQuickSave) {
                getString(R.string.emulation_quicksave_slot)
            } else {
                getString(R.string.emulation_empty_state_slot, slot)
            }
            val occupiedLabel = info?.let {
                if (isQuickSave) {
                    getString(R.string.emulation_occupied_quicksave_slot, it.time)
                } else {
                    getString(R.string.emulation_occupied_state_slot, it.slot, it.time)
                }
            }
            SidebarSavestateSlot(slot, isQuickSave, emptyLabel, occupiedLabel)
        }
    }

    private fun displaySavestateWarning() {
        if (preferences.getBoolean("savestateWarningShown", false)) {
            return
        }

        val dialogCheckboxBinding = DialogCheckboxBinding.inflate(layoutInflater)
        MaterialAlertDialogBuilder(requireContext())
            .setTitle(R.string.savestates)
            .setMessage(R.string.savestate_warning_message)
            .setView(dialogCheckboxBinding.root)
            .setPositiveButton(android.R.string.ok) { _: DialogInterface?, _: Int ->
                preferences.edit()
                    .putBoolean("savestateWarningShown", dialogCheckboxBinding.checkBox.isChecked)
                    .apply()
            }
            .show()
    }

    private fun toggleMemoryRecording() {
        if (isRecordingMemory) {
            val frameCount = NativeLibrary.stopMemoryRecording()
            isRecordingMemory = false
            sidebarViewModel.setRecordingMemory(false)
            if (frameCount > 0 && memoryRecordingTempDir?.let { hasFrameFiles(it) } == true) {
                saveMemoryRecordingLauncher.launch("memory_recording.zip")
            } else {
                memoryRecordingTempDir?.deleteRecursively()
                memoryRecordingTempDir = null
                Toast.makeText(
                    requireContext(),
                    R.string.memory_recording_empty,
                    Toast.LENGTH_SHORT
                ).show()
            }
        } else {
            val recordingsRoot = File(requireContext().cacheDir, "memory_recordings")
            recordingsRoot.deleteRecursively()
            val tempDir = File(recordingsRoot, SystemClock.elapsedRealtime().toString())
            tempDir.mkdirs()
            memoryRecordingTempDir = tempDir
            NativeLibrary.startMemoryRecording(
                tempDir.absolutePath,
                sidebarViewModel.memoryRecordingIntervalFrames.value
            )
            isRecordingMemory = true
            sidebarViewModel.setRecordingMemory(true)
        }
    }

    private fun writeMemoryDumpToUri(uri: Uri) {
        val data = pendingMemoryDump ?: return
        pendingMemoryDump = null
        viewLifecycleOwner.lifecycleScope.launch(Dispatchers.IO) {
            val stagingFile = File(requireContext().cacheDir, "memory_dump_export.bin.tmp")
            val written = runCatching {
                stagingFile.outputStream().use { it.write(data) }
                uri.outputStream().use { destination ->
                    stagingFile.inputStream().use { it.copyTo(destination) }
                }
            }.isSuccess
            stagingFile.delete()

            if (!written) {
                withContext(Dispatchers.Main) {
                    Toast.makeText(
                        requireContext(),
                        R.string.memory_recording_export_error,
                        Toast.LENGTH_LONG
                    ).show()
                }
            }
        }
    }

    private fun exportMemoryRecordingZipToUri(uri: Uri) {
        val tempDir = memoryRecordingTempDir ?: return
        memoryRecordingTempDir = null

        if (!hasFrameFiles(tempDir)) {
            tempDir.deleteRecursively()
            Toast.makeText(
                requireContext(),
                R.string.memory_recording_empty,
                Toast.LENGTH_SHORT
            ).show()
            return
        }

        val inputData = Data.Builder()
            .putString(MemoryRecordingExportWorker.KEY_TEMP_DIR_PATH, tempDir.absolutePath)
            .putString(MemoryRecordingExportWorker.KEY_DESTINATION_URI, uri.toString())
            .build()
        WorkManager.getInstance(requireContext()).enqueueUniqueWork(
            MemoryRecordingExportWorker.UNIQUE_WORK_NAME,
            ExistingWorkPolicy.APPEND_OR_REPLACE,
            OneTimeWorkRequest.Builder(MemoryRecordingExportWorker::class.java)
                .setInputData(inputData)
                .build()
        )
    }

    private fun hasFrameFiles(dir: File): Boolean =
        dir.listFiles()?.any { it.isFile && it.length() > 0 } == true

    private fun showLandscapeScreenLayoutMenu() {
        val popupMenu = PopupMenu(
            requireContext(),
            binding.inGameMenu.findViewById(R.id.menu_landscape_screen_layout)
        )

        popupMenu.menuInflater.inflate(R.menu.menu_landscape_screen_layout, popupMenu.menu)

        val layoutOptionMenuItem = when (IntSetting.SCREEN_LAYOUT.int) {
            ScreenLayout.ORIGINAL.int ->
                R.id.menu_screen_layout_original

            ScreenLayout.SINGLE_SCREEN.int ->
                R.id.menu_screen_layout_single

            ScreenLayout.SIDE_SCREEN.int ->
                R.id.menu_screen_layout_sidebyside

            ScreenLayout.HYBRID_SCREEN.int ->
                R.id.menu_screen_layout_hybrid

            ScreenLayout.CUSTOM_LAYOUT.int ->
                R.id.menu_screen_layout_custom

            else -> R.id.menu_screen_layout_largescreen
        }
        popupMenu.menu.findItem(layoutOptionMenuItem).setChecked(true)

        popupMenu.setOnMenuItemClickListener {
            when (it.itemId) {
                R.id.menu_screen_layout_largescreen -> {
                    screenAdjustmentUtil.changeScreenOrientation(ScreenLayout.LARGE_SCREEN.int)
                    true
                }

                R.id.menu_screen_layout_single -> {
                    screenAdjustmentUtil.changeScreenOrientation(ScreenLayout.SINGLE_SCREEN.int)
                    true
                }

                R.id.menu_screen_layout_sidebyside -> {
                    screenAdjustmentUtil.changeScreenOrientation(ScreenLayout.SIDE_SCREEN.int)
                    true
                }

                R.id.menu_screen_layout_hybrid -> {
                    screenAdjustmentUtil.changeScreenOrientation(ScreenLayout.HYBRID_SCREEN.int)
                    true
                }

                R.id.menu_screen_layout_original -> {
                    screenAdjustmentUtil.changeScreenOrientation(ScreenLayout.ORIGINAL.int)
                    true
                }

                R.id.menu_screen_layout_custom -> {
                    Toast.makeText(
                        requireContext(),
                        R.string.emulation_adjust_custom_layout,
                        Toast.LENGTH_LONG
                    ).show()
                    screenAdjustmentUtil.changeScreenOrientation(ScreenLayout.CUSTOM_LAYOUT.int)
                    true
                }

                else -> true
            }
        }

        popupMenu.show()
    }

    private fun showPortraitScreenLayoutMenu() {
        val popupMenu = PopupMenu(
            requireContext(),
            binding.inGameMenu.findViewById(R.id.menu_portrait_screen_layout)
        )

        popupMenu.menuInflater.inflate(R.menu.menu_portrait_screen_layout, popupMenu.menu)

        val layoutOptionMenuItem = when (IntSetting.PORTRAIT_SCREEN_LAYOUT.int) {
            PortraitScreenLayout.TOP_FULL_WIDTH.int ->
                R.id.menu_portrait_layout_top_full

            PortraitScreenLayout.CUSTOM_PORTRAIT_LAYOUT.int ->
                R.id.menu_portrait_layout_custom

            else ->
                R.id.menu_portrait_layout_top_full

        }

        popupMenu.menu.findItem(layoutOptionMenuItem).setChecked(true)

        popupMenu.setOnMenuItemClickListener {
            when (it.itemId) {
                R.id.menu_portrait_layout_top_full -> {
                    screenAdjustmentUtil.changePortraitOrientation(PortraitScreenLayout.TOP_FULL_WIDTH.int)
                    true
                }

                R.id.menu_portrait_layout_custom -> {
                    Toast.makeText(
                        requireContext(),
                        R.string.emulation_adjust_custom_layout,
                        Toast.LENGTH_LONG
                    ).show()
                    screenAdjustmentUtil.changePortraitOrientation(PortraitScreenLayout.CUSTOM_PORTRAIT_LAYOUT.int)
                    true
                }

                else -> true
            }
        }

        popupMenu.show()
    }

    private fun editControlsPlacement() {
        if (binding.surfaceInputOverlay.isInEditMode) {
            binding.doneControlConfig.visibility = View.GONE
            binding.surfaceInputOverlay.setIsInEditMode(false)
        } else {
            binding.doneControlConfig.visibility = View.VISIBLE
            binding.surfaceInputOverlay.setIsInEditMode(true)
        }
    }

    private fun showToggleControlsDialog() {
        val editor = preferences.edit()
        val enabledButtons = BooleanArray(15)
        enabledButtons.forEachIndexed { i: Int, _: Boolean ->
            var defaultValue = true
            when (i) {
                6, 7, 12, 13, 14 -> defaultValue = false
            }
            enabledButtons[i] = preferences.getBoolean("buttonToggle$i", defaultValue)
        }

        MaterialAlertDialogBuilder(requireContext())
            .setTitle(R.string.emulation_toggle_controls)
            .setMultiChoiceItems(
                R.array.n3dsButtons, enabledButtons
            ) { _: DialogInterface?, indexSelected: Int, isChecked: Boolean ->
                editor.putBoolean("buttonToggle$indexSelected", isChecked)
            }
            .setPositiveButton(android.R.string.ok) { _: DialogInterface?, _: Int ->
                editor.apply()
                binding.surfaceInputOverlay.refreshControls()
            }
            .show()
    }

    private fun showAdjustScaleDialog(target: String) {
        val sliderBinding = DialogSliderBinding.inflate(layoutInflater)

        sliderBinding.apply {
            slider.valueTo = 150f
            slider.valueFrom = 0f
            slider.value = preferences.getInt(target, 50).toFloat()
            textValue.setText((slider.value + 50).toInt().toString())
            textValue.addTextChangedListener( object : TextWatcher {
                override fun afterTextChanged(s: Editable) {
                    val value = s.toString().toIntOrNull()
                    if (value == null || value < 50 || value > 150) {
                        textInput.error = "Inappropriate Value"
                    } else {
                        textInput.error = null
                        slider.value = value.toFloat() - 50
                    }
                }
                override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}
                override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}
            })
            slider.addOnChangeListener(
                Slider.OnChangeListener { slider: Slider, progress: Float, _: Boolean ->
                    if (textValue.text.toString() != (slider.value + 50).toInt().toString()) {
                        textValue.setText((slider.value + 50).toInt().toString())
                        textValue.setSelection(textValue.length())
                        setControlScale(slider.value.toInt(), target)
                    }

                })
            textInput.suffixText = "%"
        }
        val previousProgress = sliderBinding.slider.value.toInt()

        MaterialAlertDialogBuilder(requireContext())
            .setTitle(R.string.emulation_control_scale)
            .setView(sliderBinding.root)
            .setNegativeButton(android.R.string.cancel) { _: DialogInterface?, _: Int ->
                setControlScale(previousProgress, target)
            }
            .setPositiveButton(android.R.string.ok) { _: DialogInterface?, _: Int ->
                setControlScale(sliderBinding.slider.value.toInt(), target)
            }
            .setNeutralButton(R.string.slider_default) { _: DialogInterface?, _: Int ->
                setControlScale(50, target)
            }
            .show()
    }

    private fun showAdjustOpacityDialog() {
        val sliderBinding = DialogSliderBinding.inflate(layoutInflater)

        sliderBinding.apply {
            slider.valueFrom = 0f
            slider.valueTo = 100f
            slider.value = preferences.getInt("controlOpacity", 50).toFloat()
            textValue.setText(slider.value.toInt().toString())

            textValue.addTextChangedListener( object : TextWatcher {
                override fun afterTextChanged(s: Editable) {
                    val value = s.toString().toIntOrNull()
                    if (value == null || value < slider.valueFrom || value > slider.valueTo) {
                        textInput.error = "Inappropriate Value"
                    } else {
                        textInput.error = null
                        slider.value = value.toFloat()
                    }
                }
                override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}
                override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}
            })


            slider.addOnChangeListener { _: Slider, value: Float, _: Boolean ->

                if (textValue.text.toString() != slider.value.toInt().toString()) {
                        textValue.setText(slider.value.toInt().toString())
                        textValue.setSelection(textValue.length())
                        setControlOpacity(slider.value.toInt())
                    }
                }

            textInput.suffixText = "%"
        }
        val previousProgress = sliderBinding.slider.value.toInt()

        MaterialAlertDialogBuilder(requireContext())
            .setTitle(R.string.emulation_control_opacity)
            .setView(sliderBinding.root)
            .setNegativeButton(android.R.string.cancel) { _: DialogInterface?, _: Int ->
                setControlOpacity(previousProgress)
            }
            .setPositiveButton(android.R.string.ok) { _: DialogInterface?, _: Int ->
                setControlOpacity(sliderBinding.slider.value.toInt())
            }
            .setNeutralButton(R.string.slider_default) { _: DialogInterface?, _: Int ->
                setControlOpacity(50)
            }
            .show()
    }

    private fun setControlScale(scale: Int, target: String) {
        preferences.edit()
            .putInt(target, scale)
            .apply()
        binding.surfaceInputOverlay.refreshControls()
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
        binding.surfaceInputOverlay.refreshControls()
    }

    private fun setControlOpacity(opacity: Int) {
        preferences.edit()
            .putInt("controlOpacity", opacity)
            .apply()
        binding.surfaceInputOverlay.refreshControls()
    }

    private fun showResetOverlayDialog() {
        MaterialAlertDialogBuilder(requireContext())
            .setTitle(getString(R.string.emulation_touch_overlay_reset))
            .setPositiveButton(android.R.string.ok) { _: DialogInterface?, _: Int ->
                resetInputOverlay()
            }
            .setNegativeButton(android.R.string.cancel, null)
            .show()
    }

    private fun resetInputOverlay() {
        resetAllScales()
        preferences.edit()
            .putInt("controlOpacity", 50)
            .apply()

        val editor = preferences.edit()
        for (i in 0 until 15) {
            var defaultValue = true
            when (i) {
                6, 7, 12, 13, 14 -> defaultValue = false
            }
            editor.putBoolean("buttonToggle$i", defaultValue)
        }
        editor.apply()

        binding.surfaceInputOverlay.resetButtonPlacement()
    }

    fun updateShowFpsOverlay() {
        if (EmulationMenuSettings.showFps) {
            val SYSTEM_FPS = 0
            val FPS = 1
            val FRAMETIME = 2
            val SPEED = 3
            perfStatsUpdater = Runnable {
                val perfStats = NativeLibrary.getPerfStats()
                if (perfStats[FPS] > 0) {
                    binding.showFpsText.text = String.format(
                        "FPS: %d Speed: %d%% FT: %.2fms",
                        (perfStats[FPS] + 0.5).toInt(),
                        (perfStats[SPEED] * 100.0 + 0.5).toInt(),
                        (perfStats[FRAMETIME] * 1000.0f).toFloat()
                    )
                }
                perfStatsUpdateHandler.postDelayed(perfStatsUpdater!!, 3000)
            }
            perfStatsUpdateHandler.post(perfStatsUpdater!!)
            binding.showFpsText.visibility = View.VISIBLE
        } else {
            if (perfStatsUpdater != null) {
                perfStatsUpdateHandler.removeCallbacks(perfStatsUpdater!!)
            }
            binding.showFpsText.visibility = View.GONE
        }
    }

    override fun doFrame(frameTimeNanos: Long) {
        Choreographer.getInstance().postFrameCallback(this)
        NativeLibrary.doFrame()
        NativeLibrary.doFrameSecondary()

        NativeLibrary.setGyroSensitivity(
            ScaledFloatSetting.GYRO_SENSITIVITY_VERTICAL.float /
                ScaledFloatSetting.GYRO_SENSITIVITY_VERTICAL.scale,
            ScaledFloatSetting.GYRO_SENSITIVITY_HORIZONTAL.float /
                ScaledFloatSetting.GYRO_SENSITIVITY_HORIZONTAL.scale
        )
        NativeLibrary.setGyroInvert(
            BooleanSetting.INVERT_GYRO_VERTICAL.boolean,
            BooleanSetting.INVERT_GYRO_HORIZONTAL.boolean
        )
    }

    private fun setInsets() {
        ViewCompat.setOnApplyWindowInsetsListener(
            binding.inGameMenu
        ) { v: View, windowInsets: WindowInsetsCompat ->
            val cutInsets: Insets = windowInsets.getInsets(WindowInsetsCompat.Type.displayCutout())
            var left = 0
            var right = 0
            if (ViewCompat.getLayoutDirection(v) == ViewCompat.LAYOUT_DIRECTION_LTR) {
                left = cutInsets.left
            } else {
                right = cutInsets.right
            }

            v.setPadding(left, 0, right, 0)

            val sidePadding = resources.getDimensionPixelSize(R.dimen.spacing_large)
            if (cutInsets.left == 0) {
                binding.showFpsText.setPadding(
                    sidePadding,
                    cutInsets.top,
                    cutInsets.right,
                    cutInsets.bottom
                )
            } else {
                binding.showFpsText.setPadding(
                    cutInsets.left,
                    cutInsets.top,
                    cutInsets.right,
                    cutInsets.bottom
                )
            }
            windowInsets
        }
    }

    private class EmulationState(private val gamePath: String) {
        private var state: State
        private var surface: Surface? = null
        private var secondarySurface: Surface? = null

        init {
            state = State.STOPPED
        }

        @get:Synchronized
        val isStopped: Boolean
            get() = state == State.STOPPED

        @get:Synchronized
        val isPaused: Boolean
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

        @Synchronized
        fun pause() {
            if (state != State.PAUSED) {
                state = State.PAUSED
                Log.debug("[EmulationFragment] Pausing emulation.")
                NativeLibrary.surfaceDestroyed()
                NativeLibrary.surfaceDestroyedSecondary()
                NativeLibrary.pauseEmulation()
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

            if (surface != null && secondarySurface != null) {
                runWithValidSurface()
            }
        }

        /**
         * Both the top and bottom screen surfaces must be ready before emulation can start or
         * resume, since they back two independent native rendering windows.
         */
        @Synchronized
        fun newSurface(surface: Surface?) {
            this.surface = surface
            if (this.surface != null && secondarySurface != null) {
                runWithValidSurface()
            }
        }

        @Synchronized
        fun newSecondarySurface(surface: Surface?) {
            this.secondarySurface = surface
            if (this.secondarySurface != null && this.surface != null) {
                runWithValidSurface()
            }
        }

        @Synchronized
        fun clearSurface() {
            if (surface == null) {
                Log.warning("[EmulationFragment] clearSurface called, but surface already null.")
            } else {
                surface = null
                onSurfaceCleared(isSecondary = false)
            }
        }

        @Synchronized
        fun clearSecondarySurface() {
            if (secondarySurface == null) {
                Log.warning(
                    "[EmulationFragment] clearSecondarySurface called, but surface already null."
                )
            } else {
                secondarySurface = null
                onSurfaceCleared(isSecondary = true)
            }
        }

        /**
         * Destroys only the native surface that was actually lost. The other one may still be
         * valid and in active use by the renderer (e.g. only one of the two screen Composables
         * was torn down and recreated); telling native it was destroyed too would invalidate a
         * surface Android still considers current.
         */
        private fun onSurfaceCleared(isSecondary: Boolean) {
            Log.debug("[EmulationFragment] Surface destroyed.")
            when (state) {
                State.RUNNING -> {
                    if (isSecondary) {
                        NativeLibrary.surfaceDestroyedSecondary()
                    } else {
                        NativeLibrary.surfaceDestroyed()
                    }
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

        private fun runWithValidSurface() {
            NativeLibrary.surfaceChanged(surface!!)
            NativeLibrary.surfaceChangedSecondary(secondarySurface!!)
            when (state) {
                State.STOPPED -> {
                    Thread({
                        Log.debug("[EmulationFragment] Starting emulation thread.")
                        NativeLibrary.run(gamePath)
                    }, "NativeEmulation").start()
                }

                State.PAUSED -> {
                    Log.debug("[EmulationFragment] Resuming emulation.")
                    NativeLibrary.unPauseEmulation()
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
