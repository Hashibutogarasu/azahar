import 'package:flutter/material.dart';

import '../../../data/settings/sections/system_settings.dart';
import '../../../data/settings/settings_item.dart';
import '../../../i18n/translations.g.dart';
import '../../settings/widgets/settings_list.dart';

class ClockOptionsGroup extends StatelessWidget {
  const ClockOptionsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return SettingsList(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      items: [
        SettingsItem.header(title: t.options.groups.clock),
        ...buildClockSettingsItems(t),
      ],
    );
  }
}
