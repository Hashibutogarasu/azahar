import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../widgets/dialog_cancel_button.dart';

class ArticBaseAddressEntryResult {
  const ArticBaseAddressEntryResult({
    required this.address,
    required this.installO3ds,
  });

  final String address;
  final bool installO3ds;
}

class ArticBaseAddressEntryDialog extends StatefulWidget {
  const ArticBaseAddressEntryDialog({
    super.key,
    required this.o3dsInstalled,
    required this.n3dsInstalled,
  });

  final bool o3dsInstalled;
  final bool n3dsInstalled;

  static Future<ArticBaseAddressEntryResult?> show(
    BuildContext context, {
    required bool o3dsInstalled,
    required bool n3dsInstalled,
  }) {
    return showDialog<ArticBaseAddressEntryResult>(
      context: context,
      builder: (_) => ArticBaseAddressEntryDialog(
        o3dsInstalled: o3dsInstalled,
        n3dsInstalled: n3dsInstalled,
      ),
    );
  }

  @override
  State<ArticBaseAddressEntryDialog> createState() =>
      _ArticBaseAddressEntryDialogState();
}

class _ArticBaseAddressEntryDialogState
    extends State<ArticBaseAddressEntryDialog> {
  final _addressController = TextEditingController();
  String? _selected;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final s = t.systemFiles;
    final localizations = MaterialLocalizations.of(context);
    return StatefulBuilder(
      builder: (context, setDialogState) {
        final canConfirm =
            _addressController.text.isNotEmpty && _selected != null;
        return AlertDialog(
          title: Text(s.enterAddress),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _addressController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setDialogState(() {}),
                ),
                RadioGroup<String>(
                  groupValue: _selected,
                  onChanged: (value) => setDialogState(() => _selected = value),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text(s.old3ds),
                          value: 'o3ds',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 48),
                        child: Text(
                          widget.o3dsInstalled
                              ? s.statusCompleted
                              : s.statusPossible,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(s.new3ds),
                        value: 'n3ds',
                        enabled: widget.o3dsInstalled,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 48),
                        child: Text(
                          !widget.o3dsInstalled
                              ? s.statusOld3dsNeeded
                              : (widget.n3dsInstalled
                                    ? s.statusCompleted
                                    : s.statusPossible),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            const DialogCancelButton(),
            TextButton(
              onPressed: canConfirm
                  ? () => Navigator.of(context).pop(
                      ArticBaseAddressEntryResult(
                        address: _addressController.text,
                        installO3ds: _selected == 'o3ds',
                      ),
                    )
                  : null,
              child: Text(localizations.okButtonLabel),
            ),
          ],
        );
      },
    );
  }
}
