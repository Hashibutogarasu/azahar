import '../emulator_setting_key.dart';

abstract final class GraphicsSettingKeys {
  static const graphicsApi = IntKey('Renderer', 'graphics_api', 1);
  static const spirvShaderGen = IntBoolKey(
    'Renderer',
    'spirv_shader_gen',
    true,
  );
  static const asyncShaders = IntBoolKey(
    'Renderer',
    'async_shader_compilation',
    false,
  );
  static const resolutionFactor = IntKey('Renderer', 'resolution_factor', 1);
  static const linearFiltering = IntBoolKey('Renderer', 'filter_mode', true);
  static const shadersAccurateMul = IntBoolKey(
    'Renderer',
    'shaders_accurate_mul',
    false,
  );
  static const diskShaderCache = IntBoolKey(
    'Renderer',
    'use_disk_shader_cache',
    true,
  );
  static const textureFilter = IntKey('Renderer', 'texture_filter', 0);
  static const delayRenderThreadUs = IntKey(
    'Renderer',
    'delay_game_render_thread_us',
    0,
  );
  static const stereoscopic3dMode = IntKey('Renderer', 'render_3d', 0);
  static const stereoscopic3dDepth = IntKey('Renderer', 'factor_3d', 0);
  static const disableRightEyeRender = IntBoolKey(
    'Renderer',
    'disable_right_eye_render',
    false,
  );
  static const cardboardScreenSize = IntKey(
    'Layout',
    'cardboard_screen_size',
    85,
  );
  static const cardboardXShift = IntKey('Layout', 'cardboard_x_shift', 0);
  static const cardboardYShift = IntKey('Layout', 'cardboard_y_shift', 0);
  static const dumpTextures = IntBoolKey('Utility', 'dump_textures', false);
  static const customTextures = IntBoolKey('Utility', 'custom_textures', false);
  static const asyncCustomLoading = IntBoolKey(
    'Utility',
    'async_custom_loading',
    true,
  );
  static const textureSampling = IntKey('Renderer', 'texture_sampling', 0);
}
