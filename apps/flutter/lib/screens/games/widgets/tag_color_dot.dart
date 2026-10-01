import 'package:flutter/material.dart';

/// A small circle showing the color of a tag, outlined so that black and white stay visible on any
/// background.
class TagColorDot extends StatelessWidget {
  const TagColorDot({super.key, required this.color, this.size = 12});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }
}
