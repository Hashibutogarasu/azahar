import 'action_option_tile.dart';

/// The widget a [ActionOption] turns into. It behaves exactly like the [ActionOptionTile] it
/// inherits from.
class ActionOptionWidget extends ActionOptionTile {
  const ActionOptionWidget({
    super.key,
    required super.option,
    required super.onAccessed,
    required super.onLongPress,
  });
}
