import 'package:babstrap_settings_screen/babstrap_settings_screen.dart' as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/options_settings_provider.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_group_card.dart';

class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final theme = t.settings.theme;
    final options = ref.watch(optionsSettingsProvider);
    final settings = options.themeSettings;
    final notifier = options.themeSettingsNotifier;
    final colorLabels = [
      theme.staticThemeColorBlue,
      theme.staticThemeColorCyan,
      theme.staticThemeColorRed,
      theme.staticThemeColorGreen,
      theme.staticThemeColorYellow,
      theme.staticThemeColorOrange,
      theme.staticThemeColorViolet,
      theme.staticThemeColorPink,
      theme.staticThemeColorGray,
    ];
    final themeModeLabels = {
      'system': theme.themeModeFollowSystem,
      'light': theme.themeModeLight,
      'dark': theme.themeModeDark,
    };

    return Scaffold(
      appBar: AppBar(title: Text(theme.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsGroupCard(
            items: [
              babstrap.SettingsItem(
                icons: Icons.auto_awesome,
                title: theme.materialYou,
                subtitle: theme.materialYouDescription,
                trailing: Switch(
                  value: settings.materialYou,
                  onChanged: notifier.setMaterialYou,
                ),
              ),
              babstrap.SettingsItem(
                icons: Icons.palette_outlined,
                title: theme.staticThemeColor,
                trailing: Text(colorLabels[settings.staticThemeColor]),
                onTap: () async {
                  final result = await showDialog<int>(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text(theme.staticThemeColor),
                        children: [
                          RadioGroup<int>(
                            groupValue: settings.staticThemeColor,
                            onChanged: (value) => Navigator.of(context).pop(value),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (var i = 0; i < colorLabels.length; i++)
                                  RadioListTile<int>(
                                    title: Text(colorLabels[i]),
                                    value: i,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                  if (result != null) await notifier.setStaticThemeColor(result);
                },
              ),
              babstrap.SettingsItem(
                icons: Icons.brightness_6_outlined,
                title: theme.themeMode,
                trailing: Text(themeModeLabels[settings.themeMode] ?? settings.themeMode),
                onTap: () async {
                  final result = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text(theme.themeMode),
                        children: [
                          RadioGroup<String>(
                            groupValue: settings.themeMode,
                            onChanged: (value) => Navigator.of(context).pop(value),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (final entry in themeModeLabels.entries)
                                  RadioListTile<String>(
                                    title: Text(entry.value),
                                    value: entry.key,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                  if (result != null) await notifier.setThemeMode(result);
                },
              ),
              babstrap.SettingsItem(
                icons: Icons.contrast,
                title: theme.useBlackBackgrounds,
                subtitle: theme.useBlackBackgroundsDescription,
                trailing: Switch(
                  value: settings.blackBackgrounds,
                  onChanged: notifier.setBlackBackgrounds,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
