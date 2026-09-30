import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../emulation_session_provider.dart';
import 'gamepad_button.dart';
import 'gamepad_container.dart';
import 'gamepad_cross_key.dart';
import 'gamepad_dpad.dart';
import 'gamepad_menu_buttons.dart';

/// The on-screen controllers of the emulation, placed in a [GamepadContainer] the way the original
/// Android app places them and connected to the emulation session, so that touching them operates
/// the game.
class EmulationGamepad extends ConsumerWidget {
  const EmulationGamepad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(emulationSessionProvider.notifier);
    void onButton(GamePadButton button, bool pressed) =>
        notifier.sendGamePadButton(button, pressed: pressed);
    return GamepadContainer(
      children: [
        GamepadShoulderButtons(onButton: onButton),
        GamepadFaceButtons(onButton: onButton),
        GamepadMenuButtons(onButton: onButton),
        GamepadCrossKey(onButton: onButton),
        GamepadDPad(
          onMoved: (x, y) => notifier.sendGamePadAxis(GamePadAxis.dpad, x, y),
        ),
      ],
    );
  }
}
