import 'package:flutter/widgets.dart';

/// Displays the 3DS top screen rendered by the native side into the texture [textureId].
class TopScreen extends StatelessWidget {
  const TopScreen({super.key, required this.textureId, required this.size});

  final int? textureId;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final id = textureId;
    return SizedBox.fromSize(
      size: size,
      child: id == null || id < 0 ? null : Texture(textureId: id),
    );
  }
}
