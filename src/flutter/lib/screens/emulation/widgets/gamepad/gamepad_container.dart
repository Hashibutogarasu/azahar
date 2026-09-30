import 'package:flutter/widgets.dart';

/// The area that holds the on-screen controllers and places each one: the [crossKey] at the top
/// left, the [dpad] at the bottom left, the [faceButtons] at the right and the [menuButtons] in a
/// row at the bottom.
class GamepadContainer extends StatelessWidget {
  const GamepadContainer({
    super.key,
    required this.crossKey,
    required this.dpad,
    required this.faceButtons,
    required this.menuButtons,
  });

  final Widget crossKey;
  final Widget dpad;
  final Widget faceButtons;
  final Widget menuButtons;

  static const double _stickSize = 120;
  static const double _margin = 16;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _margin,
          top: _margin,
          child: SizedBox.square(dimension: _stickSize, child: crossKey),
        ),
        Positioned(
          left: _margin,
          bottom: _margin,
          child: SizedBox.square(dimension: _stickSize, child: dpad),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: _margin),
            child: faceButtons,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: _margin),
            child: menuButtons,
          ),
        ),
      ],
    );
  }
}
