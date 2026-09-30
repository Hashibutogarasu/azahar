import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/sections/graphics_settings.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';
import '../store_option_values.dart';

/// The items of the graphics settings page, which is not listed on the Options page: the renderer,
/// stereoscopy, Cardboard VR, utility and advanced settings.
final rendererOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'renderer',
    title: (t) => t.settings.graphics.title,
    sections: [
      OptionSection(
        title: (t) => t.settings.graphics.renderer,
        options: [
          EnumOption<int>(
            title: (t) => t.settings.graphics.graphicsApi,
            icon: Icons.monitor,
            value: const StoreIntValue(GraphicsSettingKeys.graphicsApi),
            choices: [
              EnumChoice(
                label: (t) => t.settings.graphics.graphicsApiOpengles,
                value: 1,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.graphicsApiVulkan,
                value: 2,
              ),
            ],
          ),
          BoolOption(
            title: (t) => t.settings.graphics.spirvShaderGen,
            description: (t) => t.settings.graphics.spirvShaderGenDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(GraphicsSettingKeys.spirvShaderGen),
          ),
          BoolOption(
            title: (t) => t.settings.graphics.asyncShaders,
            description: (t) => t.settings.graphics.asyncShadersDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(GraphicsSettingKeys.asyncShaders),
          ),
          EnumOption<int>(
            title: (t) => t.settings.graphics.internalResolution,
            description: (t) =>
                t.settings.graphics.internalResolutionDescription,
            icon: Icons.aspect_ratio,
            value: const StoreIntValue(GraphicsSettingKeys.resolutionFactor),
            choices: [
              EnumChoice(
                label: (t) => t.settings.graphics.internalResolutionNative,
                value: 1,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.internalResolution2x,
                value: 2,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.internalResolution3x,
                value: 3,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.internalResolution4x,
                value: 4,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.internalResolution5x,
                value: 5,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.internalResolution6x,
                value: 6,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.internalResolution7x,
                value: 7,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.internalResolution8x,
                value: 8,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.internalResolution9x,
                value: 9,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.internalResolution10x,
                value: 10,
              ),
            ],
          ),
          BoolOption(
            title: (t) => t.settings.graphics.linearFiltering,
            description: (t) => t.settings.graphics.linearFilteringDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(GraphicsSettingKeys.linearFiltering),
          ),
          BoolOption(
            title: (t) => t.settings.graphics.shadersAccurateMul,
            description: (t) =>
                t.settings.graphics.shadersAccurateMulDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(GraphicsSettingKeys.shadersAccurateMul),
          ),
          BoolOption(
            title: (t) => t.settings.graphics.useDiskShaderCache,
            description: (t) =>
                t.settings.graphics.useDiskShaderCacheDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(GraphicsSettingKeys.diskShaderCache),
          ),
          EnumOption<int>(
            title: (t) => t.settings.graphics.textureFilterName,
            description: (t) => t.settings.graphics.textureFilterDescription,
            icon: Icons.filter_vintage,
            value: const StoreIntValue(GraphicsSettingKeys.textureFilter),
            choices: [
              EnumChoice(
                label: (t) => t.settings.graphics.textureFilterNone,
                value: 0,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.textureFilterAnime4k,
                value: 1,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.textureFilterBicubic,
                value: 2,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.textureFilterScaleforce,
                value: 3,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.textureFilterXbrz,
                value: 4,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.textureFilterMmpx,
                value: 5,
              ),
            ],
          ),
          IntOption(
            title: (t) => t.settings.graphics.delayRenderThread,
            description: (t) =>
                t.settings.graphics.delayRenderThreadDescription,
            icon: Icons.tune,
            value: const StoreIntValue(GraphicsSettingKeys.delayRenderThreadUs),
            min: 0,
            max: 16000,
            defaultValue: 0,
            units: ' μs',
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.graphics.stereoscopy,
        options: [
          EnumOption<int>(
            title: (t) => t.settings.graphics.render3d,
            icon: Icons.view_in_ar,
            value: const StoreIntValue(GraphicsSettingKeys.stereoscopic3dMode),
            choices: [
              EnumChoice(
                label: (t) => t.settings.graphics.render3dOff,
                value: 0,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.render3dSideBySide,
                value: 1,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.render3dReverseSideBySide,
                value: 2,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.render3dAnaglyph,
                value: 3,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.render3dInterlaced,
                value: 4,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.render3dReverseInterlaced,
                value: 5,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.render3dCardboardVr,
                value: 6,
              ),
            ],
          ),
          PercentOption(
            title: (t) => t.settings.graphics.factor3d,
            description: (t) => t.settings.graphics.factor3dDescription,
            icon: Icons.tune,
            value: const IntPercentValue(
              StoreIntValue(GraphicsSettingKeys.stereoscopic3dDepth),
            ),
            defaultValue: 0.0,
          ),
          BoolOption(
            title: (t) => t.settings.graphics.disableRightEyeRender,
            description: (t) =>
                t.settings.graphics.disableRightEyeRenderDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(
              GraphicsSettingKeys.disableRightEyeRender,
            ),
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.graphics.cardboardVr,
        options: [
          PercentOption(
            title: (t) => t.settings.graphics.cardboardScreenSize,
            description: (t) =>
                t.settings.graphics.cardboardScreenSizeDescription,
            icon: Icons.tune,
            value: const IntPercentValue(
              StoreIntValue(GraphicsSettingKeys.cardboardScreenSize),
            ),
            min: 0.3,
            defaultValue: 0.85,
          ),
          PercentOption(
            title: (t) => t.settings.graphics.cardboardXShift,
            description: (t) => t.settings.graphics.cardboardXShiftDescription,
            icon: Icons.tune,
            value: const IntPercentValue(
              StoreIntValue(GraphicsSettingKeys.cardboardXShift),
            ),
            min: -1.0,
            defaultValue: 0.0,
          ),
          PercentOption(
            title: (t) => t.settings.graphics.cardboardYShift,
            description: (t) => t.settings.graphics.cardboardYShiftDescription,
            icon: Icons.tune,
            value: const IntPercentValue(
              StoreIntValue(GraphicsSettingKeys.cardboardYShift),
            ),
            min: -1.0,
            defaultValue: 0.0,
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.graphics.utility,
        options: [
          BoolOption(
            title: (t) => t.settings.graphics.dumpTextures,
            description: (t) => t.settings.graphics.dumpTexturesDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(GraphicsSettingKeys.dumpTextures),
          ),
          BoolOption(
            title: (t) => t.settings.graphics.customTextures,
            description: (t) => t.settings.graphics.customTexturesDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(GraphicsSettingKeys.customTextures),
          ),
          BoolOption(
            title: (t) => t.settings.graphics.asyncCustomLoading,
            description: (t) =>
                t.settings.graphics.asyncCustomLoadingDescription,
            icon: Icons.toggle_on_outlined,
            value: const StoreBoolValue(GraphicsSettingKeys.asyncCustomLoading),
          ),
        ],
      ),
      OptionSection(
        title: (t) => t.settings.graphics.advanced,
        options: [
          EnumOption<int>(
            title: (t) => t.settings.graphics.textureSamplingName,
            description: (t) => t.settings.graphics.textureSamplingDescription,
            icon: Icons.grid_on,
            value: const StoreIntValue(GraphicsSettingKeys.textureSampling),
            choices: [
              EnumChoice(
                label: (t) => t.settings.graphics.textureSamplingGameControlled,
                value: 0,
              ),
              EnumChoice(
                label: (t) =>
                    t.settings.graphics.textureSamplingNearestNeighbor,
                value: 1,
              ),
              EnumChoice(
                label: (t) => t.settings.graphics.textureSamplingLinear,
                value: 2,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);
