import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../../data/settings/sections/audio_settings.dart';
import '../../../data/settings/system_save_value_store.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_list.dart';

/// The pre-redesign Audio settings page. The current UI merges these items into
/// [MediaSettingsPage]'s Emulator section instead; kept only for the legacy Options UI
/// (`useLegacySettingsUI`).
@Deprecated('Only used by the legacy Options UI. See MediaSettingsPage for the current UI.')
class LegacyAudioSettingsPage extends ConsumerStatefulWidget {
  const LegacyAudioSettingsPage({super.key});

  @override
  ConsumerState<LegacyAudioSettingsPage> createState() => _LegacyAudioSettingsPageState();
}

class _LegacyAudioSettingsPageState extends ConsumerState<LegacyAudioSettingsPage> {
  late final _systemSaveStore = SystemSaveValueStore(AppServices.systemSaveRepository);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.audio.title)),
      body: SettingsList(items: buildAudioSettingsItems(t, _systemSaveStore)),
    );
  }
}
