import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';

abstract final class DebugSettingKeys {
  static const cpuClockSpeed = IntKey('Core', 'cpu_clock_percentage', 100);
  static const cpuJit = IntBoolKey('Core', 'use_cpu_jit', true);
  static const hwShaders = IntBoolKey('Renderer', 'use_hw_shader', true);
  static const vsync = IntBoolKey('Renderer', 'use_vsync_new', true);
  static const rendererDebug = IntBoolKey('Debugging', 'renderer_debug', false);
  static const instantDebugLog = IntBoolKey(
    'Debugging',
    'instant_debug_log',
    false,
  );
  static const delayStartLleModules = IntBoolKey(
    'Debugging',
    'delay_start_for_lle_modules',
    true,
  );
  static const deterministicAsyncOperations = IntBoolKey(
    'Debugging',
    'deterministic_async_operations',
    false,
  );
}

List<SettingsItem> buildDebugSettingsItems(Translations t) {
  final d = t.settings.debug;
  return [
    SettingsItem.header(title: d.warning),
    SettingsItem.slider(
      title: d.cpuClockSpeed,
      description: d.cpuClockSpeedDescription,
      setting: DebugSettingKeys.cpuClockSpeed,
      min: 25,
      max: 400,
      units: '%',
    ),
    SettingsItem.switch_(
      title: d.cpuJit,
      description: d.cpuJitDescription,
      setting: DebugSettingKeys.cpuJit,
    ),
    SettingsItem.switch_(
      title: d.hwShaders,
      description: d.hwShadersDescription,
      setting: DebugSettingKeys.hwShaders,
    ),
    SettingsItem.switch_(
      title: d.vsync,
      description: d.vsyncDescription,
      setting: DebugSettingKeys.vsync,
    ),
    SettingsItem.switch_(
      title: d.rendererDebug,
      description: d.rendererDebugDescription,
      setting: DebugSettingKeys.rendererDebug,
    ),
    SettingsItem.switch_(
      title: d.instantDebugLog,
      description: d.instantDebugLogDescription,
      setting: DebugSettingKeys.instantDebugLog,
    ),
    SettingsItem.switch_(
      title: d.delayStartLleModules,
      description: d.delayStartLleModulesDescription,
      setting: DebugSettingKeys.delayStartLleModules,
    ),
    SettingsItem.switch_(
      title: d.deterministicAsyncOperations,
      description: d.deterministicAsyncOperationsDescription,
      setting: DebugSettingKeys.deterministicAsyncOperations,
    ),
  ];
}
