part of '../abstract_base_option.dart';

/// A gamepad button, key combination or stick bound by pressing it. The value is the bound input,
/// written as [mode] describes.
@freezed
abstract class InputBindingOption
    with _$InputBindingOption, WidgetConvertable
    implements AbstractBaseOption {
  const InputBindingOption._();

  const factory InputBindingOption({
    required TranslationText title,
    TranslationText? description,
    required IconData icon,
    required OptionValue<String> value,
    @Default(InputBindingMode.rawKey) InputBindingMode mode,
  }) = _InputBindingOption;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => InputBindingOptionWidget(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
