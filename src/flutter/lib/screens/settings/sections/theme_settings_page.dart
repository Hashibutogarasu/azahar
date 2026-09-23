import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/translations.g.dart';
import '../../../theme/theme_settings_provider.dart';

class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final theme = t.settings.theme;
    final settings = ref.watch(themeSettingsProvider);
    final notifier = ref.read(themeSettingsProvider.notifier);
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
        children: [
          SwitchListTile(
            title: Text(theme.materialYou),
            subtitle: Text(theme.materialYouDescription),
            value: settings.materialYou,
            onChanged: notifier.setMaterialYou,
          ),
          ListTile(
            title: Text(theme.staticThemeColor),
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
          ListTile(
            title: Text(theme.themeMode),
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
          SwitchListTile(
            title: Text(theme.useBlackBackgrounds),
            subtitle: Text(theme.useBlackBackgroundsDescription),
            value: settings.blackBackgrounds,
            onChanged: notifier.setBlackBackgrounds,
          ),
        ],
      ),
    );
  }
}
