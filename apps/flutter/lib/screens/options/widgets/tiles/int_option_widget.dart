import 'int_option_tile.dart';

/// The widget a [IntOption] turns into. It behaves exactly like the [IntOptionTile] it
/// inherits from.
class IntOptionWidget extends IntOptionTile {
  const IntOptionWidget({
    super.key,
    required super.option,
    required super.onAccessed,
    required super.onLongPress,
  });
}
