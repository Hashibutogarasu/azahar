import 'package:babstrap_settings_screen/babstrap_settings_screen.dart' as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/settings/options_settings_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../settings/widgets/settings_group_card.dart';

class OtherOptionsGroup extends ConsumerWidget {
  const OtherOptionsGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final settings = ref.read(optionsSettingsProvider);
    return SettingsGroupCard(
      settingsGroupTitle: t.options.groups.other,
      items: [
        babstrap.SettingsItem(
          icons: Icons.history_toggle_off,
          title: t.options.useLegacySettingsUI,
          subtitle: t.options.useLegacySettingsUIDescription,
          trailing: Switch(
            value: settings.useLegacySettingsUI,
            onChanged: (value) => _confirmLegacyToggle(context, ref, t, value),
          ),
        ),
        babstrap.SettingsItem(
          icons: Icons.code,
          title: t.settings.debug.title,
          onTap: () => const OptionsDebugSettingsRoute().push(context),
        ),
        babstrap.SettingsItem(
          icons: Icons.info_outline,
          title: t.options.about,
          subtitle: t.options.aboutDescription,
          onTap: () => const AboutRoute().push(context),
        ),
        babstrap.SettingsItem(
          icons: Icons.restore,
          title: t.settings.resetToDefault,
          titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error),
          iconStyle: babstrap.IconStyle(
            iconsColor: Theme.of(context).colorScheme.error,
            withBackground: false,
          ),
          trailing: const SizedBox.shrink(),
          onTap: () => _confirmReset(context, ref, t),
        ),
      ],
    );
  }

  Future<void> _confirmLegacyToggle(
    BuildContext context,
    WidgetRef ref,
    Translations t,
    bool value,
  ) async {
    final dialog = t.options.useLegacySettingsUIDialog;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: dialog.title,
      message: dialog.message,
      confirmLabel: dialog.confirm,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(optionsSettingsProvider).setUseLegacySettingsUI(value);
    if (context.mounted) {
      context.go(OptionsRoute(isLegacy: value).location);
    }
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref, Translations t) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: t.settings.resetToDefaultDialog.title,
      message: t.settings.resetToDefaultDialog.message,
      confirmLabel: t.settings.resetToDefaultDialog.confirm,
    );
    if (!confirmed) return;
    await ref.read(optionsSettingsProvider).resetAll();
  }
}
