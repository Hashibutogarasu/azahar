import 'package:freezed_annotation/freezed_annotation.dart';

import 'actions/gamepad_key_combo.dart';

part 'key_binding.freezed.dart';

/// The key combination bound to the action `actionId` in the controller profile `profileId`.
@freezed
abstract class KeyBinding with _$KeyBinding {
  const factory KeyBinding({
    required String profileId,
    required String actionId,
    required GamepadKeyCombo combo,
  }) = _KeyBinding;
}
