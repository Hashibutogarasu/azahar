import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app_services.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/settings/user_directories_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../setup/setup_step.dart';
import '../../setup/widgets/setup_navigation_bar.dart';
import '../../setup/widgets/setup_step_view.dart';
import 'profile_draft_provider.dart';

/// The last step of adding a profile: the folder it scans for games. Confirming it creates the
/// profile, makes the folders the core expects in its user folder, and leaves the pages for
/// adding a profile.
class ProfileGamesDirectoryPage extends ConsumerStatefulWidget {
  const ProfileGamesDirectoryPage({super.key});

  @override
  ConsumerState<ProfileGamesDirectoryPage> createState() =>
      _ProfileGamesDirectoryPageState();
}

class _ProfileGamesDirectoryPageState
    extends ConsumerState<ProfileGamesDirectoryPage> {
  bool _isCreating = false;

  Future<void> _create() async {
    final draft = ref.read(profileDraftProvider);
    setState(() => _isCreating = true);
    try {
      await AppServices.profileService.createUserProfile(
        name: draft.name,
        userDirectory: draft.userDirectory!,
        gamesDirectory: draft.gamesDirectory!,
      );
    } on DuplicateProfileNameException {
      if (!mounted) return;
      setState(() => _isCreating = false);
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
    final gamesDirectory = ref.watch(profileDraftProvider).gamesDirectory;
    return Column(
      children: [
        Expanded(
          child: SetupStepView(
            step: SetupStep(
              icon: Icons.sports_esports,
              title: t.setup.gamesDirectory.title,
              description: t.profiles.create.gamesDirectoryDescription,
              actions: [
                SetupAction(
                  icon: Icons.folder_open,
                  label: t.setup.gamesDirectory.title,
                  isCompleted: gamesDirectory != null,
                  performAction: (_) async {
                    final uri = await ref
                        .read(userDirectoriesProvider)
                        .pickGamesDirectory();
                    if (uri == null) return false;
                    ref
                        .read(profileDraftProvider.notifier)
                        .setGamesDirectory(uri);
                    return true;
                  },
                ),
              ],
            ),
            onAction: (action) => action.performAction(context),
          ),
        ),
        SetupNavigationBar(
          showBack: true,
          showNext: gamesDirectory != null && !_isCreating,
          nextLabel: t.profiles.create.create,
          onBack: () => context.pop(),
          onNext: _create,
        ),
      ],
    );
  }
}
