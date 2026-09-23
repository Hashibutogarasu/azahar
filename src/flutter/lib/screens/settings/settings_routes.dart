import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'settings_menu_page.dart';
import 'settings_section_page.dart';

part 'settings_routes.g.dart';

@TypedGoRoute<SettingsMenuRoute>(path: '/settings')
class SettingsMenuRoute extends GoRouteData with $SettingsMenuRoute {
  const SettingsMenuRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsMenuPage();
  }
}

@TypedGoRoute<SettingsSectionRoute>(path: '/settings/:menuTag')
class SettingsSectionRoute extends GoRouteData with $SettingsSectionRoute {
  const SettingsSectionRoute({required this.menuTag});

  final String menuTag;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SettingsSectionPage(menuTag: menuTag);
  }
}
