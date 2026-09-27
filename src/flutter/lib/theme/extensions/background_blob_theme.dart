import 'package:flutter/material.dart';

/// A soft, blurred gradient circle drawn behind screen content.
class BackgroundBlob {
  const BackgroundBlob({required this.color, required this.alignment, required this.size});

  final Color color;
  final Alignment alignment;
  final double size;
}

/// Named sets of background blobs, one per screen that shows them.
enum BackgroundBlobVariant { games, options }

/// Tokens for the decorative blurred background blobs behind a screen. [glass] draws the Azahar
/// blobs; [flat] draws none, so a single [BackgroundBlobs] widget works for both styles.
class BackgroundBlobTheme extends ThemeExtension<BackgroundBlobTheme> {
  const BackgroundBlobTheme({required this.blurSigma, required this.blobsByVariant});

  final double blurSigma;
  final Map<BackgroundBlobVariant, List<BackgroundBlob>> blobsByVariant;

  factory BackgroundBlobTheme.flat(ColorScheme colorScheme) {
    return const BackgroundBlobTheme(blurSigma: 0, blobsByVariant: {});
  }

  factory BackgroundBlobTheme.glass(ColorScheme colorScheme) {
    return BackgroundBlobTheme(
      blurSigma: 100,
      blobsByVariant: {
        BackgroundBlobVariant.games: [
          BackgroundBlob(
            color: colorScheme.primaryContainer.withValues(alpha: 0.12),
            alignment: const Alignment(0, -0.8),
            size: 380,
          ),
          BackgroundBlob(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.1),
            alignment: const Alignment(-0.9, -0.2),
            size: 300,
          ),
          BackgroundBlob(
            color: colorScheme.tertiaryContainer.withValues(alpha: 0.1),
            alignment: const Alignment(0.9, 0.4),
            size: 320,
          ),
        ],
        BackgroundBlobVariant.options: [
          BackgroundBlob(
            color: colorScheme.primaryContainer.withValues(alpha: 0.1),
            alignment: const Alignment(-0.9, -0.9),
            size: 384,
          ),
          BackgroundBlob(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.08),
            alignment: const Alignment(1.0, -0.2),
            size: 448,
          ),
          BackgroundBlob(
            color: colorScheme.tertiaryContainer.withValues(alpha: 0.08),
            alignment: const Alignment(-0.9, 0.7),
            size: 320,
          ),
        ],
      },
    );
  }

  @override
  BackgroundBlobTheme copyWith({
    double? blurSigma,
    Map<BackgroundBlobVariant, List<BackgroundBlob>>? blobsByVariant,
  }) {
    return BackgroundBlobTheme(
      blurSigma: blurSigma ?? this.blurSigma,
      blobsByVariant: blobsByVariant ?? this.blobsByVariant,
    );
  }

  @override
  BackgroundBlobTheme lerp(ThemeExtension<BackgroundBlobTheme>? other, double t) {
    if (other is! BackgroundBlobTheme) return this;
    return t < 0.5 ? this : other;
  }
}
