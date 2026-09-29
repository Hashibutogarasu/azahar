import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../data/settings/sections/emulation_settings.dart';
import '../../../data/settings/settings_item.dart';
import '../../../i18n/translations.g.dart';
import '../../settings/widgets/settings_list.dart';

class EmulationOptionsGroup extends StatefulWidget {
  const EmulationOptionsGroup({super.key});

  @override
  State<EmulationOptionsGroup> createState() => _EmulationOptionsGroupState();
}

class _EmulationOptionsGroupState extends State<EmulationOptionsGroup> {
  late final _store = HighLevelEmulationValueStore(
    AppServices.emulatorSettingsRepository,
  );

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SettingsList(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      items: [
        SettingsItem.header(title: t.options.groups.emulation),
        ...buildEmulationSettingsItems(t, _store),
      ],
    );
  }
}
