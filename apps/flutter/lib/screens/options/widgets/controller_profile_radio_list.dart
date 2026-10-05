import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/gamepad/actions/key_bindings_providers.dart';
import '../../../i18n/translations.g.dart';
import '../../settings/dialogs/text_input_dialog.dart';

/// The controller profiles as radio tiles, oldest first, with the one in use selected, ending with
/// an item that adds a profile. Selecting a profile switches the key bindings to it, and every
/// profile but the built-in one can be deleted.
class ControllerProfileRadioList extends ConsumerWidget {
  const ControllerProfileRadioList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final profiles = ref.watch(controllerProfilesProvider).value ?? const [];
    final activeCuid = ref.watch(activeControllerProfileProvider);
    final notifier = ref.read(activeControllerProfileProvider.notifier);
    return RadioGroup<String>(
      groupValue: activeCuid,
      onChanged: (cuid) {
        if (cuid != null) notifier.select(cuid);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final profile in profiles)
            RadioListTile<String>(
              value: profile.cuid,
              title: Text(
                profile.isBuiltIn ? t.profiles.builtIn : profile.name,
              ),
              secondary: profile.isBuiltIn
                  ? null
                  : IconButton(
                      tooltip: t.profiles.delete,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => notifier.delete(profile.cuid),
                    ),
            ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(t.settings.gamepad.addControllerProfile),
            onTap: () => _add(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final name = await TextInputDialog.show(
      context,
      title: context.t.settings.gamepad.controllerProfileName,
      initialText: '',
    );
    if (name == null || name.trim().isEmpty) return;
    final notifier = ref.read(activeControllerProfileProvider.notifier);
    final profile = await notifier.create(name.trim());
    await notifier.select(profile.cuid);
  }
}
