package org.citra.citra_emu.fragments

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.core.widget.doOnTextChanged
import androidx.documentfile.provider.DocumentFile
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import androidx.navigation.fragment.findNavController
import androidx.preference.PreferenceManager
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.transition.MaterialSharedAxis
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.HomeNavigationDirections
import org.citra.citra_emu.R
import org.citra.citra_emu.databinding.DialogSoftwareKeyboardBinding
import org.citra.citra_emu.features.settings.model.Settings
import org.citra.citra_emu.features.settings.ui.SettingsEvent
import org.citra.citra_emu.features.settings.ui.SettingsViewModel
import org.citra.citra_emu.features.settings.ui.SettingsActivity
import org.citra.citra_emu.features.settings.utils.SettingsFile
import org.citra.citra_emu.ui.main.MainActivity
import org.citra.citra_emu.ui.settings.SettingsScreen
import org.citra.citra_emu.ui.theme.CitraTheme
import org.citra.citra_emu.utils.GameHelper
import org.citra.citra_emu.utils.GpuDriverHelper
import org.citra.citra_emu.utils.Log
import org.citra.citra_emu.utils.PermissionsHandler
import org.citra.citra_emu.viewmodel.DriverViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel

class HomeSettingsFragment : Fragment() {
    private lateinit var mainActivity: MainActivity
    private val homeViewModel: HomeViewModel by activityViewModels()
    private val driverViewModel: DriverViewModel by activityViewModels()
    private val settingsViewModel: SettingsViewModel by viewModels()
    private val preferences
        get() =
            PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        reenterTransition = MaterialSharedAxis(MaterialSharedAxis.X, false)
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        mainActivity = requireActivity() as MainActivity
        return ComposeView(requireContext()).apply {
            setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
            setContent {
                CitraTheme {
                    val userDir by homeViewModel.userDir.collectAsState()
                    val gamesDir by homeViewModel.gamesDir.collectAsState()
                    val driverMetadata by driverViewModel.selectedDriverMetadata.collectAsState()
                    SettingsScreen(
                        viewModel = settingsViewModel,
                        userDir = userDir,
                        gamesDir = gamesDir,
                        driverName = driverMetadata,
                        onEvent = { event -> handleEvent(event) }
                    )
                }
            }
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        // Ensure UI elements are visible
        homeViewModel.setNavigationVisibility(visible = true, animated = true)
        homeViewModel.setStatusBarShadeVisibility(visible = true)
    }

    private fun handleEvent(event: SettingsEvent) {
        when (event) {
            SettingsEvent.NavigateToCoreSettings -> SettingsActivity.launch(
                requireContext(),
                SettingsFile.FILE_NAME_CONFIG,
                ""
            )

            SettingsEvent.OpenArcticBaseDialog -> showArcticBaseDialog()
            is SettingsEvent.NavigateToEmulationActivity -> {
                val action = HomeNavigationDirections.actionGlobalEmulationActivity(event.game)
                findNavController().navigate(action)
            }

            SettingsEvent.LaunchCiaInstaller -> mainActivity.ciaFileInstaller.launch(true)
            SettingsEvent.NavigateToSystemFiles -> {
                exitTransition = MaterialSharedAxis(MaterialSharedAxis.X, true)
                findNavController().navigate(R.id.action_homeSettingsFragment_to_systemFilesFragment)
            }

            SettingsEvent.ShareLog -> shareLog()
            SettingsEvent.NavigateToDriverManager -> {
                if (GpuDriverHelper.supportsCustomDriverLoading()) {
                    findNavController().navigate(R.id.action_homeSettingsFragment_to_driverManagerFragment)
                } else {
                    Toast.makeText(
                        context,
                        R.string.custom_driver_not_supported,
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }

            SettingsEvent.SelectUserFolder -> PermissionsHandler.compatibleSelectDirectory(
                mainActivity.openCitraDirectory
            )

            SettingsEvent.SelectGamesFolder -> getGamesDirectory.launch(Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).data)
            SettingsEvent.NavigateToThemeSettings -> SettingsActivity.launch(
                requireContext(),
                Settings.SECTION_THEME,
                ""
            )

            SettingsEvent.NavigateToAbout -> {
                exitTransition = MaterialSharedAxis(MaterialSharedAxis.X, true)
                findNavController().navigate(R.id.action_homeSettingsFragment_to_aboutFragment)
            }
        }
    }

    private fun showArcticBaseDialog() {
        val inflater = LayoutInflater.from(context)
        val inputBinding = DialogSoftwareKeyboardBinding.inflate(inflater)
        var textInputValue: String = preferences.getString("last_artic_base_addr", "")!!
        inputBinding.editTextInput.setText(textInputValue)
        inputBinding.editTextInput.doOnTextChanged { text, _, _, _ ->
            textInputValue = text.toString()
        }
        context?.let { ctx ->
            MaterialAlertDialogBuilder(ctx)
                .setView(inputBinding.root)
                .setTitle(getString(R.string.artic_base_enter_address))
                .setPositiveButton(android.R.string.ok) { _, _ ->
                    if (textInputValue.isNotEmpty()) {
                        preferences.edit()
                            .putString("last_artic_base_addr", textInputValue)
                            .apply()
                        settingsViewModel.onArcticBaseAddressEntered(textInputValue)
                    }
                }
                .setNegativeButton(android.R.string.cancel) { _, _ -> }
                .show()
        }
    }

    private val getGamesDirectory =
        registerForActivityResult(ActivityResultContracts.OpenDocumentTree()) { result ->
            if (result == null) {
                return@registerForActivityResult
            }
            requireContext().contentResolver.takePersistableUriPermission(
                result,
                Intent.FLAG_GRANT_READ_URI_PERMISSION
            )
            preferences.edit()
                .putString(GameHelper.KEY_GAME_PATH, result.toString())
                .apply()
            Toast.makeText(
                CitraApplication.appContext,
                R.string.games_dir_selected,
                Toast.LENGTH_LONG
            ).show()
            homeViewModel.setGamesDir(requireActivity(), result.path!!)
        }

    private fun shareLog() {
        val logDirectory = DocumentFile.fromTreeUri(
            requireContext(),
            PermissionsHandler.citraDirectory
        )?.findFile("log")
        val currentLog = logDirectory?.findFile("azahar_log.txt")
        val oldLog = logDirectory?.findFile("azahar_log.old.txt")
        val intent = Intent().apply {
            action = Intent.ACTION_SEND
            type = "text/plain"
        }
        if (!Log.gameLaunched && oldLog?.exists() == true) {
            intent.putExtra(Intent.EXTRA_STREAM, oldLog.uri)
            startActivity(Intent.createChooser(intent, getText(R.string.share_log)))
        } else if (currentLog?.exists() == true) {
            intent.putExtra(Intent.EXTRA_STREAM, currentLog.uri)
            startActivity(Intent.createChooser(intent, getText(R.string.share_log)))
        } else {
            Toast.makeText(
                requireContext(),
                getText(R.string.share_log_not_found),
                Toast.LENGTH_SHORT
            ).show()
        }
    }
}
