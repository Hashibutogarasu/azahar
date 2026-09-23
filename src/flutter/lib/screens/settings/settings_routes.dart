import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'sections/camera_settings_page.dart';
import 'sections/controls_settings_page.dart';
import 'sections/general_settings_page.dart';
import 'sections/graphics_settings_page.dart';
import 'sections/layout_settings_page.dart';
import 'sections/system_settings_page.dart';
import 'settings_menu_page.dart';

part 'settings_routes.g.dart';

@TypedGoRoute<SettingsMenuRoute>(path: '/settings')
class SettingsMenuRoute extends GoRouteData with $SettingsMenuRoute {
  const SettingsMenuRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsMenuPage();
  }
}

@TypedGoRoute<GeneralSettingsRoute>(path: '/settings/general')
class GeneralSettingsRoute extends GoRouteData with $GeneralSettingsRoute {
  const GeneralSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GeneralSettingsPage();
  }
}

@TypedGoRoute<GraphicsSettingsRoute>(path: '/settings/graphics')
class GraphicsSettingsRoute extends GoRouteData with $GraphicsSettingsRoute {
  const GraphicsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GraphicsSettingsPage();
  }
}

@TypedGoRoute<SystemSettingsRoute>(path: '/settings/system')
class SystemSettingsRoute extends GoRouteData with $SystemSettingsRoute {
  const SystemSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SystemSettingsPage();
  }
}

@TypedGoRoute<CameraSettingsRoute>(path: '/settings/camera')
class CameraSettingsRoute extends GoRouteData with $CameraSettingsRoute {
  const CameraSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CameraSettingsPage();
  }
}

@TypedGoRoute<ControlsSettingsRoute>(path: '/settings/controls')
class ControlsSettingsRoute extends GoRouteData with $ControlsSettingsRoute {
  const ControlsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ControlsSettingsPage();
  }
}

@TypedGoRoute<LayoutSettingsRoute>(path: '/settings/layout')
class LayoutSettingsRoute extends GoRouteData with $LayoutSettingsRoute {
  const LayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LayoutSettingsPage();
  }
}

@TypedGoRoute<CustomLandscapeLayoutSettingsRoute>(path: '/settings/layout/custom-landscape')
class CustomLandscapeLayoutSettingsRoute extends GoRouteData
    with $CustomLandscapeLayoutSettingsRoute {
  const CustomLandscapeLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomLandscapeLayoutSettingsPage();
  }
}

@TypedGoRoute<CustomPortraitLayoutSettingsRoute>(path: '/settings/layout/custom-portrait')
class CustomPortraitLayoutSettingsRoute extends GoRouteData
    with $CustomPortraitLayoutSettingsRoute {
  const CustomPortraitLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomPortraitLayoutSettingsPage();
  }
}
