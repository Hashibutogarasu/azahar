part of '../abstract_base_option.dart';

/// One selectable value of an [EnumOption], with the translation key of its label.
@freezed
abstract class EnumChoice<T> with _$EnumChoice<T> {
  const factory EnumChoice({required String labelKey, required T value}) =
      _EnumChoice<T>;
}

/// A value picked from a fixed list of [choices]. [T] is `int` or `String`, matching how the
/// setting is stored.
@freezed
abstract class EnumOption<T>
    with _$EnumOption<T>
    implements AbstractBaseOption {
  const EnumOption._();

  const factory EnumOption({
    required String titleKey,
    String? descriptionKey,
    required IconData icon,
    required OptionValue<T> value,
    required List<EnumChoice<T>> choices,
  }) = _EnumOption<T>;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => EnumOptionTile<T>(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
