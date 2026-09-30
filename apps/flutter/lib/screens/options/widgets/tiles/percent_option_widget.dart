import 'percent_option_tile.dart';

/// The widget a [PercentOption] turns into. It behaves exactly like the [PercentOptionTile] it
/// inherits from.
class PercentOptionWidget extends PercentOptionTile {
  const PercentOptionWidget({
    super.key,
    required super.option,
    required super.onAccessed,
    required super.onLongPress,
  });
}
