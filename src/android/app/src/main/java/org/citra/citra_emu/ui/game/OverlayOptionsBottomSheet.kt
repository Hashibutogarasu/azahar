package org.citra.citra_emu.ui.game

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import org.citra.citra_emu.R

@Composable
fun OverlayOptionsBottomSheet(
    isOverlayEnabled: Boolean,
    onOverlayEnabledChange: (Boolean) -> Unit,
    isHapticFeedbackEnabled: Boolean,
    onHapticFeedbackChange: (Boolean) -> Unit, // Assuming haptics are handled elsewhere or here
    opacity: Float, // 0 to 100
    onOpacityChange: (Float) -> Unit,
    scale: Float, // 0 to 100 or similar scale
    onScaleChange: (Float) -> Unit,
    onEditLayout: () -> Unit,
    onResetOverlay: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        Text(
            text = stringResource(R.string.emulation_overlay_options),
            style = MaterialTheme.typography.titleLarge
        )

        // Show Overlay Toggle
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(text = stringResource(R.string.emulation_show_controller_overlay))
            Switch(checked = isOverlayEnabled, onCheckedChange = onOverlayEnabledChange)
        }

        // Haptic Feedback Toggle (If available in UI requirements, adding as placeholder if not specified but standard)
        // Leaving out if not explicitly requested, but usually relevant. Check strings.

        HorizontalDivider()

        // Opacity Slider
        Text(text = stringResource(R.string.emulation_control_opacity, opacity.toInt()))
        Slider(
            value = opacity,
            onValueChange = onOpacityChange,
            valueRange = 0f..100f,
            steps = 100
        )

        // Scale Slider
        Text(text = stringResource(R.string.emulation_control_scale, scale.toInt()))
        Slider(
            value = scale,
            onValueChange = onScaleChange,
            valueRange = 0f..150f, // Assuming scale range
            steps = 150
        )

        HorizontalDivider()

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Button(
                onClick = onEditLayout,
                modifier = Modifier.weight(1f)
            ) {
                Text(text = stringResource(R.string.emulation_edit_layout))
            }

            OutlinedButton(
                onClick = onResetOverlay,
                modifier = Modifier.weight(1f)
            ) {
                Icon(Icons.Default.Refresh, contentDescription = null)
                Spacer(Modifier.width(8.dp))
                Text(text = stringResource(R.string.emulation_touch_overlay_reset))
            }
        }
    }
}
