part of '../abstract_base_option.dart';

/// A [BoolOption] that changes how heavy the emulation is.
class EmulatorBoolOption extends AbstractEmulatorOption<bool> {
  EmulatorBoolOption({
    required super.title,
    super.description,
    required super.icon,
    required super.setting,
  });

  @override
  bool read(WidgetRef ref) => setting.read(ref);

  @override
  Future<void> apply(BuildContext context, WidgetRef ref, bool value) =>
      setting.apply(context, ref, value);

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => BoolOptionWidget(
    option: BoolOption(
      title: title,
      description: description,
      icon: icon,
      value: setting,
    ),
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
