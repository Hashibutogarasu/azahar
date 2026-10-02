import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_draft.freezed.dart';

@freezed
abstract class ProfileDraft with _$ProfileDraft {
  const factory ProfileDraft({
    @Default('') String name,
    String? userDirectory,
    String? gamesDirectory,
  }) = _ProfileDraft;
}
