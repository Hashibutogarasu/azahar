// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.lifecycle.viewmodel.compose.viewModel
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import org.citra.citra_emu.features.cheats.model.CheatsViewModel
import org.citra.citra_emu.features.cheats.ui.compose.CheatsScreen

/**
 * Navigation destination wrapper around [CheatsScreen] for MainActivity's Compose graph.
 *
 * [CheatsScreen] itself stays plain-parameterized (a [CheatsViewModel] plus callbacks) since
 * `CheatsActivity` also renders it directly, outside of any navigation graph. This route owns a
 * back-stack-entry-scoped [CheatsViewModel] and initializes it from the navigation argument.
 */
@Destination<RootGraph>
@Composable
fun CheatsRoute(titleId: Long, navigator: DestinationsNavigator) {
    val cheatsViewModel: CheatsViewModel = viewModel()
    LaunchedEffect(titleId) { cheatsViewModel.initialize(titleId) }
    CheatsScreen(
        cheatsViewModel = cheatsViewModel,
        onNavigateBack = { navigator.navigateUp() }
    )
}
