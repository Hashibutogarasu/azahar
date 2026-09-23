import 'package:flutter/widgets.dart';

import '../emulation_view_model.dart';

/// Displays the 3DS bottom screen rendered by the native side and forwards touches on it to
/// [viewModel] as 3DS touchscreen input.
class BottomScreen extends StatelessWidget {
  const BottomScreen({super.key, required this.viewModel, required this.size});

  final EmulationViewModel viewModel;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final id = viewModel.bottomTextureId;
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) => viewModel.touchPressed(event.localPosition, size),
      onPointerMove: (event) => viewModel.touchMoved(event.localPosition, size),
      onPointerUp: (_) => viewModel.touchReleased(),
      child: SizedBox.fromSize(
        size: size,
        child: id == null || id < 0 ? null : Texture(textureId: id),
      ),
    );
  }
}
