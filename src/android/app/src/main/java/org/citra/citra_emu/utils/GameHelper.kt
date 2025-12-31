// Copyright Citra Emulator Project / Azahar Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.
package org.citra.citra_emu.utils
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import androidx.preference.PreferenceManager
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import org.citra.citra_emu.CitraApplication
import org.citra.citra_emu.NativeLibrary
import org.citra.citra_emu.R
import org.citra.citra_emu.model.CheapDocument
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.model.GameInfo
import kotlin.time.Duration.Companion.seconds
/**
 * Helper object for game discovery, caching, and metadata operations.
 */
object GameHelper {
    const val KEY_GAME_PATH = "game_path"
    const val KEY_GAMES = "games"
    private lateinit var preferences: SharedPreferences
    /**
     * Scans the configured game directory and returns all discovered games.
     * Also includes installed games from the native library.
     * Results are cached in SharedPreferences.
     */
    fun getGames(): List<Game> {
        val games = mutableListOf<Game>()
        val context = CitraApplication.appContext
        preferences = PreferenceManager.getDefaultSharedPreferences(context)
        val gamesDir = preferences.getString(KEY_GAME_PATH, "")
        val gamesUri = Uri.parse(gamesDir)
        addGamesRecursive(games, FileUtil.listFiles(gamesUri), 3)
        NativeLibrary.getInstalledGamePaths().forEach {
            games.add(getGame(Uri.parse(it), isInstalled = true, addedToLibrary = true))
        }
        // Cache list of games found on disk
        val serializedGames = mutableSetOf<String>()
        games.forEach {
            serializedGames.add(Json.encodeToString(it))
        }
        preferences.edit()
            .remove(KEY_GAMES)
            .putStringSet(KEY_GAMES, serializedGames)
            .apply()
        return games.toList()
    }
    private fun addGamesRecursive(
        games: MutableList<Game>,
        files: Array<CheapDocument>,
        depth: Int
    ) {
        if (depth <= 0) {
            return
        }
        files.forEach {
            if (it.isDirectory) {
                addGamesRecursive(games, FileUtil.listFiles(it.uri), depth - 1)
            } else {
                if (Game.allExtensions.contains(FileUtil.getExtension(it.uri))) {
                    games.add(getGame(it.uri, isInstalled = false, addedToLibrary = true))
                }
            }
        }
    }
    /**
     * Creates a Game object from a URI.
     *
     * @param uri The URI of the game file
     * @param isInstalled Whether this game is installed (vs from external storage)
     * @param addedToLibrary Whether to track the "added to library" timestamp
     */
    fun getGame(uri: Uri, isInstalled: Boolean, addedToLibrary: Boolean): Game {
        val filePath = uri.toString()
        var gameInfo: GameInfo? = GameInfo(filePath)
        if (gameInfo?.isValid() == false) {
            gameInfo = null
        }
        val isEncrypted = gameInfo?.isEncrypted() == true
        val newGame = Game(
            (gameInfo?.getTitle() ?: FileUtil.getFilename(uri)).replace("[\\t\\n\\r]+".toRegex(), " "),
            filePath.replace("\n", " "),
            filePath,
            gameInfo?.getTitleID() ?: 0,
            gameInfo?.getCompany() ?: "",
            if (isEncrypted) { CitraApplication.appContext.getString(R.string.unsupported_encrypted) } else { gameInfo?.getRegions() ?: "" },
            isInstalled,
            gameInfo?.isSystemTitle() ?: false,
            gameInfo?.getIsVisibleSystemTitle() ?: false,
            gameInfo?.getIcon(),
            gameInfo?.getFileType() ?: "",
            if (FileUtil.isNativePath(filePath)) {
                CitraApplication.documentsTree.getFilename(filePath)
            } else {
                FileUtil.getFilename(Uri.parse(filePath))
            }
        )
        if (addedToLibrary) {
            val addedTime = preferences.getLong(newGame.keyAddedToLibraryTime, 0L)
            if (addedTime == 0L) {
                preferences.edit()
                    .putLong(newGame.keyAddedToLibraryTime, System.currentTimeMillis())
                    .apply()
            }
        }
        return newGame
    }
    /**
     * Represents the various directory paths associated with a game.
     */
    data class GameDirectories(
        val gameDir: String,
        val saveDir: String,
        val modsDir: String,
        val texturesDir: String,
        val appDir: String,
        val dlcDir: String,
        val updatesDir: String,
        val extraDir: String
    )
    /**
     * Gets all relevant directory paths for a game.
     * Uses [Nintendo3DSPaths] for path construction.
     */
    fun getGameDirectories(game: Game): GameDirectories {
        return GameDirectories(
            gameDir = game.path.substringBeforeLast("/"),
            saveDir = Nintendo3DSPaths.buildSaveDir(game.titleId),
            modsDir = Nintendo3DSPaths.buildModsDir(game.titleId),
            texturesDir = Nintendo3DSPaths.buildTexturesDir(game.titleId),
            appDir = game.path.substringBeforeLast("/").split("/").filter { it.isNotEmpty() }.joinToString("/"),
            dlcDir = Nintendo3DSPaths.buildDlcDir(game.titleId),
            updatesDir = Nintendo3DSPaths.buildUpdatesDir(game.titleId),
            extraDir = Nintendo3DSPaths.buildExtraDir(game.titleId)
        )
    }
    /**
     * Formats playtime seconds into a human-readable string.
     * Uses [kotlin.time.Duration] for time calculations.
     *
     * @param context The context (currently unused, kept for API compatibility)
     * @param playTimeSeconds Total playtime in seconds
     * @return Formatted string like "2h 30m 15s" or "45m 30s" or "30s"
     */
    fun formatPlaytime(context: Context, playTimeSeconds: Long): String {
        val duration = playTimeSeconds.seconds
        return duration.toComponents { hours, minutes, seconds, _ ->
            when {
                hours > 0 -> "${hours}h ${minutes}m ${seconds}s"
                minutes > 0 -> "${minutes}m ${seconds}s"
                else -> "${seconds}s"
            }
        }
    }
}
