import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/emulator_setting_key.dart';
import '../../settings/sections/camera_settings.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../store_option_values.dart';
import '../translation_text.dart';

/// The options on the Camera page: the image source, camera device and flip of the inner camera
/// and of the outer left and right cameras.
final cameraPageOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'cameraPage',
    title: (t) => t.settings.camera.title,
    sections: [
      buildCameraSection(
        title: (t) => t.settings.camera.innerCamera,
        imageSource: CameraSettingKeys.innerImageSource,
        cameraDevice: CameraSettingKeys.innerCameraDevice,
        imageFlip: CameraSettingKeys.innerImageFlip,
      ),
      buildCameraSection(
        title: (t) => t.settings.camera.outerLeftCamera,
        imageSource: CameraSettingKeys.outerLeftImageSource,
        cameraDevice: CameraSettingKeys.outerLeftCameraDevice,
        imageFlip: CameraSettingKeys.outerLeftImageFlip,
      ),
      buildCameraSection(
        title: (t) => t.settings.camera.outerRightCamera,
        imageSource: CameraSettingKeys.outerRightImageSource,
        cameraDevice: CameraSettingKeys.outerRightCameraDevice,
        imageFlip: CameraSettingKeys.outerRightImageFlip,
      ),
    ],
  ),
);

/// Builds the section of one camera, set with the given emulator setting keys.
OptionSection buildCameraSection({
  required TranslationText title,
  required StringKey imageSource,
  required StringKey cameraDevice,
  required IntKey imageFlip,
}) {
  return OptionSection(
    title: title,
    options: [
      EnumOption<String>(
        title: (t) => t.settings.camera.imageSource,
        description: (t) => t.settings.camera.imageSourceDescription,
        icon: Icons.list,
        value: StoreStringValue(imageSource),
        choices: [
          EnumChoice(
            label: (t) => t.settings.camera.imageSourceBlank,
            value: 'blank',
          ),
          EnumChoice(
            label: (t) => t.settings.camera.imageSourceStillImage,
            value: 'image',
          ),
          EnumChoice(
            label: (t) => t.settings.camera.imageSourceDeviceCamera,
            value: 'ndk',
          ),
        ],
      ),
      EnumOption<String>(
        title: (t) => t.settings.camera.cameraDevice,
        description: (t) => t.settings.camera.cameraDeviceDescription,
        icon: Icons.list,
        value: StoreStringValue(cameraDevice),
        choices: [
          EnumChoice(
            label: (t) => t.settings.camera.cameraDeviceDefault,
            value: '',
          ),
          EnumChoice(
            label: (t) => t.settings.camera.cameraDeviceAnyFront,
            value: '_front',
          ),
          EnumChoice(
            label: (t) => t.settings.camera.cameraDeviceAnyBack,
            value: '_back',
          ),
        ],
      ),
      EnumOption<int>(
        title: (t) => t.settings.camera.imageFlip,
        icon: Icons.list,
        value: StoreIntValue(imageFlip),
        choices: [
          EnumChoice(label: (t) => t.settings.camera.imageFlipNone, value: 0),
          EnumChoice(
            label: (t) => t.settings.camera.imageFlipHorizontal,
            value: 1,
          ),
          EnumChoice(
            label: (t) => t.settings.camera.imageFlipVertical,
            value: 2,
          ),
          EnumChoice(
            label: (t) => t.settings.camera.imageFlipReverse,
            value: 3,
          ),
        ],
      ),
    ],
  );
}
