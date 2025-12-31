// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.
package org.citra.citra_emu.utils
/**
 * Nintendo 3DS file system path constants.
 *
 * These represent the standard directory structure used by 3DS for
 * save data, installed titles, DLC, updates, and extra data.
 */
object Nintendo3DSPaths {
    // Root directories
    const val SDMC = "sdmc"
    const val NINTENDO_3DS = "Nintendo 3DS"
    // Zero-filled ID used for emulated console
    const val ZEROS_ID = "00000000000000000000000000000000"
    // Title type high IDs
    const val TITLE_ID_DLC = "0004008c"
    const val TITLE_ID_UPDATES = "0004000e"
    // Directory names
    const val DIR_TITLE = "title"
    const val DIR_DATA = "data"
    const val DIR_CONTENT = "content"
    const val DIR_LOAD = "load"
    const val DIR_MODS = "mods"
    const val DIR_TEXTURES = "textures"
    const val DIR_EXTDATA = "extdata"
    // Data identifiers
    const val SAVE_DATA_ID = "00000001"
    const val EXTRA_DATA_ID = "00000000"
    /**
     * Base path for 3DS user data under SDMC.
     * Format: sdmc/Nintendo 3DS/{console_id}/{sdmc_id}
     * For emulation, both IDs are zeros.
     */
    val baseSdmcPath: String
        get() = "$SDMC/$NINTENDO_3DS/$ZEROS_ID/$ZEROS_ID"
    /**
     * Builds the save data directory path for a given title.
     *
     * @param titleId The 64-bit title ID
     * @return Path in format: {baseSdmcPath}/title/{highId}/{lowId}/data/00000001
     */
    fun buildSaveDir(titleId: Long): String {
        val titleIdHex = String.format("%016x", titleId).lowercase()
        val highId = titleIdHex.substring(0, 8)
        val lowId = titleIdHex.substring(8)
        return "$baseSdmcPath/$DIR_TITLE/$highId/$lowId/$DIR_DATA/$SAVE_DATA_ID"
    }
    /**
     * Builds the mods directory path for a given title.
     *
     * @param titleId The 64-bit title ID
     * @return Path in format: load/mods/{TITLEID}
     */
    fun buildModsDir(titleId: Long): String {
        val titleIdHex = String.format("%016X", titleId)
        return "$DIR_LOAD/$DIR_MODS/$titleIdHex"
    }
    /**
     * Builds the textures directory path for a given title.
     *
     * @param titleId The 64-bit title ID
     * @return Path in format: load/textures/{TITLEID}
     */
    fun buildTexturesDir(titleId: Long): String {
        val titleIdHex = String.format("%016X", titleId)
        return "$DIR_LOAD/$DIR_TEXTURES/$titleIdHex"
    }
    /**
     * Builds the DLC directory path for a given title.
     *
     * @param titleId The 64-bit title ID
     * @return Path in format: {baseSdmcPath}/title/0004008c/{lowId}/content
     */
    fun buildDlcDir(titleId: Long): String {
        val titleIdHex = String.format("%016x", titleId).lowercase()
        val lowId = titleIdHex.substring(8)
        return "$baseSdmcPath/$DIR_TITLE/$TITLE_ID_DLC/$lowId/$DIR_CONTENT"
    }
    /**
     * Builds the updates directory path for a given title.
     *
     * @param titleId The 64-bit title ID
     * @return Path in format: {baseSdmcPath}/title/0004000e/{lowId}/content
     */
    fun buildUpdatesDir(titleId: Long): String {
        val titleIdHex = String.format("%016x", titleId).lowercase()
        val lowId = titleIdHex.substring(8)
        return "$baseSdmcPath/$DIR_TITLE/$TITLE_ID_UPDATES/$lowId/$DIR_CONTENT"
    }
    /**
     * Builds the extra data directory path for a given title.
     *
     * @param titleId The 64-bit title ID
     * @return Path in format: {baseSdmcPath}/extdata/00000000/{extdataId}
     */
    fun buildExtraDir(titleId: Long): String {
        val titleIdHex = String.format("%016X", titleId)
        // Extract middle portion and pad for extdata ID
        val extdataId = titleIdHex.substring(8, 14).padStart(8, '0')
        return "$baseSdmcPath/$DIR_EXTDATA/$EXTRA_DATA_ID/$extdataId"
    }
}
