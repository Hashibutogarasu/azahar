part of '../abstract_base_option.dart';

/// A number chosen with a slider or typed in, between [min] and [max].
@freezed
abstract class FloatOption with _$FloatOption implements AbstractBaseOption {
  const FloatOption._();

  const factory FloatOption({
    required String titleKey,
    String? descriptionKey,
    required IconData icon,
    required OptionValue<double> value,
    required double min,
    required double max,
    required double defaultValue,
    @Default('') String units,
  }) = _FloatOption;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => FloatOptionTile(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
