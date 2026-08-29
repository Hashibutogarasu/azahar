// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.features.cheats.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.ui.platform.ComposeView
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.navigation.findNavController
import androidx.navigation.fragment.navArgs
import com.google.android.material.transition.MaterialSharedAxis
import org.citra.citra_emu.features.cheats.ui.compose.CheatsScreen
import org.citra.citra_emu.features.cheats.model.CheatsViewModel
import org.citra.citra_emu.ui.compose.theme.AzaharTheme
import org.citra.citra_emu.viewmodel.HomeViewModel

/**
 * Hosts [CheatsScreen] for the `cheatsFragment` destination in
 * `home_navigation.xml`. This thin wrapper only exists because MainActivity's
 * own navigation graph has not been migrated to Compose yet; once it has,
 * this Fragment can be removed and its destination replaced with a
 * `composable()` route calling [CheatsScreen] directly.
 */
class CheatsFragment : Fragment() {
    private val cheatsViewModel: CheatsViewModel by activityViewModels()
    private val homeViewModel: HomeViewModel by activityViewModels()

    private val args by navArgs<CheatsFragmentArgs>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enterTransition = MaterialSharedAxis(MaterialSharedAxis.X, true)
        returnTransition = MaterialSharedAxis(MaterialSharedAxis.X, false)
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        homeViewModel.setNavigationVisibility(visible = false, animated = true)
        homeViewModel.setStatusBarShadeVisibility(visible = false)

        cheatsViewModel.initialize(args.titleId)

        return ComposeView(requireContext()).apply {
            setContent {
                AzaharTheme {
                    CheatsScreen(
                        cheatsViewModel = cheatsViewModel,
                        onNavigateBack = { findNavController().popBackStack() }
                    )
                }
            }
        }
    }

    override fun onStop() {
        super.onStop()
        cheatsViewModel.saveIfNeeded()
    }
}
