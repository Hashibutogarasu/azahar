import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app_services.dart';
import '../../../data/busy_provider.dart';
import '../../../data/master/repositories/profile_repository.dart';
import '../../../data/settings/user_directories_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../setup/setup_step.dart';
import '../../setup/widgets/setup_navigation_bar.dart';
import '../../setup/widgets/setup_step_view.dart';
import 'profile_draft_provider.dart';

/// The last step of adding a profile: its user folder and games folder, chosen with the same
/// step as the setup wizard. Confirming it creates the profile, makes the folders the core
/// expects in its user folder, and leaves the pages for adding a profile.
class ProfileDirectoriesPage extends ConsumerStatefulWidget {
  const ProfileDirectoriesPage({super.key});

  @override
  ConsumerState<ProfileDirectoriesPage> createState() =>
      _ProfileDirectoriesPageState();
}

class _ProfileDirectoriesPageState
    extends ConsumerState<ProfileDirectoriesPage> {
  Future<void> _create() async {
    final draft = ref.read(profileDraftProvider);
    try {
      await ref
          .read(busyProvider.notifier)
          .run(
            () => AppServices.profileService.createUserProfile(
              name: draft.name,
              userDirectory: draft.userDirectory!,
              gamesDirectory: draft.gamesDirectory!,
            ),
          );
    } on DuplicateProfileNameException {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text(context.t.profiles.create.nameTaken)),
        );
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final draft = ref.watch(profileDraftProvider);
    final isBusy = ref.watch(isBusyProvider);
    final directories = ref.read(userDirectoriesProvider);
    final draftNotifier = ref.read(profileDraftProvider.notifier);
    return Column(
      children: [
        Expanded(
          child: SetupStepView(
            step: SetupStep.dataFolders(
              t,
              userDirectoryCompleted: draft.userDirectory != null,
              gamesDirectoryCompleted: draft.gamesDirectory != null,
              selectUserDirectory: (_) async {
                final uri = await directories.pickUserDirectory();
                if (uri == null) return false;
                draftNotifier.setUserDirectory(uri);
                return true;
              },
              selectGamesDirectory: (_) async {
                final uri = await directories.pickGamesDirectory();
                if (uri == null) return false;
                draftNotifier.setGamesDirectory(uri);
                return true;
              },
            ),
            onAction: (action) => action.performAction(context),
          ),
        ),
        SetupNavigationBar(
          showBack: !isBusy,
          showNext:
              draft.userDirectory != null &&
              draft.gamesDirectory != null &&
              !isBusy,
          nextLabel: t.profiles.create.create,
          onBack: () => context.pop(),
          onNext: _create,
        ),
      ],
    );
  }
}
