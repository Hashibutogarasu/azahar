// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.debug

import com.airbnb.android.showkase.annotation.ShowkaseRoot
import com.airbnb.android.showkase.annotation.ShowkaseRootModule

/**
 * Root marker consumed by Showkase's KSP processor.
 *
 * Showkase discovers every `@ShowkaseComposable`/`@Preview` composable
 * reachable from the debug source set and generates the `Showkase`
 * accessor object used by [ShowkaseLauncherActivity].
 */
@ShowkaseRoot
class AzaharShowkaseRoot : ShowkaseRootModule
