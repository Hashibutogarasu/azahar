import '../emulator_setting_key.dart';

abstract final class CameraSettingKeys {
  static const innerImageSource = StringKey(
    'Camera',
    'camera_inner_name',
    'ndk',
  );
  static const innerCameraDevice = StringKey(
    'Camera',
    'camera_inner_config',
    '_front',
  );
  static const innerImageFlip = IntKey('Camera', 'camera_inner_flip', 0);
  static const outerLeftImageSource = StringKey(
    'Camera',
    'camera_outer_left_name',
    'ndk',
  );
  static const outerLeftCameraDevice = StringKey(
    'Camera',
    'camera_outer_left_config',
    '_back',
  );
  static const outerLeftImageFlip = IntKey(
    'Camera',
    'camera_outer_left_flip',
    0,
  );
  static const outerRightImageSource = StringKey(
    'Camera',
    'camera_outer_right_name',
    'ndk',
  );
  static const outerRightCameraDevice = StringKey(
    'Camera',
    'camera_outer_right_config',
    '_back',
  );
  static const outerRightImageFlip = IntKey(
    'Camera',
    'camera_outer_right_flip',
    0,
  );
}
