package org.citra.citra_emu.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import org.citra.citra_emu.ui.components.HiddenAppsScreen
import org.citra.citra_emu.ui.main.MainActivity
import org.citra.citra_emu.ui.theme.CitraTheme
import org.citra.citra_emu.viewmodel.GamesViewModel

class HiddenAppsFragment : Fragment() {
    private val gamesViewModel: GamesViewModel by activityViewModels()
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed)
            setContent {
                CitraTheme {
                    HiddenAppsScreen(
                        viewModel = gamesViewModel,
                        onOpenDrawer = {
                            (requireActivity() as MainActivity).openDrawer()
                        }
                    )
                }
            }
        }
    }
}
