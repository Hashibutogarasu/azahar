part of '../abstract_base_option.dart';

/// An on/off switch.
@freezed
abstract class BoolOption
    with _$BoolOption, WidgetConvertable
    implements AbstractBaseOption {
  const BoolOption._();

  const factory BoolOption({
    required TranslationText title,
    TranslationText? description,
    required IconData icon,
    required OptionValue<bool> value,
  }) = _BoolOption;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => BoolOptionWidget(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
