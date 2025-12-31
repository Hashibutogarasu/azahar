package org.citra.citra_emu.fragments

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.SystemClock
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.documentfile.provider.DocumentFile
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.navigation.Navigation
import androidx.preference.PreferenceManager
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.R
import org.citra.citra_emu.activities.EmulationActivity
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.ui.components.GamesScreen
import org.citra.citra_emu.ui.theme.CitraTheme
import org.citra.citra_emu.viewmodel.GamesViewModel
import org.citra.citra_emu.viewmodel.HomeViewModel

class GamesFragment : Fragment() {
    private val gamesViewModel: GamesViewModel by activityViewModels()
    private val homeViewModel: HomeViewModel by activityViewModels()
    private var lastClickTime: Long = 0
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
            setContent {
                CitraTheme {
                    GamesScreen(
                        viewModel = gamesViewModel,
                        onOpenDrawer = {
                            (requireActivity() as? org.citra.citra_emu.ui.main.MainActivity)?.openDrawer()
                        },
                        onGameSelected = { game ->
                            launchGame(game)
                        },
                        onOpenFolders = { game ->
                            showOpenFoldersMenu(game)
                        },
                        onUninstall = { game ->
                            // TODO: params.onUninstall(game)
                        },
                        onShortcut = { game ->
                            // TODO: params.onShortcut(game)
                        },
                        onCheats = { game ->
                            openCheats(game)
                        }
                    )
                }
            }
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        homeViewModel.setNavigationVisibility(visible = true, animated = false)
        homeViewModel.setStatusBarShadeVisibility(visible = true)
    }

    private fun launchGame(game: Game) {
        if (SystemClock.elapsedRealtime() - lastClickTime < 1000) {
            return
        }
        lastClickTime = SystemClock.elapsedRealtime()
        if (!gameExists(game)) {
            Toast.makeText(
                requireContext(),
                R.string.loader_game_does_not_exist,
                Toast.LENGTH_SHORT
            ).show()
            gamesViewModel.reloadGames(true)
            return
        }
        val preferences = PreferenceManager.getDefaultSharedPreferences(CitraApplication.appContext)
        preferences.edit()
            .putLong(game.keyLastPlayedTime, System.currentTimeMillis())
            .apply()
        // Use direct Intent to avoid Navigation Component issues
        val intent = Intent(requireActivity(), EmulationActivity::class.java).apply {
            putExtra("game", game)
            flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        }
        startActivity(intent)
    }

    private fun openCheats(game: Game) {
        val bundle = Bundle().apply {
            putLong("titleId", game.titleId)
        }
        Navigation.findNavController(requireActivity(), R.id.fragment_container)
            .navigate(R.id.cheatsFragment, bundle)
    }

    private fun gameExists(game: Game): Boolean {
        // Installed games (e.g. CIAs) always exist if they are in the database.
        if (game.isInstalled) {
            return true
        }
        // Return whether the file exists.
        val file = DocumentFile.fromSingleUri(CitraApplication.appContext, Uri.parse(game.path))
        return file?.exists() ?: false
    }

    private fun showOpenFoldersMenu(game: Game) {
        // TODO: Implement this using the new PathUtils
    }
}
