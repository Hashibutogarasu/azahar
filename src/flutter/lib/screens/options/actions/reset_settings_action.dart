import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/options_settings_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../../widgets/confirmation_dialog.dart';

/// Resets every setting to its default after the user confirms.
abstract final class ResetSettingsAction {
  static Future<void> run(BuildContext context, WidgetRef ref) async {
    final dialog = context.t.settings.resetToDefaultDialog;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: dialog.title,
      message: dialog.message,
      confirmLabel: dialog.confirm,
    );
    if (!confirmed) return;
    await ref.read(optionsSettingsProvider).resetAll();
  }
}
