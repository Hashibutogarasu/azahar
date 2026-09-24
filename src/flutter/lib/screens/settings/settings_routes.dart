import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'sections/audio_settings_page.dart';
import 'sections/camera_settings_page.dart';
import 'sections/controls_settings_page.dart';
import 'sections/debug_settings_page.dart';
import 'sections/general_settings_page.dart';
import 'sections/graphics_settings_page.dart';
import 'sections/language_settings_page.dart';
import 'sections/layout_settings_page.dart';
import 'sections/system_settings_page.dart';
import 'sections/theme_settings_page.dart';
import 'settings_menu_page.dart';

part 'settings_routes.g.dart';

/// The pre-redesign `/settings` route tree. Not registered in the app's router (see
/// `lib/main.dart`); kept only so the legacy Options UI (`useLegacySettingsUI`) can still reach
/// it. The current UI uses the routes in `lib/screens/options/options_routes.dart` instead, which
/// build the very same page widgets referenced below.
@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacySettingsMenuRoute>(path: '/settings')
class LegacySettingsMenuRoute extends GoRouteData with $LegacySettingsMenuRoute {
  const LegacySettingsMenuRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LegacySettingsMenuPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyGeneralSettingsRoute>(path: '/settings/general')
class LegacyGeneralSettingsRoute extends GoRouteData with $LegacyGeneralSettingsRoute {
  const LegacyGeneralSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GeneralSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyGraphicsSettingsRoute>(path: '/settings/graphics')
class LegacyGraphicsSettingsRoute extends GoRouteData with $LegacyGraphicsSettingsRoute {
  const LegacyGraphicsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GraphicsSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacySystemSettingsRoute>(path: '/settings/system')
class LegacySystemSettingsRoute extends GoRouteData with $LegacySystemSettingsRoute {
  const LegacySystemSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SystemSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyCameraSettingsRoute>(path: '/settings/camera')
class LegacyCameraSettingsRoute extends GoRouteData with $LegacyCameraSettingsRoute {
  const LegacyCameraSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CameraSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyControlsSettingsRoute>(path: '/settings/controls')
class LegacyControlsSettingsRoute extends GoRouteData with $LegacyControlsSettingsRoute {
  const LegacyControlsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ControlsSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyLayoutSettingsRoute>(path: '/settings/layout')
class LegacyLayoutSettingsRoute extends GoRouteData with $LegacyLayoutSettingsRoute {
  const LegacyLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LayoutSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyCustomLandscapeLayoutSettingsRoute>(
  path: '/settings/layout/custom-landscape',
)
class LegacyCustomLandscapeLayoutSettingsRoute extends GoRouteData
    with $LegacyCustomLandscapeLayoutSettingsRoute {
  const LegacyCustomLandscapeLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomLandscapeLayoutSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyCustomPortraitLayoutSettingsRoute>(path: '/settings/layout/custom-portrait')
class LegacyCustomPortraitLayoutSettingsRoute extends GoRouteData
    with $LegacyCustomPortraitLayoutSettingsRoute {
  const LegacyCustomPortraitLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomPortraitLayoutSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyAudioSettingsRoute>(path: '/settings/audio')
class LegacyAudioSettingsRoute extends GoRouteData with $LegacyAudioSettingsRoute {
  const LegacyAudioSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AudioSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyDebugSettingsRoute>(path: '/settings/debug')
class LegacyDebugSettingsRoute extends GoRouteData with $LegacyDebugSettingsRoute {
  const LegacyDebugSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DebugSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyThemeSettingsRoute>(path: '/settings/theme')
class LegacyThemeSettingsRoute extends GoRouteData with $LegacyThemeSettingsRoute {
  const LegacyThemeSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ThemeSettingsPage();
  }
}

@Deprecated('Not registered in the router. Kept for the legacy Options UI only.')
@TypedGoRoute<LegacyLanguageSettingsRoute>(path: '/settings/language')
class LegacyLanguageSettingsRoute extends GoRouteData with $LegacyLanguageSettingsRoute {
  const LegacyLanguageSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LanguageSettingsPage();
  }
}
