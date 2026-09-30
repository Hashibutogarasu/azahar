import 'package:flutter/material.dart';

import '../../../widgets/dialog_cancel_button.dart';

/// Edits a single line of text, popping the entered text.
class TextInputDialog extends StatefulWidget {
  const TextInputDialog({
    super.key,
    required this.title,
    required this.initialText,
    this.maxLength,
  });

  final String title;
  final String initialText;
  final int? maxLength;

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String initialText,
    int? maxLength,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => TextInputDialog(
        title: title,
        initialText: initialText,
        maxLength: maxLength,
      ),
    );
  }

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(controller: _controller, maxLength: widget.maxLength),
      actions: [
        const DialogCancelButton(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
