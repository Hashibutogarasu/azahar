part of '../abstract_base_option.dart';

/// A whole number chosen with a slider or typed in, between [min] and [max].
@freezed
abstract class IntOption with _$IntOption implements AbstractBaseOption {
  const IntOption._();

  const factory IntOption({
    required String titleKey,
    String? descriptionKey,
    required IconData icon,
    required OptionValue<int> value,
    required int min,
    required int max,
    required int defaultValue,
    @Default('') String units,
  }) = _IntOption;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => IntOptionTile(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
