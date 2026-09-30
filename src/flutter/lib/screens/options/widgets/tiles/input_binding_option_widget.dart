import 'input_binding_option_tile.dart';

/// The widget a [InputBindingOption] turns into. It behaves exactly like the [InputBindingOptionTile] it
/// inherits from.
class InputBindingOptionWidget extends InputBindingOptionTile {
  const InputBindingOptionWidget({
    super.key,
    required super.option,
    required super.onAccessed,
    required super.onLongPress,
  });
}
