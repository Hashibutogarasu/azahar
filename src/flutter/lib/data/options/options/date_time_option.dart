part of '../abstract_base_option.dart';

/// A point in time picked with a date and a time picker. The value is the Unix time in seconds,
/// as text, the way the emulator stores it.
@freezed
abstract class DateTimeOption
    with _$DateTimeOption
    implements AbstractBaseOption {
  const DateTimeOption._();

  const factory DateTimeOption({
    required String titleKey,
    String? descriptionKey,
    required IconData icon,
    required OptionValue<String> value,
  }) = _DateTimeOption;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => DateTimeOptionTile(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
