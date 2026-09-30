part of '../abstract_base_option.dart';

/// A point in time picked with a date and a time picker. The value is the Unix time in seconds,
/// as text, the way the emulator stores it.
@freezed
abstract class DateTimeOption
    with _$DateTimeOption, WidgetConvertable
    implements AbstractBaseOption {
  const DateTimeOption._();

  const factory DateTimeOption({
    required TranslationText title,
    TranslationText? description,
    required IconData icon,
    required OptionValue<String> value,
  }) = _DateTimeOption;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => DateTimeOptionWidget(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
