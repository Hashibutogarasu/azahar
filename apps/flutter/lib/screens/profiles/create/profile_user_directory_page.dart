import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/settings/user_directories_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../setup/setup_step.dart';
import '../../setup/widgets/setup_navigation_bar.dart';
import '../../setup/widgets/setup_step_view.dart';
import 'profile_draft_provider.dart';

/// The second step of adding a profile: the folder that keeps its NAND, saves, cheats and
/// settings.
class ProfileUserDirectoryPage extends ConsumerWidget {
  const ProfileUserDirectoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final userDirectory = ref.watch(profileDraftProvider).userDirectory;
    return Column(
      children: [
        Expanded(
          child: SetupStepView(
            step: SetupStep(
              icon: Icons.home,
              title: t.setup.userDirectory.title,
              description: t.profiles.create.userDirectoryDescription,
              actions: [
                SetupAction(
                  icon: Icons.folder_open,
                  label: t.setup.userDirectory.title,
                  isCompleted: userDirectory != null,
                  performAction: (_) async {
                    final uri = await ref
                        .read(userDirectoriesProvider)
                        .pickUserDirectory();
                    if (uri == null) return false;
                    ref
                        .read(profileDraftProvider.notifier)
                        .setUserDirectory(uri);
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
          showNext: userDirectory != null,
          onBack: () => context.pop(),
          onNext: () => const ProfileGamesDirectoryRoute().push<void>(context),
        ),
      ],
    );
  }
}
