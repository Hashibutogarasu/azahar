import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/theme_settings_provider.dart';
import '../../../theme/theme_style.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';

/// The items of the theme and color settings page, which is not listed on the Options page: theme style, Material You, the static color, the theme mode and
/// black backgrounds. The static color choices depend on the theme style, so this provider
/// rebuilds when the style changes.
final themeOptionsProvider = Provider<OptionCategory>((ref) {
  final style = ref.watch(
    themeSettingsProvider.select((settings) => settings.themeStyle),
  );
  const namedColorKeys = [
    'Blue',
    'Cyan',
    'Red',
    'Green',
    'Yellow',
    'Orange',
    'Violet',
    'Pink',
    'Gray',
  ];
  final colorKeys = [
    if (style == ThemeStyle.azahar) 'Default',
    ...namedColorKeys,
  ];
  return OptionCategory(
    id: 'theme',
    titleKey: 'settings.theme.title',
    sections: [
      OptionSection(
        options: [
          EnumOption<String>(
            titleKey: 'settings.theme.themeStyle',
            icon: Icons.style_outlined,
            value: CallbackOptionValue<String>(
              onRead: (ref) => ref.watch(themeSettingsProvider).themeStyle.name,
              onWrite: (context, ref, value) => ref
                  .read(themeSettingsProvider.notifier)
                  .setThemeStyle(ThemeStyle.values.byName(value)),
            ),
            choices: [
              for (final style in ThemeStyle.values)
                EnumChoice(
                  labelKey: 'settings.themes.${style.name}',
                  value: style.name,
                ),
            ],
          ),
          BoolOption(
            titleKey: 'settings.theme.materialYou',
            descriptionKey: 'settings.theme.materialYouDescription',
            icon: Icons.auto_awesome,
            value: CallbackOptionValue<bool>(
              onRead: (ref) => ref.watch(themeSettingsProvider).materialYou,
              onWrite: (context, ref, value) => ref
                  .read(themeSettingsProvider.notifier)
                  .setMaterialYou(value),
            ),
          ),
          EnumOption<int>(
            titleKey: 'settings.theme.staticThemeColor',
            icon: Icons.palette_outlined,
            value: CallbackOptionValue<int>(
              onRead: (ref) =>
                  ref.watch(themeSettingsProvider).staticThemeColor,
              onWrite: (context, ref, value) => ref
                  .read(themeSettingsProvider.notifier)
                  .setStaticThemeColor(value),
            ),
            choices: [
              for (var i = 0; i < colorKeys.length; i++)
                EnumChoice(
                  labelKey: 'settings.theme.staticThemeColor${colorKeys[i]}',
                  value: i,
                ),
            ],
          ),
          EnumOption<String>(
            titleKey: 'settings.theme.themeMode',
            icon: Icons.brightness_6_outlined,
            value: CallbackOptionValue<String>(
              onRead: (ref) => ref.watch(themeSettingsProvider).themeMode,
              onWrite: (context, ref, value) =>
                  ref.read(themeSettingsProvider.notifier).setThemeMode(value),
            ),
            choices: const [
              EnumChoice(
                labelKey: 'settings.theme.themeModeFollowSystem',
                value: 'system',
              ),
              EnumChoice(
                labelKey: 'settings.theme.themeModeLight',
                value: 'light',
              ),
              EnumChoice(
                labelKey: 'settings.theme.themeModeDark',
                value: 'dark',
              ),
            ],
          ),
          BoolOption(
            titleKey: 'settings.theme.useBlackBackgrounds',
            descriptionKey: 'settings.theme.useBlackBackgroundsDescription',
            icon: Icons.contrast,
            value: CallbackOptionValue<bool>(
              onRead: (ref) =>
                  ref.watch(themeSettingsProvider).blackBackgrounds,
              onWrite: (context, ref, value) => ref
                  .read(themeSettingsProvider.notifier)
                  .setBlackBackgrounds(value),
            ),
          ),
        ],
      ),
    ],
  );
});
