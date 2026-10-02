import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../../data/options/categories/profile_options.dart';
import '../../../data/profiles/profile.dart';
import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../games/game_process_provider.dart';
import '../../games/games_provider.dart';

/// The profiles, oldest first, with the default one selected.
final profilesProvider = StreamProvider<List<Profile>>(
  (ref) => AppServices.profileRepository.watchProfiles(),
);

/// The cuid of the default profile.
final defaultProfileCuidProvider = FutureProvider<String?>(
  (ref) => AppServices.profileRepository.defaultProfileCuid(),
);

/// The profiles as radio tiles, ending with an item that opens the page for adding a profile.
/// Selecting a profile makes it the default one.
class ProfileRadioList extends ConsumerWidget {
  const ProfileRadioList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final profiles = ref.watch(profilesProvider).value ?? const [];
    final defaultCuid = ref.watch(defaultProfileCuidProvider).value;
    final isGameRunning = ref.watch(gameProcessProvider);
    return RadioGroup<String>(
      groupValue: defaultCuid,
      onChanged: (cuid) {
        if (cuid != null) _switchTo(context, ref, cuid, isGameRunning);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final profile in profiles) ProfileRadioTile(profile: profile),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(t.profiles.add),
            onTap: () => const ProfileNameRoute().push<void>(context),
          ),
        ],
      ),
    );
  }

  Future<void> _switchTo(
    BuildContext context,
    WidgetRef ref,
    String cuid,
    bool isGameRunning,
  ) async {
    if (isGameRunning) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(context.t.profiles.gameRunning)));
      return;
    }
    await AppServices.profileService.switchTo(cuid);
    await AppServices.loadAll();
    ref.invalidate(defaultProfileCuidProvider);
    ref.invalidate(profileOptionsProvider);
    await ref.read(gamesProvider.notifier).rescan();
  }
}

/// A radio tile for [profile]: its icon and name, with where it is stored below.
class ProfileRadioTile extends StatelessWidget {
  const ProfileRadioTile({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return RadioListTile<String>(
      value: profile.cuid,
      title: Row(
        children: [
          Icon(profile.isBuiltIn ? Icons.build : Icons.person, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(profile.isBuiltIn ? t.profiles.builtIn : profile.name),
          ),
        ],
      ),
      subtitle: Text(
        profile.isBuiltIn
            ? t.profiles.builtInLocation(path: 'profiles/${profile.hash}')
            : AppServices.profileService.displayLocation(profile),
      ),
    );
  }
}
