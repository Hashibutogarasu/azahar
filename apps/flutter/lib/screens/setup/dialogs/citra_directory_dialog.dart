import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../widgets/dialog_cancel_button.dart';

class CitraDirectoryDialog extends StatefulWidget {
  const CitraDirectoryDialog({
    super.key,
    required this.path,
    required this.showMoveDataCheckbox,
  });

  final String path;
  final bool showMoveDataCheckbox;

  static Future<bool?> show(
    BuildContext context, {
    required String path,
    required bool showMoveDataCheckbox,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => CitraDirectoryDialog(
        path: path,
        showMoveDataCheckbox: showMoveDataCheckbox,
      ),
    );
  }

  @override
  State<CitraDirectoryDialog> createState() => _CitraDirectoryDialogState();
}

class _CitraDirectoryDialogState extends State<CitraDirectoryDialog> {
  bool _moveData = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final localizations = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(t.setup.userDirectory.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Uri.parse(widget.path).path),
          if (widget.showMoveDataCheckbox)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _moveData,
              onChanged: (value) => setState(() => _moveData = value ?? false),
              title: Text(t.setup.userDirectory.moveData),
            ),
        ],
      ),
      actions: [
        const DialogCancelButton(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_moveData),
          child: Text(localizations.okButtonLabel),
        ),
      ],
    );
  }
}
