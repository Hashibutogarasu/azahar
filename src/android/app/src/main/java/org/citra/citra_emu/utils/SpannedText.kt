// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.utils

import android.graphics.Typeface
import android.text.Spanned
import android.text.style.StyleSpan
import android.text.style.URLSpan
import android.text.style.UnderlineSpan
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.LinkAnnotation
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextLinkStyles
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration

/**
 * Converts an `HtmlCompat.fromHtml()` result to an [AnnotatedString], preserving bold/italic
 * emphasis and clickable links instead of the plain, unstyled text a bare `.toString()` yields.
 */
fun Spanned.toAnnotatedString(linkColor: Color): AnnotatedString = buildAnnotatedString {
    append(this@toAnnotatedString.toString())
    for (span in getSpans(0, length, Any::class.java)) {
        val start = getSpanStart(span)
        val end = getSpanEnd(span)
        if (start < 0 || end <= start) {
            continue
        }
        when (span) {
            is URLSpan -> addLink(
                LinkAnnotation.Url(
                    span.url,
                    TextLinkStyles(SpanStyle(color = linkColor, textDecoration = TextDecoration.Underline))
                ),
                start,
                end
            )
            is StyleSpan -> addStyle(
                SpanStyle(
                    fontWeight = if (span.style == Typeface.BOLD || span.style == Typeface.BOLD_ITALIC) {
                        FontWeight.Bold
                    } else {
                        null
                    },
                    fontStyle = if (span.style == Typeface.ITALIC || span.style == Typeface.BOLD_ITALIC) {
                        FontStyle.Italic
                    } else {
                        null
                    }
                ),
                start,
                end
            )
            is UnderlineSpan -> addStyle(SpanStyle(textDecoration = TextDecoration.Underline), start, end)
        }
    }
}
