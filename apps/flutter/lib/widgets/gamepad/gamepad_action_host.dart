import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/gamepad/actions/gamepad_action_manager.dart';
import '../../data/gamepad/gamepad_hub.dart';

/// Keeps the [gamepadActionManagerProvider] running for as long as the app is shown, hands it
/// the root navigator, and switches the input mode back to touch whenever the screen is touched.
class GamepadActionHost extends ConsumerStatefulWidget {
  const GamepadActionHost({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  ConsumerState<GamepadActionHost> createState() => _GamepadActionHostState();
}

class _GamepadActionHostState extends ConsumerState<GamepadActionHost> {
  @override
  void initState() {
    super.initState();
    ref.read(gamepadActionManagerProvider.notifier).attach(widget.navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(gamepadActionManagerProvider, (_, _) {});
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) =>
          ref.read(gamepadInputModeProvider.notifier).markTouch(),
      child: widget.child,
    );
  }
}
