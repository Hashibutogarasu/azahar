import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_services.dart';
import 'i18n/translations.g.dart';
import 'native/applet_channel.dart';
import 'routing/app_routes.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppletChannel(_navigatorKey);
  runApp(const AzaharApp());
}

class AzaharApp extends StatelessWidget {
  const AzaharApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: context.t.appName,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  navigatorKey: _navigatorKey,
  routes: $appRoutes,
  redirect: (context, state) async {
    final isFirstLaunch = await AppServices.settingsRepository.isFirstApplicationLaunch();
    final isGoingToSetup = state.matchedLocation == const SetupRoute().location;
    if (isFirstLaunch && !isGoingToSetup) {
      return const SetupRoute().location;
    }
    if (!isFirstLaunch && isGoingToSetup) {
      return const GamesListRoute().location;
    }
    return null;
  },
);
