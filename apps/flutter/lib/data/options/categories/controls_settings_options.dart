import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../../screens/options/widgets/controller_profile_radio_list.dart';
import '../../gamepad/actions/console/console_action.dart';
import '../../gamepad/actions/console/console_actions.dart';
import '../../gamepad/actions/gamepad_action.dart';
import '../../gamepad/actions/gamepad_action_registry.dart';
import '../../settings/emulator_setting_key.dart';
import '../abstract_base_option.dart';
import '../input_binding_mode.dart';
import '../key_binding_option_value.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../store_option_values.dart';
import '../translation_text.dart';

/// The items of the gamepad settings page, which is not listed on the Options page: switching
/// between the controller profiles, the controller input mode, gyro, the key bindings of the
/// registered gamepad actions in the profile in use, hotkeys and the Artic Base controller. Using
/// them is not recorded in the history.
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

  final registry = ref.watch(gamepadActionRegistryProvider);

  InputBindingOption actionBinding(GamepadAction action) => InputBindingOption(
    title: action.title,
    icon: Icons.sports_esports_outlined,
    value: KeyBindingOptionValue(action),
    mode: action.defaultCombo.analog == null
        ? InputBindingMode.combo
        : InputBindingMode.stick,
  );

  return OptionCategory(
    id: 'controlsSettings',
    title: (t) => t.settings.gamepad.title,
    excludeFromHistory: true,
    sections: [
      OptionSection(
        title: (t) => t.settings.gamepad.controllerProfiles,
        options: [
          CustomWidgetOption(
            title: (t) => t.settings.gamepad.controllerProfiles,
            icon: Icons.sports_esports,
            builder: (context) => const ControllerProfileRadioList(),
          ),
        ],
      ),
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
        title: (t) => t.settings.gamepad.consoleControls,
        options: [for (final action in consoleActions) actionBinding(action)],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.emulationControls,
        options: [
          for (final action in registry.actionsOf(GamepadActionScope.emulation))
            if (action is! ConsoleAction) actionBinding(action),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.gamepad.appControls,
        options: [
          for (final action in registry.actionsOf(GamepadActionScope.app))
            actionBinding(action),
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
