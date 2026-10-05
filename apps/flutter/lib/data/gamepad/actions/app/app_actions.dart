import '../gamepad_action.dart';
import 'activate_action.dart';
import 'cancel_action.dart';
import 'move_focus_down_action.dart';
import 'move_focus_left_action.dart';
import 'move_focus_right_action.dart';
import 'move_focus_up_action.dart';
import 'next_focus_region_action.dart';
import 'next_page_action.dart';
import 'open_context_menu_action.dart';
import 'previous_focus_region_action.dart';
import 'previous_page_action.dart';

/// The actions that operate the app itself, in the order they are listed in the settings.
final List<GamepadAction> appActions = [
  PreviousPageAction(),
  NextPageAction(),
  PreviousFocusRegionAction(),
  NextFocusRegionAction(),
  MoveFocusUpAction(),
  MoveFocusDownAction(),
  MoveFocusLeftAction(),
  MoveFocusRightAction(),
  ActivateAction(),
  CancelAction(),
  OpenContextMenuAction(),
];
