import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../../settings/emulator_setting_key.dart';
import '../../settings/sections/layout_settings.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../store_option_values.dart';
import '../translation_text.dart';

/// The options on the Layout page: the screen orientation and the two pages for the custom
/// landscape and portrait layouts.
final layoutPageOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'layoutPage',
    title: (t) => t.settings.layout.title,
    sections: [
      OptionSection(
        options: [
          EnumOption<int>(
            title: (t) => t.settings.layout.screenOrientation,
            icon: Icons.screen_rotation,
            value: const StoreIntValue(LayoutSettingKeys.screenOrientation),
            choices: [
              EnumChoice(
                label: (t) => t.settings.layout.screenOrientationAutoSensor,
                value: 2,
              ),
              EnumChoice(
                label: (t) => t.settings.layout.screenOrientationLandscape,
                value: 0,
              ),
              EnumChoice(
                label: (t) =>
                    t.settings.layout.screenOrientationLandscapeReverse,
                value: 8,
              ),
              EnumChoice(
                label: (t) => t.settings.layout.screenOrientationPortrait,
                value: 1,
              ),
              EnumChoice(
                label: (t) =>
                    t.settings.layout.screenOrientationPortraitReverse,
                value: 9,
              ),
            ],
          ),
          NestedOption(
            title: (t) => t.settings.layout.customLandscapeLayout,
            icon: Icons.crop_landscape,
            destination: const OptionsCustomLandscapeLayoutSettingsRoute(),
          ),
          NestedOption(
            title: (t) => t.settings.layout.customPortraitLayout,
            icon: Icons.crop_portrait,
            destination: const OptionsCustomPortraitLayoutSettingsRoute(),
          ),
        ],
      ),
    ],
  ),
);

/// The options on the custom landscape layout page.
final customLandscapeLayoutPageOptionsProvider = Provider<OptionCategory>(
  (ref) => buildCustomLayoutCategory(
    id: 'customLandscapeLayoutPage',
    title: (t) => t.settings.layout.customLandscapeLayout,
    topX: CustomLandscapeLayoutSettingKeys.topX,
    topY: CustomLandscapeLayoutSettingKeys.topY,
    topWidth: CustomLandscapeLayoutSettingKeys.topWidth,
    topHeight: CustomLandscapeLayoutSettingKeys.topHeight,
    bottomX: CustomLandscapeLayoutSettingKeys.bottomX,
    bottomY: CustomLandscapeLayoutSettingKeys.bottomY,
    bottomWidth: CustomLandscapeLayoutSettingKeys.bottomWidth,
    bottomHeight: CustomLandscapeLayoutSettingKeys.bottomHeight,
  ),
);

/// The options on the custom portrait layout page.
final customPortraitLayoutPageOptionsProvider = Provider<OptionCategory>(
  (ref) => buildCustomLayoutCategory(
    id: 'customPortraitLayoutPage',
    title: (t) => t.settings.layout.customPortraitLayout,
    topX: CustomPortraitLayoutSettingKeys.topX,
    topY: CustomPortraitLayoutSettingKeys.topY,
    topWidth: CustomPortraitLayoutSettingKeys.topWidth,
    topHeight: CustomPortraitLayoutSettingKeys.topHeight,
    bottomX: CustomPortraitLayoutSettingKeys.bottomX,
    bottomY: CustomPortraitLayoutSettingKeys.bottomY,
    bottomWidth: CustomPortraitLayoutSettingKeys.bottomWidth,
    bottomHeight: CustomPortraitLayoutSettingKeys.bottomHeight,
  ),
);

/// Builds a custom layout page: the position and size of the top screen, then of the bottom
/// screen, each set with the given emulator setting keys.
OptionCategory buildCustomLayoutCategory({
  required String id,
  required TranslationText title,
  required IntKey topX,
  required IntKey topY,
  required IntKey topWidth,
  required IntKey topHeight,
  required IntKey bottomX,
  required IntKey bottomY,
  required IntKey bottomWidth,
  required IntKey bottomHeight,
}) {
  OptionSection section(
    TranslationText sectionTitle,
    IntKey x,
    IntKey y,
    IntKey width,
    IntKey height,
  ) {
    IntOption pixels(TranslationText title, IntKey setting) => IntOption(
      title: title,
      icon: Icons.tune,
      value: StoreIntValue(setting),
      min: 0,
      max: 4000,
      defaultValue: setting.defaultValue,
      units: 'px',
    );
    return OptionSection(
      title: sectionTitle,
      options: [
        pixels((t) => t.settings.layout.positionX, x),
        pixels((t) => t.settings.layout.positionY, y),
        pixels((t) => t.settings.layout.width, width),
        pixels((t) => t.settings.layout.height, height),
      ],
    );
  }

  return OptionCategory(
    id: id,
    title: title,
    sections: [
      section(
        (t) => t.settings.layout.topScreen,
        topX,
        topY,
        topWidth,
        topHeight,
      ),
      section(
        (t) => t.settings.layout.bottomScreen,
        bottomX,
        bottomY,
        bottomWidth,
        bottomHeight,
      ),
    ],
  );
}
