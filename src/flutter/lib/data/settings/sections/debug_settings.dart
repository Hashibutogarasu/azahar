import '../emulator_setting_key.dart';

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
