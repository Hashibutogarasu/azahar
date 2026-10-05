import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_controller_profile.freezed.dart';

/// What a controller profile is created from.
@freezed
abstract class NewControllerProfile with _$NewControllerProfile {
  const factory NewControllerProfile({
    required String name,
    @Default(false) bool isBuiltIn,
  }) = _NewControllerProfile;
}
