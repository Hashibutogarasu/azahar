import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamepads/gamepads.dart';

import '../../../i18n/translations.g.dart';
import '../../../widgets/dialog_cancel_button.dart';

/// Waits for the next gamepad button press and pops its key.
class InputBindingDialog extends StatefulWidget {
  const InputBindingDialog({super.key, required this.title});

  final String title;

  static Future<String?> show(BuildContext context, {required String title}) {
    return showDialog<String>(
      context: context,
      builder: (_) => InputBindingDialog(title: title),
    );
  }

  @override
  State<InputBindingDialog> createState() => _InputBindingDialogState();
}

class _InputBindingDialogState extends State<InputBindingDialog> {
  StreamSubscription<GamepadEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = Gamepads.events
        .where((event) => event.type == KeyType.button && event.value > 0.5)
        .listen((event) {
          if (mounted) Navigator.of(context).pop(event.key);
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(context.t.settings.inputBindingDialog.waitingForInput),
      actions: const [DialogCancelButton()],
    );
  }
}
