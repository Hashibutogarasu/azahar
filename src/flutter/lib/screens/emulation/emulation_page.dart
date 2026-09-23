import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../models/game.dart';
import 'emulation_screens_layout.dart';
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

  Widget _screen(int? textureId, Size size) {
    return SizedBox.fromSize(
      size: size,
      child: textureId == null || textureId < 0 ? null : Texture(textureId: textureId),
    );
  }

  Widget _screens(BoxConstraints constraints) {
    final layout = EmulationScreensLayout.fit(constraints.biggest);
    _requestStart(layout);
    final topScreen = _screen(_viewModel.topTextureId, layout.topScreen);
    final bottomScreen = _screen(_viewModel.bottomTextureId, layout.bottomScreen);
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
    return Scaffold(
      backgroundColor: Colors.black,
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
    );
  }
}
