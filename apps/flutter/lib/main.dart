import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'app_services.dart';
import 'data/settings/debug_settings_provider.dart';
import 'data/user_directory_bootstrap.dart';
import 'errors/app_exception.dart';
import 'i18n/translations.g.dart';
import 'routing/app_routes.dart';
import 'screens/settings/settings_routes.dart' as legacy_settings;
import 'theme/app_theme.dart';
import 'theme/no_overscroll_indicator_behavior.dart';
import 'theme/theme_settings_provider.dart';

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

void main(List<String> args) {
  FlutterError.demangleStackTrace = (stack) => switch (stack) {
    stack_trace.Chain() => stack.toTrace().vmTrace,
    stack_trace.Trace() => stack.vmTrace,
    _ => stack,
  };
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initializeRust();
      AppServices.loggingService.start();
      await AppServices.migrateKeyValueRepositories();
      await AppServices.profileService.initialize();
      await applyDebugSettings(
        await AppServices.debugSettingsRepository.read(),
      );

      if (Platform.isLinux) {
        late final AppLifecycleListener exitListener;
        exitListener = AppLifecycleListener(
          onExitRequested: () async {
            await UserDirectoryBootstrap.cleanupIfUnconfigured();
            exitListener.dispose();
            return AppExitResponse.exit;
          },
        );
      }

      AppletChannel(
        _navigatorKey,
        stringsOf: (context) => AppletStrings(
          cancel: context.t.common.cancel,
          iForgot: context.t.applets.iForgot,
          standardMii: context.t.applets.standardMii,
          softwareKeyboard: context.t.applets.softwareKeyboard,
        ),
      );

      final defaultOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exception case final AppException error) {
          reportAppException(error);
        } else {
          defaultOnError?.call(details);
        }
      };

      runApp(const ProviderScope(child: AzaharApp()));
    },
    (error, stackTrace) {
      if (error is AppException) {
        reportAppException(error);
      } else {
        FlutterError.reportError(
          FlutterErrorDetails(exception: error, stack: stackTrace),
        );
      }
    },
  );
}

class AzaharApp extends ConsumerWidget {
  const AzaharApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsProvider);
    return TranslationProvider(
      child: Builder(
        builder: (context) {
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              return MaterialApp.router(
                title: context.t.appName,
                themeMode: _themeMode(themeSettings.themeMode),
                theme: AppTheme.light(
                  style: themeSettings.themeStyle,
                  staticThemeColor: themeSettings.staticThemeColor,
                  materialYou: themeSettings.materialYou,
                  dynamicScheme: lightDynamic,
                ),
                darkTheme: AppTheme.dark(
                  style: themeSettings.themeStyle,
                  staticThemeColor: themeSettings.staticThemeColor,
                  blackBackgrounds: themeSettings.blackBackgrounds,
                  materialYou: themeSettings.materialYou,
                  dynamicScheme: darkDynamic,
                ),
                scrollBehavior: const NoOverscrollIndicatorBehavior(),
                routerConfig: _router,
                scaffoldMessengerKey: _scaffoldMessengerKey,
              );
            },
          );
        },
      ),
    );
  }

  ThemeMode _themeMode(String value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}

final GoRouter _router = GoRouter(
  navigatorKey: _navigatorKey,
  // The `/settings` hub itself is never linked to from the current UI (only reachable through
  // the legacy Options UI, via useLegacySettingsUI); its route tree stays registered so that
  // legacy UI still works end-to-end.
  routes: [...$appRoutes, ...legacy_settings.$appRoutes],
  redirect: (context, state) async {
    final isFirstLaunch = await AppServices.firstLaunchRepository
        .isFirstApplicationLaunch();
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
