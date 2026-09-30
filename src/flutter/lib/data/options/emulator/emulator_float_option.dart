part of '../abstract_base_option.dart';

/// A [FloatOption] that changes how heavy the emulation is.
class EmulatorFloatOption extends AbstractEmulatorOption<double> {
  EmulatorFloatOption({
    required super.title,
    super.description,
    required super.icon,
    required super.setting,
    required this.min,
    required this.max,
    required this.defaultValue,
  });

  final double min;

  final double max;

  final double defaultValue;

  @override
  double read(WidgetRef ref) => setting.read(ref);

  @override
  Future<void> apply(BuildContext context, WidgetRef ref, double value) =>
      setting.apply(context, ref, value);

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => FloatOptionWidget(
    option: FloatOption(
      title: title,
      description: description,
      icon: icon,
      value: setting,
      min: min,
      max: max,
      defaultValue: defaultValue,
    ),
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
