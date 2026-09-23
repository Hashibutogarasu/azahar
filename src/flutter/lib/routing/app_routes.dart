import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../screens/games/games_list_page.dart';
import '../screens/home/app_shell.dart';
import '../screens/options/about_page.dart';
import '../screens/options/gpu_driver_manager_page.dart';
import '../screens/options/options_page.dart';
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
  const OptionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OptionsPage();
  }
}
