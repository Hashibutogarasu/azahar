import '../../../i18n/translations.g.dart';
import '../emulator_setting_key.dart';
import '../settings_item.dart';

abstract final class CameraSettingKeys {
  static const innerImageSource = StringKey('Camera', 'camera_inner_name', 'ndk');
  static const innerCameraDevice = StringKey('Camera', 'camera_inner_config', '_front');
  static const innerImageFlip = IntKey('Camera', 'camera_inner_flip', 0);
  static const outerLeftImageSource = StringKey('Camera', 'camera_outer_left_name', 'ndk');
  static const outerLeftCameraDevice = StringKey('Camera', 'camera_outer_left_config', '_back');
  static const outerLeftImageFlip = IntKey('Camera', 'camera_outer_left_flip', 0);
  static const outerRightImageSource = StringKey('Camera', 'camera_outer_right_name', 'ndk');
  static const outerRightCameraDevice = StringKey('Camera', 'camera_outer_right_config', '_back');
  static const outerRightImageFlip = IntKey('Camera', 'camera_outer_right_flip', 0);
}

List<SettingsItem> buildCameraSettingsItems(Translations t) {
  final c = t.settings.camera;
  return [
    SettingsItem.header(title: c.innerCamera),
    ..._buildCameraGroup(
      c,
      imageSource: CameraSettingKeys.innerImageSource,
      cameraDevice: CameraSettingKeys.innerCameraDevice,
      imageFlip: CameraSettingKeys.innerImageFlip,
    ),
    SettingsItem.header(title: c.outerLeftCamera),
    ..._buildCameraGroup(
      c,
      imageSource: CameraSettingKeys.outerLeftImageSource,
      cameraDevice: CameraSettingKeys.outerLeftCameraDevice,
      imageFlip: CameraSettingKeys.outerLeftImageFlip,
    ),
    SettingsItem.header(title: c.outerRightCamera),
    ..._buildCameraGroup(
      c,
      imageSource: CameraSettingKeys.outerRightImageSource,
      cameraDevice: CameraSettingKeys.outerRightCameraDevice,
      imageFlip: CameraSettingKeys.outerRightImageFlip,
    ),
  ];
}

List<SettingsItem> _buildCameraGroup(
  Translations$settings$camera$en c, {
  required StringKey imageSource,
  required StringKey cameraDevice,
  required IntKey imageFlip,
}) {
  return [
    SettingsItem.stringSingleChoice(
      title: c.imageSource,
      setting: imageSource,
      choiceLabels: [c.imageSourceBlank, c.imageSourceStillImage, c.imageSourceDeviceCamera],
      choiceValues: const ['blank', 'image', 'ndk'],
    ),
    SettingsItem.stringSingleChoice(
      title: c.cameraDevice,
      setting: cameraDevice,
      choiceLabels: [c.cameraDeviceDefault, c.cameraDeviceAnyFront, c.cameraDeviceAnyBack],
      choiceValues: const ['', '_front', '_back'],
    ),
    SettingsItem.singleChoice(
      title: c.imageFlip,
      setting: imageFlip,
      choiceLabels: [c.imageFlipNone, c.imageFlipHorizontal, c.imageFlipVertical, c.imageFlipReverse],
      choiceValues: const [0, 1, 2, 3],
    ),
  ];
}
