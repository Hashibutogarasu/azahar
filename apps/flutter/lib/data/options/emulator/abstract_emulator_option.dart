part of '../abstract_base_option.dart';

/// An option that changes how heavy the emulation is. What it reads, writes and weighs comes from
/// its [setting]; the option itself only says how the setting is shown.
///
/// [read] and [apply] are left to each kind of option.
sealed class AbstractEmulatorOption<T> extends AbstractBaseOption
    with OptionReadable<T>, OptionApplicable<T> {
  AbstractEmulatorOption({
    required this.title,
    this.description,
    required this.icon,
    required this.setting,
  }) : weightIndex = setting.weightIndex;

  @override
  final TranslationText title;

  @override
  final TranslationText? description;

  @override
  final IconData icon;

  /// Reads, writes and weighs the value this option shows.
  final EmulatorSetting<T> setting;

  /// The largest share of the whole weight index this option can add, between 0.0 and 1.0.
  final double weightIndex;

  /// The share of the whole weight index the current value adds.
  double get currentWeight => setting.currentWeight;

  /// The [setting] as the [OptionValue] the widgets of the plain option kinds work with.
  OptionValue<T> get optionValue => CallbackOptionValue<T>(
    onRead: (ref) => setting.read(),
    onWrite: (context, ref, value) => setting.write(value),
  );
}
