import 'nested_option_tile.dart';

/// The widget a [NestedOption] turns into. It behaves exactly like the [NestedOptionTile] it
/// inherits from.
class NestedOptionWidget extends NestedOptionTile {
  const NestedOptionWidget({
    super.key,
    required super.option,
    required super.onAccessed,
    required super.onLongPress,
  });
}
