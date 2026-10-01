import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../app_services.dart';
import '../../data/platform_provider.dart';
import '../../data/repositories/cheat_repository.dart';
import 'emulation_screens_layout.dart';
import 'emulation_session_provider.dart';
import 'motion_input_source.dart';
import 'physical_gamepad_source.dart';
import 'widgets/bottom_screen.dart';
import 'widgets/cheats_dialog.dart';
import 'widgets/close_game_dialog.dart';
import 'widgets/emulation_drawer.dart';
import 'widgets/gamepad/emulation_gamepad.dart';
import 'widgets/emulation_loading_card.dart';
import 'widgets/emulation_menu_actions.dart';
import 'widgets/emulation_side_panel.dart';
import 'widgets/top_screen.dart';

class EmulationPage extends ConsumerStatefulWidget {
  const EmulationPage({super.key, required this.gamePath, this.game});

  final String gamePath;
  final Game? game;

  @override
  ConsumerState<EmulationPage> createState() => _EmulationPageState();
}

class _EmulationPageState extends ConsumerState<EmulationPage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _launchRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    await ref.read(emulationSessionProvider.notifier).stopForExit();
    return AppExitResponse.exit;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(emulationSessionProvider.notifier);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        notifier.handleAppBackground();
      case AppLifecycleState.resumed:
        notifier.handleAppForeground();
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  void _requestLaunch(EmulationScreensLayout layout) {
    if (_launchRequested) return;
    if (layout.topScreen.isEmpty || layout.bottomScreen.isEmpty) return;
    _launchRequested = true;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(emulationSessionProvider.notifier)
          .launch(
            gamePath: widget.gamePath,
            layout: layout,
            devicePixelRatio: devicePixelRatio,
          );
    });
  }

  void _requestMediaSessionActivation() {
    final game = widget.game;
    if (game == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(emulationSessionProvider.notifier)
          .activateMediaSessionIfNeeded(game);
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

  Future<void> _openCheats() async {
    final game = widget.game;
    if (game == null) return;
    final notifier = ref.read(emulationSessionProvider.notifier);
    final wasPaused = ref.read(emulationSessionProvider).isPaused;
    await notifier.pauseForClosePrompt();
    try {
      if (!mounted) return;
      await CheatsDialog.show(
        context,
        repository: CheatRepository(AppServices.nativeBridge, game.titleId),
      );
    } finally {
      if (!wasPaused) await notifier.cancelClosePrompt();
    }
  }

  Widget _screens(BoxConstraints constraints) {
    final isDesktop = ref.watch(isDesktopPlatformProvider);
    final layout = EmulationScreensLayout.fit(
      constraints.biggest,
      isDesktop: isDesktop,
    );
    _requestLaunch(layout);
    _requestMediaSessionActivation();
    final notifier = ref.read(emulationSessionProvider.notifier);
    final state = ref.watch(emulationSessionProvider);
    final topScreen = TopScreen(
      textureId: state.topTextureId,
      size: layout.topScreen,
    );
    final bottomScreen = BottomScreen(
      textureId: state.bottomTextureId,
      size: layout.bottomScreen,
      onPointerDown: (event) =>
          notifier.touchPressed(event.localPosition, layout.bottomScreen),
      onPointerMove: (event) =>
          notifier.touchMoved(event.localPosition, layout.bottomScreen),
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
    ref.listen(emulationSessionProvider.select((state) => state.isFinished), (
      _,
      isFinished,
    ) {
      if (isFinished) Navigator.of(context).pop();
    });
    final state = ref.watch(emulationSessionProvider);
    if (state.isClosingWindow) {
      return const ColoredBox(color: Colors.black);
    }
    final isDesktop = ref.watch(isDesktopPlatformProvider);
    final notifier = ref.read(emulationSessionProvider.notifier);
    final actions = EmulationMenuActions(
      onTogglePause: notifier.togglePause,
      onAdvanceFrame: notifier.advanceFrame,
      onCheats: widget.game == null ? null : _openCheats,
      onCloseGame: _confirmCloseGame,
    );
    final screens = SafeArea(
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => _screens(constraints),
          ),
          if (!state.emulationStarted || state.isTerminating)
            Center(
              child: EmulationLoadingCard(
                gamePath: widget.gamePath,
                game: widget.game,
                progress: state.shaderProgress,
                isTerminating: state.isTerminating,
              ),
            ),
        ],
      ),
    );
    final page = PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPressed();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        drawerEnableOpenDragGesture: false,
        drawer: !isDesktop && state.emulationStarted
            ? EmulationDrawer(
                gamePath: widget.gamePath,
                game: widget.game,
                isPaused: state.isPaused,
                actions: actions,
              )
            : null,
        body: isDesktop && state.emulationStarted
            ? Stack(
                children: [
                  screens,
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: EmulationSidePanel(
                      gamePath: widget.gamePath,
                      isPaused: state.isPaused,
                      actions: actions,
                    ),
                  ),
                ],
              )
            : !isDesktop && state.emulationStarted
            ? Stack(
                children: [
                  screens,
                  const Positioned.fill(child: EmulationGamepad()),
                ],
              )
            : screens,
      ),
    );
    return PhysicalGamepadSource(
      child: isDesktop ? page : MotionInputSource(child: page),
    );
  }
}
