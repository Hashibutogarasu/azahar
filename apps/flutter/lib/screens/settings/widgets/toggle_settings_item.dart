import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';

import '../../../widgets/app_toggle_switch.dart';

/// A settings row with an icon, title, optional subtitle, and a trailing [AppToggleSwitch] that
/// the whole row toggles, so it can also be focused and toggled with a controller.
/// The single widget that builds a toggle-switch settings row, so every screen shares the same
/// switch style instead of each mixing in its own [Switch].
class ToggleSettingsItem extends babstrap.SettingsItem {
  ToggleSettingsItem({
    required IconData icon,
    required super.title,
    super.subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) : super(
         icons: icon,
         onTap: () => onChanged(!value),
         trailing: AppToggleSwitch(value: value, onChanged: onChanged),
       );
}
