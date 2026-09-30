part of '../abstract_base_option.dart';

/// A line of text the user types in.
@freezed
abstract class StringOption
    with _$StringOption, WidgetConvertable
    implements AbstractBaseOption {
  const StringOption._();

  const factory StringOption({
    required TranslationText title,
    TranslationText? description,
    required IconData icon,
    required OptionValue<String> value,
    int? maxLength,
  }) = _StringOption;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => StringOptionWidget(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
