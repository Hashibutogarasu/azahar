import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../screens/options/widgets/tiles/action_option_widget.dart';
import '../../screens/options/widgets/tiles/bool_option_widget.dart';
import '../../screens/options/widgets/tiles/date_time_option_widget.dart';
import '../../screens/options/widgets/tiles/enum_option_widget.dart';
import '../../screens/options/widgets/tiles/float_option_widget.dart';
import '../../screens/options/widgets/tiles/input_binding_option_widget.dart';
import '../../screens/options/widgets/tiles/int_option_widget.dart';
import '../../screens/options/widgets/tiles/nested_option_widget.dart';
import '../../screens/options/widgets/tiles/percent_option_widget.dart';
import '../../screens/options/widgets/tiles/string_option_widget.dart';
import 'emulator/settings/emulator_setting.dart';
import 'option_applicable.dart';
import 'option_readable.dart';
import 'option_value.dart';
import 'translation_text.dart';
import 'widget_convertable.dart';

part 'abstract_base_option.freezed.dart';
part 'emulator/abstract_emulator_option.dart';
part 'emulator/emulator_bool_option.dart';
part 'emulator/emulator_enum_option.dart';
part 'emulator/emulator_float_option.dart';
part 'emulator/emulator_int_option.dart';
part 'emulator/emulator_percent_option.dart';
part 'emulator/emulator_string_option.dart';
part 'options/action_option.dart';
part 'options/bool_option.dart';
part 'options/custom_widget_option.dart';
part 'options/date_time_option.dart';
part 'options/enum_option.dart';
part 'options/float_option.dart';
part 'options/input_binding_option.dart';
part 'options/int_option.dart';
part 'options/nested_option.dart';
part 'options/percent_option.dart';
part 'options/string_option.dart';

/// What every Options item has in common: how its title and description are read from the
/// translations, its icon, and how it turns into a widget through [WidgetConvertable]. The rest,
/// such as how its value is read or where it leads, belongs to each kind.
///
/// The title and description are [TranslationText] functions, for example
/// `(t) => t.settings.graphics.title`, applied to the current locale when the item is shown or
/// searched.
sealed class AbstractBaseOption with WidgetConvertable {
  const AbstractBaseOption();

  TranslationText get title;

  TranslationText? get description;

  IconData get icon;
}
