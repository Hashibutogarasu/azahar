import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../settings/sections/audio_settings_page.dart';
import '../settings/sections/camera_settings_page.dart';
import '../settings/sections/controls_settings_page.dart';
import '../settings/sections/debug_settings_page.dart';
import '../settings/sections/general_settings_page.dart';
import '../settings/sections/graphics_settings_page.dart';
import '../settings/sections/language_settings_page.dart';
import '../settings/sections/layout_settings_page.dart';
import '../settings/sections/system_settings_page.dart';
import '../settings/sections/theme_settings_page.dart';
import 'emulation_settings_page.dart';

part 'options_routes.g.dart';

/// The redesigned Options tab's route tree. Every settings section is reached from here (under
/// `/options/...`) instead of the retired `/settings` hub (see `lib/screens/settings/settings_routes.dart`,
/// kept only for the legacy Options UI).

@TypedGoRoute<OptionsEmulationSettingsRoute>(path: '/options/emulation')
class OptionsEmulationSettingsRoute extends GoRouteData with $OptionsEmulationSettingsRoute {
  const OptionsEmulationSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EmulationSettingsPage();
  }
}

@TypedGoRoute<OptionsGeneralSettingsRoute>(path: '/options/emulation/general')
class OptionsGeneralSettingsRoute extends GoRouteData with $OptionsGeneralSettingsRoute {
  const OptionsGeneralSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GeneralSettingsPage();
  }
}

@TypedGoRoute<OptionsSystemSettingsRoute>(path: '/options/emulation/system')
class OptionsSystemSettingsRoute extends GoRouteData with $OptionsSystemSettingsRoute {
  const OptionsSystemSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SystemSettingsPage();
  }
}

@TypedGoRoute<OptionsAudioSettingsRoute>(path: '/options/emulation/audio')
class OptionsAudioSettingsRoute extends GoRouteData with $OptionsAudioSettingsRoute {
  const OptionsAudioSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AudioSettingsPage();
  }
}

@TypedGoRoute<OptionsCameraSettingsRoute>(path: '/options/emulation/camera')
class OptionsCameraSettingsRoute extends GoRouteData with $OptionsCameraSettingsRoute {
  const OptionsCameraSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CameraSettingsPage();
  }
}

@TypedGoRoute<OptionsControlsSettingsRoute>(path: '/options/emulation/controls')
class OptionsControlsSettingsRoute extends GoRouteData with $OptionsControlsSettingsRoute {
  const OptionsControlsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ControlsSettingsPage();
  }
}

@TypedGoRoute<OptionsGraphicsSettingsRoute>(path: '/options/graphics')
class OptionsGraphicsSettingsRoute extends GoRouteData with $OptionsGraphicsSettingsRoute {
  const OptionsGraphicsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GraphicsSettingsPage();
  }
}

@TypedGoRoute<OptionsLayoutSettingsRoute>(path: '/options/graphics/layout')
class OptionsLayoutSettingsRoute extends GoRouteData with $OptionsLayoutSettingsRoute {
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
class OptionsCustomPortraitLayoutSettingsRoute extends GoRouteData
    with $OptionsCustomPortraitLayoutSettingsRoute {
  const OptionsCustomPortraitLayoutSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CustomPortraitLayoutSettingsPage();
  }
}

@TypedGoRoute<OptionsDebugSettingsRoute>(path: '/options/debug')
class OptionsDebugSettingsRoute extends GoRouteData with $OptionsDebugSettingsRoute {
  const OptionsDebugSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DebugSettingsPage();
  }
}

@TypedGoRoute<OptionsLanguageSettingsRoute>(path: '/options/language')
class OptionsLanguageSettingsRoute extends GoRouteData with $OptionsLanguageSettingsRoute {
  const OptionsLanguageSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LanguageSettingsPage();
  }
}

@TypedGoRoute<OptionsThemeSettingsRoute>(path: '/options/theme')
class OptionsThemeSettingsRoute extends GoRouteData with $OptionsThemeSettingsRoute {
  const OptionsThemeSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ThemeSettingsPage();
  }
}
