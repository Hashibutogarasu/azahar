import 'string_option_tile.dart';

/// The widget a [StringOption] turns into. It behaves exactly like the [StringOptionTile] it
/// inherits from.
class StringOptionWidget extends StringOptionTile {
  const StringOptionWidget({
    super.key,
    required super.option,
    required super.onAccessed,
    required super.onLongPress,
  });
}
