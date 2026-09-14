// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version.
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.emulation.compose

import android.view.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.geometry.Rect

/** Hosts the emulation surfaces and exposes their lifecycle to the host fragment. */
@Composable
fun EmulationWidget(
    topFirst: Boolean,
    onTopSurfaceChanged: (Surface) -> Unit,
    onTopSurfaceDestroyed: () -> Unit,
    onBottomSurfaceChanged: (Surface) -> Unit,
    onBottomSurfaceDestroyed: () -> Unit,
    onBottomScreenBoundsChanged: (Rect) -> Unit
) {
    EmulationScreensLayout(
        topFirst = topFirst,
        onTopSurfaceChanged = onTopSurfaceChanged,
        onTopSurfaceDestroyed = onTopSurfaceDestroyed,
        onBottomSurfaceChanged = onBottomSurfaceChanged,
        onBottomSurfaceDestroyed = onBottomSurfaceDestroyed,
        onBottomScreenBoundsChanged = onBottomScreenBoundsChanged
    )
}
