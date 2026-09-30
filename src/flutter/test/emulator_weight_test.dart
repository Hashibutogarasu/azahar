import 'package:azahar/data/options/emulator/settings/async_shaders_setting.dart';
import 'package:azahar/data/options/emulator/settings/emulation_speed_setting.dart';
import 'package:azahar/data/options/emulator/settings/emulator_setting.dart';
import 'package:azahar/data/options/emulator/settings/graphics_api_setting.dart';
import 'package:azahar/data/options/emulator/settings/internal_resolution_setting.dart';
import 'package:azahar/data/options/emulator/settings/shader_cache_setting.dart';
import 'package:azahar/data/options/emulator/settings/spirv_shader_gen_setting.dart';
import 'package:azahar/data/options/emulator/settings/texture_filter_setting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const settings = <EmulatorSetting<Object?>>[
    GraphicsApiSetting(),
    InternalResolutionSetting(),
    EmulationSpeedSetting(),
    TextureFilterSetting(),
    ShaderCacheSetting(),
    SpirvShaderGenSetting(),
    AsyncShadersSetting(),
  ];

  test('the shares of all settings add up to 1.0', () {
    final total = settings.fold<double>(0, (sum, s) => sum + s.weightIndex);
    expect(total, closeTo(1.0, 1e-9));
  });

  test('the graphics API has the largest share, then the resolution', () {
    final shares = settings.map((s) => s.weightIndex).toList()
      ..sort((a, b) => b.compareTo(a));
    expect(shares[0], const GraphicsApiSetting().weightIndex);
    expect(shares[1], const InternalResolutionSetting().weightIndex);
  });

  test('a higher internal resolution weighs more', () {
    const resolution = InternalResolutionSetting();
    expect(
      resolution.weightFactor(10),
      greaterThan(resolution.weightFactor(1)),
    );
    expect(resolution.weightFactor(10), lessThanOrEqualTo(1.0));
  });

  test('every factor stays within 0.0 and 1.0', () {
    for (final factor in [
      for (final v in [1, 2]) const GraphicsApiSetting().weightFactor(v),
      for (var v = 0; v <= 5; v++) const TextureFilterSetting().weightFactor(v),
      for (final v in [0.01, 1.0, 2.0, 5.0])
        const EmulationSpeedSetting().weightFactor(v),
      for (final v in [true, false]) ...[
        const ShaderCacheSetting().weightFactor(v),
        const SpirvShaderGenSetting().weightFactor(v),
        const AsyncShadersSetting().weightFactor(v),
      ],
    ]) {
      expect(factor, inInclusiveRange(0.0, 1.0));
    }
  });
}
