import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/settings/options_settings_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../../widgets/confirmation_dialog.dart';

/// Switches between the current and the legacy Options UI after the user confirms, then reloads
/// the Options page in the chosen UI.
abstract final class ChangeLegacySettingsUiAction {
  static Future<void> run(
    BuildContext context,
    WidgetRef ref,
    bool useLegacy,
  ) async {
    final dialog = context.t.options.useLegacySettingsUIDialog;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: dialog.title,
      message: dialog.message,
      confirmLabel: dialog.confirm,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(optionsSettingsProvider).setUseLegacySettingsUI(useLegacy);
    if (context.mounted) {
      context.go(OptionsRoute(isLegacy: useLegacy).location);
    }
  }
}
