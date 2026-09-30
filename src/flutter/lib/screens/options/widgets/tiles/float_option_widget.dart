import 'float_option_tile.dart';

/// The widget a [FloatOption] turns into. It behaves exactly like the [FloatOptionTile] it
/// inherits from.
class FloatOptionWidget extends FloatOptionTile {
  const FloatOptionWidget({
    super.key,
    required super.option,
    required super.onAccessed,
    required super.onLongPress,
  });
}
