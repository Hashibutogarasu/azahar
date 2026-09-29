import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../settings/widgets/settings_group_card.dart';

class GeneralOptionsGroup extends StatelessWidget {
  const GeneralOptionsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SettingsGroupCard(
      settingsGroupTitle: t.options.groups.general,
      items: [
        babstrap.SettingsItem(
          icons: Icons.account_circle_outlined,
          title: t.options.general,
          subtitle: t.options.generalDescription,
          onTap: () => const OptionsGeneralSettingsRoute().push(context),
        ),
        babstrap.SettingsItem(
          icons: Icons.language,
          title: t.settings.language.title,
          onTap: () => const OptionsLanguageSettingsRoute().push(context),
        ),
        babstrap.SettingsItem(
          icons: Icons.palette_outlined,
          title: t.options.themeAndColor,
          subtitle: t.options.themeAndColorDescription,
          onTap: () => const OptionsThemeSettingsRoute().push(context),
        ),
        babstrap.SettingsItem(
          icons: Icons.music_note_outlined,
          title: t.options.media,
          subtitle: t.options.mediaDescription,
          onTap: () => const OptionsMediaSettingsRoute().push(context),
        ),
      ],
    );
  }
}
