import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../../data/busy_provider.dart';
import '../../../data/options/categories/profile_options.dart';
import '../../../data/platform_provider.dart';
import '../../../data/profiles/profile.dart';
import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../../widgets/long_press_menu_sheet.dart';
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
/// Selecting a profile makes it the default one. Its items are disabled while [isBusyProvider]
/// is true, because adding, switching or deleting would change the profiles under an operation
/// that has not finished yet.
class ProfileRadioList extends ConsumerWidget {
  const ProfileRadioList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final profiles = ref.watch(profilesProvider).value ?? const [];
    final defaultCuid = ref.watch(defaultProfileCuidProvider).value;
    final isGameRunning = ref.watch(gameProcessProvider);
    final isBusy = ref.watch(isBusyProvider);
    return RadioGroup<String>(
      groupValue: defaultCuid,
      onChanged: (cuid) {
        if (cuid != null && !isBusy) {
          _switchTo(context, ref, cuid, isGameRunning);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final profile in profiles)
            ProfileRadioTile(
              profile: profile,
              enabled: !isBusy,
              onDelete: profile.isBuiltIn
                  ? null
                  : () => _delete(context, ref, profile.cuid, isGameRunning),
            ),
          ListTile(
            enabled: !isBusy,
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
      _showMessage(context, context.t.profiles.gameRunning);
      return;
    }
    await ref.read(busyProvider.notifier).run(() async {
      await AppServices.profileService.switchTo(cuid);
      await _reload(ref);
    });
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    String cuid,
    bool isGameRunning,
  ) async {
    if (isGameRunning) {
      _showMessage(context, context.t.profiles.deleteGameRunning);
      return;
    }
    await ref.read(busyProvider.notifier).run(() async {
      final switched = await AppServices.profileService.deleteProfile(cuid);
      if (switched) {
        await _reload(ref);
      }
    });
  }

  /// Reloads what depends on the default profile after it changed.
  Future<void> _reload(WidgetRef ref) async {
    await AppServices.loadAll();
    ref.invalidate(defaultProfileCuidProvider);
    ref.invalidate(profileOptionsProvider);
    await ref.read(gamesProvider.notifier).rescan();
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// One entry of the menu of a profile, so the desktop menu and the mobile sheet list the same
/// entries.
class _ProfileMenuAction {
  const _ProfileMenuAction({
    required this.icon,
    required this.label,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final VoidCallback onSelected;
}

/// A radio tile for [profile]: its name, with where it is stored below. Its menu opens from a
/// button at its end on desktop platforms, and by pressing and holding it on mobile ones, in the
/// same [LongPressMenuSheet] as the other items of the Options pages.
class ProfileRadioTile extends ConsumerWidget {
  const ProfileRadioTile({
    super.key,
    required this.profile,
    required this.enabled,
    this.onDelete,
  });

  final Profile profile;
  final bool enabled;
  final VoidCallback? onDelete;

  List<_ProfileMenuAction> _actions(BuildContext context) {
    final onDelete = this.onDelete;
    return [
      if (onDelete != null)
        _ProfileMenuAction(
          icon: Icons.delete_outline,
          label: context.t.profiles.delete,
          onSelected: onDelete,
        ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final isDesktop = ref.watch(isDesktopPlatformProvider);
    final actions = _actions(context);
    final hasMenu = actions.isNotEmpty;
    final tile = RadioListTile<String>(
      value: profile.cuid,
      enabled: enabled,
      title: Text(profile.isBuiltIn ? t.profiles.builtIn : profile.name),
      subtitle: Text(
        profile.isBuiltIn
            ? t.profiles.builtInLocation(path: 'profiles/${profile.hash}')
            : AppServices.profileService.displayLocation(profile),
      ),
      secondary: isDesktop && hasMenu
          ? PopupMenuButton<void>(
              enabled: enabled,
              itemBuilder: (context) => [
                for (final action in actions)
                  PopupMenuItem<void>(
                    onTap: action.onSelected,
                    child: ListTile(
                      leading: Icon(action.icon),
                      title: Text(action.label),
                    ),
                  ),
              ],
            )
          : null,
    );
    if (isDesktop || !hasMenu) return tile;
    return GestureDetector(
      onLongPress: enabled ? () => _showSheet(context, actions) : null,
      child: tile,
    );
  }

  Future<void> _showSheet(
    BuildContext context,
    List<_ProfileMenuAction> actions,
  ) {
    return LongPressMenuSheet.show(
      context,
      builder: (sheetContext) => LongPressMenuSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final action in actions)
              ListTile(
                leading: Icon(action.icon),
                title: Text(action.label),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  action.onSelected();
                },
              ),
          ],
        ),
      ),
    );
  }
}
