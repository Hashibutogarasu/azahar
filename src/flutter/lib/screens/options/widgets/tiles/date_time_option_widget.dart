import 'date_time_option_tile.dart';

/// The widget a [DateTimeOption] turns into. It behaves exactly like the [DateTimeOptionTile] it
/// inherits from.
class DateTimeOptionWidget extends DateTimeOptionTile {
  const DateTimeOptionWidget({
    super.key,
    required super.option,
    required super.onAccessed,
    required super.onLongPress,
  });
}
