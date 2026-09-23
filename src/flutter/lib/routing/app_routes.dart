import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../models/game.dart';
import '../screens/emulation/emulation_page.dart';
import '../screens/games/games_list_page.dart';
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

@TypedGoRoute<GamesListRoute>(path: '/')
class GamesListRoute extends GoRouteData with $GamesListRoute {
  const GamesListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GamesListPage();
  }
}

@TypedGoRoute<EmulationRoute>(path: '/emulation/:gamePath')
class EmulationRoute extends GoRouteData with $EmulationRoute {
  const EmulationRoute({required this.gamePath, this.$extra});

  final String gamePath;
  final Game? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EmulationPage(gamePath: Uri.decodeComponent(gamePath), game: $extra);
  }
}
