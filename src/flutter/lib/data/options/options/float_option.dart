part of '../abstract_base_option.dart';

/// A number chosen with a slider or typed in, between [min] and [max].
class FloatOption implements AbstractBaseOption {
  const FloatOption({
    required this.title,
    this.description,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    required this.defaultValue,
  }) : assert(min <= max),
       assert(defaultValue >= min && defaultValue <= max);

  @override
  final TranslationText title;

  @override
  final TranslationText? description;

  @override
  final IconData icon;

  final OptionValue<double> value;

  final double min;

  final double max;

  final double defaultValue;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => FloatOptionTile(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
