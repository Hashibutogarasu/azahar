import 'package:flutter/widgets.dart';

import 'gamepad_layout.dart';

/// The area that holds the on-screen controllers. It fills the space it is given, works out the
/// [GamepadLayout] for that space and hands it to the [children], which place themselves in it.
/// Touches that miss every control pass through to what is below.
class GamepadContainer extends StatelessWidget {
  const GamepadContainer({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GamepadLayoutScope(
        layout: GamepadLayout(constraints.biggest),
        child: Stack(fit: StackFit.expand, children: children),
      ),
    );
  }
}
