// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.utils

import android.os.Handler
import android.os.Looper

/**
 * Forwards log lines reported by the native logging backend to the Dart side in batches.
 * Where the log is stored is decided by Dart; lines are held until a listener is attached.
 */
object LogLineRelay {
    private const val DELIVERY_INTERVAL_MS = 50L
    private const val MAX_PENDING_LINES = 20000

    private val lock = Any()
    private val pending = ArrayList<String>()
    private val handler = Handler(Looper.getMainLooper())
    private var deliveryScheduled = false

    @Volatile
    private var listener: ((List<String>) -> Unit)? = null

    /**
     * Attaches the listener that receives batches of lines, or detaches it when null.
     */
    fun setListener(newListener: ((List<String>) -> Unit)?) {
        synchronized(lock) {
            listener = newListener
            scheduleDeliveryLocked()
        }
    }

    fun push(line: ByteArray) {
        synchronized(lock) {
            if (pending.size >= MAX_PENDING_LINES) {
                pending.removeAt(0)
            }
            pending.add(String(line, Charsets.UTF_8))
            scheduleDeliveryLocked()
        }
    }

    private fun scheduleDeliveryLocked() {
        if (deliveryScheduled || listener == null || pending.isEmpty()) {
            return
        }
        deliveryScheduled = true
        handler.postDelayed(::deliver, DELIVERY_INTERVAL_MS)
    }

    private fun deliver() {
        val (target, batch) = synchronized(lock) {
            deliveryScheduled = false
            val current = listener ?: return
            val lines: List<String> = ArrayList(pending)
            pending.clear()
            current to lines
        }
        target(batch)
    }
}
