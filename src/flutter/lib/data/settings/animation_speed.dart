/// How fast UI transitions (nav bar, page slides, ...) animate.
enum AnimationSpeed {
  fast(120),
  normal(200),
  slow(350);

  const AnimationSpeed(this.milliseconds);

  final int milliseconds;
}

/// The animation [Duration] to use given the user's [AnimationSpeed] and whether
/// `reduceMotion` is enabled (which always collapses it to zero).
Duration resolveAnimationDuration({
  required bool reduceMotion,
  required AnimationSpeed speed,
}) {
  return reduceMotion
      ? Duration.zero
      : Duration(milliseconds: speed.milliseconds);
}
