// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $setupRoute,
  $aboutRoute,
  $gpuDriverManagerRoute,
  $systemFilesRoute,
  $appShellRouteData,
  $optionsGeneralSettingsRoute,
  $optionsMediaSettingsRoute,
  $optionsEmulatedNetworkSettingsRoute,
  $optionsCameraSettingsRoute,
  $optionsControlsSettingsRoute,
  $optionsGraphicsSettingsRoute,
  $optionsLayoutSettingsRoute,
  $optionsCustomLandscapeLayoutSettingsRoute,
  $optionsCustomPortraitLayoutSettingsRoute,
  $optionsDebugSettingsRoute,
  $optionsLanguageSettingsRoute,
  $optionsThemeSettingsRoute,
];

RouteBase get $setupRoute => GoRouteData.$route(
  path: '/setup',
  hasOverriddenOnExit: false,
  factory: $SetupRoute._fromState,
);

mixin $SetupRoute on GoRouteData {
  static SetupRoute _fromState(GoRouterState state) => const SetupRoute();

  @override
  String get location => GoRouteData.$location('/setup');

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

RouteBase get $aboutRoute => GoRouteData.$route(
  path: '/about',
  hasOverriddenOnExit: false,
  factory: $AboutRoute._fromState,
);

mixin $AboutRoute on GoRouteData {
  static AboutRoute _fromState(GoRouterState state) => const AboutRoute();

  @override
  String get location => GoRouteData.$location('/about');

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

RouteBase get $gpuDriverManagerRoute => GoRouteData.$route(
  path: '/gpu-driver-manager',
  hasOverriddenOnExit: false,
  factory: $GpuDriverManagerRoute._fromState,
);

mixin $GpuDriverManagerRoute on GoRouteData {
  static GpuDriverManagerRoute _fromState(GoRouterState state) =>
      const GpuDriverManagerRoute();

  @override
  String get location => GoRouteData.$location('/gpu-driver-manager');

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

RouteBase get $systemFilesRoute => GoRouteData.$route(
  path: '/system-files',
  hasOverriddenOnExit: false,
  factory: $SystemFilesRoute._fromState,
);

mixin $SystemFilesRoute on GoRouteData {
  static SystemFilesRoute _fromState(GoRouterState state) =>
      const SystemFilesRoute();

  @override
  String get location => GoRouteData.$location('/system-files');

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

RouteBase get $appShellRouteData => StatefulShellRouteData.$route(
  factory: $AppShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/',
          hasOverriddenOnExit: false,
          factory: $GamesListRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/options',
          hasOverriddenOnExit: false,
          factory: $OptionsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellRouteDataExtension on AppShellRouteData {
  static AppShellRouteData _fromState(GoRouterState state) =>
      const AppShellRouteData();
}

mixin $GamesListRoute on GoRouteData {
  static GamesListRoute _fromState(GoRouterState state) =>
      const GamesListRoute();

  @override
  String get location => GoRouteData.$location('/');

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

mixin $OptionsRoute on GoRouteData {
  static OptionsRoute _fromState(GoRouterState state) => OptionsRoute(
    isLegacy: _$convertMapValue(
      'is-legacy',
      state.uri.queryParameters,
      _$boolConverter,
    ),
  );

  OptionsRoute get _self => this as OptionsRoute;

  @override
  String get location => GoRouteData.$location(
    '/options',
    queryParams: {
      if (_self.isLegacy != null) 'is-legacy': _self.isLegacy!.toString(),
    },
  );

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

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

RouteBase get $optionsGeneralSettingsRoute => GoRouteData.$route(
  path: '/options/general',
  hasOverriddenOnExit: false,
  factory: $OptionsGeneralSettingsRoute._fromState,
);

mixin $OptionsGeneralSettingsRoute on GoRouteData {
  static OptionsGeneralSettingsRoute _fromState(GoRouterState state) =>
      const OptionsGeneralSettingsRoute();

  @override
  String get location => GoRouteData.$location('/options/general');

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

RouteBase get $optionsMediaSettingsRoute => GoRouteData.$route(
  path: '/options/media',
  hasOverriddenOnExit: false,
  factory: $OptionsMediaSettingsRoute._fromState,
);

mixin $OptionsMediaSettingsRoute on GoRouteData {
  static OptionsMediaSettingsRoute _fromState(GoRouterState state) =>
      const OptionsMediaSettingsRoute();

  @override
  String get location => GoRouteData.$location('/options/media');

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

RouteBase get $optionsEmulatedNetworkSettingsRoute => GoRouteData.$route(
  path: '/options/networking/emulated-network',
  hasOverriddenOnExit: false,
  factory: $OptionsEmulatedNetworkSettingsRoute._fromState,
);

mixin $OptionsEmulatedNetworkSettingsRoute on GoRouteData {
  static OptionsEmulatedNetworkSettingsRoute _fromState(GoRouterState state) =>
      const OptionsEmulatedNetworkSettingsRoute();

  @override
  String get location =>
      GoRouteData.$location('/options/networking/emulated-network');

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

RouteBase get $optionsCameraSettingsRoute => GoRouteData.$route(
  path: '/options/camera',
  hasOverriddenOnExit: false,
  factory: $OptionsCameraSettingsRoute._fromState,
);

mixin $OptionsCameraSettingsRoute on GoRouteData {
  static OptionsCameraSettingsRoute _fromState(GoRouterState state) =>
      const OptionsCameraSettingsRoute();

  @override
  String get location => GoRouteData.$location('/options/camera');

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

RouteBase get $optionsControlsSettingsRoute => GoRouteData.$route(
  path: '/options/controls',
  hasOverriddenOnExit: false,
  factory: $OptionsControlsSettingsRoute._fromState,
);

mixin $OptionsControlsSettingsRoute on GoRouteData {
  static OptionsControlsSettingsRoute _fromState(GoRouterState state) =>
      const OptionsControlsSettingsRoute();

  @override
  String get location => GoRouteData.$location('/options/controls');

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

RouteBase get $optionsGraphicsSettingsRoute => GoRouteData.$route(
  path: '/options/graphics',
  hasOverriddenOnExit: false,
  factory: $OptionsGraphicsSettingsRoute._fromState,
);

mixin $OptionsGraphicsSettingsRoute on GoRouteData {
  static OptionsGraphicsSettingsRoute _fromState(GoRouterState state) =>
      const OptionsGraphicsSettingsRoute();

  @override
  String get location => GoRouteData.$location('/options/graphics');

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

RouteBase get $optionsLayoutSettingsRoute => GoRouteData.$route(
  path: '/options/graphics/layout',
  hasOverriddenOnExit: false,
  factory: $OptionsLayoutSettingsRoute._fromState,
);

mixin $OptionsLayoutSettingsRoute on GoRouteData {
  static OptionsLayoutSettingsRoute _fromState(GoRouterState state) =>
      const OptionsLayoutSettingsRoute();

  @override
  String get location => GoRouteData.$location('/options/graphics/layout');

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

RouteBase get $optionsCustomLandscapeLayoutSettingsRoute => GoRouteData.$route(
  path: '/options/graphics/layout/custom-landscape',
  hasOverriddenOnExit: false,
  factory: $OptionsCustomLandscapeLayoutSettingsRoute._fromState,
);

mixin $OptionsCustomLandscapeLayoutSettingsRoute on GoRouteData {
  static OptionsCustomLandscapeLayoutSettingsRoute _fromState(
    GoRouterState state,
  ) => const OptionsCustomLandscapeLayoutSettingsRoute();

  @override
  String get location =>
      GoRouteData.$location('/options/graphics/layout/custom-landscape');

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

RouteBase get $optionsCustomPortraitLayoutSettingsRoute => GoRouteData.$route(
  path: '/options/graphics/layout/custom-portrait',
  hasOverriddenOnExit: false,
  factory: $OptionsCustomPortraitLayoutSettingsRoute._fromState,
);

mixin $OptionsCustomPortraitLayoutSettingsRoute on GoRouteData {
  static OptionsCustomPortraitLayoutSettingsRoute _fromState(
    GoRouterState state,
  ) => const OptionsCustomPortraitLayoutSettingsRoute();

  @override
  String get location =>
      GoRouteData.$location('/options/graphics/layout/custom-portrait');

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

RouteBase get $optionsDebugSettingsRoute => GoRouteData.$route(
  path: '/options/debug',
  hasOverriddenOnExit: false,
  factory: $OptionsDebugSettingsRoute._fromState,
);

mixin $OptionsDebugSettingsRoute on GoRouteData {
  static OptionsDebugSettingsRoute _fromState(GoRouterState state) =>
      const OptionsDebugSettingsRoute();

  @override
  String get location => GoRouteData.$location('/options/debug');

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

RouteBase get $optionsLanguageSettingsRoute => GoRouteData.$route(
  path: '/options/language',
  hasOverriddenOnExit: false,
  factory: $OptionsLanguageSettingsRoute._fromState,
);

mixin $OptionsLanguageSettingsRoute on GoRouteData {
  static OptionsLanguageSettingsRoute _fromState(GoRouterState state) =>
      const OptionsLanguageSettingsRoute();

  @override
  String get location => GoRouteData.$location('/options/language');

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

RouteBase get $optionsThemeSettingsRoute => GoRouteData.$route(
  path: '/options/theme',
  hasOverriddenOnExit: false,
  factory: $OptionsThemeSettingsRoute._fromState,
);

mixin $OptionsThemeSettingsRoute on GoRouteData {
  static OptionsThemeSettingsRoute _fromState(GoRouterState state) =>
      const OptionsThemeSettingsRoute();

  @override
  String get location => GoRouteData.$location('/options/theme');

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
