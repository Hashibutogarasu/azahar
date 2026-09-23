import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_services.dart';
import 'errors/app_exception.dart';
import 'i18n/translations.g.dart';
import 'native/applet_channel.dart';
import 'routing/app_routes.dart';
import 'screens/settings/settings_routes.dart' as settings;
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// Reports an [AppException] to the user via a snackbar, from wherever it was thrown, without
/// that call site needing a [BuildContext].
void reportAppException(AppException error) {
  _scaffoldMessengerKey.currentState
    ?..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(error.message)));
}

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      AppletChannel(_navigatorKey);

      final defaultOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exception case final AppException error) {
          reportAppException(error);
        } else {
          defaultOnError?.call(details);
        }
      };

      runApp(const AzaharApp());
    },
    (error, stackTrace) {
      if (error is AppException) {
        reportAppException(error);
      } else {
        FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stackTrace));
      }
    },
  );
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
            scaffoldMessengerKey: _scaffoldMessengerKey,
          );
        },
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  navigatorKey: _navigatorKey,
  routes: [...$appRoutes, ...settings.$appRoutes],
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
