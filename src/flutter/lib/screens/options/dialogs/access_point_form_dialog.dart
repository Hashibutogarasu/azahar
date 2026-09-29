import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../models/access_point.dart';
import '../../../widgets/dialog_cancel_button.dart';

/// Adds a new virtual access point, or edits [initial] when provided.
class AccessPointFormDialog extends StatefulWidget {
  const AccessPointFormDialog({super.key, this.initial});

  final AccessPoint? initial;

  static Future<AccessPoint?> show(
    BuildContext context, {
    AccessPoint? initial,
  }) {
    return showDialog<AccessPoint>(
      context: context,
      builder: (_) => AccessPointFormDialog(initial: initial),
    );
  }

  @override
  State<AccessPointFormDialog> createState() => _AccessPointFormDialogState();
}

class _AccessPointFormDialogState extends State<AccessPointFormDialog> {
  late final _ssidController = TextEditingController(
    text: widget.initial?.ssid ?? '',
  );
  late final _bssidController = TextEditingController(
    text: widget.initial?.bssid ?? '',
  );
  late final _frequencyController = TextEditingController(
    text: (widget.initial?.frequency ?? 2437).toString(),
  );
  late final _levelController = TextEditingController(
    text: (widget.initial?.level ?? -50).toString(),
  );

  @override
  void dispose() {
    _ssidController.dispose();
    _bssidController.dispose();
    _frequencyController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _submit() {
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
    final isEditing = widget.initial != null;
    return AlertDialog(
      title: Text(isEditing ? n.editAccessPoint : n.addAccessPoint),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ssidController,
            decoration: InputDecoration(
              labelText: n.ssid,
              hintText: n.ssidHint,
            ),
          ),
          TextField(
            controller: _bssidController,
            decoration: InputDecoration(
              labelText: n.bssid,
              hintText: n.bssidHint,
            ),
          ),
          TextField(
            controller: _frequencyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: n.frequency,
              hintText: n.frequencyHint,
            ),
          ),
          TextField(
            controller: _levelController,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            decoration: InputDecoration(hintText: n.levelHint),
          ),
        ],
      ),
      actions: [
        const DialogCancelButton(),
        TextButton(
          onPressed: _submit,
          child: Text(isEditing ? t.common.save : n.addAccessPoint),
        ),
      ],
    );
  }
}
