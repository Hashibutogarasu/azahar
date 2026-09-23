import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/game.dart';
import 'emulation_screens_layout.dart';
import 'emulation_session_provider.dart';
import 'widgets/bottom_screen.dart';
import 'widgets/close_game_dialog.dart';
import 'widgets/emulation_drawer.dart';
import 'widgets/emulation_loading_card.dart';
import 'widgets/top_screen.dart';

class EmulationPage extends ConsumerStatefulWidget {
  const EmulationPage({super.key, required this.gamePath, this.game});

  final String gamePath;
  final Game? game;

  @override
  ConsumerState<EmulationPage> createState() => _EmulationPageState();
}

class _EmulationPageState extends ConsumerState<EmulationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _launchRequested = false;

  void _requestLaunch(EmulationScreensLayout layout) {
    if (_launchRequested) return;
    if (layout.topScreen.isEmpty || layout.bottomScreen.isEmpty) return;
    _launchRequested = true;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(emulationSessionProvider.notifier).launch(
            gamePath: widget.gamePath,
            layout: layout,
            devicePixelRatio: devicePixelRatio,
          );
    });
  }

  void _handleBackPressed() {
    if (!ref.read(emulationSessionProvider).emulationStarted) return;
    final scaffold = _scaffoldKey.currentState;
    if (scaffold == null) return;
    if (scaffold.isDrawerOpen) {
      scaffold.closeDrawer();
    } else {
      scaffold.openDrawer();
    }
  }

  Future<void> _confirmCloseGame() async {
    final notifier = ref.read(emulationSessionProvider.notifier);
    _scaffoldKey.currentState?.closeDrawer();
    await notifier.pauseForClosePrompt();
    if (!mounted) return;
    final confirmed = await CloseGameDialog.show(context);
    if (!mounted) return;
    if (confirmed == true) {
      await notifier.terminate();
    } else {
      await notifier.cancelClosePrompt();
    }
  }

  Widget _screens(BoxConstraints constraints) {
    final layout = EmulationScreensLayout.fit(constraints.biggest);
    _requestLaunch(layout);
    final notifier = ref.read(emulationSessionProvider.notifier);
    final state = ref.watch(emulationSessionProvider);
    final topScreen = TopScreen(textureId: state.topTextureId, size: layout.topScreen);
    final bottomScreen = BottomScreen(
      textureId: state.bottomTextureId,
      size: layout.bottomScreen,
      onPointerDown: (event) => notifier.touchPressed(event.localPosition, layout.bottomScreen),
      onPointerMove: (event) => notifier.touchMoved(event.localPosition, layout.bottomScreen),
      onPointerUp: (_) => notifier.touchReleased(),
    );
    return Align(
      alignment: Alignment.topCenter,
      child: Flex(
        direction: layout.direction,
        mainAxisSize: MainAxisSize.min,
        children: state.isScreensSwapped
            ? [bottomScreen, topScreen]
            : [topScreen, bottomScreen],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emulationSessionProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPressed();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        drawer: state.emulationStarted
            ? EmulationDrawer(
                gameTitle: widget.game?.title ?? '',
                onCloseGame: _confirmCloseGame,
              )
            : null,
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(builder: (context, constraints) => _screens(constraints)),
              if (!state.emulationStarted)
                Center(
                  child: EmulationLoadingCard(
                    game: widget.game,
                    progress: state.shaderProgress,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
