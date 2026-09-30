part of 'app_routes.dart';

@TypedGoRoute<OptionsGeneralSettingsRoute>(path: '/options/general')
class OptionsGeneralSettingsRoute extends AppRouteData
    with $OptionsGeneralSettingsRoute {
  const OptionsGeneralSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GeneralSettingsPage();
  }
}

@TypedGoRoute<OptionsMediaSettingsRoute>(path: '/options/media')
class OptionsMediaSettingsRoute extends AppRouteData
    with $OptionsMediaSettingsRoute {
  const OptionsMediaSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MediaSettingsPage();
  }
}

@TypedGoRoute<OptionsEmulatedNetworkSettingsRoute>(
  path: '/options/networking/emulated-network',
)
class OptionsEmulatedNetworkSettingsRoute extends AppRouteData
    with $OptionsEmulatedNetworkSettingsRoute {
  const OptionsEmulatedNetworkSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EmulatedNetworkPage();
  }
}

@TypedGoRoute<OptionsCameraSettingsRoute>(path: '/options/camera')
class OptionsCameraSettingsRoute extends AppRouteData
    with $OptionsCameraSettingsRoute {
  const OptionsCameraSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CameraSettingsPage();
  }
}

@TypedGoRoute<OptionsControlsSettingsRoute>(path: '/options/controls')
class OptionsControlsSettingsRoute extends AppRouteData
    with $OptionsControlsSettingsRoute {
  const OptionsControlsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ControlsSettingsPage();
  }
}

@TypedGoRoute<OptionsGraphicsSettingsRoute>(path: '/options/graphics')
class OptionsGraphicsSettingsRoute extends AppRouteData
    with $OptionsGraphicsSettingsRoute {
  const OptionsGraphicsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GraphicsSettingsPage();
  }
}

@TypedGoRoute<OptionsLayoutSettingsRoute>(path: '/options/graphics/layout')
class OptionsLayoutSettingsRoute extends AppRouteData
    with $OptionsLayoutSettingsRoute {
  const OptionsLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LayoutSettingsPage();
  }
}

@TypedGoRoute<OptionsCustomLandscapeLayoutSettingsRoute>(
  path: '/options/graphics/layout/custom-landscape',
)
class OptionsCustomLandscapeLayoutSettingsRoute extends AppRouteData
    with $OptionsCustomLandscapeLayoutSettingsRoute {
  const OptionsCustomLandscapeLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomLandscapeLayoutSettingsPage();
  }
}

@TypedGoRoute<OptionsCustomPortraitLayoutSettingsRoute>(
  path: '/options/graphics/layout/custom-portrait',
)
class OptionsCustomPortraitLayoutSettingsRoute extends AppRouteData
    with $OptionsCustomPortraitLayoutSettingsRoute {
  const OptionsCustomPortraitLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomPortraitLayoutSettingsPage();
  }
}

@TypedGoRoute<OptionsDebugSettingsRoute>(path: '/options/debug')
class OptionsDebugSettingsRoute extends AppRouteData
    with $OptionsDebugSettingsRoute {
  const OptionsDebugSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DebugSettingsPage();
  }
}

@TypedGoRoute<OptionsLanguageSettingsRoute>(path: '/options/language')
class OptionsLanguageSettingsRoute extends AppRouteData
    with $OptionsLanguageSettingsRoute {
  const OptionsLanguageSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LanguageSettingsPage();
  }
}

@TypedGoRoute<OptionsThemeSettingsRoute>(path: '/options/theme')
class OptionsThemeSettingsRoute extends AppRouteData
    with $OptionsThemeSettingsRoute {
  const OptionsThemeSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ThemeSettingsPage();
  }
}

@TypedGoRoute<OptionsAccessibilitySettingsRoute>(path: '/options/accessibility')
class OptionsAccessibilitySettingsRoute extends AppRouteData
    with $OptionsAccessibilitySettingsRoute {
  const OptionsAccessibilitySettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccessibilitySettingsPage();
  }
}

@TypedGoRoute<OptionsAdvancedSettingsRoute>(path: '/options/advanced')
class OptionsAdvancedSettingsRoute extends AppRouteData
    with $OptionsAdvancedSettingsRoute {
  const OptionsAdvancedSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AdvancedSettingsPage();
  }
}
