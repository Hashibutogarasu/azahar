// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.emulation.compose

import android.view.Surface
import android.view.SurfaceHolder
import android.view.SurfaceView
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.wrapContentWidth
import androidx.compose.runtime.Composable
import androidx.compose.runtime.key
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.viewinterop.AndroidView

/** The 3DS top screen is 400x240 pixels; the bottom screen is 320x240. */
private const val TOP_SCREEN_WIDTH = 400f
private const val TOP_SCREEN_HEIGHT = 240f
private const val BOTTOM_SCREEN_WIDTH = 320f
private const val BOTTOM_SCREEN_HEIGHT = 240f

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
 * Arranges the 3DS top and bottom screens as two independent Composables stacked in a [Column],
 * both scaled by the same zoom factor (matching the classic 3DS layout: the top screen fills the
 * shared width; the bottom screen, being narrower at 320 native pixels vs the top's 400, ends up
 * narrower on screen too, and is centered below it) rather than each independently stretched to
 * fill the same width, which would distort the bottom screen's proportions. [topFirst] decides
 * which one is displayed first, i.e. the app-level screen swap. Native code never makes this
 * decision: each native window always renders the same fixed screen (top or bottom) regardless
 * of where this layout places it.
 *
 * The shared zoom factor is chosen so the stacked pair fits within the available space without
 * cropping, picking whichever of a width-driven or a height-driven fit is smaller;
 * [BoxWithConstraints] measures the available space to compute it.
 *
 * Each screen is wrapped in [key] with a stable identity ("top"/"bottom") so that swapping their
 * order only reorders them; without it, Compose's positional slot table would treat the reordered
 * calls as different content and tear down/recreate both underlying SurfaceViews (and their
 * native surfaces) on every swap.
 */
@Composable
fun EmulationScreensLayout(
    modifier: Modifier = Modifier,
    topFirst: Boolean = true,
    onTopSurfaceChanged: (Surface) -> Unit,
    onTopSurfaceDestroyed: () -> Unit,
    onBottomSurfaceChanged: (Surface) -> Unit,
    onBottomSurfaceDestroyed: () -> Unit,
    onBottomScreenBoundsChanged: (Rect) -> Unit
) {
    BoxWithConstraints(
        modifier = modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        val combinedWidth = maxOf(TOP_SCREEN_WIDTH, BOTTOM_SCREEN_WIDTH)
        val combinedHeight = TOP_SCREEN_HEIGHT + BOTTOM_SCREEN_HEIGHT
        val zoomFittingWidth = maxWidth / combinedWidth
        val zoomFittingHeight = maxHeight / combinedHeight
        val zoom = minOf(zoomFittingWidth, zoomFittingHeight)

        val topScreenWidth = TOP_SCREEN_WIDTH * zoom
        val topScreenHeight = TOP_SCREEN_HEIGHT * zoom
        val bottomScreenWidth = BOTTOM_SCREEN_WIDTH * zoom
        val bottomScreenHeight = BOTTOM_SCREEN_HEIGHT * zoom

        Column(
            modifier = Modifier.wrapContentWidth(),
            verticalArrangement = Arrangement.Top,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            val topScreen: @Composable ColumnScope.() -> Unit = {
                EmulationSurfaceView(
                    modifier = Modifier.width(topScreenWidth).height(topScreenHeight),
                    onSurfaceChanged = onTopSurfaceChanged,
                    onSurfaceDestroyed = onTopSurfaceDestroyed
                )
            }
            val bottomScreen: @Composable ColumnScope.() -> Unit = {
                Box(
                    modifier = Modifier
                        .width(bottomScreenWidth)
                        .height(bottomScreenHeight)
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
                key("top") { topScreen() }
                key("bottom") { bottomScreen() }
            } else {
                key("bottom") { bottomScreen() }
                key("top") { topScreen() }
            }
        }
    }
}
