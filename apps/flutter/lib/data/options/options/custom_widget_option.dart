part of '../abstract_base_option.dart';

/// An item that shows the widget [builder] returns as it is. It has no value of its own; the
/// widget reads and changes what it shows by itself.
@freezed
abstract class CustomWidgetOption
    with _$CustomWidgetOption, WidgetConvertable
    implements AbstractBaseOption {
  const CustomWidgetOption._();

  const factory CustomWidgetOption({
    required TranslationText title,
    TranslationText? description,
    required IconData icon,
    required WidgetBuilder builder,
  }) = _CustomWidgetOption;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => Builder(builder: builder);
}
