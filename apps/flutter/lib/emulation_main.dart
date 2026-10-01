import 'package:flutter/material.dart';

import 'app_services.dart';
import 'i18n/translations.g.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'screens/emulation/emulation_page.dart';
import 'theme/app_theme.dart';
import 'theme/no_overscroll_indicator_behavior.dart';
import 'theme/theme_style.dart';

const String emulationRoutePrefix = '/__emulation__/';
const String emulationArgument = '--emulation';

class EmulationStandaloneApp extends StatefulWidget {
  const EmulationStandaloneApp({super.key, required this.gamePath});

  final String gamePath;

  @override
  State<EmulationStandaloneApp> createState() => _EmulationStandaloneAppState();
}

class _EmulationStandaloneAppState extends State<EmulationStandaloneApp> {
  Game? _game;

  @override
  void initState() {
    super.initState();
    AppServices.gameRepository.gameByPath(widget.gamePath).then((game) {
      if (mounted) setState(() => _game = game);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: MaterialApp(
        theme: AppTheme.light(style: ThemeStyle.azahar),
        darkTheme: AppTheme.dark(style: ThemeStyle.azahar),
        scrollBehavior: const NoOverscrollIndicatorBehavior(),
        home: EmulationPage(gamePath: widget.gamePath, game: _game),
      ),
    );
  }
}
