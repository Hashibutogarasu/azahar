import 'package:flutter/material.dart';

import '../i18n/translations.g.dart';

/// A dialog's "Cancel" action button, translated via slang instead of Flutter's own
/// [MaterialLocalizations] (which isn't wired up as a second, separately-configured localization
/// source in this app).
class DialogCancelButton extends StatelessWidget {
  const DialogCancelButton({super.key, this.onPressed});

  /// Defaults to popping the current dialog with no result.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      child: Text(context.t.common.cancel),
    );
  }
}
