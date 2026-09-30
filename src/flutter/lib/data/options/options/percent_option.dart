part of '../abstract_base_option.dart';

/// A [FloatOption] whose value is a fraction of a whole, where 1.0 is 100%. The value is limited
/// to [min]..[max], which are 0.0..1.0 unless the setting allows more or less, and is shown and
/// edited as a percentage on a slider.
class PercentOption extends FloatOption {
  const PercentOption({
    required super.title,
    super.description,
    required super.icon,
    required super.value,
    super.min = 0.0,
    super.max = 1.0,
    required super.defaultValue,
  });

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => PercentOptionTile(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
