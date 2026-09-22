// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.overlay

import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Rect
import android.graphics.drawable.BitmapDrawable
import android.view.HapticFeedbackConstants
import android.view.MotionEvent
import org.citra.citra_emu.NativeLibrary

/**
 * Custom [BitmapDrawable] that is capable
 * of storing it's own ID.
 *
 * @param res                [Resources] instance.
 * @param defaultStateBitmap [Bitmap] to use with the default state Drawable.
 * @param pressedStateBitmap [Bitmap] to use with the pressed state Drawable.
 * @param id                 Identifier for this type of button.
 */
class InputOverlayDrawableButton(
    res: Resources,
    defaultStateBitmap: Bitmap,
    pressedStateBitmap: Bitmap,
    val id: Int,
    val opacity: Int
) {
    private val touchTracker = TouchTracker()
    val trackId: Int
        get() = touchTracker.pointerId
    private var previousTouchX = 0
    private var previousTouchY = 0
    private var controlPositionX = 0
    private var controlPositionY = 0
    val width: Int
    val height: Int
    private val defaultStateBitmap: BitmapDrawable
    private val pressedStateBitmap: BitmapDrawable
    private var pressedState = false

    init {
        this.defaultStateBitmap = BitmapDrawable(res, defaultStateBitmap)
        this.pressedStateBitmap = BitmapDrawable(res, pressedStateBitmap)
        width = this.defaultStateBitmap.intrinsicWidth
        height = this.defaultStateBitmap.intrinsicHeight
    }

    /**
     * Updates button status based on the motion event.
     *
     * @return true if value was changed
     */
    fun updateStatus(event: MotionEvent, overlay:InputOverlay): Boolean {
        if (touchTracker.tryClaim(event, bounds::contains)) {
            pressedState = true
            overlay.hapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
            return true
        }
        if (touchTracker.consumeRelease(event)) {
            pressedState = false
            overlay.hapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY_RELEASE)
            return true
        }
        return false
    }

    fun onConfigureTouch(event: MotionEvent): Boolean {
        val pointerIndex = event.actionIndex
        val fingerPositionX = event.getX(pointerIndex).toInt()
        val fingerPositionY = event.getY(pointerIndex).toInt()
        when (event.action) {
            MotionEvent.ACTION_DOWN -> {
                previousTouchX = fingerPositionX
                previousTouchY = fingerPositionY
            }

            MotionEvent.ACTION_MOVE -> {
                controlPositionX += fingerPositionX - previousTouchX
                controlPositionY += fingerPositionY - previousTouchY
                setBounds(
                    controlPositionX,
                    controlPositionY,
                    width + controlPositionX,
                    height + controlPositionY
                )
                previousTouchX = fingerPositionX
                previousTouchY = fingerPositionY
            }
        }
        return true
    }

    fun setPosition(x: Int, y: Int) {
        controlPositionX = x
        controlPositionY = y
    }

    fun draw(canvas: Canvas) {
        val bitmapDrawable: BitmapDrawable = currentStateBitmapDrawable
        bitmapDrawable.alpha = opacity
        bitmapDrawable.draw(canvas)
    }

    private val currentStateBitmapDrawable: BitmapDrawable
        get() = if (pressedState) pressedStateBitmap else defaultStateBitmap

    fun setBounds(left: Int, top: Int, right: Int, bottom: Int) {
        defaultStateBitmap.setBounds(left, top, right, bottom)
        pressedStateBitmap.setBounds(left, top, right, bottom)
    }

    val status: Int
        get() = if (pressedState) NativeLibrary.ButtonState.PRESSED else NativeLibrary.ButtonState.RELEASED
    val bounds: Rect
        get() = defaultStateBitmap.bounds
}
