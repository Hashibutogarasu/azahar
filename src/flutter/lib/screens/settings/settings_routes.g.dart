// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$settingsMenuRoute, $settingsSectionRoute];

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

RouteBase get $settingsSectionRoute => GoRouteData.$route(
  path: '/settings/:menuTag',
  hasOverriddenOnExit: false,
  factory: $SettingsSectionRoute._fromState,
);

mixin $SettingsSectionRoute on GoRouteData {
  static SettingsSectionRoute _fromState(GoRouterState state) =>
      SettingsSectionRoute(menuTag: state.pathParameters['menuTag']!);

  SettingsSectionRoute get _self => this as SettingsSectionRoute;

  @override
  String get location =>
      GoRouteData.$location('/settings/${Uri.encodeComponent(_self.menuTag)}');

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
