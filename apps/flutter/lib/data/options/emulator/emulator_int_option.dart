part of '../abstract_base_option.dart';

/// An [IntOption] that changes how heavy the emulation is.
class EmulatorIntOption extends AbstractEmulatorOption<int> {
  EmulatorIntOption({
    required super.title,
    super.description,
    required super.icon,
    required super.setting,
    required this.min,
    required this.max,
    required this.defaultValue,
    this.units = '',
  });

  final int min;

  final int max;

  final int defaultValue;

  final String units;

  @override
  int read(WidgetRef ref) => setting.read();

  @override
  Future<void> apply(BuildContext context, WidgetRef ref, int value) =>
      setting.write(value);

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => IntOptionWidget(
    option: IntOption(
      title: title,
      description: description,
      icon: icon,
      value: optionValue,
      min: min,
      max: max,
      defaultValue: defaultValue,
      units: units,
    ),
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
