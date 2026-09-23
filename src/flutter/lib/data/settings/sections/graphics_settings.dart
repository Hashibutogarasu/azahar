import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';

abstract final class GraphicsSettingKeys {
  static const graphicsApi = IntKey('Renderer', 'graphics_api', 1);
  static const spirvShaderGen = IntBoolKey('Renderer', 'spirv_shader_gen', true);
  static const asyncShaders = IntBoolKey('Renderer', 'async_shader_compilation', false);
  static const resolutionFactor = IntKey('Renderer', 'resolution_factor', 1);
  static const linearFiltering = IntBoolKey('Renderer', 'filter_mode', true);
  static const shadersAccurateMul = IntBoolKey('Renderer', 'shaders_accurate_mul', false);
  static const diskShaderCache = IntBoolKey('Renderer', 'use_disk_shader_cache', true);
  static const textureFilter = IntKey('Renderer', 'texture_filter', 0);
  static const delayRenderThreadUs = IntKey('Renderer', 'delay_game_render_thread_us', 0);
  static const stereoscopic3dMode = IntKey('Renderer', 'render_3d', 0);
  static const stereoscopic3dDepth = IntKey('Renderer', 'factor_3d', 0);
  static const disableRightEyeRender = IntBoolKey('Renderer', 'disable_right_eye_render', false);
  static const cardboardScreenSize = IntKey('Layout', 'cardboard_screen_size', 85);
  static const cardboardXShift = IntKey('Layout', 'cardboard_x_shift', 0);
  static const cardboardYShift = IntKey('Layout', 'cardboard_y_shift', 0);
  static const dumpTextures = IntBoolKey('Utility', 'dump_textures', false);
  static const customTextures = IntBoolKey('Utility', 'custom_textures', false);
  static const asyncCustomLoading = IntBoolKey('Utility', 'async_custom_loading', true);
  static const textureSampling = IntKey('Renderer', 'texture_sampling', 0);
}

List<SettingsItem> buildGraphicsSettingsItems(Translations t) {
  final g = t.settings.graphics;
  return [
    SettingsItem.header(title: g.renderer),
    SettingsItem.singleChoice(
      title: g.graphicsApi,
      setting: GraphicsSettingKeys.graphicsApi,
      choiceLabels: [g.graphicsApiOpengles, g.graphicsApiVulkan],
      choiceValues: const [1, 2],
    ),
    SettingsItem.switch_(
      title: g.spirvShaderGen,
      description: g.spirvShaderGenDescription,
      setting: GraphicsSettingKeys.spirvShaderGen,
    ),
    SettingsItem.switch_(
      title: g.asyncShaders,
      description: g.asyncShadersDescription,
      setting: GraphicsSettingKeys.asyncShaders,
    ),
    SettingsItem.singleChoice(
      title: g.internalResolution,
      description: g.internalResolutionDescription,
      setting: GraphicsSettingKeys.resolutionFactor,
      choiceLabels: [
        g.internalResolutionNative,
        g.internalResolution2x,
        g.internalResolution3x,
        g.internalResolution4x,
        g.internalResolution5x,
        g.internalResolution6x,
        g.internalResolution7x,
        g.internalResolution8x,
        g.internalResolution9x,
        g.internalResolution10x,
      ],
      choiceValues: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    ),
    SettingsItem.switch_(
      title: g.linearFiltering,
      description: g.linearFilteringDescription,
      setting: GraphicsSettingKeys.linearFiltering,
    ),
    SettingsItem.switch_(
      title: g.shadersAccurateMul,
      description: g.shadersAccurateMulDescription,
      setting: GraphicsSettingKeys.shadersAccurateMul,
    ),
    SettingsItem.switch_(
      title: g.useDiskShaderCache,
      description: g.useDiskShaderCacheDescription,
      setting: GraphicsSettingKeys.diskShaderCache,
    ),
    SettingsItem.singleChoice(
      title: g.textureFilterName,
      description: g.textureFilterDescription,
      setting: GraphicsSettingKeys.textureFilter,
      choiceLabels: [
        g.textureFilterNone,
        g.textureFilterAnime4k,
        g.textureFilterBicubic,
        g.textureFilterScaleforce,
        g.textureFilterXbrz,
        g.textureFilterMmpx,
      ],
      choiceValues: const [0, 1, 2, 3, 4, 5],
    ),
    SettingsItem.slider(
      title: g.delayRenderThread,
      description: g.delayRenderThreadDescription,
      setting: GraphicsSettingKeys.delayRenderThreadUs,
      min: 0,
      max: 16000,
      units: ' μs',
    ),
    SettingsItem.header(title: g.stereoscopy),
    SettingsItem.singleChoice(
      title: g.render3d,
      setting: GraphicsSettingKeys.stereoscopic3dMode,
      choiceLabels: [
        g.render3dOff,
        g.render3dSideBySide,
        g.render3dReverseSideBySide,
        g.render3dAnaglyph,
        g.render3dInterlaced,
        g.render3dReverseInterlaced,
        g.render3dCardboardVr,
      ],
      choiceValues: const [0, 1, 2, 3, 4, 5, 6],
    ),
    SettingsItem.slider(
      title: g.factor3d,
      description: g.factor3dDescription,
      setting: GraphicsSettingKeys.stereoscopic3dDepth,
      min: 0,
      max: 100,
      units: '%',
    ),
    SettingsItem.switch_(
      title: g.disableRightEyeRender,
      description: g.disableRightEyeRenderDescription,
      setting: GraphicsSettingKeys.disableRightEyeRender,
    ),
    SettingsItem.header(title: g.cardboardVr),
    SettingsItem.slider(
      title: g.cardboardScreenSize,
      description: g.cardboardScreenSizeDescription,
      setting: GraphicsSettingKeys.cardboardScreenSize,
      min: 30,
      max: 100,
      units: '%',
    ),
    SettingsItem.slider(
      title: g.cardboardXShift,
      description: g.cardboardXShiftDescription,
      setting: GraphicsSettingKeys.cardboardXShift,
      min: -100,
      max: 100,
      units: '%',
    ),
    SettingsItem.slider(
      title: g.cardboardYShift,
      description: g.cardboardYShiftDescription,
      setting: GraphicsSettingKeys.cardboardYShift,
      min: -100,
      max: 100,
      units: '%',
    ),
    SettingsItem.header(title: g.utility),
    SettingsItem.switch_(
      title: g.dumpTextures,
      description: g.dumpTexturesDescription,
      setting: GraphicsSettingKeys.dumpTextures,
    ),
    SettingsItem.switch_(
      title: g.customTextures,
      description: g.customTexturesDescription,
      setting: GraphicsSettingKeys.customTextures,
    ),
    SettingsItem.switch_(
      title: g.asyncCustomLoading,
      description: g.asyncCustomLoadingDescription,
      setting: GraphicsSettingKeys.asyncCustomLoading,
    ),
    SettingsItem.header(title: g.advanced),
    SettingsItem.singleChoice(
      title: g.textureSamplingName,
      description: g.textureSamplingDescription,
      setting: GraphicsSettingKeys.textureSampling,
      choiceLabels: [
        g.textureSamplingGameControlled,
        g.textureSamplingNearestNeighbor,
        g.textureSamplingLinear,
      ],
      choiceValues: const [0, 1, 2],
    ),
  ];
}
