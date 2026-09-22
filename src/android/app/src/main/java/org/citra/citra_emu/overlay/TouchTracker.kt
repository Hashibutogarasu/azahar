// Copyright 2026 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.overlay

import android.graphics.PointF
import android.graphics.Rect
import android.view.MotionEvent

/**
 * Tracks which single touch pointer, if any, is currently controlling an overlay control
 * ([InputOverlayDrawableButton], [InputOverlayDrawableDpad], [InputOverlayDrawableJoystick]).
 *
 * Every control needs the same pointer bookkeeping around a [MotionEvent] stream: claim a
 * pointer that goes down inside its bounds, ignore any other pointer while one is already
 * claimed, and give it back up on that same pointer's `ACTION_UP`/`ACTION_POINTER_UP` *or* on
 * `ACTION_CANCEL` (which aborts the whole gesture stream rather than a single pointer lifting,
 * and is not scoped to any particular pointer id). Centralizing that here means each control's
 * `updateStatus()` only has to react to a claim/move/release, not reimplement pointer tracking.
 */
class TouchTracker {
    var pointerId = -1
        private set

    val isTracking: Boolean
        get() = pointerId != -1

    /**
     * Claims [event]'s active pointer if this tracker isn't already tracking one, the event is
     * an `ACTION_DOWN`/`ACTION_POINTER_DOWN`, and [withinBounds] accepts its position.
     *
     * @return true if a pointer was claimed.
     */
    fun tryClaim(event: MotionEvent, withinBounds: (x: Int, y: Int) -> Boolean): Boolean {
        val action = event.action and MotionEvent.ACTION_MASK
        val isActionDown =
            action == MotionEvent.ACTION_DOWN || action == MotionEvent.ACTION_POINTER_DOWN
        if (!isActionDown || isTracking) {
            return false
        }
        val pointerIndex = event.actionIndex
        if (!withinBounds(event.getX(pointerIndex).toInt(), event.getY(pointerIndex).toInt())) {
            return false
        }
        pointerId = event.getPointerId(pointerIndex)
        return true
    }

    /**
     * Releases the tracked pointer if [event] ends its gesture: its own pointer lifting
     * (`ACTION_UP`/`ACTION_POINTER_UP`) or the whole stream being cancelled (`ACTION_CANCEL`).
     *
     * @return true if a pointer was released.
     */
    fun consumeRelease(event: MotionEvent): Boolean {
        if (!isTracking) {
            return false
        }
        val action = event.action and MotionEvent.ACTION_MASK
        val isOwnPointerUp =
            (action == MotionEvent.ACTION_UP || action == MotionEvent.ACTION_POINTER_UP) &&
                event.getPointerId(event.actionIndex) == pointerId
        val isCancel = action == MotionEvent.ACTION_CANCEL
        if (!isOwnPointerUp && !isCancel) {
            return false
        }
        pointerId = -1
        return true
    }

    /** Index of the tracked pointer within [event], or -1 if not tracking or not present. */
    fun indexInEvent(event: MotionEvent): Int {
        if (!isTracking) {
            return -1
        }
        for (i in 0 until event.pointerCount) {
            if (event.getPointerId(i) == pointerId) {
                return i
            }
        }
        return -1
    }

    /** The tracked pointer's raw position within [event], or null if not tracking or not present. */
    fun positionInEvent(event: MotionEvent): PointF? {
        val index = indexInEvent(event)
        if (index == -1) {
            return null
        }
        return PointF(event.getX(index), event.getY(index))
    }

    /**
     * The tracked pointer's position within [event], normalized relative to [bounds]'s center
     * into a signed axis (0 at the center, ±1 at the matching edge), or null if not tracking or
     * not present. This is the "touch position -> analog axis" math shared by every control that
     * reads relative movement (the d-pad's slide, a joystick's stick).
     */
    fun normalizedAxisInEvent(event: MotionEvent, bounds: Rect): PointF? {
        val position = positionInEvent(event) ?: return null
        val centerX = bounds.centerX().toFloat()
        val centerY = bounds.centerY().toFloat()
        return PointF(
            (position.x - centerX) / (bounds.right - centerX),
            (position.y - centerY) / (bounds.bottom - centerY)
        )
    }
}
