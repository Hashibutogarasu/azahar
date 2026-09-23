import 'package:flutter/widgets.dart';
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

  const factory SettingsItem.floatSlider({
    required String title,
    String? description,
    required FloatKey setting,
    required double min,
    required double max,
    required String units,
  }) = SettingsFloatSliderItem;

  const factory SettingsItem.stringSingleChoice({
    required String title,
    String? description,
    required StringKey setting,
    required List<String> choiceLabels,
    required List<String> choiceValues,
  }) = SettingsStringSingleChoiceItem;

  const factory SettingsItem.stringInput({
    required String title,
    String? description,
    required StringKey setting,
    int? maxLength,
  }) = SettingsStringInputItem;

  const factory SettingsItem.dateTime({
    required String title,
    String? description,
    required StringKey setting,
  }) = SettingsDateTimeItem;

  const factory SettingsItem.action({
    required String title,
    String? description,
    required void Function(BuildContext context) onTap,
  }) = SettingsActionItem;

  const factory SettingsItem.submenu({
    required String title,
    String? description,
    required void Function(BuildContext context) onTap,
  }) = SettingsSubmenuItem;
}
