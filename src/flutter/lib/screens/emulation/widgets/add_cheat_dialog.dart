import 'package:flutter/material.dart';

import '../../../data/repositories/cheat_repository.dart';
import '../../../i18n/translations.g.dart';
import '../../../widgets/dialog_cancel_button.dart';

/// Collects the name, notes and gateway code of a new cheat and adds it through [repository].
///
/// Both the cancel and the add button dismiss the dialog; the result of [show] tells whether a
/// cheat was added.
class AddCheatDialog extends StatefulWidget {
  const AddCheatDialog({super.key, required this.repository});

  final CheatRepository repository;

  static Future<bool> show(
    BuildContext context, {
    required CheatRepository repository,
  }) async {
    final added = await showDialog<bool>(
      context: context,
      builder: (_) => AddCheatDialog(repository: repository),
    );
    return added ?? false;
  }

  @override
  State<AddCheatDialog> createState() => _AddCheatDialogState();
}

class _AddCheatDialogState extends State<AddCheatDialog> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _codeController = TextEditingController();
  String? _nameError;
  String? _codeError;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = context.t;
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    final nameError = name.isEmpty ? t.emulation.cheatNameEmpty : null;
    var codeError = code.isEmpty ? t.emulation.cheatCodeEmpty : null;
    if (codeError == null) {
      final invalidLine = await widget.repository.validateCode(code);
      if (invalidLine != 0) {
        codeError = t.emulation.cheatErrorOnLine(line: invalidLine);
      }
    }
    if (!mounted) return;
    if (nameError != null || codeError != null) {
      setState(() {
        _nameError = nameError;
        _codeError = codeError;
      });
      return;
    }
    await widget.repository.add(
      name: name,
      notes: _notesController.text.trim(),
      code: code,
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AlertDialog(
      title: Text(t.emulation.addCheat),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: t.emulation.cheatName,
                errorText: _nameError,
              ),
            ),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: t.emulation.cheatNotes),
            ),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: null,
              decoration: InputDecoration(
                labelText: t.emulation.cheatCode,
                errorText: _codeError,
              ),
            ),
          ],
        ),
      ),
      actions: [
        const DialogCancelButton(),
        TextButton(onPressed: _submit, child: Text(t.emulation.addCheat)),
      ],
    );
  }
}
