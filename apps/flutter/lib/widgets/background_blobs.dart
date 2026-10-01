import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings/feature_flags_provider.dart';
import '../theme/extensions/background_blob_theme.dart';

/// Paints the decorative blurred gradient blobs behind a screen. Renders nothing under the
/// Legacy theme, since its [BackgroundBlobTheme] carries no blobs.
class BackgroundBlobs extends ConsumerWidget {
  const BackgroundBlobs({super.key, required this.variant});

  final BackgroundBlobVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<BackgroundBlobTheme>()!;
    final blobs = theme.blobsByVariant[variant] ?? const [];
    if (blobs.isEmpty) return const SizedBox.shrink();
    final performanceImprovements = ref.watch(performanceImprovementsProvider);
    final stack = Stack(
      children: [
        for (final blob in blobs)
          Align(
            alignment: blob.alignment,
            child: Container(
              width: performanceImprovements ? blob.size * 1.5 : blob.size,
              height: performanceImprovements ? blob.size * 1.5 : blob.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: performanceImprovements ? null : blob.color,
                gradient: performanceImprovements
                    ? RadialGradient(
                        colors: [blob.color, blob.color.withValues(alpha: 0)],
                      )
                    : null,
              ),
            ),
          ),
      ],
    );
    return IgnorePointer(
      child: ClipRect(
        child: performanceImprovements
            ? RepaintBoundary(child: stack)
            : ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: theme.blurSigma,
                  sigmaY: theme.blurSigma,
                ),
                child: stack,
              ),
      ),
    );
  }
}
