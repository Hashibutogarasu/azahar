import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';

import '../../settings/widgets/toggle_settings_item.dart';

/// A [ToggleSettingsItem] row for one [Cheat], showing its name, its notes as the subtitle and a
/// switch that reflects whether the cheat is enabled.
class CheatToggleTile extends ToggleSettingsItem {
  CheatToggleTile({required Cheat cheat, required super.onChanged})
    : super(
        icon: Icons.code,
        title: cheat.name,
        subtitle: cheat.notes.isEmpty ? null : cheat.notes,
        value: cheat.enabled,
      );
}
