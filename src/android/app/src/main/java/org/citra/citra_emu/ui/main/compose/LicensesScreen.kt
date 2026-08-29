// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.main.compose

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import org.citra.citra_emu.R
import org.citra.citra_emu.model.License
import org.citra.citra_emu.viewmodel.HomeViewModel

private val LICENSES = listOf(
    License(
        R.string.license_adreno_tools,
        R.string.license_adreno_tools_description,
        R.string.license_adreno_tools_link,
        R.string.license_adreno_tools_copyright,
        R.string.license_adreno_tools_text
    ),
    License(
        R.string.license_cubeb,
        R.string.license_cubeb_description,
        R.string.license_cubeb_link,
        R.string.license_cubeb_copyright,
        R.string.license_cubeb_text
    ),
    License(
        R.string.license_dynarmic,
        R.string.license_dynarmic_description,
        R.string.license_dynarmic_link,
        R.string.license_dynarmic_copyright,
        R.string.license_dynarmic_text
    ),
    License(
        R.string.license_sirit,
        R.string.license_sirit_description,
        R.string.license_sirit_link,
        R.string.license_sirit_copyright,
        R.string.license_sirit_text
    ),
    License(
        R.string.license_cryptopp,
        R.string.license_cryptopp_description,
        R.string.license_cryptopp_link,
        R.string.license_cryptopp_copyright,
        R.string.license_cryptopp_text
    ),
    License(
        titleId = R.string.license_boost,
        descriptionId = R.string.license_boost_description,
        linkId = R.string.license_boost_link,
        licenseId = R.string.license_boost_text
    ),
    License(
        R.string.license_nihstro,
        R.string.license_nihstro_description,
        R.string.license_nihstro_link,
        R.string.license_nihstro_copyright,
        R.string.license_nihstro_text
    ),
    License(
        R.string.license_httplib,
        R.string.license_httplib_description,
        R.string.license_httplib_link,
        R.string.license_httplib_copyright,
        R.string.license_mit
    ),
    License(
        R.string.license_teakra,
        R.string.license_teakra_description,
        R.string.license_teakra_link,
        R.string.license_teakra_copyright,
        R.string.license_mit
    ),
    License(
        R.string.license_enet,
        R.string.license_enet_description,
        R.string.license_enet_link,
        R.string.license_enet_copyright,
        R.string.license_mit
    ),
    License(
        R.string.license_glad,
        R.string.license_glad_description,
        R.string.license_glad_link,
        R.string.license_glad_copyright,
        R.string.license_mit
    ),
    License(
        titleId = R.string.license_glslang,
        descriptionId = R.string.license_glslang_description,
        linkId = R.string.license_glslang_link,
        licenseLinkId = R.string.license_glslang_link_license
    ),
    License(
        R.string.license_openal,
        R.string.license_openal_description,
        R.string.license_openal_link,
        R.string.license_openal_copyright,
        R.string.license_openal_text
    ),
    License(
        R.string.license_sdl,
        R.string.license_sdl_description,
        R.string.license_sdl_link,
        R.string.license_sdl_copyright,
        R.string.license_sdl_text
    ),
    License(
        R.string.license_vma,
        R.string.license_vma_description,
        R.string.license_vma_link,
        R.string.license_vma_copyright,
        R.string.license_mit
    ),
    License(
        R.string.license_zstd,
        R.string.license_zstd_description,
        R.string.license_zstd_link,
        R.string.license_zstd_copyright,
        R.string.license_zstd_text
    )
)

/** Mirrors the legacy `LicensesFragment` + `LicenseAdapter`. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LicensesScreen(
    homeViewModel: HomeViewModel,
    onNavigateBack: () -> Unit,
    modifier: Modifier = Modifier
) {
    LaunchedEffect(Unit) {
        homeViewModel.setNavigationVisibility(visible = false, animated = true)
        homeViewModel.setStatusBarShadeVisibility(visible = false)
    }

    var selectedLicense by remember { mutableStateOf<License?>(null) }

    Scaffold(
        modifier = modifier,
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.licenses)) },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(painterResource(R.drawable.ic_back), contentDescription = null)
                    }
                }
            )
        }
    ) { contentPadding ->
        LazyColumn(
            Modifier
                .padding(contentPadding)
                .fillMaxSize()
        ) {
            items(LICENSES) { license ->
                Column(
                    Modifier
                        .fillMaxWidth()
                        .clickable { selectedLicense = license }
                        .padding(16.dp)
                ) {
                    Text(stringResource(license.titleId), style = MaterialTheme.typography.headlineMedium)
                    Text(
                        stringResource(license.descriptionId),
                        style = MaterialTheme.typography.bodySmall,
                        modifier = Modifier.padding(top = 4.dp)
                    )
                }
                HorizontalDivider()
            }
        }
    }

    selectedLicense?.let { license ->
        LicenseBottomSheet(license = license, onDismiss = { selectedLicense = null })
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun LicenseBottomSheet(license: License, onDismiss: () -> Unit) {
    ModalBottomSheet(onDismissRequest = onDismiss, sheetState = rememberModalBottomSheetState()) {
        Column(
            Modifier
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp)
        ) {
            Text(
                stringResource(license.titleId),
                style = MaterialTheme.typography.headlineLarge,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.fillMaxWidth(),
                textAlign = TextAlign.Center
            )
            Text(
                stringResource(license.linkId),
                style = MaterialTheme.typography.bodyLarge,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp),
                textAlign = TextAlign.Center
            )
            if (license.copyrightId != 0) {
                Text(
                    stringResource(license.copyrightId),
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 16.dp),
                    textAlign = TextAlign.Center
                )
            }
            val licenseTextId = if (license.licenseId != 0) license.licenseId else license.licenseLinkId
            Text(
                stringResource(licenseTextId),
                style = MaterialTheme.typography.bodyMedium,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 16.dp)
            )
        }
    }
}
