package org.citra.citra_emu.ui.game

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import org.citra.citra_emu.R

@Composable
fun AmiiboBottomSheet(
    onLoadAmiibo: () -> Unit,
    onRemoveAmiibo: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = stringResource(R.string.menu_emulation_amiibo),
            style = MaterialTheme.typography.titleLarge
        )

        Button(
            onClick = onLoadAmiibo,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(text = stringResource(R.string.menu_emulation_amiibo_load))
        }

        OutlinedButton(
            onClick = onRemoveAmiibo,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(text = stringResource(R.string.menu_emulation_amiibo_remove))
        }
    }
}
