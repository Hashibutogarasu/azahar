import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'emulator_setting_key.dart';
import 'settings_value_store.dart';

part 'settings_item.freezed.dart';

@freezed
sealed class SettingsItem with _$SettingsItem {
  const factory SettingsItem.header({required String title, String? description}) =
      SettingsHeaderItem;

  const factory SettingsItem.switch_({
    required String title,
    String? description,
    required IntBoolKey setting,
    SettingsValueStore? store,
  }) = SettingsSwitchItem;

  const factory SettingsItem.slider({
    required String title,
    String? description,
    required IntKey setting,
    required int min,
    required int max,
    required String units,
    SettingsValueStore? store,
  }) = SettingsSliderItem;

  const factory SettingsItem.singleChoice({
    required String title,
    String? description,
    required IntKey setting,
    required List<String> choiceLabels,
    required List<int> choiceValues,
    SettingsValueStore? store,
  }) = SettingsSingleChoiceItem;

  const factory SettingsItem.floatSlider({
    required String title,
    String? description,
    required FloatKey setting,
    required double min,
    required double max,
    required String units,
    SettingsValueStore? store,
  }) = SettingsFloatSliderItem;

  const factory SettingsItem.stringSingleChoice({
    required String title,
    String? description,
    required StringKey setting,
    required List<String> choiceLabels,
    required List<String> choiceValues,
    SettingsValueStore? store,
  }) = SettingsStringSingleChoiceItem;

  const factory SettingsItem.stringInput({
    required String title,
    String? description,
    required StringKey setting,
    int? maxLength,
    SettingsValueStore? store,
  }) = SettingsStringInputItem;

  const factory SettingsItem.dateTime({
    required String title,
    String? description,
    required StringKey setting,
    SettingsValueStore? store,
  }) = SettingsDateTimeItem;

  const factory SettingsItem.inputBinding({
    required String title,
    String? description,
    required StringKey setting,
    SettingsValueStore? store,
  }) = SettingsInputBindingItem;

  const factory SettingsItem.action({
    required String title,
    String? description,
    IconData? icon,
    required void Function(BuildContext context) onTap,
  }) = SettingsActionItem;

  const factory SettingsItem.submenu({
    required String title,
    String? description,
    IconData? icon,
    required void Function(BuildContext context) onTap,
  }) = SettingsSubmenuItem;
}
