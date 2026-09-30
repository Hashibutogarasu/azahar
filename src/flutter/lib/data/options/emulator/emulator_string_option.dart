part of '../abstract_base_option.dart';

/// A [StringOption] that changes how heavy the emulation is.
class EmulatorStringOption extends AbstractEmulatorOption<String> {
  EmulatorStringOption({
    required super.title,
    super.description,
    required super.icon,
    required super.setting,
    this.maxLength,
  });

  final int? maxLength;

  @override
  String read(WidgetRef ref) => setting.read(ref);

  @override
  Future<void> apply(BuildContext context, WidgetRef ref, String value) =>
      setting.apply(context, ref, value);

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => StringOptionWidget(
    option: StringOption(
      title: title,
      description: description,
      icon: icon,
      value: setting,
      maxLength: maxLength,
    ),
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
