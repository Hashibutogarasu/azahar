import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../widgets/confirmation_dialog.dart';

class CloseGameDialog {
  const CloseGameDialog._();

  static Future<bool> show(BuildContext context) {
    final t = context.t;
    return ConfirmationDialog.show(
      context,
      title: t.emulation.closeGame,
      message: t.emulation.closeGameMessage,
      confirmLabel: MaterialLocalizations.of(context).okButtonLabel,
    );
  }
}
