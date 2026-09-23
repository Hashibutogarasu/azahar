import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';

class CloseGameDialog extends StatelessWidget {
  const CloseGameDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(context: context, builder: (_) => const CloseGameDialog());
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final localizations = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(t.emulation.closeGame),
      content: Text(t.emulation.closeGameMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(localizations.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(localizations.okButtonLabel),
        ),
      ],
    );
  }
}
