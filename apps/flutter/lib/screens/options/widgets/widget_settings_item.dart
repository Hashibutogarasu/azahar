import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';

/// Lets an arbitrary [child] widget sit in a list that only accepts settings items, such as
/// [SettingsGroupCard]. It draws [child] and nothing else.
class WidgetSettingsItem extends babstrap.SettingsItem {
  WidgetSettingsItem({required this.child})
    : super(icons: Icons.settings, title: '');

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
