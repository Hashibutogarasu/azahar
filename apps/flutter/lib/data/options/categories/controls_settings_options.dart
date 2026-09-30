import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../settings/emulator_setting_key.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../store_option_values.dart';
import '../translation_text.dart';

/// The items of the gamepad settings page, which is not listed on the Options page: the controller
/// input mode, gyro, button and axis bindings, hotkeys and the Artic Base controller.
final controlsSettingsOptionsProvider = Provider<OptionCategory>((ref) {
  final bindings = AppServices.controlBindingsValueStore;

  InputBindingOption binding(TranslationText title, String key) =>
      InputBindingOption(
        title: title,
        icon: Icons.sports_esports_outlined,
        value: StoreStringValue(
          StringKey('Controls', key, ''),
          store: bindings,
        ),
      );

  return OptionCategory(
    id: 'controlsSettings',
    title: (t) => t.settings.gamepad.title,
    sections: [
      OptionSection(
        options: [
          EnumOption<int>(
            title: (t) => t.settings.gamepad.controllerInputMode,
            description: (t) =>
                t.settings.gamepad.controllerInputModeDescription,
            icon: Icons.list,
            value: const StoreIntValue(
              IntKey('Controls', 'controller_input_mode', 0),
            ),
            choices: [
              EnumChoice(
                label: (t) => t.settings.gamepad.controllerInputModeManual,
                value: 0,
              ),
              EnumChoice(
                label: (t) => t.settings.gamepad.controllerInputModeAutoDetect,
                value: 1,
              ),
            ],
          ),
          BoolOption(
            title: (t) => t.settings.gamepad.invertLeftStickYAxis,
            description: (t) =>
                t.settings.gamepad.invertLeftStickYAxisDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(
              IntBoolKey(
                'Controls',
                'invert_controller_left_stick_y_axis',
                false,
              ),
            ),
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.gyroSettings,
        options: [
          EnumOption<int>(
            title: (t) => t.settings.gamepad.gyroInputSource,
            description: (t) => t.settings.gamepad.gyroInputSourceDescription,
            icon: Icons.list,
            value: const StoreIntValue(
              IntKey('Controls', 'gyro_input_source', 0),
            ),
            choices: [
              EnumChoice(
                label: (t) => t.settings.gamepad.gyroInputSourceDevice,
                value: 0,
              ),
              EnumChoice(
                label: (t) => t.settings.gamepad.gyroInputSourceController,
                value: 1,
              ),
            ],
          ),
          PercentOption(
            title: (t) => t.settings.gamepad.gyroSensitivityVertical,
            description: (t) =>
                t.settings.gamepad.gyroSensitivityVerticalDescription,
            icon: Icons.screen_rotation,
            value: const FloatPercentValue(
              StoreFloatValue(
                ScaledFloatKey(
                  'Controls',
                  'gyro_sensitivity_vertical',
                  1.0,
                  100,
                ),
              ),
            ),
            max: 2.0,
            defaultValue: 1.0,
          ),
          BoolOption(
            title: (t) => t.settings.gamepad.invertGyroVertical,
            description: (t) =>
                t.settings.gamepad.invertGyroVerticalDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(
              IntBoolKey('Controls', 'invert_gyro_vertical', false),
            ),
          ),
          PercentOption(
            title: (t) => t.settings.gamepad.gyroSensitivityHorizontal,
            description: (t) =>
                t.settings.gamepad.gyroSensitivityHorizontalDescription,
            icon: Icons.screen_rotation,
            value: const FloatPercentValue(
              StoreFloatValue(
                ScaledFloatKey(
                  'Controls',
                  'gyro_sensitivity_horizontal',
                  1.0,
                  100,
                ),
              ),
            ),
            max: 2.0,
            defaultValue: 1.0,
          ),
          BoolOption(
            title: (t) => t.settings.gamepad.invertGyroHorizontal,
            description: (t) =>
                t.settings.gamepad.invertGyroHorizontalDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(
              IntBoolKey('Controls', 'invert_gyro_horizontal', false),
            ),
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.genericButtons,
        options: [
          binding((t) => t.settings.gamepad.buttonA, 'button_a'),
          binding((t) => t.settings.gamepad.buttonB, 'button_b'),
          binding((t) => t.settings.gamepad.buttonX, 'button_x'),
          binding((t) => t.settings.gamepad.buttonY, 'button_y'),
          binding((t) => t.settings.gamepad.buttonSelect, 'button_select'),
          binding((t) => t.settings.gamepad.buttonStart, 'button_start'),
          binding((t) => t.settings.gamepad.buttonHome, 'button_home'),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.circlePad,
        options: [
          binding(
            (t) => t.settings.gamepad.axisVertical,
            'circlepad_axis_vertical',
          ),
          binding(
            (t) => t.settings.gamepad.axisHorizontal,
            'circlepad_axis_horizontal',
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.cStick,
        options: [
          binding(
            (t) => t.settings.gamepad.axisVertical,
            'cstick_axis_vertical',
          ),
          binding(
            (t) => t.settings.gamepad.axisHorizontal,
            'cstick_axis_horizontal',
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.dpadAxis,
        options: [
          binding((t) => t.settings.gamepad.axisVertical, 'dpad_axis_vertical'),
          binding(
            (t) => t.settings.gamepad.axisHorizontal,
            'dpad_axis_horizontal',
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.dpadButtons,
        options: [
          binding((t) => t.settings.gamepad.buttonUp, 'button_up'),
          binding((t) => t.settings.gamepad.buttonDown, 'button_down'),
          binding((t) => t.settings.gamepad.buttonLeft, 'button_left'),
          binding((t) => t.settings.gamepad.buttonRight, 'button_right'),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.triggers,
        options: [
          binding((t) => t.settings.gamepad.buttonL, 'button_l'),
          binding((t) => t.settings.gamepad.buttonR, 'button_r'),
          binding((t) => t.settings.gamepad.buttonZl, 'button_zl'),
          binding((t) => t.settings.gamepad.buttonZr, 'button_zr'),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.hotkeys,
        options: [
          binding(
            (t) => t.settings.gamepad.hotkeySwapScreens,
            'hotkey_screen_swap',
          ),
          binding(
            (t) => t.settings.gamepad.hotkeyCycleLayout,
            'hotkey_toggle_layout',
          ),
          binding(
            (t) => t.settings.gamepad.hotkeyCloseGame,
            'hotkey_close_game',
          ),
          binding(
            (t) => t.settings.gamepad.hotkeyPauseOrResume,
            'hotkey_pause_or_resume_game',
          ),
          binding(
            (t) => t.settings.gamepad.hotkeyQuicksave,
            'hotkey_quickload',
          ),
          binding(
            (t) => t.settings.gamepad.hotkeyQuickload,
            'hotkey_quickpause',
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.miscellaneous,
        options: [
          BoolOption(
            title: (t) => t.settings.gamepad.useArticBaseController,
            description: (t) =>
                t.settings.gamepad.useArticBaseControllerDescription,
            icon: Icons.cloud_outlined,
            value: const StoreBoolValue(
              IntBoolKey('Controls', 'use_artic_base_controller', false),
            ),
          ),
        ],
      ),
    ],
  );
});
