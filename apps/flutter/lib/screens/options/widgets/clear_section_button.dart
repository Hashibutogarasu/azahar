import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../widgets/confirmation_dialog.dart';

/// The delete button at the right end of the History and Pinned headings: a trash icon beside a
/// label. Pressing it asks for confirmation and then calls [onConfirmed]; it is disabled while
/// there is nothing to delete.
class ClearSectionButton extends StatelessWidget {
  const ClearSectionButton({
    super.key,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.onConfirmed,
    this.enabled = true,
  });

  final String confirmTitle;
  final String confirmMessage;
  final VoidCallback onConfirmed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final label = context.t.options.clear;
    return TextButton.icon(
      onPressed: enabled
          ? () async {
              final confirmed = await ConfirmationDialog.show(
                context,
                title: confirmTitle,
                message: confirmMessage,
                confirmLabel: label,
              );
              if (confirmed) onConfirmed();
            }
          : null,
      icon: const Icon(Icons.delete_outline),
      label: Text(label),
    );
  }
}
