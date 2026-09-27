import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/extensions/background_blob_theme.dart';

/// Paints the decorative blurred gradient blobs behind a screen. Renders nothing under the
/// Legacy theme, since its [BackgroundBlobTheme] carries no blobs.
class BackgroundBlobs extends StatelessWidget {
  const BackgroundBlobs({super.key, required this.variant});

  final BackgroundBlobVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BackgroundBlobTheme>()!;
    final blobs = theme.blobsByVariant[variant] ?? const [];
    if (blobs.isEmpty) return const SizedBox.shrink();
    return IgnorePointer(
      child: ClipRect(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: theme.blurSigma, sigmaY: theme.blurSigma),
          child: Stack(
            children: [
              for (final blob in blobs)
                Align(
                  alignment: blob.alignment,
                  child: Container(
                    width: blob.size,
                    height: blob.size,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: blob.color),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
