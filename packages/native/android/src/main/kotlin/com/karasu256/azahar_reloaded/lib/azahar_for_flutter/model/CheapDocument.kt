// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.model

import android.net.Uri
import android.provider.DocumentsContract

/**
 * A struct that is much more "cheaper" than DocumentFile.
 * Only contains the information we needed.
 */
class CheapDocument(val filename: String, val mimeType: String, val uri: Uri) {
    val isDirectory: Boolean
        get() = mimeType == DocumentsContract.Document.MIME_TYPE_DIR
}
