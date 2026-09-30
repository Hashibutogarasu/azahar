// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.ui.compose

import androidx.compose.material3.LocalTextStyle
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.core.text.HtmlCompat
import org.citra.citra_emu.utils.toAnnotatedString

/**
 * Renders an HTML string resource (as produced by Transifex/`<string><![CDATA[...]]></string>`
 * entries using `<b>`/`<a href>`/etc.) as styled, clickable text. The single call site every
 * screen should use instead of `HtmlCompat.fromHtml(...).toString()`, which silently drops all
 * of that formatting.
 */
@Composable
fun HtmlText(
    html: String,
    modifier: Modifier = Modifier,
    style: TextStyle = LocalTextStyle.current,
    textAlign: TextAlign = TextAlign.Unspecified,
    htmlMode: Int = HtmlCompat.FROM_HTML_MODE_COMPACT
) {
    val linkColor = MaterialTheme.colorScheme.primary
    val annotatedString = remember(html, linkColor, htmlMode) {
        HtmlCompat.fromHtml(html, htmlMode).toAnnotatedString(linkColor)
    }
    Text(annotatedString, modifier = modifier, style = style, textAlign = textAlign)
}
