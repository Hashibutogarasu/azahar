import 'package:flutter/material.dart';

import '../i18n/translations.g.dart';

/// A top-level destination of the app shell, shared by [AppNavBar] and [AppSideBar] so both
/// navigation styles list the same tabs in the same order.
class AppNavDestination {
  const AppNavDestination({required this.icon, required this.label});

  final IconData icon;
  final String label;

  static List<AppNavDestination> of(BuildContext context) {
    final t = context.t;
    return [
      AppNavDestination(icon: Icons.videogame_asset, label: t.home.games),
      AppNavDestination(icon: Icons.more_horiz, label: t.home.options),
    ];
  }
}
