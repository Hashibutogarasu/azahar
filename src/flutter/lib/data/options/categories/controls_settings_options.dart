import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../settings/emulator_setting_key.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../store_option_values.dart';

/// The items of the gamepad settings page, which is not listed on the Options page: the controller
/// input mode, gyro, button and axis bindings, hotkeys and the Artic Base controller.
final controlsSettingsOptionsProvider = Provider<OptionCategory>((ref) {
  final bindings = AppServices.controlBindingsValueStore;

  InputBindingOption binding(String titleKey, String key) => InputBindingOption(
    titleKey: 'settings.gamepad.$titleKey',
    icon: Icons.sports_esports_outlined,
    value: StoreStringValue(StringKey('Controls', key, ''), store: bindings),
  );

  return OptionCategory(
    id: 'controlsSettings',
    titleKey: 'settings.gamepad.title',
    sections: [
      const OptionSection(
        options: [
          EnumOption<int>(
            titleKey: 'settings.gamepad.controllerInputMode',
            descriptionKey: 'settings.gamepad.controllerInputModeDescription',
            icon: Icons.list,
            value: StoreIntValue(
              IntKey('Controls', 'controller_input_mode', 0),
            ),
            choices: [
              EnumChoice(
                labelKey: 'settings.gamepad.controllerInputModeManual',
                value: 0,
              ),
              EnumChoice(
                labelKey: 'settings.gamepad.controllerInputModeAutoDetect',
                value: 1,
              ),
            ],
          ),
          BoolOption(
            titleKey: 'settings.gamepad.invertLeftStickYAxis',
            descriptionKey: 'settings.gamepad.invertLeftStickYAxisDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(
              IntBoolKey(
                'Controls',
                'invert_controller_left_stick_y_axis',
                false,
              ),
            ),
          ),
        ],
      ),
      const OptionSection(
        titleKey: 'settings.gamepad.gyroSettings',
        options: [
          EnumOption<int>(
            titleKey: 'settings.gamepad.gyroInputSource',
            descriptionKey: 'settings.gamepad.gyroInputSourceDescription',
            icon: Icons.list,
            value: StoreIntValue(IntKey('Controls', 'gyro_input_source', 0)),
            choices: [
              EnumChoice(
                labelKey: 'settings.gamepad.gyroInputSourceDevice',
                value: 0,
              ),
              EnumChoice(
                labelKey: 'settings.gamepad.gyroInputSourceController',
                value: 1,
              ),
            ],
          ),
          FloatOption(
            titleKey: 'settings.gamepad.gyroSensitivityVertical',
            descriptionKey:
                'settings.gamepad.gyroSensitivityVerticalDescription',
            icon: Icons.screen_rotation,
            value: StoreFloatValue(
              ScaledFloatKey('Controls', 'gyro_sensitivity_vertical', 1.0, 100),
            ),
            min: 0,
            max: 200,
            defaultValue: 100,
            units: '%',
          ),
          BoolOption(
            titleKey: 'settings.gamepad.invertGyroVertical',
            descriptionKey: 'settings.gamepad.invertGyroVerticalDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(
              IntBoolKey('Controls', 'invert_gyro_vertical', false),
            ),
          ),
          FloatOption(
            titleKey: 'settings.gamepad.gyroSensitivityHorizontal',
            descriptionKey:
                'settings.gamepad.gyroSensitivityHorizontalDescription',
            icon: Icons.screen_rotation,
            value: StoreFloatValue(
              ScaledFloatKey(
                'Controls',
                'gyro_sensitivity_horizontal',
                1.0,
                100,
              ),
            ),
            min: 0,
            max: 200,
            defaultValue: 100,
            units: '%',
          ),
          BoolOption(
            titleKey: 'settings.gamepad.invertGyroHorizontal',
            descriptionKey: 'settings.gamepad.invertGyroHorizontalDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(
              IntBoolKey('Controls', 'invert_gyro_horizontal', false),
            ),
          ),
        ],
      ),
      OptionSection(
        titleKey: 'settings.gamepad.genericButtons',
        options: [
          binding('buttonA', 'button_a'),
          binding('buttonB', 'button_b'),
          binding('buttonX', 'button_x'),
          binding('buttonY', 'button_y'),
          binding('buttonSelect', 'button_select'),
          binding('buttonStart', 'button_start'),
          binding('buttonHome', 'button_home'),
        ],
      ),
      OptionSection(
        titleKey: 'settings.gamepad.circlePad',
        options: [
          binding('axisVertical', 'circlepad_axis_vertical'),
          binding('axisHorizontal', 'circlepad_axis_horizontal'),
        ],
      ),
      OptionSection(
        titleKey: 'settings.gamepad.cStick',
        options: [
          binding('axisVertical', 'cstick_axis_vertical'),
          binding('axisHorizontal', 'cstick_axis_horizontal'),
        ],
      ),
      OptionSection(
        titleKey: 'settings.gamepad.dpadAxis',
        options: [
          binding('axisVertical', 'dpad_axis_vertical'),
          binding('axisHorizontal', 'dpad_axis_horizontal'),
        ],
      ),
      OptionSection(
        titleKey: 'settings.gamepad.dpadButtons',
        options: [
          binding('buttonUp', 'button_up'),
          binding('buttonDown', 'button_down'),
          binding('buttonLeft', 'button_left'),
          binding('buttonRight', 'button_right'),
        ],
      ),
      OptionSection(
        titleKey: 'settings.gamepad.triggers',
        options: [
          binding('buttonL', 'button_l'),
          binding('buttonR', 'button_r'),
          binding('buttonZl', 'button_zl'),
          binding('buttonZr', 'button_zr'),
        ],
      ),
      OptionSection(
        titleKey: 'settings.gamepad.hotkeys',
        options: [
          binding('hotkeySwapScreens', 'hotkey_screen_swap'),
          binding('hotkeyCycleLayout', 'hotkey_toggle_layout'),
          binding('hotkeyCloseGame', 'hotkey_close_game'),
          binding('hotkeyPauseOrResume', 'hotkey_pause_or_resume_game'),
          binding('hotkeyQuicksave', 'hotkey_quickload'),
          binding('hotkeyQuickload', 'hotkey_quickpause'),
        ],
      ),
      const OptionSection(
        titleKey: 'settings.gamepad.miscellaneous',
        options: [
          BoolOption(
            titleKey: 'settings.gamepad.useArticBaseController',
            descriptionKey:
                'settings.gamepad.useArticBaseControllerDescription',
            icon: Icons.cloud_outlined,
            value: StoreBoolValue(
              IntBoolKey('Controls', 'use_artic_base_controller', false),
            ),
          ),
        ],
      ),
    ],
  );
});
