part of '../abstract_base_option.dart';

/// A [PercentOption] that changes how heavy the emulation is. Its setting reads and writes a
/// fraction of a whole, where 1.0 is 100%.
class EmulatorPercentOption extends AbstractEmulatorOption<double> {
  EmulatorPercentOption({
    required super.title,
    super.description,
    required super.icon,
    required super.setting,
    this.min = 0.0,
    this.max = 1.0,
    required this.defaultValue,
    this.preview,
  });

  final double min;

  final double max;

  final double defaultValue;

  final Future<void> Function(WidgetRef ref, double value)? preview;

  @override
  double read(WidgetRef ref) => setting.read(ref);

  @override
  Future<void> apply(BuildContext context, WidgetRef ref, double value) =>
      setting.apply(context, ref, value);

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => PercentOptionWidget(
    option: PercentOption(
      title: title,
      description: description,
      icon: icon,
      value: setting,
      min: min,
      max: max,
      defaultValue: defaultValue,
      preview: preview,
    ),
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
