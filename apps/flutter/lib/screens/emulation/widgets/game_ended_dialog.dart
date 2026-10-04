import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';

/// Asks whether to save or discard the changes after the game itself asked to end. It cannot be
/// dismissed, since the game has stopped and one of the two has to be chosen.
class GameEndedDialog {
  const GameEndedDialog._();

  /// Returns true to save the changes and false to discard them.
  static Future<bool> show(BuildContext context) async {
    final t = context.t;
    final save = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(t.emulation.gameEndedTitle),
          content: Text(t.emulation.gameEndedMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(t.emulation.discard),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(t.emulation.save),
            ),
          ],
        ),
      ),
    );
    return save ?? true;
  }
}
