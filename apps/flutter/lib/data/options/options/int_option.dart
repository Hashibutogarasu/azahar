part of '../abstract_base_option.dart';

/// A whole number chosen with a slider or typed in, between [min] and [max].
@freezed
abstract class IntOption
    with _$IntOption, WidgetConvertable
    implements AbstractBaseOption {
  const IntOption._();

  const factory IntOption({
    required TranslationText title,
    TranslationText? description,
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
  }) => IntOptionWidget(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
