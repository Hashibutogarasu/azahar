import 'package:flutter/widgets.dart';

class BottomScreen extends StatelessWidget {
  const BottomScreen({
    super.key,
    required this.textureId,
    required this.size,
    required this.onPointerDown,
    required this.onPointerMove,
    required this.onPointerUp,
  });

  final int? textureId;
  final Size size;
  final void Function(PointerDownEvent event) onPointerDown;
  final void Function(PointerMoveEvent event) onPointerMove;
  final void Function(PointerUpEvent event) onPointerUp;

  @override
  Widget build(BuildContext context) {
    final id = textureId;
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
      child: SizedBox.fromSize(
        size: size,
        child: id == null || id < 0 ? null : Texture(textureId: id),
      ),
    );
  }
}
