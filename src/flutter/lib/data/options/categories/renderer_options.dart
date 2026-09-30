import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/sections/graphics_settings.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../store_option_values.dart';

/// The items of the graphics settings page, which is not listed on the Options page: the renderer,
/// stereoscopy, Cardboard VR, utility and advanced settings.
final rendererOptionsProvider = Provider<OptionCategory>(
  (ref) => const OptionCategory(
    id: 'renderer',
    titleKey: 'settings.graphics.title',
    sections: [
      OptionSection(
        titleKey: 'settings.graphics.renderer',
        options: [
          EnumOption<int>(
            titleKey: 'settings.graphics.graphicsApi',
            icon: Icons.monitor,
            value: StoreIntValue(GraphicsSettingKeys.graphicsApi),
            choices: [
              EnumChoice(
                labelKey: 'settings.graphics.graphicsApiOpengles',
                value: 1,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.graphicsApiVulkan',
                value: 2,
              ),
            ],
          ),
          BoolOption(
            titleKey: 'settings.graphics.spirvShaderGen',
            descriptionKey: 'settings.graphics.spirvShaderGenDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(GraphicsSettingKeys.spirvShaderGen),
          ),
          BoolOption(
            titleKey: 'settings.graphics.asyncShaders',
            descriptionKey: 'settings.graphics.asyncShadersDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(GraphicsSettingKeys.asyncShaders),
          ),
          EnumOption<int>(
            titleKey: 'settings.graphics.internalResolution',
            descriptionKey: 'settings.graphics.internalResolutionDescription',
            icon: Icons.aspect_ratio,
            value: StoreIntValue(GraphicsSettingKeys.resolutionFactor),
            choices: [
              EnumChoice(
                labelKey: 'settings.graphics.internalResolutionNative',
                value: 1,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.internalResolution2x',
                value: 2,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.internalResolution3x',
                value: 3,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.internalResolution4x',
                value: 4,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.internalResolution5x',
                value: 5,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.internalResolution6x',
                value: 6,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.internalResolution7x',
                value: 7,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.internalResolution8x',
                value: 8,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.internalResolution9x',
                value: 9,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.internalResolution10x',
                value: 10,
              ),
            ],
          ),
          BoolOption(
            titleKey: 'settings.graphics.linearFiltering',
            descriptionKey: 'settings.graphics.linearFilteringDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(GraphicsSettingKeys.linearFiltering),
          ),
          BoolOption(
            titleKey: 'settings.graphics.shadersAccurateMul',
            descriptionKey: 'settings.graphics.shadersAccurateMulDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(GraphicsSettingKeys.shadersAccurateMul),
          ),
          BoolOption(
            titleKey: 'settings.graphics.useDiskShaderCache',
            descriptionKey: 'settings.graphics.useDiskShaderCacheDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(GraphicsSettingKeys.diskShaderCache),
          ),
          EnumOption<int>(
            titleKey: 'settings.graphics.textureFilterName',
            descriptionKey: 'settings.graphics.textureFilterDescription',
            icon: Icons.filter_vintage,
            value: StoreIntValue(GraphicsSettingKeys.textureFilter),
            choices: [
              EnumChoice(
                labelKey: 'settings.graphics.textureFilterNone',
                value: 0,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.textureFilterAnime4k',
                value: 1,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.textureFilterBicubic',
                value: 2,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.textureFilterScaleforce',
                value: 3,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.textureFilterXbrz',
                value: 4,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.textureFilterMmpx',
                value: 5,
              ),
            ],
          ),
          IntOption(
            titleKey: 'settings.graphics.delayRenderThread',
            descriptionKey: 'settings.graphics.delayRenderThreadDescription',
            icon: Icons.tune,
            value: StoreIntValue(GraphicsSettingKeys.delayRenderThreadUs),
            min: 0,
            max: 16000,
            defaultValue: 0,
            units: ' μs',
          ),
        ],
      ),
      OptionSection(
        titleKey: 'settings.graphics.stereoscopy',
        options: [
          EnumOption<int>(
            titleKey: 'settings.graphics.render3d',
            icon: Icons.view_in_ar,
            value: StoreIntValue(GraphicsSettingKeys.stereoscopic3dMode),
            choices: [
              EnumChoice(labelKey: 'settings.graphics.render3dOff', value: 0),
              EnumChoice(
                labelKey: 'settings.graphics.render3dSideBySide',
                value: 1,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.render3dReverseSideBySide',
                value: 2,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.render3dAnaglyph',
                value: 3,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.render3dInterlaced',
                value: 4,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.render3dReverseInterlaced',
                value: 5,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.render3dCardboardVr',
                value: 6,
              ),
            ],
          ),
          IntOption(
            titleKey: 'settings.graphics.factor3d',
            descriptionKey: 'settings.graphics.factor3dDescription',
            icon: Icons.tune,
            value: StoreIntValue(GraphicsSettingKeys.stereoscopic3dDepth),
            min: 0,
            max: 100,
            defaultValue: 0,
            units: '%',
          ),
          BoolOption(
            titleKey: 'settings.graphics.disableRightEyeRender',
            descriptionKey:
                'settings.graphics.disableRightEyeRenderDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(GraphicsSettingKeys.disableRightEyeRender),
          ),
        ],
      ),
      OptionSection(
        titleKey: 'settings.graphics.cardboardVr',
        options: [
          IntOption(
            titleKey: 'settings.graphics.cardboardScreenSize',
            descriptionKey: 'settings.graphics.cardboardScreenSizeDescription',
            icon: Icons.tune,
            value: StoreIntValue(GraphicsSettingKeys.cardboardScreenSize),
            min: 30,
            max: 100,
            defaultValue: 85,
            units: '%',
          ),
          IntOption(
            titleKey: 'settings.graphics.cardboardXShift',
            descriptionKey: 'settings.graphics.cardboardXShiftDescription',
            icon: Icons.tune,
            value: StoreIntValue(GraphicsSettingKeys.cardboardXShift),
            min: -100,
            max: 100,
            defaultValue: 0,
            units: '%',
          ),
          IntOption(
            titleKey: 'settings.graphics.cardboardYShift',
            descriptionKey: 'settings.graphics.cardboardYShiftDescription',
            icon: Icons.tune,
            value: StoreIntValue(GraphicsSettingKeys.cardboardYShift),
            min: -100,
            max: 100,
            defaultValue: 0,
            units: '%',
          ),
        ],
      ),
      OptionSection(
        titleKey: 'settings.graphics.utility',
        options: [
          BoolOption(
            titleKey: 'settings.graphics.dumpTextures',
            descriptionKey: 'settings.graphics.dumpTexturesDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(GraphicsSettingKeys.dumpTextures),
          ),
          BoolOption(
            titleKey: 'settings.graphics.customTextures',
            descriptionKey: 'settings.graphics.customTexturesDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(GraphicsSettingKeys.customTextures),
          ),
          BoolOption(
            titleKey: 'settings.graphics.asyncCustomLoading',
            descriptionKey: 'settings.graphics.asyncCustomLoadingDescription',
            icon: Icons.toggle_on_outlined,
            value: StoreBoolValue(GraphicsSettingKeys.asyncCustomLoading),
          ),
        ],
      ),
      OptionSection(
        titleKey: 'settings.graphics.advanced',
        options: [
          EnumOption<int>(
            titleKey: 'settings.graphics.textureSamplingName',
            descriptionKey: 'settings.graphics.textureSamplingDescription',
            icon: Icons.grid_on,
            value: StoreIntValue(GraphicsSettingKeys.textureSampling),
            choices: [
              EnumChoice(
                labelKey: 'settings.graphics.textureSamplingGameControlled',
                value: 0,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.textureSamplingNearestNeighbor',
                value: 1,
              ),
              EnumChoice(
                labelKey: 'settings.graphics.textureSamplingLinear',
                value: 2,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);
