import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../screens/options/widgets/tiles/action_option_tile.dart';
import '../../screens/options/widgets/tiles/bool_option_tile.dart';
import '../../screens/options/widgets/tiles/date_time_option_tile.dart';
import '../../screens/options/widgets/tiles/enum_option_tile.dart';
import '../../screens/options/widgets/tiles/float_option_tile.dart';
import '../../screens/options/widgets/tiles/input_binding_option_tile.dart';
import '../../screens/options/widgets/tiles/int_option_tile.dart';
import '../../screens/options/widgets/tiles/nested_option_tile.dart';
import '../../screens/options/widgets/tiles/string_option_tile.dart';
import 'option_value.dart';

part 'abstract_base_option.freezed.dart';
part 'options/action_option.dart';
part 'options/bool_option.dart';
part 'options/date_time_option.dart';
part 'options/enum_option.dart';
part 'options/float_option.dart';
part 'options/input_binding_option.dart';
part 'options/int_option.dart';
part 'options/nested_option.dart';
part 'options/string_option.dart';

/// What every Options item has in common: the translation keys of its title and description, its
/// icon, and how it turns into a widget. The rest, such as how its value is read or where it
/// leads, belongs to each kind.
///
/// The keys are translation key paths (for example `settings.graphics.title`), resolved against
/// the current locale when the item is shown or searched.
sealed class AbstractBaseOption {
  const AbstractBaseOption();

  String get titleKey;

  String? get descriptionKey;

  IconData get icon;

  /// Builds the widget that shows and edits this option. [onAccessed] is called when the option
  /// is changed or opened, and [onLongPress] when the widget is pressed and held.
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  });
}
