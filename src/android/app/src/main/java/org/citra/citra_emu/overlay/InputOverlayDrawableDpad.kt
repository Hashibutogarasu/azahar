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
 * @param res                             [Resources] instance.
 * @param defaultStateBitmap              [Bitmap] of the default state.
 * @param pressedOneDirectionStateBitmap  [Bitmap] of the pressed state in one direction.
 * @param pressedTwoDirectionsStateBitmap [Bitmap] of the pressed state in two direction.
 * @param upId                            Identifier for the up button.
 * @param downId                          Identifier for the down button.
 * @param leftId                          Identifier for the left button.
 * @param rightId                         Identifier for the right button.
 * @param opacity                         0-255 alpha value
 */
class InputOverlayDrawableDpad(
    res: Resources,
    defaultStateBitmap: Bitmap,
    pressedOneDirectionStateBitmap: Bitmap,
    pressedTwoDirectionsStateBitmap: Bitmap,
    val upId: Int,
    val downId: Int,
    val leftId: Int,
    val rightId: Int,
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
    private val pressedOneDirectionStateBitmap: BitmapDrawable
    private val pressedTwoDirectionsStateBitmap: BitmapDrawable
    private var upButtonState = false
    private var downButtonState = false
    private var leftButtonState = false
    private var rightButtonState = false

    init {
        this.defaultStateBitmap = BitmapDrawable(res, defaultStateBitmap)
        this.pressedOneDirectionStateBitmap = BitmapDrawable(res, pressedOneDirectionStateBitmap)
        this.pressedTwoDirectionsStateBitmap = BitmapDrawable(res, pressedTwoDirectionsStateBitmap)
        width = this.defaultStateBitmap.intrinsicWidth
        height = this.defaultStateBitmap.intrinsicHeight
    }

    /**
     * Updates the d-pad's pressed directions from a touch event.
     *
     * @return true if a direction's pressed state changed.
     */
    fun updateStatus(event: MotionEvent, dpadSlide: Boolean, overlay:InputOverlay): Boolean {
        val claimed = touchTracker.tryClaim(event, bounds::contains)
        if (touchTracker.consumeRelease(event)) {
            upButtonState = false
            downButtonState = false
            leftButtonState = false
            rightButtonState = false
            overlay.hapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY_RELEASE)
            return true
        }
        if (!dpadSlide && !claimed) {
            return false
        }
        val axis = touchTracker.normalizedAxisInEvent(event, bounds) ?: return false
        val upState = upButtonState
        val downState = downButtonState
        val leftState = leftButtonState
        val rightState = rightButtonState
        upButtonState = axis.y < -VIRT_AXIS_DEADZONE
        downButtonState = axis.y > VIRT_AXIS_DEADZONE
        leftButtonState = axis.x < -VIRT_AXIS_DEADZONE
        rightButtonState = axis.x > VIRT_AXIS_DEADZONE

        val stateChanged = upState != upButtonState || downState != downButtonState || leftState != leftButtonState || rightState != rightButtonState

        if(stateChanged)
            overlay.hapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY)
        else if(claimed)
            overlay.hapticFeedback(HapticFeedbackConstants.CLOCK_TICK)

        return stateChanged
    }

    fun draw(canvas: Canvas) {
        val px = controlPositionX + width / 2
        val py = controlPositionY + height / 2

        // Pressed up
        if (upButtonState && !leftButtonState && !rightButtonState) {
            pressedOneDirectionStateBitmap.alpha = opacity
            pressedOneDirectionStateBitmap.draw(canvas)
            return
        }

        // Pressed down
        if (downButtonState && !leftButtonState && !rightButtonState) {
            canvas.save()
            canvas.rotate(180f, px.toFloat(), py.toFloat())
            pressedOneDirectionStateBitmap.alpha = opacity
            pressedOneDirectionStateBitmap.draw(canvas)
            canvas.restore()
            return
        }

        // Pressed left
        if (leftButtonState && !upButtonState && !downButtonState) {
            canvas.save()
            canvas.rotate(270f, px.toFloat(), py.toFloat())
            pressedOneDirectionStateBitmap.alpha = opacity
            pressedOneDirectionStateBitmap.draw(canvas)
            canvas.restore()
            return
        }

        // Pressed right
        if (rightButtonState && !upButtonState && !downButtonState) {
            canvas.save()
            canvas.rotate(90f, px.toFloat(), py.toFloat())
            pressedOneDirectionStateBitmap.alpha = opacity
            pressedOneDirectionStateBitmap.draw(canvas)
            canvas.restore()
            return
        }

        // Pressed up left
        if (upButtonState && leftButtonState && !rightButtonState) {
            pressedTwoDirectionsStateBitmap.alpha = opacity
            pressedTwoDirectionsStateBitmap.draw(canvas)
            return
        }

        // Pressed up right
        if (upButtonState && !leftButtonState && rightButtonState) {
            canvas.save()
            canvas.rotate(90f, px.toFloat(), py.toFloat())
            pressedTwoDirectionsStateBitmap.alpha = opacity
            pressedTwoDirectionsStateBitmap.draw(canvas)
            canvas.restore()
            return
        }

        // Pressed down left
        if (downButtonState && leftButtonState && !rightButtonState) {
            canvas.save()
            canvas.rotate(270f, px.toFloat(), py.toFloat())
            pressedTwoDirectionsStateBitmap.alpha = opacity
            pressedTwoDirectionsStateBitmap.draw(canvas)
            canvas.restore()
            return
        }

        // Pressed down right
        if (downButtonState && !leftButtonState && rightButtonState) {
            canvas.save()
            canvas.rotate(180f, px.toFloat(), py.toFloat())
            pressedTwoDirectionsStateBitmap.alpha = opacity
            pressedTwoDirectionsStateBitmap.draw(canvas)
            canvas.restore()
            return
        }

        // Not pressed
        defaultStateBitmap.alpha = opacity
        defaultStateBitmap.draw(canvas)
    }

    val upStatus: Int
        get() = if (upButtonState) {
            NativeLibrary.ButtonState.PRESSED
        } else {
            NativeLibrary.ButtonState.RELEASED
        }
    val downStatus: Int
        get() = if (downButtonState) {
            NativeLibrary.ButtonState.PRESSED
        } else {
            NativeLibrary.ButtonState.RELEASED
        }
    val leftStatus: Int
        get() = if (leftButtonState) {
            NativeLibrary.ButtonState.PRESSED
        } else {
            NativeLibrary.ButtonState.RELEASED
        }
    val rightStatus: Int
        get() = if (rightButtonState) {
            NativeLibrary.ButtonState.PRESSED
        } else {
            NativeLibrary.ButtonState.RELEASED
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
                    controlPositionX, controlPositionY, width + controlPositionX,
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

    fun setBounds(left: Int, top: Int, right: Int, bottom: Int) {
        defaultStateBitmap.setBounds(left, top, right, bottom)
        pressedOneDirectionStateBitmap.setBounds(left, top, right, bottom)
        pressedTwoDirectionsStateBitmap.setBounds(left, top, right, bottom)
    }

    val bounds: Rect
        get() = defaultStateBitmap.bounds

    companion object {
        private const val VIRT_AXIS_DEADZONE = 0.5f
    }
}
