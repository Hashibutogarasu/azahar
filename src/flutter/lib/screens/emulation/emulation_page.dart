import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../models/game.dart';
import 'emulation_view_model.dart';
import 'widgets/emulation_loading_card.dart';

class EmulationPage extends StatefulWidget {
  const EmulationPage({super.key, required this.gamePath, this.game});

  final String gamePath;
  final Game? game;

  @override
  State<EmulationPage> createState() => _EmulationPageState();
}

class _EmulationPageState extends State<EmulationPage> {
  final EmulationViewModel _viewModel = EmulationViewModel(AppServices.nativeBridge);

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mediaQuery = MediaQuery.of(context);
      _viewModel.start(
        widget.gamePath,
        maxWidth: mediaQuery.size.width,
        maxHeight: mediaQuery.size.height,
        devicePixelRatio: mediaQuery.devicePixelRatio,
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

  Widget _screen(int? textureId, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: textureId == null || textureId < 0 ? null : Texture(textureId: textureId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topScreen = _screen(
      _viewModel.topTextureId,
      _viewModel.topScreenWidth,
      _viewModel.topScreenHeight,
    );
    final bottomScreen = _screen(
      _viewModel.bottomTextureId,
      _viewModel.bottomScreenWidth,
      _viewModel.bottomScreenHeight,
    );
    final screens = _viewModel.isScreensSwapped
        ? [bottomScreen, topScreen]
        : [topScreen, bottomScreen];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: screens,
              ),
            ),
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
    );
  }
}
