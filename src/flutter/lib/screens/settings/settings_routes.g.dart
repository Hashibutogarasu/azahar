// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $settingsMenuRoute,
  $generalSettingsRoute,
  $graphicsSettingsRoute,
  $systemSettingsRoute,
  $cameraSettingsRoute,
  $controlsSettingsRoute,
  $layoutSettingsRoute,
  $customLandscapeLayoutSettingsRoute,
  $customPortraitLayoutSettingsRoute,
];

RouteBase get $settingsMenuRoute => GoRouteData.$route(
  path: '/settings',
  hasOverriddenOnExit: false,
  factory: $SettingsMenuRoute._fromState,
);

mixin $SettingsMenuRoute on GoRouteData {
  static SettingsMenuRoute _fromState(GoRouterState state) =>
      const SettingsMenuRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $generalSettingsRoute => GoRouteData.$route(
  path: '/settings/general',
  hasOverriddenOnExit: false,
  factory: $GeneralSettingsRoute._fromState,
);

mixin $GeneralSettingsRoute on GoRouteData {
  static GeneralSettingsRoute _fromState(GoRouterState state) =>
      const GeneralSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/general');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $graphicsSettingsRoute => GoRouteData.$route(
  path: '/settings/graphics',
  hasOverriddenOnExit: false,
  factory: $GraphicsSettingsRoute._fromState,
);

mixin $GraphicsSettingsRoute on GoRouteData {
  static GraphicsSettingsRoute _fromState(GoRouterState state) =>
      const GraphicsSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/graphics');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $systemSettingsRoute => GoRouteData.$route(
  path: '/settings/system',
  hasOverriddenOnExit: false,
  factory: $SystemSettingsRoute._fromState,
);

mixin $SystemSettingsRoute on GoRouteData {
  static SystemSettingsRoute _fromState(GoRouterState state) =>
      const SystemSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/system');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cameraSettingsRoute => GoRouteData.$route(
  path: '/settings/camera',
  hasOverriddenOnExit: false,
  factory: $CameraSettingsRoute._fromState,
);

mixin $CameraSettingsRoute on GoRouteData {
  static CameraSettingsRoute _fromState(GoRouterState state) =>
      const CameraSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/camera');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $controlsSettingsRoute => GoRouteData.$route(
  path: '/settings/controls',
  hasOverriddenOnExit: false,
  factory: $ControlsSettingsRoute._fromState,
);

mixin $ControlsSettingsRoute on GoRouteData {
  static ControlsSettingsRoute _fromState(GoRouterState state) =>
      const ControlsSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/controls');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $layoutSettingsRoute => GoRouteData.$route(
  path: '/settings/layout',
  hasOverriddenOnExit: false,
  factory: $LayoutSettingsRoute._fromState,
);

mixin $LayoutSettingsRoute on GoRouteData {
  static LayoutSettingsRoute _fromState(GoRouterState state) =>
      const LayoutSettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings/layout');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $customLandscapeLayoutSettingsRoute => GoRouteData.$route(
  path: '/settings/layout/custom-landscape',
  hasOverriddenOnExit: false,
  factory: $CustomLandscapeLayoutSettingsRoute._fromState,
);

mixin $CustomLandscapeLayoutSettingsRoute on GoRouteData {
  static CustomLandscapeLayoutSettingsRoute _fromState(GoRouterState state) =>
      const CustomLandscapeLayoutSettingsRoute();

  @override
  String get location =>
      GoRouteData.$location('/settings/layout/custom-landscape');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $customPortraitLayoutSettingsRoute => GoRouteData.$route(
  path: '/settings/layout/custom-portrait',
  hasOverriddenOnExit: false,
  factory: $CustomPortraitLayoutSettingsRoute._fromState,
);

mixin $CustomPortraitLayoutSettingsRoute on GoRouteData {
  static CustomPortraitLayoutSettingsRoute _fromState(GoRouterState state) =>
      const CustomPortraitLayoutSettingsRoute();

  @override
  String get location =>
      GoRouteData.$location('/settings/layout/custom-portrait');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
