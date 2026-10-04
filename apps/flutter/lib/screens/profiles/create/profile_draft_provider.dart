import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_draft.dart';

/// The [ProfileDraft] of the pages for adding a profile. It lives as long as
/// [ProfileCreateShell] is shown.
final profileDraftProvider =
    NotifierProvider.autoDispose<ProfileDraftNotifier, ProfileDraft>(
      ProfileDraftNotifier.new,
    );

class ProfileDraftNotifier extends Notifier<ProfileDraft> {
  @override
  ProfileDraft build() => const ProfileDraft();

  void setName(String name) => state = state.copyWith(name: name);

  void setUserDirectory(String uri) =>
      state = state.copyWith(userDirectory: uri);

  void setGamesDirectory(String uri) =>
      state = state.copyWith(gamesDirectory: uri);

  void clearDirectories() => state = ProfileDraft(name: state.name);
}
