import 'package:freezed_annotation/freezed_annotation.dart';

import 'emulator_setting_key.dart';

part 'settings_item.freezed.dart';

@freezed
sealed class SettingsItem with _$SettingsItem {
  const factory SettingsItem.header({required String title, String? description}) =
      SettingsHeaderItem;

  const factory SettingsItem.switch_({
    required String title,
    String? description,
    required IntBoolKey setting,
  }) = SettingsSwitchItem;

  const factory SettingsItem.slider({
    required String title,
    String? description,
    required IntKey setting,
    required int min,
    required int max,
    required String units,
  }) = SettingsSliderItem;

  const factory SettingsItem.singleChoice({
    required String title,
    String? description,
    required IntKey setting,
    required List<String> choiceLabels,
    required List<int> choiceValues,
  }) = SettingsSingleChoiceItem;

  const factory SettingsItem.submenu({
    required String title,
    String? description,
    required String menuTag,
  }) = SettingsSubmenuItem;
}
