import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app_services.dart';
import '../data/settings/settings_load_provider.dart';
import '../screens/games/games_list_page.dart';
import '../screens/home/app_shell.dart';
import '../screens/options/about_page.dart';
import '../screens/options/gpu_driver_manager_page.dart';
import '../screens/options/legacy_options_page.dart';
import '../screens/options/options_page.dart';
import '../screens/options/system_files_page.dart';
import '../screens/setup/setup_wizard_page.dart';

part 'app_routes.g.dart';

@TypedGoRoute<SetupRoute>(path: '/setup')
class SetupRoute extends GoRouteData with $SetupRoute {
  const SetupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SetupWizardPage();
  }
}

@TypedGoRoute<AboutRoute>(path: '/about')
class AboutRoute extends GoRouteData with $AboutRoute {
  const AboutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutPage();
  }
}

@TypedGoRoute<GpuDriverManagerRoute>(path: '/gpu-driver-manager')
class GpuDriverManagerRoute extends GoRouteData with $GpuDriverManagerRoute {
  const GpuDriverManagerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GpuDriverManagerPage();
  }
}

@TypedGoRoute<SystemFilesRoute>(path: '/system-files')
class SystemFilesRoute extends GoRouteData with $SystemFilesRoute {
  const SystemFilesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SystemFilesPage();
  }
}

@TypedStatefulShellRoute<AppShellRouteData>(
  branches: [
    TypedStatefulShellBranch<GamesBranchData>(routes: [TypedGoRoute<GamesListRoute>(path: '/')]),
    TypedStatefulShellBranch<OptionsBranchData>(
      routes: [TypedGoRoute<OptionsRoute>(path: '/options')],
    ),
  ],
)
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

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
  /// [AppServices.settingsRepository]'s `useLegacySettingsUI` setting.
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
        final useLegacy = AppServices.settingsRepository.useLegacySettingsUI;
        // ignore: deprecated_member_use_from_same_package
        return useLegacy ? const LegacyOptionsPage() : const OptionsPage();
      },
    );
  }
}
