import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app_services.dart';
import '../../models/game.dart';
import '../../routing/app_routes.dart';
import 'emulation_screens_layout.dart';
import 'emulation_view_model.dart';
import 'widgets/bottom_screen.dart';
import 'widgets/close_game_dialog.dart';
import 'widgets/emulation_drawer.dart';
import 'widgets/emulation_loading_card.dart';
import 'widgets/top_screen.dart';

class EmulationPage extends StatefulWidget {
  const EmulationPage({super.key, required this.gamePath, this.game});

  final String gamePath;
  final Game? game;

  @override
  State<EmulationPage> createState() => _EmulationPageState();
}

class _EmulationPageState extends State<EmulationPage> {
  final EmulationViewModel _viewModel = EmulationViewModel(AppServices.nativeBridge);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _startRequested = false;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _requestStart(EmulationScreensLayout layout) {
    if (_startRequested) return;
    _startRequested = true;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.start(
        widget.gamePath,
        layout: layout,
        devicePixelRatio: devicePixelRatio,
      );
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() => setState(() {});

  /// Toggles the drawer, mirroring the original app's back-key handling. Ignored while the game
  /// hasn't started yet.
  void _handleBackPressed() {
    if (!_viewModel.emulationStarted) return;
    final scaffold = _scaffoldKey.currentState;
    if (scaffold == null) return;
    if (scaffold.isDrawerOpen) {
      scaffold.closeDrawer();
    } else {
      scaffold.openDrawer();
    }
  }

  Future<void> _confirmCloseGame() async {
    _scaffoldKey.currentState?.closeDrawer();
    await _viewModel.pauseForClosePrompt();
    if (!mounted) return;
    final confirmed = await CloseGameDialog.show(context);
    if (!mounted) return;
    if (confirmed == true) {
      if (context.canPop()) {
        context.pop();
      } else {
        const GamesListRoute().go(context);
      }
    } else {
      await _viewModel.cancelClosePrompt();
    }
  }

  Widget _screens(BoxConstraints constraints) {
    final layout = EmulationScreensLayout.fit(constraints.biggest);
    _requestStart(layout);
    final topScreen = TopScreen(textureId: _viewModel.topTextureId, size: layout.topScreen);
    final bottomScreen = BottomScreen(viewModel: _viewModel, size: layout.bottomScreen);
    return Align(
      alignment: Alignment.topCenter,
      child: Flex(
        direction: layout.direction,
        mainAxisSize: MainAxisSize.min,
        children: _viewModel.isScreensSwapped
            ? [bottomScreen, topScreen]
            : [topScreen, bottomScreen],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPressed();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        drawer: _viewModel.emulationStarted
            ? EmulationDrawer(
                gameTitle: widget.game?.title ?? '',
                onCloseGame: _confirmCloseGame,
              )
            : null,
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(builder: (context, constraints) => _screens(constraints)),
              if (!_viewModel.emulationStarted)
                Center(
                  child: EmulationLoadingCard(
                    game: widget.game,
                    progress: _viewModel.shaderProgress,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
