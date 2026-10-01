import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app_services.dart';
import '../data/settings/settings_load_provider.dart';
import '../screens/games/games_list_page.dart';
import '../screens/home/app_shell.dart';
import '../screens/home/slide_branch_container.dart';
import '../screens/options/about_page.dart';
import '../screens/options/emulated_network_page.dart';
import '../screens/options/gpu_driver_manager_page.dart';
import '../screens/options/legacy_options_page.dart';
import '../screens/options/options_page.dart';
import '../screens/options/system_files_page.dart';
import '../screens/settings/sections/accessibility_settings_page.dart';
import '../screens/settings/sections/advanced_settings_page.dart';
import '../screens/settings/sections/camera_settings_page.dart';
import '../screens/settings/sections/controls_settings_page.dart';
import '../screens/settings/sections/debug_settings_page.dart';
import '../screens/settings/sections/feature_flags_page.dart';
import '../screens/settings/sections/general_settings_page.dart';
import '../screens/settings/sections/graphics_settings_page.dart';
import '../screens/settings/sections/language_settings_page.dart';
import '../screens/settings/sections/layout_settings_page.dart';
import '../screens/settings/sections/media_settings_page.dart';
import '../screens/settings/sections/theme_settings_page.dart';
import '../screens/setup/setup_wizard_page.dart';
import 'app_route_data.dart';

part 'app_routes.g.dart';
part 'options_page_routes.dart';

@TypedGoRoute<SetupRoute>(path: '/setup')
class SetupRoute extends AppRouteData with $SetupRoute {
  const SetupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SetupWizardPage();
  }
}

@TypedGoRoute<AboutRoute>(path: '/about')
class AboutRoute extends AppRouteData with $AboutRoute {
  const AboutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutPage();
  }
}

@TypedGoRoute<GpuDriverManagerRoute>(path: '/gpu-driver-manager')
class GpuDriverManagerRoute extends AppRouteData with $GpuDriverManagerRoute {
  const GpuDriverManagerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GpuDriverManagerPage();
  }
}

@TypedGoRoute<SystemFilesRoute>(path: '/system-files')
class SystemFilesRoute extends AppRouteData with $SystemFilesRoute {
  const SystemFilesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SystemFilesPage();
  }
}

@TypedStatefulShellRoute<AppShellRouteData>(
  branches: [
    TypedStatefulShellBranch<GamesBranchData>(
      routes: [TypedGoRoute<GamesListRoute>(path: '/')],
    ),
    TypedStatefulShellBranch<OptionsBranchData>(
      routes: [TypedGoRoute<OptionsRoute>(path: '/options')],
    ),
  ],
)
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  static const ShellNavigationContainerBuilder $navigatorContainerBuilder =
      slideBranchContainerBuilder;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return AppShell(navigationShell: navigationShell);
  }
}

class GamesBranchData extends StatefulShellBranchData {
  const GamesBranchData();
}

class GamesListRoute extends GoRouteData with $GamesListRoute {
  const GamesListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GamesListPage();
  }
}

class OptionsBranchData extends StatefulShellBranchData {
  const OptionsBranchData();
}

class OptionsRoute extends GoRouteData with $OptionsRoute {
  const OptionsRoute({this.isLegacy});

  /// Overrides which Options UI to show. When omitted, falls back to
  /// [AppServices.legacySettingsUiRepository]'s `useLegacySettingsUI` setting.
  final bool? isLegacy;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    if (isLegacy != null) {
      // ignore: deprecated_member_use_from_same_package
      return isLegacy! ? const LegacyOptionsPage() : const OptionsPage();
    }
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(settingsLoadProvider);
        final useLegacy =
            AppServices.legacySettingsUiRepository.useLegacySettingsUI;
        // ignore: deprecated_member_use_from_same_package
        return useLegacy ? const LegacyOptionsPage() : const OptionsPage();
      },
    );
  }
}
