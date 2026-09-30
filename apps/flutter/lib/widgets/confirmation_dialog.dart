import 'package:flutter/material.dart';

import 'dialog_cancel_button.dart';

/// A generic "are you sure?" prompt: a title, a message, [DialogCancelButton], and a single
/// confirm action. Used by every plain confirmation dialog in the app instead of each one
/// building its own `AlertDialog`.
class ConfirmationDialog {
  const ConfirmationDialog._();

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          const DialogCancelButton(),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}
