part of '../abstract_base_option.dart';

/// An [EnumOption] that changes how heavy the emulation is.
class EmulatorEnumOption<T> extends AbstractEmulatorOption<T> {
  EmulatorEnumOption({
    required super.title,
    super.description,
    required super.icon,
    required super.setting,
    required this.choices,
  });

  final List<EnumChoice<T>> choices;

  @override
  T read(WidgetRef ref) => setting.read();

  @override
  Future<void> apply(BuildContext context, WidgetRef ref, T value) =>
      setting.write(value);

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => EnumOptionWidget<T>(
    option: EnumOption<T>(
      title: title,
      description: description,
      icon: icon,
      value: optionValue,
      choices: choices,
    ),
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
