package org.citra.citra_emu.ui.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Shortcut
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.FilledTonalIconButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.R
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.utils.GameHelper

/**
 * Bottom sheet composable for displaying game details and actions.
 *
 * @param game The game to display
 * @param isHidden Whether the game is currently hidden
 * @param onPlay Called when user clicks Play
 * @param onOpenMenu Called when user clicks Open folders menu
 * @param onUninstallMenu Called when user clicks Uninstall menu
 * @param onShortcut Called when user clicks Create Shortcut
 * @param onCheats Called when user clicks Cheats
 * @param onToggleVisibility Called when user clicks Hide/Unhide
 * @param modifier Modifier for the root container
 */
@Composable
fun GameDetailsBottomSheet(
    game: Game,
    isHidden: Boolean = false,
    onPlay: () -> Unit,
    onOpenMenu: () -> Unit,
    onUninstallMenu: () -> Unit,
    onShortcut: () -> Unit,
    onCheats: () -> Unit,
    onToggleVisibility: () -> Unit,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val scrollState = rememberScrollState()
    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(16.dp)
            .verticalScroll(scrollState)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.Top
        ) {
            // Game Icon using reusable GameIcon composable
            GameIcon(
                game = game,
                modifier = Modifier.size(140.dp),
                cornerRadius = 16.dp
            )
            Spacer(modifier = Modifier.width(16.dp))
            // Game Details
            Column(
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                Text(
                    text = game.title,
                    style = MaterialTheme.typography.titleMedium,
                    color = MaterialTheme.colorScheme.onSurface,
                    fontWeight = FontWeight.Bold,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )
                Text(
                    text = game.company,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                Text(
                    text = game.regions,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                Text(
                    text = stringResource(R.string.game_context_id) + " " + String.format(
                        "%016X",
                        game.titleId
                    ),
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Text(
                    text = stringResource(R.string.game_context_file) + " " + game.filename,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                Text(
                    text = stringResource(R.string.game_context_type) + " " + game.fileType,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                val playTimeSeconds = NativeLibrary.playTimeManagerGetPlayTime(game.titleId)
                val readablePlayTime = GameHelper.formatPlaytime(context, playTimeSeconds)
                Text(
                    text = stringResource(R.string.game_context_playtime) + " " + readablePlayTime,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        // Action Buttons Row 1
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Button(
                onClick = onPlay,
                modifier = Modifier.weight(1f),
                contentPadding = ButtonDefaults.ButtonWithIconContentPadding
            ) {
                Icon(
                    imageVector = Icons.Default.PlayArrow,
                    contentDescription = null,
                    modifier = Modifier.size(ButtonDefaults.IconSize)
                )
                Spacer(Modifier.size(ButtonDefaults.IconSpacing))
                Text(stringResource(R.string.play))
            }
            FilledTonalIconButton(onClick = onOpenMenu) {
                Icon(
                    painter = painterResource(R.drawable.ic_open),
                    contentDescription = stringResource(R.string.game_context_open_app)
                )
            }
            FilledTonalIconButton(onClick = onUninstallMenu) {
                Icon(
                    imageVector = Icons.Default.Delete,
                    contentDescription = stringResource(R.string.uninstall)
                )
            }
            FilledTonalIconButton(onClick = onShortcut) {
                Icon(
                    imageVector = Icons.Default.Shortcut,
                    contentDescription = stringResource(R.string.shortcut)
                )
            }
        }
        Spacer(modifier = Modifier.height(16.dp))
        // Action Buttons Row 2
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            FilledTonalButton(
                onClick = onCheats,
                contentPadding = ButtonDefaults.ButtonWithIconContentPadding
            ) {
                Icon(
                    painter = painterResource(R.drawable.ic_settings),
                    contentDescription = null,
                    modifier = Modifier.size(ButtonDefaults.IconSize)
                )
                Spacer(Modifier.size(ButtonDefaults.IconSpacing))
                Text(stringResource(R.string.cheats))
            }
            FilledTonalButton(
                onClick = onToggleVisibility,
                contentPadding = ButtonDefaults.ButtonWithIconContentPadding
            ) {
                Icon(
                    imageVector = if (isHidden) Icons.Default.Visibility else Icons.Default.VisibilityOff,
                    contentDescription = null,
                    modifier = Modifier.size(ButtonDefaults.IconSize)
                )
                Spacer(Modifier.size(ButtonDefaults.IconSpacing))
                Text(
                    stringResource(
                        if (isHidden) R.string.menu_unhide_app else R.string.menu_hide_app
                    )
                )
            }
        }
    }
}

// Backwards-compatible overload for existing usage
@Composable
fun GameDetailsBottomSheet(
    game: Game,
    onPlay: () -> Unit,
    onOpenMenu: () -> Unit,
    onUninstallMenu: () -> Unit,
    onShortcut: () -> Unit,
    onCheats: () -> Unit,
    onHide: () -> Unit,
    modifier: Modifier = Modifier
) {
    GameDetailsBottomSheet(
        game = game,
        isHidden = false,
        onPlay = onPlay,
        onOpenMenu = onOpenMenu,
        onUninstallMenu = onUninstallMenu,
        onShortcut = onShortcut,
        onCheats = onCheats,
        onToggleVisibility = onHide,
        modifier = modifier
    )
}
