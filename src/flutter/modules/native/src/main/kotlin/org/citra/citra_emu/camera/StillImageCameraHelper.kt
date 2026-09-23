// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.camera

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import androidx.annotation.Keep
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.NativeLibrary

object StillImageCameraHelper {
    private val filePickerLock = Object()
    private var filePickerPath: String? = null

    var launcher: (() -> Unit)? = null

    @Keep
    @JvmStatic
    fun OpenFilePicker(): String? {
        val emulationActivity = NativeLibrary.sEmulationActivity.get()
        emulationActivity!!.runOnUiThread { launcher?.invoke() }
        synchronized(filePickerLock) {
            try {
                filePickerLock.wait()
            } catch (ignored: InterruptedException) {
            }
        }
        return filePickerPath
    }

    @JvmStatic
    fun OnFilePickerResult(result: String?) {
        filePickerPath = result
        synchronized(filePickerLock) { filePickerLock.notifyAll() }
    }

    @Keep
    @JvmStatic
    fun LoadImageFromFile(uri: String?, width: Int, height: Int): Bitmap? {
        uri ?: return null
        val context = CitraApplication.appContext
        val inputStream = context.contentResolver.openInputStream(Uri.parse(uri)) ?: return null
        val source = inputStream.use { BitmapFactory.decodeStream(it) } ?: return null
        val scale = maxOf(width.toFloat() / source.width, height.toFloat() / source.height)
        val scaledWidth = (source.width * scale).toInt()
        val scaledHeight = (source.height * scale).toInt()
        val scaled = Bitmap.createScaledBitmap(source, scaledWidth, scaledHeight, true)
        val x = (scaledWidth - width) / 2
        val y = (scaledHeight - height) / 2
        return Bitmap.createBitmap(scaled, x.coerceAtLeast(0), y.coerceAtLeast(0), width, height)
    }
}
