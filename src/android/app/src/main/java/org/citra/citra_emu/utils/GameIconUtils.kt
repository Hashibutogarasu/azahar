// Copyright 2023 Citra Emulator Project
// Licensed under GPLv2 or any later version
// Refer to the license.txt file included.

package org.citra.citra_emu.utils

import android.graphics.Bitmap
import android.widget.ImageView
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.platform.LocalContext
import androidx.core.graphics.drawable.toDrawable
import androidx.fragment.app.FragmentActivity
import coil.ImageLoader
import coil.decode.DataSource
import coil.fetch.DrawableResult
import coil.fetch.FetchResult
import coil.fetch.Fetcher
import coil.key.Keyer
import coil.memory.MemoryCache
import coil.request.ImageRequest
import coil.request.Options
import coil.transform.RoundedCornersTransformation
import org.citra.citra_emu.R
import org.citra.citra_emu.model.Game
import java.nio.IntBuffer

/** Decodes a [Game]'s raw embedded icon pixels into a 48x48 bitmap. */
fun gameIconBitmap(vector: IntArray?): Bitmap? {
    vector ?: return null
    val bitmap = Bitmap.createBitmap(48, 48, Bitmap.Config.RGB_565)
    bitmap.copyPixelsFromBuffer(IntBuffer.wrap(vector))
    return bitmap
}

class GameIconFetcher(
    private val game: Game,
    private val options: Options
) : Fetcher {
    override suspend fun fetch(): FetchResult {
        return DrawableResult(
            drawable = gameIconBitmap(game.icon)!!.toDrawable(options.context.resources),
            isSampled = false,
            dataSource = DataSource.DISK
        )
    }

    class Factory : Fetcher.Factory<Game> {
        override fun create(data: Game, options: Options, imageLoader: ImageLoader): Fetcher =
            GameIconFetcher(data, options)
    }
}

class GameIconKeyer : Keyer<Game> {
    override fun key(data: Game, options: Options): String = data.path
}

object GameIconUtils {
    fun loadGameIcon(activity: FragmentActivity, game: Game, imageView: ImageView) {
        val imageLoader = ImageLoader.Builder(activity)
            .components {
                add(GameIconKeyer())
                add(GameIconFetcher.Factory())
            }
            .memoryCache {
                MemoryCache.Builder(activity)
                    .maxSizePercent(0.25)
                    .build()
            }
            .build()

        val request = ImageRequest.Builder(activity)
            .data(game)
            .target(imageView)
            .error(R.drawable.no_icon)
            .transformations(
                RoundedCornersTransformation(
                    activity.resources.getDimensionPixelSize(R.dimen.spacing_med).toFloat()
                )
            )
            .build()
        imageLoader.enqueue(request)
    }

    /** Compose equivalent of the [ImageLoader] built by [loadGameIcon], shared across a screen. */
    @Composable
    fun rememberGameIconLoader(): ImageLoader {
        val context = LocalContext.current
        return remember {
            ImageLoader.Builder(context)
                .components {
                    add(GameIconKeyer())
                    add(GameIconFetcher.Factory())
                }
                .memoryCache {
                    MemoryCache.Builder(context)
                        .maxSizePercent(0.25)
                        .build()
                }
                .build()
        }
    }

    /** Compose equivalent of the [ImageRequest] built by [loadGameIcon], for a single game. */
    @Composable
    fun rememberGameIconRequest(game: Game): ImageRequest {
        val context = LocalContext.current
        return remember(game.path) {
            ImageRequest.Builder(context)
                .data(game)
                .error(R.drawable.no_icon)
                .transformations(
                    RoundedCornersTransformation(
                        context.resources.getDimensionPixelSize(R.dimen.spacing_med).toFloat()
                    )
                )
                .build()
        }
    }

    /** For contexts (e.g. building a launcher shortcut) that need the raw bitmap directly. */
    fun loadGameIconBitmapBlocking(game: Game): Bitmap? = gameIconBitmap(game.icon)
}
