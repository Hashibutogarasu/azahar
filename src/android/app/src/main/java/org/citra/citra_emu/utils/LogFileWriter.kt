// Copyright Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.utils

import android.net.Uri
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.utils.FileUtil.outputStream
import java.io.OutputStream

/**
 * Single owner of the emulator log file location and rotation inside the user directory.
 * The native logging backend only reports lines, so this is the only place that knows
 * where the log is stored.
 */
object LogFileWriter {
    private const val LOG_DIRECTORY = "log"
    private const val LOG_FILE = "azahar_log.txt"
    private const val OLD_LOG_FILE = "azahar_log.old.txt"
    private const val WRITE_LIMIT_BYTES = 100L * 1024 * 1024

    private const val CURRENT_LOG_PATH = "$LOG_DIRECTORY/$LOG_FILE"
    private const val OLD_LOG_PATH = "$LOG_DIRECTORY/$OLD_LOG_FILE"

    private val documentsTree get() = CitraApplication.documentsTree

    private var output: OutputStream? = null
    private var openedUserDirectory: String? = null
    private var bytesWritten = 0L

    /**
     * Rotates the previous log and opens a fresh one inside [userDirectory]. Calling it again
     * for the directory that is already open keeps the current log.
     */
    @Synchronized
    fun open(userDirectory: String) {
        if (output != null && openedUserDirectory == userDirectory) {
            return
        }
        close()

        documentsTree.createDir("", LOG_DIRECTORY)
        if (documentsTree.exists(CURRENT_LOG_PATH)) {
            documentsTree.deleteDocument(OLD_LOG_PATH)
            documentsTree.renameFile(CURRENT_LOG_PATH, OLD_LOG_FILE)
        }
        documentsTree.createFile(LOG_DIRECTORY, LOG_FILE)

        output = documentsTree.getUri(CURRENT_LOG_PATH).takeIf { it != Uri.EMPTY }?.outputStream()
        openedUserDirectory = userDirectory
        bytesWritten = 0
    }

    @Synchronized
    fun write(line: ByteArray) {
        val stream = output ?: return
        if (bytesWritten > WRITE_LIMIT_BYTES) {
            return
        }
        stream.write(line)
        stream.write('\n'.code)
        bytesWritten += line.size + 1
    }

    @Synchronized
    fun flush() {
        output?.flush()
    }

    /**
     * Returns the log that should be shared: the previous run's log while no game has been
     * launched yet, otherwise the current one.
     */
    fun findShareableLog(gameLaunched: Boolean): Uri? {
        val current = documentsTree.getUri(CURRENT_LOG_PATH).takeIf { documentsTree.exists(CURRENT_LOG_PATH) }
        val old = documentsTree.getUri(OLD_LOG_PATH).takeIf { documentsTree.exists(OLD_LOG_PATH) }
        return if (!gameLaunched && old != null) old else current
    }

    private fun close() {
        FileUtil.closeQuietly(output)
        output = null
        openedUserDirectory = null
    }
}
