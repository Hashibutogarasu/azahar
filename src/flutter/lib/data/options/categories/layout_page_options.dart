import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../../settings/emulator_setting_key.dart';
import '../../settings/sections/layout_settings.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../store_option_values.dart';

/// The options on the Layout page: the screen orientation and the two pages for the custom
/// landscape and portrait layouts.
final layoutPageOptionsProvider = Provider<OptionCategory>(
  (ref) => const OptionCategory(
    id: 'layoutPage',
    titleKey: 'settings.layout.title',
    sections: [
      OptionSection(
        options: [
          EnumOption<int>(
            titleKey: 'settings.layout.screenOrientation',
            icon: Icons.screen_rotation,
            value: StoreIntValue(LayoutSettingKeys.screenOrientation),
            choices: [
              EnumChoice(
                labelKey: 'settings.layout.screenOrientationAutoSensor',
                value: 2,
              ),
              EnumChoice(
                labelKey: 'settings.layout.screenOrientationLandscape',
                value: 0,
              ),
              EnumChoice(
                labelKey: 'settings.layout.screenOrientationLandscapeReverse',
                value: 8,
              ),
              EnumChoice(
                labelKey: 'settings.layout.screenOrientationPortrait',
                value: 1,
              ),
              EnumChoice(
                labelKey: 'settings.layout.screenOrientationPortraitReverse',
                value: 9,
              ),
            ],
          ),
          NestedOption(
            titleKey: 'settings.layout.customLandscapeLayout',
            icon: Icons.crop_landscape,
            destination: OptionsCustomLandscapeLayoutSettingsRoute(),
          ),
          NestedOption(
            titleKey: 'settings.layout.customPortraitLayout',
            icon: Icons.crop_portrait,
            destination: OptionsCustomPortraitLayoutSettingsRoute(),
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
    titleKey: 'settings.layout.customLandscapeLayout',
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
    titleKey: 'settings.layout.customPortraitLayout',
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
  required String titleKey,
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
    String sectionTitleKey,
    IntKey x,
    IntKey y,
    IntKey width,
    IntKey height,
  ) {
    IntOption pixels(String key, IntKey setting) => IntOption(
      titleKey: key,
      icon: Icons.tune,
      value: StoreIntValue(setting),
      min: 0,
      max: 4000,
      defaultValue: setting.defaultValue,
      units: 'px',
    );
    return OptionSection(
      titleKey: sectionTitleKey,
      options: [
        pixels('settings.layout.positionX', x),
        pixels('settings.layout.positionY', y),
        pixels('settings.layout.width', width),
        pixels('settings.layout.height', height),
      ],
    );
  }

  return OptionCategory(
    id: id,
    titleKey: titleKey,
    sections: [
      section('settings.layout.topScreen', topX, topY, topWidth, topHeight),
      section(
        'settings.layout.bottomScreen',
        bottomX,
        bottomY,
        bottomWidth,
        bottomHeight,
      ),
    ],
  );
}
