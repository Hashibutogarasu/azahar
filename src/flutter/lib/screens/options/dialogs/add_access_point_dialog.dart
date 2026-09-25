import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../models/access_point.dart';
import '../../../widgets/dialog_cancel_button.dart';

class AddAccessPointDialog extends StatefulWidget {
  const AddAccessPointDialog({super.key});

  static Future<AccessPoint?> show(BuildContext context) {
    return showDialog<AccessPoint>(context: context, builder: (_) => const AddAccessPointDialog());
  }

  @override
  State<AddAccessPointDialog> createState() => _AddAccessPointDialogState();
}

class _AddAccessPointDialogState extends State<AddAccessPointDialog> {
  final _ssidController = TextEditingController();
  final _bssidController = TextEditingController();
  final _frequencyController = TextEditingController(text: '2437');
  final _levelController = TextEditingController(text: '-50');

  @override
  void dispose() {
    _ssidController.dispose();
    _bssidController.dispose();
    _frequencyController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _add() {
    Navigator.of(context).pop(
      AccessPoint(
        ssid: _ssidController.text,
        bssid: _bssidController.text,
        frequency: int.tryParse(_frequencyController.text) ?? 0,
        level: int.tryParse(_levelController.text) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final n = t.settings.networking;
    return AlertDialog(
      title: Text(n.addAccessPoint),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ssidController,
            decoration: InputDecoration(labelText: n.ssid, hintText: n.ssidHint),
          ),
          TextField(
            controller: _bssidController,
            decoration: InputDecoration(labelText: n.bssid, hintText: n.bssidHint),
          ),
          TextField(
            controller: _frequencyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: n.frequency, hintText: n.frequencyHint),
          ),
          TextField(
            controller: _levelController,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: InputDecoration(hintText: n.levelHint),
          ),
        ],
      ),
      actions: [const DialogCancelButton(), TextButton(onPressed: _add, child: Text(n.addAccessPoint))],
    );
  }
}
