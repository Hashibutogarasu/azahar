package org.citra.citra_emu.utils

import androidx.documentfile.provider.DocumentFile
import org.citra.citra_emu.CitraApplication
import org.ini4j.Wini
import java.io.BufferedReader
import java.io.InputStreamReader

object EmulatorSettingsFile {
    private fun configFile(): DocumentFile? {
        val root = DocumentFile.fromTreeUri(
            CitraApplication.appContext,
            PermissionsHandler.citraDirectory
        ) ?: return null
        return root.findFile("config")?.findFile("config.ini")
    }

    fun read(): Map<String, Map<String, String>> {
        val file = configFile() ?: return emptyMap()
        val sections = LinkedHashMap<String, LinkedHashMap<String, String>>()
        val inputStream = CitraApplication.appContext.contentResolver.openInputStream(file.uri)
            ?: return emptyMap()
        var currentSection: LinkedHashMap<String, String>? = null
        BufferedReader(InputStreamReader(inputStream)).useLines { lines ->
            for (rawLine in lines) {
                val line = rawLine.trim()
                if (line.startsWith("[") && line.endsWith("]")) {
                    currentSection = sections.getOrPut(line.substring(1, line.length - 1)) {
                        LinkedHashMap()
                    }
                    continue
                }
                val separator = line.indexOf('=')
                if (separator <= 0 || currentSection == null) continue
                val key = line.substring(0, separator).trim()
                val value = line.substring(separator + 1).trim()
                if (value.isNotEmpty()) {
                    currentSection!![key] = value
                }
            }
        }
        return sections
    }

    fun write(section: String, key: String, value: String) {
        val file = configFile() ?: return
        val contentResolver = CitraApplication.appContext.contentResolver
        val inputStream = contentResolver.openInputStream(file.uri)
        val writer = Wini(inputStream)
        inputStream?.close()
        writer.put(section, key, value)
        val outputStream = contentResolver.openOutputStream(file.uri, "wt")
        writer.store(outputStream)
        outputStream?.flush()
        outputStream?.close()
    }
}
