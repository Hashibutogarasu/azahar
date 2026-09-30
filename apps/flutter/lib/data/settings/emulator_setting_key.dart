class IntKey {
  const IntKey(this.section, this.key, this.defaultValue);

  final String section;
  final String key;
  final int defaultValue;
}

class BoolKey {
  const BoolKey(this.section, this.key, this.defaultValue);

  final String section;
  final String key;
  final bool defaultValue;
}

/// An [IntKey] whose ini value of `0`/`1` is presented as a boolean switch, mirroring the
/// original app's `AbstractIntSetting`-backed switches (e.g. `USE_FRAME_LIMIT`).
class IntBoolKey extends IntKey {
  const IntBoolKey(String section, String key, bool defaultValue)
    : super(section, key, defaultValue ? 1 : 0);
}

class FloatKey {
  const FloatKey(this.section, this.key, this.defaultValue);

  final String section;
  final String key;
  final double defaultValue;
}

/// A [FloatKey] whose ini value is stored divided by [scale] (e.g. volume stored as `0.0`-`1.0`
/// but presented as a `0`-`100` percentage), mirroring the original app's `ScaledFloatSetting`.
class ScaledFloatKey extends FloatKey {
  const ScaledFloatKey(
    super.section,
    super.key,
    super.defaultValue,
    this.scale,
  );

  final int scale;
}

class StringKey {
  const StringKey(this.section, this.key, this.defaultValue);

  final String section;
  final String key;
  final String defaultValue;
}
