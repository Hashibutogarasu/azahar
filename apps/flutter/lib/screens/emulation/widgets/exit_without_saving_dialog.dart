import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../widgets/confirmation_dialog.dart';

/// Asks before the changes the game made since it started are discarded.
class ExitWithoutSavingDialog {
  const ExitWithoutSavingDialog._();

  static Future<bool> show(BuildContext context) {
    final t = context.t;
    return ConfirmationDialog.show(
      context,
      title: t.emulation.exitWithoutSaving,
      message: t.emulation.exitWithoutSavingMessage,
      confirmLabel: MaterialLocalizations.of(context).okButtonLabel,
    );
  }
}
