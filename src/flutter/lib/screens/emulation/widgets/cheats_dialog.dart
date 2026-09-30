import 'package:flutter/material.dart';

import '../../../data/repositories/cheat_repository.dart';
import '../../../i18n/translations.g.dart';
import 'add_cheat_dialog.dart';
import 'cheat_toggle_tile.dart';

/// Lists the cheats of the running title and lets the user toggle them.
///
/// Open it through [show]. The plus buttons at the top and the bottom of the list open
/// [AddCheatDialog] on top of this dialog, which stays open and shows the new cheat once that
/// one is dismissed.
class CheatsDialog extends StatefulWidget {
  const CheatsDialog({super.key, required this.repository});

  final CheatRepository repository;

  static Future<void> show(
    BuildContext context, {
    required CheatRepository repository,
  }) async {
    await repository.load();
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => CheatsDialog(repository: repository),
    );
  }

  @override
  State<CheatsDialog> createState() => _CheatsDialogState();
}

class _CheatsDialogState extends State<CheatsDialog> {
  Future<void> _setEnabled(int index, bool enabled) async {
    await widget.repository.setEnabled(index, enabled);
    if (mounted) setState(() {});
  }

  Future<void> _requestAdd() async {
    await AddCheatDialog.show(context, repository: widget.repository);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cheats = widget.repository.cheats;
    return AlertDialog(
      title: Text(t.emulation.cheats),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AddCheatButton(onPressed: _requestAdd),
              if (cheats.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(t.emulation.noCheats),
                )
              else
                for (var i = 0; i < cheats.length; i++)
                  CheatToggleTile(
                    cheat: cheats[i],
                    onChanged: (value) => _setEnabled(i, value),
                  ),
              _AddCheatButton(onPressed: _requestAdd),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    );
  }
}

class _AddCheatButton extends StatelessWidget {
  const _AddCheatButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: context.t.emulation.addCheat,
      onPressed: onPressed,
    );
  }
}
