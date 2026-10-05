import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'app_services.dart';
import 'data/settings/debug_settings_provider.dart';
import 'errors/app_exception.dart';
import 'i18n/translations.g.dart';
import 'routing/app_routes.dart';
import 'screens/profiles/legacy_data_prompt_page.dart';
import 'screens/settings/settings_routes.dart' as legacy_settings;
import 'theme/app_theme.dart';
import 'theme/no_overscroll_indicator_behavior.dart';
import 'theme/theme_settings_provider.dart';
import 'theme/theme_style.dart';
import 'widgets/gamepad/gamepad_action_host.dart';

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
      await AppServices.prepareMasterDatabase();
      AppServices.loggingService.start();
      await _initializeProfiles();
      await applyDebugSettings(
        await AppServices.debugSettingsRepository.read(),
      );

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

      runApp(const AzaharRoot());
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

/// Initializes the profiles, first asking whether to move the core data left in the app data
/// folder when there is any.
Future<void> _initializeProfiles() async {
  final profileService = AppServices.profileService;
  if (!await profileService.shouldAskLegacyMigration()) {
    await profileService.initialize();
    return;
  }
  final systemDirectory = await AppServices.locationsRepository
      .systemDirectory();
  final done = Completer<void>();
  runApp(
    TranslationProvider(
      child: MaterialApp(
        theme: AppTheme.light(style: ThemeStyle.azahar),
        darkTheme: AppTheme.dark(style: ThemeStyle.azahar),
        home: LegacyDataPromptPage(
          path: systemDirectory.path,
          onChoice: (migrate) =>
              profileService.initialize(migrateLegacyData: migrate),
          onDone: done.complete,
        ),
      ),
    ),
  );
  await done.future;
}

/// Rebuilds the whole app, with fresh providers, whenever another user database is opened. While
/// the database is being replaced the app is taken down, so nothing reads the closing one.
class AzaharRoot extends StatefulWidget {
  const AzaharRoot({super.key});

  @override
  State<AzaharRoot> createState() => _AzaharRootState();
}

class _AzaharRootState extends State<AzaharRoot> {
  final _sessions = AppServices.userSessions;

  @override
  void initState() {
    super.initState();
    _sessions.markShown();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_sessions.generation, _sessions.reopening]),
      builder: (context, _) {
        if (_sessions.reopening.value) return const SizedBox.shrink();
        return ProviderScope(
          key: ValueKey(_sessions.generation.value),
          child: const AzaharApp(),
        );
      },
    );
  }
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
                shortcuts: _shortcutsWithoutGameButtons(),
                builder: (context, child) => GamepadActionHost(
                  navigatorKey: _navigatorKey,
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// The default shortcuts of the platform without the ones bound to gamepad buttons, which the
  /// gamepad actions handle instead, so that a button press does not act twice.
  static Map<ShortcutActivator, Intent> _shortcutsWithoutGameButtons() {
    return {
      for (final MapEntry(:key, :value) in WidgetsApp.defaultShortcuts.entries)
        if (!_isGameButton(key)) key: value,
    };
  }

  static bool _isGameButton(ShortcutActivator activator) {
    final triggers = activator.triggers;
    if (triggers == null) return false;
    return triggers.any(
      (key) =>
          key.keyId >= LogicalKeyboardKey.gameButton1.keyId &&
          key.keyId <= LogicalKeyboardKey.gameButtonZ.keyId,
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
