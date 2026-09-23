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
