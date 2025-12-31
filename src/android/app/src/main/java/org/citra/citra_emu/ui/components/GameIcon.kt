package org.citra.citra_emu.ui.components

import androidx.compose.foundation.Image
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import coil.ImageLoader
import coil.compose.rememberAsyncImagePainter
import coil.memory.MemoryCache
import coil.request.ImageRequest
import org.citra.citra_emu.R
import org.citra.citra_emu.model.Game
import org.citra.citra_emu.utils.GameIconFetcher
import org.citra.citra_emu.utils.GameIconKeyer

/**
 * Reusable composable for displaying game icons.
 * Uses Coil with custom fetcher for loading 3DS game icons.
 *
 * @param game The game to display the icon for
 * @param modifier Modifier for the Image composable
 * @param cornerRadius Corner radius for rounding (default 16.dp)
 * @param contentScale Content scale for the image (default Crop)
 */
@Composable
fun GameIcon(
    game: Game,
    modifier: Modifier = Modifier,
    cornerRadius: Dp = 16.dp,
    contentScale: ContentScale = ContentScale.Crop
) {
    val context = LocalContext.current
    // Create ImageLoader with Game icon support
    val imageLoader = remember {
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
    val painter = rememberAsyncImagePainter(
        model = ImageRequest.Builder(context)
            .data(game)
            .error(R.drawable.no_icon)
            .build(),
        imageLoader = imageLoader
    )
    Image(
        painter = painter,
        contentDescription = game.title,
        contentScale = contentScale,
        modifier = modifier.clip(RoundedCornerShape(cornerRadius))
    )
}
