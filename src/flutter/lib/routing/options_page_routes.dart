part of 'app_routes.dart';

@TypedGoRoute<OptionsGeneralSettingsRoute>(path: '/options/general')
class OptionsGeneralSettingsRoute extends GoRouteData
    with $OptionsGeneralSettingsRoute, SlideTransitionRoute {
  const OptionsGeneralSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GeneralSettingsPage();
  }
}

@TypedGoRoute<OptionsMediaSettingsRoute>(path: '/options/media')
class OptionsMediaSettingsRoute extends GoRouteData
    with $OptionsMediaSettingsRoute, SlideTransitionRoute {
  const OptionsMediaSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MediaSettingsPage();
  }
}

@TypedGoRoute<OptionsEmulatedNetworkSettingsRoute>(
  path: '/options/networking/emulated-network',
)
class OptionsEmulatedNetworkSettingsRoute extends GoRouteData
    with $OptionsEmulatedNetworkSettingsRoute, SlideTransitionRoute {
  const OptionsEmulatedNetworkSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EmulatedNetworkPage();
  }
}

@TypedGoRoute<OptionsCameraSettingsRoute>(path: '/options/camera')
class OptionsCameraSettingsRoute extends GoRouteData
    with $OptionsCameraSettingsRoute, SlideTransitionRoute {
  const OptionsCameraSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CameraSettingsPage();
  }
}

@TypedGoRoute<OptionsControlsSettingsRoute>(path: '/options/controls')
class OptionsControlsSettingsRoute extends GoRouteData
    with $OptionsControlsSettingsRoute, SlideTransitionRoute {
  const OptionsControlsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ControlsSettingsPage();
  }
}

@TypedGoRoute<OptionsGraphicsSettingsRoute>(path: '/options/graphics')
class OptionsGraphicsSettingsRoute extends GoRouteData
    with $OptionsGraphicsSettingsRoute, SlideTransitionRoute {
  const OptionsGraphicsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GraphicsSettingsPage();
  }
}

@TypedGoRoute<OptionsLayoutSettingsRoute>(path: '/options/graphics/layout')
class OptionsLayoutSettingsRoute extends GoRouteData
    with $OptionsLayoutSettingsRoute, SlideTransitionRoute {
  const OptionsLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LayoutSettingsPage();
  }
}

@TypedGoRoute<OptionsCustomLandscapeLayoutSettingsRoute>(
  path: '/options/graphics/layout/custom-landscape',
)
class OptionsCustomLandscapeLayoutSettingsRoute extends GoRouteData
    with $OptionsCustomLandscapeLayoutSettingsRoute, SlideTransitionRoute {
  const OptionsCustomLandscapeLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomLandscapeLayoutSettingsPage();
  }
}

@TypedGoRoute<OptionsCustomPortraitLayoutSettingsRoute>(
  path: '/options/graphics/layout/custom-portrait',
)
class OptionsCustomPortraitLayoutSettingsRoute extends GoRouteData
    with $OptionsCustomPortraitLayoutSettingsRoute, SlideTransitionRoute {
  const OptionsCustomPortraitLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomPortraitLayoutSettingsPage();
  }
}

@TypedGoRoute<OptionsDebugSettingsRoute>(path: '/options/debug')
class OptionsDebugSettingsRoute extends GoRouteData
    with $OptionsDebugSettingsRoute, SlideTransitionRoute {
  const OptionsDebugSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DebugSettingsPage();
  }
}

@TypedGoRoute<OptionsLanguageSettingsRoute>(path: '/options/language')
class OptionsLanguageSettingsRoute extends GoRouteData
    with $OptionsLanguageSettingsRoute, SlideTransitionRoute {
  const OptionsLanguageSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LanguageSettingsPage();
  }
}

@TypedGoRoute<OptionsThemeSettingsRoute>(path: '/options/theme')
class OptionsThemeSettingsRoute extends GoRouteData
    with $OptionsThemeSettingsRoute, SlideTransitionRoute {
  const OptionsThemeSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ThemeSettingsPage();
  }
}

@TypedGoRoute<OptionsAccessibilitySettingsRoute>(path: '/options/accessibility')
class OptionsAccessibilitySettingsRoute extends GoRouteData
    with $OptionsAccessibilitySettingsRoute, SlideTransitionRoute {
  const OptionsAccessibilitySettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccessibilitySettingsPage();
  }
}

@TypedGoRoute<OptionsAdvancedSettingsRoute>(path: '/options/advanced')
class OptionsAdvancedSettingsRoute extends GoRouteData
    with $OptionsAdvancedSettingsRoute, SlideTransitionRoute {
  const OptionsAdvancedSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AdvancedSettingsPage();
  }
}
