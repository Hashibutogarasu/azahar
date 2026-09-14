// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.emulation.compose

import android.view.Surface
import android.view.SurfaceHolder
import android.view.SurfaceView
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.viewinterop.AndroidView

/**
 * Wraps a bare [SurfaceView] as a Composable and forwards its surface lifecycle to native code.
 * Used once for the 3DS top screen and once for the bottom screen, each backed by its own
 * independent native rendering surface (see NativeLibrary's primary/secondary surface pair).
 */
@Composable
private fun EmulationSurfaceView(
    modifier: Modifier = Modifier,
    onSurfaceChanged: (Surface) -> Unit,
    onSurfaceDestroyed: () -> Unit
) {
    AndroidView(
        modifier = modifier,
        factory = { context ->
            SurfaceView(context).apply {
                holder.addCallback(object : SurfaceHolder.Callback {
                    override fun surfaceCreated(holder: SurfaceHolder) {}

                    override fun surfaceChanged(
                        holder: SurfaceHolder,
                        format: Int,
                        width: Int,
                        height: Int
                    ) {
                        onSurfaceChanged(holder.surface)
                    }

                    override fun surfaceDestroyed(holder: SurfaceHolder) {
                        onSurfaceDestroyed()
                    }
                })
            }
        }
    )
}

/**
 * Arranges the 3DS top and bottom screens as two independent Composables stacked in a [Column].
 * [topFirst] decides which one is displayed first, i.e. the app-level screen swap; [topWeight]
 * and [bottomWeight] decide their relative on-screen size. Native code never makes either
 * decision: each native window always renders the same fixed screen (top or bottom) regardless
 * of where this layout places it.
 */
@Composable
fun EmulationScreensLayout(
    modifier: Modifier = Modifier,
    topFirst: Boolean = true,
    topWeight: Float = 1f,
    bottomWeight: Float = 1f,
    onTopSurfaceChanged: (Surface) -> Unit,
    onTopSurfaceDestroyed: () -> Unit,
    onBottomSurfaceChanged: (Surface) -> Unit,
    onBottomSurfaceDestroyed: () -> Unit,
    onBottomScreenBoundsChanged: (Rect) -> Unit
) {
    Column(modifier = modifier.fillMaxSize()) {
        val topScreen: @Composable ColumnScope.() -> Unit = {
            EmulationSurfaceView(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(topWeight),
                onSurfaceChanged = onTopSurfaceChanged,
                onSurfaceDestroyed = onTopSurfaceDestroyed
            )
        }
        val bottomScreen: @Composable ColumnScope.() -> Unit = {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(bottomWeight)
                    .onGloballyPositioned { coordinates ->
                        onBottomScreenBoundsChanged(coordinates.boundsInWindow())
                    }
            ) {
                EmulationSurfaceView(
                    modifier = Modifier.fillMaxSize(),
                    onSurfaceChanged = onBottomSurfaceChanged,
                    onSurfaceDestroyed = onBottomSurfaceDestroyed
                )
            }
        }
        if (topFirst) {
            topScreen()
            bottomScreen()
        } else {
            bottomScreen()
            topScreen()
        }
    }
}
