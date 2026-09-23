import 'package:flutter/material.dart';

import 'app_services.dart';
import 'i18n/translations.g.dart';
import 'models/game.dart';
import 'screens/emulation/emulation_page.dart';
import 'theme/app_theme.dart';

const String emulationRoutePrefix = '/__emulation__/';

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
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: EmulationPage(gamePath: widget.gamePath, game: _game),
      ),
    );
  }
}
