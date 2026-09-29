import '../../../i18n/translations.g.dart';
import '../control_bindings_value_store.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';

class ControlBinding {
  const ControlBinding(this.label, this.key);

  final String label;
  final StringKey key;
}

List<SettingsItem> buildControlsSettingsItems(
  Translations t,
  ControlBindingsValueStore controlBindingsStore,
) {
  final c = t.settings.gamepad;
  return [
    SettingsItem.singleChoice(
      title: c.controllerInputMode,
      description: c.controllerInputModeDescription,
      setting: const IntKey('Controls', 'controller_input_mode', 0),
      choiceLabels: [
        c.controllerInputModeManual,
        c.controllerInputModeAutoDetect,
      ],
      choiceValues: const [0, 1],
    ),
    SettingsItem.switch_(
      title: c.invertLeftStickYAxis,
      description: c.invertLeftStickYAxisDescription,
      setting: const IntBoolKey(
        'Controls',
        'invert_controller_left_stick_y_axis',
        false,
      ),
    ),
    SettingsItem.header(title: c.gyroSettings),
    SettingsItem.singleChoice(
      title: c.gyroInputSource,
      description: c.gyroInputSourceDescription,
      setting: const IntKey('Controls', 'gyro_input_source', 0),
      choiceLabels: [c.gyroInputSourceDevice, c.gyroInputSourceController],
      choiceValues: const [0, 1],
    ),
    SettingsItem.floatSlider(
      title: c.gyroSensitivityVertical,
      description: c.gyroSensitivityVerticalDescription,
      setting: const ScaledFloatKey(
        'Controls',
        'gyro_sensitivity_vertical',
        1.0,
        100,
      ),
      min: 0,
      max: 200,
      units: '%',
    ),
    SettingsItem.switch_(
      title: c.invertGyroVertical,
      description: c.invertGyroVerticalDescription,
      setting: const IntBoolKey('Controls', 'invert_gyro_vertical', false),
    ),
    SettingsItem.floatSlider(
      title: c.gyroSensitivityHorizontal,
      description: c.gyroSensitivityHorizontalDescription,
      setting: const ScaledFloatKey(
        'Controls',
        'gyro_sensitivity_horizontal',
        1.0,
        100,
      ),
      min: 0,
      max: 200,
      units: '%',
    ),
    SettingsItem.switch_(
      title: c.invertGyroHorizontal,
      description: c.invertGyroHorizontalDescription,
      setting: const IntBoolKey('Controls', 'invert_gyro_horizontal', false),
    ),
    SettingsItem.header(title: c.genericButtons),
    ..._bindingItems(controlBindingsStore, [
      ControlBinding(c.buttonA, const StringKey('Controls', 'button_a', '')),
      ControlBinding(c.buttonB, const StringKey('Controls', 'button_b', '')),
      ControlBinding(c.buttonX, const StringKey('Controls', 'button_x', '')),
      ControlBinding(c.buttonY, const StringKey('Controls', 'button_y', '')),
      ControlBinding(
        c.buttonSelect,
        const StringKey('Controls', 'button_select', ''),
      ),
      ControlBinding(
        c.buttonStart,
        const StringKey('Controls', 'button_start', ''),
      ),
      ControlBinding(
        c.buttonHome,
        const StringKey('Controls', 'button_home', ''),
      ),
    ]),
    SettingsItem.header(title: c.circlePad),
    ..._bindingItems(controlBindingsStore, [
      ControlBinding(
        c.axisVertical,
        const StringKey('Controls', 'circlepad_axis_vertical', ''),
      ),
      ControlBinding(
        c.axisHorizontal,
        const StringKey('Controls', 'circlepad_axis_horizontal', ''),
      ),
    ]),
    SettingsItem.header(title: c.cStick),
    ..._bindingItems(controlBindingsStore, [
      ControlBinding(
        c.axisVertical,
        const StringKey('Controls', 'cstick_axis_vertical', ''),
      ),
      ControlBinding(
        c.axisHorizontal,
        const StringKey('Controls', 'cstick_axis_horizontal', ''),
      ),
    ]),
    SettingsItem.header(title: c.dpadAxis, description: c.dpadAxisDescription),
    ..._bindingItems(controlBindingsStore, [
      ControlBinding(
        c.axisVertical,
        const StringKey('Controls', 'dpad_axis_vertical', ''),
      ),
      ControlBinding(
        c.axisHorizontal,
        const StringKey('Controls', 'dpad_axis_horizontal', ''),
      ),
    ]),
    SettingsItem.header(
      title: c.dpadButtons,
      description: c.dpadButtonsDescription,
    ),
    ..._bindingItems(controlBindingsStore, [
      ControlBinding(c.buttonUp, const StringKey('Controls', 'button_up', '')),
      ControlBinding(
        c.buttonDown,
        const StringKey('Controls', 'button_down', ''),
      ),
      ControlBinding(
        c.buttonLeft,
        const StringKey('Controls', 'button_left', ''),
      ),
      ControlBinding(
        c.buttonRight,
        const StringKey('Controls', 'button_right', ''),
      ),
    ]),
    SettingsItem.header(title: c.triggers),
    ..._bindingItems(controlBindingsStore, [
      ControlBinding(c.buttonL, const StringKey('Controls', 'button_l', '')),
      ControlBinding(c.buttonR, const StringKey('Controls', 'button_r', '')),
      ControlBinding(c.buttonZl, const StringKey('Controls', 'button_zl', '')),
      ControlBinding(c.buttonZr, const StringKey('Controls', 'button_zr', '')),
    ]),
    SettingsItem.header(title: c.hotkeys),
    ..._bindingItems(controlBindingsStore, [
      ControlBinding(
        c.hotkeySwapScreens,
        const StringKey('Controls', 'hotkey_screen_swap', ''),
      ),
      ControlBinding(
        c.hotkeyCycleLayout,
        const StringKey('Controls', 'hotkey_toggle_layout', ''),
      ),
      ControlBinding(
        c.hotkeyCloseGame,
        const StringKey('Controls', 'hotkey_close_game', ''),
      ),
      ControlBinding(
        c.hotkeyPauseOrResume,
        const StringKey('Controls', 'hotkey_pause_or_resume_game', ''),
      ),
      ControlBinding(
        c.hotkeyQuicksave,
        const StringKey('Controls', 'hotkey_quickload', ''),
      ),
      ControlBinding(
        c.hotkeyQuickload,
        const StringKey('Controls', 'hotkey_quickpause', ''),
      ),
    ]),
    SettingsItem.header(title: c.miscellaneous),
    SettingsItem.switch_(
      title: c.useArticBaseController,
      description: c.useArticBaseControllerDescription,
      setting: const IntBoolKey('Controls', 'use_artic_base_controller', false),
    ),
  ];
}

List<SettingsItem> _bindingItems(
  ControlBindingsValueStore store,
  List<ControlBinding> bindings,
) {
  return [
    for (final binding in bindings)
      SettingsItem.inputBinding(
        title: binding.label,
        setting: binding.key,
        store: store,
      ),
  ];
}
