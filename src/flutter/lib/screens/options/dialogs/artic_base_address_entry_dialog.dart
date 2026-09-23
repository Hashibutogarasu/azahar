import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';

class ArticBaseAddressEntryResult {
  const ArticBaseAddressEntryResult({required this.address, required this.installO3ds});

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
  State<ArticBaseAddressEntryDialog> createState() => _ArticBaseAddressEntryDialogState();
}

class _ArticBaseAddressEntryDialogState extends State<ArticBaseAddressEntryDialog> {
  final _addressController = TextEditingController();
  bool _selectedO3ds = false;
  bool _selectedN3ds = false;

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
            _addressController.text.isNotEmpty && (_selectedO3ds || _selectedN3ds);
        return AlertDialog(
          title: Text(s.enterAddress),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _addressController,
                keyboardType: TextInputType.url,
                onChanged: (_) => setDialogState(() {}),
              ),
              RadioGroup<bool>(
                groupValue: _selectedO3ds,
                onChanged: (value) => setDialogState(() {
                  _selectedO3ds = true;
                  _selectedN3ds = false;
                }),
                child: RadioListTile<bool>(title: Text(s.old3ds), value: true),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48),
                child: Text(
                  widget.o3dsInstalled ? s.statusCompleted : s.statusPossible,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              RadioGroup<bool>(
                groupValue: _selectedN3ds,
                onChanged: (value) => setDialogState(() {
                  _selectedN3ds = true;
                  _selectedO3ds = false;
                }),
                child: RadioListTile<bool>(
                  title: Text(s.new3ds),
                  value: true,
                  enabled: widget.o3dsInstalled,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48),
                child: Text(
                  !widget.o3dsInstalled
                      ? s.statusOld3dsNeeded
                      : (widget.n3dsInstalled ? s.statusCompleted : s.statusPossible),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancelButtonLabel),
            ),
            TextButton(
              onPressed: canConfirm
                  ? () => Navigator.of(context).pop(
                        ArticBaseAddressEntryResult(
                          address: _addressController.text,
                          installO3ds: _selectedO3ds,
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
