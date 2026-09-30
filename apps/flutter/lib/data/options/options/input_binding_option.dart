part of '../abstract_base_option.dart';

/// A gamepad button or axis bound by pressing it. The value is the key of the bound input.
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
