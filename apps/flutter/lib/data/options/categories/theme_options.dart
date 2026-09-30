import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/theme_settings_provider.dart';
import '../../../theme/theme_style.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../translation_text.dart';

/// The items of the theme and color settings page, which is not listed on the Options page: theme
/// style, Material You, the static color, the theme mode and black backgrounds. The static color
/// choices depend on the theme style, so this provider rebuilds when the style changes.
final themeOptionsProvider = Provider<OptionCategory>((ref) {
  final style = ref.watch(
    themeSettingsProvider.select((settings) => settings.themeStyle),
  );
  final List<TranslationText> colorLabels = [
    if (style == ThemeStyle.azahar)
      (t) => t.settings.theme.staticThemeColorDefault,
    (t) => t.settings.theme.staticThemeColorBlue,
    (t) => t.settings.theme.staticThemeColorCyan,
    (t) => t.settings.theme.staticThemeColorRed,
    (t) => t.settings.theme.staticThemeColorGreen,
    (t) => t.settings.theme.staticThemeColorYellow,
    (t) => t.settings.theme.staticThemeColorOrange,
    (t) => t.settings.theme.staticThemeColorViolet,
    (t) => t.settings.theme.staticThemeColorPink,
    (t) => t.settings.theme.staticThemeColorGray,
  ];
  return OptionCategory(
    id: 'theme',
    title: (t) => t.settings.theme.title,
    sections: [
      OptionSection(
        options: [
          EnumOption<ThemeStyle>(
            title: (t) => t.settings.theme.themeStyle,
            icon: Icons.style_outlined,
            value: CallbackOptionValue<ThemeStyle>(
              onRead: (ref) => ref.watch(themeSettingsProvider).themeStyle,
              onWrite: (context, ref, value) =>
                  ref.read(themeSettingsProvider.notifier).setThemeStyle(value),
            ),
            choices: [
              EnumChoice(
                label: (t) => t.settings.themes.azahar,
                value: ThemeStyle.azahar,
              ),
              EnumChoice(
                label: (t) => t.settings.themes.legacy,
                value: ThemeStyle.legacy,
              ),
            ],
          ),
          BoolOption(
            title: (t) => t.settings.theme.materialYou,
            description: (t) => t.settings.theme.materialYouDescription,
            icon: Icons.auto_awesome,
            value: CallbackOptionValue<bool>(
              onRead: (ref) => ref.watch(themeSettingsProvider).materialYou,
              onWrite: (context, ref, value) => ref
                  .read(themeSettingsProvider.notifier)
                  .setMaterialYou(value),
            ),
          ),
          EnumOption<int>(
            title: (t) => t.settings.theme.staticThemeColor,
            icon: Icons.palette_outlined,
            value: CallbackOptionValue<int>(
              onRead: (ref) =>
                  ref.watch(themeSettingsProvider).staticThemeColor,
              onWrite: (context, ref, value) => ref
                  .read(themeSettingsProvider.notifier)
                  .setStaticThemeColor(value),
            ),
            choices: [
              for (final (index, label) in colorLabels.indexed)
                EnumChoice(label: label, value: index),
            ],
          ),
          EnumOption<String>(
            title: (t) => t.settings.theme.themeMode,
            icon: Icons.brightness_6_outlined,
            value: CallbackOptionValue<String>(
              onRead: (ref) => ref.watch(themeSettingsProvider).themeMode,
              onWrite: (context, ref, value) =>
                  ref.read(themeSettingsProvider.notifier).setThemeMode(value),
            ),
            choices: [
              EnumChoice(
                label: (t) => t.settings.theme.themeModeFollowSystem,
                value: 'system',
              ),
              EnumChoice(
                label: (t) => t.settings.theme.themeModeLight,
                value: 'light',
              ),
              EnumChoice(
                label: (t) => t.settings.theme.themeModeDark,
                value: 'dark',
              ),
            ],
          ),
          BoolOption(
            title: (t) => t.settings.theme.useBlackBackgrounds,
            description: (t) => t.settings.theme.useBlackBackgroundsDescription,
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
