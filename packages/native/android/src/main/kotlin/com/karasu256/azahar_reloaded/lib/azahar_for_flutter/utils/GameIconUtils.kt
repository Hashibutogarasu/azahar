// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils

import android.graphics.Bitmap
import java.nio.IntBuffer

/** Decodes a game's raw embedded icon pixels into a 48x48 bitmap. */
fun gameIconBitmap(vector: IntArray?): Bitmap? {
    vector ?: return null
    val bitmap = Bitmap.createBitmap(48, 48, Bitmap.Config.RGB_565)
    bitmap.copyPixelsFromBuffer(IntBuffer.wrap(vector))
    return bitmap
}
