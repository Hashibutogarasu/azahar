import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/emulator_setting_key.dart';
import '../../settings/sections/camera_settings.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../store_option_values.dart';

/// The options on the Camera page: the image source, camera device and flip of the inner camera
/// and of the outer left and right cameras.
final cameraPageOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'cameraPage',
    titleKey: 'settings.camera.title',
    sections: [
      buildCameraSection(
        titleKey: 'settings.camera.innerCamera',
        imageSource: CameraSettingKeys.innerImageSource,
        cameraDevice: CameraSettingKeys.innerCameraDevice,
        imageFlip: CameraSettingKeys.innerImageFlip,
      ),
      buildCameraSection(
        titleKey: 'settings.camera.outerLeftCamera',
        imageSource: CameraSettingKeys.outerLeftImageSource,
        cameraDevice: CameraSettingKeys.outerLeftCameraDevice,
        imageFlip: CameraSettingKeys.outerLeftImageFlip,
      ),
      buildCameraSection(
        titleKey: 'settings.camera.outerRightCamera',
        imageSource: CameraSettingKeys.outerRightImageSource,
        cameraDevice: CameraSettingKeys.outerRightCameraDevice,
        imageFlip: CameraSettingKeys.outerRightImageFlip,
      ),
    ],
  ),
);

/// Builds the section of one camera, set with the given emulator setting keys.
OptionSection buildCameraSection({
  required String titleKey,
  required StringKey imageSource,
  required StringKey cameraDevice,
  required IntKey imageFlip,
}) {
  return OptionSection(
    titleKey: titleKey,
    options: [
      EnumOption<String>(
        titleKey: 'settings.camera.imageSource',
        descriptionKey: 'settings.camera.imageSourceDescription',
        icon: Icons.list,
        value: StoreStringValue(imageSource),
        choices: const [
          EnumChoice(
            labelKey: 'settings.camera.imageSourceBlank',
            value: 'blank',
          ),
          EnumChoice(
            labelKey: 'settings.camera.imageSourceStillImage',
            value: 'image',
          ),
          EnumChoice(
            labelKey: 'settings.camera.imageSourceDeviceCamera',
            value: 'ndk',
          ),
        ],
      ),
      EnumOption<String>(
        titleKey: 'settings.camera.cameraDevice',
        descriptionKey: 'settings.camera.cameraDeviceDescription',
        icon: Icons.list,
        value: StoreStringValue(cameraDevice),
        choices: const [
          EnumChoice(
            labelKey: 'settings.camera.cameraDeviceDefault',
            value: '',
          ),
          EnumChoice(
            labelKey: 'settings.camera.cameraDeviceAnyFront',
            value: '_front',
          ),
          EnumChoice(
            labelKey: 'settings.camera.cameraDeviceAnyBack',
            value: '_back',
          ),
        ],
      ),
      EnumOption<int>(
        titleKey: 'settings.camera.imageFlip',
        icon: Icons.list,
        value: StoreIntValue(imageFlip),
        choices: const [
          EnumChoice(labelKey: 'settings.camera.imageFlipNone', value: 0),
          EnumChoice(labelKey: 'settings.camera.imageFlipHorizontal', value: 1),
          EnumChoice(labelKey: 'settings.camera.imageFlipVertical', value: 2),
          EnumChoice(labelKey: 'settings.camera.imageFlipReverse', value: 3),
        ],
      ),
    ],
  );
}
