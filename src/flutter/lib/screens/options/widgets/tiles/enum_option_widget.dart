import 'enum_option_tile.dart';

/// The widget an [EnumOption] turns into. It behaves exactly like the [EnumOptionTile] it
/// inherits from.
class EnumOptionWidget<T> extends EnumOptionTile<T> {
  const EnumOptionWidget({
    super.key,
    required super.option,
    required super.onAccessed,
    required super.onLongPress,
  });
}
