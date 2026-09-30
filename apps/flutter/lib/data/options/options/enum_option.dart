part of '../abstract_base_option.dart';

/// One selectable value of an [EnumOption], with the function that reads its label from the
/// translations.
@freezed
abstract class EnumChoice<T> with _$EnumChoice<T> {
  const factory EnumChoice({required TranslationText label, required T value}) =
      _EnumChoice<T>;
}

/// A value picked from a fixed list of [choices]. [T] is the type of the choices' values: an `int`
/// or `String` matching how the setting is stored, or an enum.
@freezed
abstract class EnumOption<T>
    with _$EnumOption<T>, WidgetConvertable
    implements AbstractBaseOption {
  const EnumOption._();

  const factory EnumOption({
    required TranslationText title,
    TranslationText? description,
    required IconData icon,
    required OptionValue<T> value,
    required List<EnumChoice<T>> choices,
  }) = _EnumOption<T>;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => EnumOptionWidget<T>(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
