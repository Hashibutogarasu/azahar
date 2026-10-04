// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package com.karasu256.azahar_reloaded.lib.azahar_for_flutter.channel

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/**
 * Runs a method call on the storage thread and answers it on the main thread.
 *
 * The user directory is a document tree of the Storage Access Framework, and `DocumentsTree`
 * holds one lock while it queries the provider. A call that reaches it from the main thread can
 * wait for a scan of the games for seconds and make the application stop responding, so every
 * handler that touches the user directory extends this class.
 */
abstract class BackgroundMethodHandler : AzaharMethodHandler {
    /**
     * Does the work of the call on the storage thread and returns the value sent back to Dart.
     * An [IllegalArgumentException] is reported as `invalid_argument`.
     */
    protected abstract fun run(call: MethodCall): Any?

    /**
     * Sends [value] back to Dart on the main thread. Handlers that also have to touch the UI,
     * such as starting an activity, override it.
     */
    protected open fun deliver(value: Any?, result: MethodChannel.Result) {
        result.success(value)
    }

    final override fun execute(call: MethodCall, result: MethodChannel.Result) {
        storageExecutor.execute {
            val outcome = runCatching { run(call) }
            mainHandler.post {
                outcome.fold(
                    onSuccess = { deliver(it, result) },
                    onFailure = { error ->
                        val code = if (error is IllegalArgumentException) "invalid_argument" else name
                        result.error(code, error.message, null)
                    }
                )
            }
        }
    }

    companion object {
        /** Runs the calls one at a time, in the order they came from Dart. */
        private val storageExecutor: ExecutorService = Executors.newSingleThreadExecutor()
        private val mainHandler = Handler(Looper.getMainLooper())
    }
}
