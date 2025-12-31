package org.citra.citra_emu.ui.game

import androidx.annotation.StringRes
import androidx.annotation.DrawableRes
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import org.citra.citra_emu.R

// Define the structure for Menu Items
sealed class EmulationMenuItem {
    data class Action(
        @StringRes val titleId: Int,
        @DrawableRes val iconId: Int,
        val action: () -> Unit
    ) : EmulationMenuItem()

    data class Toggle(
        @StringRes val titleId: Int,
        @DrawableRes val iconId: Int,
        val isChecked: Boolean,
        val onToggle: (Boolean) -> Unit
    ) : EmulationMenuItem()

    // For items that act as headers or non-interactable info could be added here
}

@Composable
fun EmulationMenu(
    items: List<EmulationMenuItem>,
    modifier: Modifier = Modifier,
    headerContent: @Composable () -> Unit = {}
) {
    Surface(
        color = MaterialTheme.colorScheme.surface,
        contentColor = MaterialTheme.colorScheme.onSurface,
        modifier = modifier.fillMaxWidth()
    ) {
        LazyColumn(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp)
        ) {
            item {
                headerContent()
                HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))
            }

            items(items) { item ->
                when (item) {
                    is EmulationMenuItem.Action -> {
                        EmulationMenuActionItem(item)
                    }

                    is EmulationMenuItem.Toggle -> {
                        EmulationMenuToggleItem(item)
                    }
                }
            }
        }
    }
}

@Composable
fun EmulationMenuActionItem(
    item: EmulationMenuItem.Action,
    modifier: Modifier = Modifier
) {
    ListItem(
        headlineContent = { Text(text = stringResource(id = item.titleId)) },
        leadingContent = {
            Icon(
                painter = painterResource(id = item.iconId),
                contentDescription = null,
                modifier = Modifier.size(24.dp)
            )
        },
        modifier = modifier.clickable { item.action() }
    )
}

@Composable
fun EmulationMenuToggleItem(
    item: EmulationMenuItem.Toggle,
    modifier: Modifier = Modifier
) {
    ListItem(
        headlineContent = { Text(text = stringResource(id = item.titleId)) },
        leadingContent = {
            Icon(
                painter = painterResource(id = item.iconId),
                contentDescription = null,
                modifier = Modifier.size(24.dp)
            )
        },
        trailingContent = {
            Switch(
                checked = item.isChecked,
                onCheckedChange = item.onToggle
            )
        },
        modifier = modifier.clickable { item.onToggle(!item.isChecked) }
    )
}
