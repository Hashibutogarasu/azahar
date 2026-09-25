import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../widgets/dialog_cancel_button.dart';

class ArticBaseConnectDialog extends StatefulWidget {
  const ArticBaseConnectDialog({super.key, required this.initialAddress});

  final String initialAddress;

  static Future<String?> show(BuildContext context, {required String initialAddress}) {
    return showDialog<String>(
      context: context,
      builder: (_) => ArticBaseConnectDialog(initialAddress: initialAddress),
    );
  }

  @override
  State<ArticBaseConnectDialog> createState() => _ArticBaseConnectDialogState();
}

class _ArticBaseConnectDialogState extends State<ArticBaseConnectDialog> {
  late final _controller = TextEditingController(text: widget.initialAddress);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final localizations = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(t.articBaseConnectDialog.title),
      content: TextField(controller: _controller),
      actions: [
        const DialogCancelButton(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(localizations.okButtonLabel),
        ),
      ],
    );
  }
}
