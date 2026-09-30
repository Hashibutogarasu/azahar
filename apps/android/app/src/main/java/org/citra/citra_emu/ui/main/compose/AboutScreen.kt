// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import android.app.Activity
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootGraph
import com.ramcosta.composedestinations.generated.destinations.LicensesScreenDestination
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import org.citra.citra_emu.BuildConfig
import org.citra.citra_emu.R

/** Mirrors the legacy `AboutFragment`. */
@Destination<RootGraph>
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AboutScreen(
    navigator: DestinationsNavigator,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val onNavigateBack: () -> Unit = { (context as Activity).finish() }
    val onNavigateToLicenses: () -> Unit = { navigator.navigate(LicensesScreenDestination) }

    Scaffold(
        modifier = modifier,
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.about)) },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(painterResource(R.drawable.ic_back), contentDescription = null)
                    }
                }
            )
        }
    ) { contentPadding ->
        Column(
            Modifier
                .padding(contentPadding)
                .verticalScroll(rememberScrollState())
        ) {
            Image(
                painterResource(R.drawable.ic_citra_full),
                contentDescription = null,
                modifier = Modifier
                    .padding(top = 20.dp)
                    .size(104.dp)
                    .align(Alignment.CenterHorizontally)
            )
            HorizontalDivider(Modifier.padding(horizontal = 20.dp, vertical = 28.dp))

            Column(Modifier.padding(horizontal = 40.dp)) {
                Text(stringResource(R.string.about), style = MaterialTheme.typography.titleMedium)
                Text(
                    stringResource(R.string.citra_description),
                    style = MaterialTheme.typography.bodyMedium,
                    modifier = Modifier.padding(top = 6.dp)
                )
            }
            HorizontalDivider(Modifier.padding(horizontal = 20.dp, vertical = 16.dp))

            AboutRow(
                titleId = R.string.contributors,
                descriptionId = R.string.contributors_description,
                onClick = { openLink(context, context.getString(R.string.contributors_link)) }
            )
            HorizontalDivider(Modifier.padding(horizontal = 20.dp))

            AboutRow(
                titleId = R.string.licenses,
                descriptionId = R.string.licenses_description,
                onClick = onNavigateToLicenses
            )
            HorizontalDivider(Modifier.padding(horizontal = 20.dp))

            AboutRow(
                titleId = R.string.build,
                description = BuildConfig.VERSION_NAME,
                onClick = {
                    val clipBoard =
                        context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                    clipBoard.setPrimaryClip(
                        ClipData.newPlainText(context.getString(R.string.build), BuildConfig.GIT_HASH)
                    )
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                        Toast.makeText(context, R.string.copied_to_clipboard, Toast.LENGTH_SHORT).show()
                    }
                }
            )
            HorizontalDivider(Modifier.padding(horizontal = 20.dp))

            Row(
                Modifier
                    .fillMaxWidth()
                    .padding(top = 12.dp, bottom = 16.dp, start = 40.dp, end = 40.dp),
                horizontalArrangement = Arrangement.Center
            ) {
                IconButton(onClick = { openLink(context, context.getString(R.string.support_link)) }) {
                    Icon(painterResource(R.drawable.ic_discord), contentDescription = null)
                }
                IconButton(onClick = { openLink(context, context.getString(R.string.website_link)) }) {
                    Icon(painterResource(R.drawable.ic_website), contentDescription = null)
                }
                IconButton(onClick = { openLink(context, context.getString(R.string.github_link)) }) {
                    Icon(painterResource(R.drawable.ic_github), contentDescription = null)
                }
            }
        }
    }
}

@Composable
private fun AboutRow(
    titleId: Int,
    onClick: () -> Unit,
    descriptionId: Int? = null,
    description: String? = null
) {
    Column(
        Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(vertical = 16.dp, horizontal = 40.dp)
    ) {
        Text(stringResource(titleId), style = MaterialTheme.typography.titleMedium)
        Text(
            description ?: descriptionId?.let { stringResource(it) }.orEmpty(),
            style = MaterialTheme.typography.bodyMedium,
            modifier = Modifier.padding(top = 6.dp)
        )
    }
}

private fun openLink(context: Context, link: String) {
    context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(link)))
}
