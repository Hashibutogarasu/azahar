import 'package:freezed_annotation/freezed_annotation.dart';

part 'controller_profile.freezed.dart';

/// A set of controller settings that can be switched between. `isBuiltIn` marks the profile that
/// always exists and cannot be deleted.
@freezed
abstract class ControllerProfile with _$ControllerProfile {
  const factory ControllerProfile({
    required String cuid,
    required String name,
    required bool isBuiltIn,
    required DateTime createdAt,
  }) = _ControllerProfile;
}
