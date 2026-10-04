import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import 'emulation_menu_actions.dart';
import 'emulation_menu_item.dart';
import 'emulation_menu_section.dart';

/// The Emulation, Tools and Other sections of the in-game menu, in the same order as the original
/// app's `SidebarWidget`. Only the actions that are ported so far are listed.
class EmulationMenuSections extends StatelessWidget {
  const EmulationMenuSections({
    super.key,
    required this.isPaused,
    required this.actions,
    this.iconsOnly = false,
  });

  final bool isPaused;
  final EmulationMenuActions actions;
  final bool iconsOnly;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmulationMenuSection(
          title: t.emulation.menuSectionEmulation,
          iconsOnly: iconsOnly,
          children: [
            EmulationMenuItem(
              icon: isPaused ? Icons.play_arrow : Icons.pause,
              title: isPaused
                  ? t.emulation.resumeEmulation
                  : t.emulation.pauseEmulation,
              iconsOnly: iconsOnly,
              onTap: actions.onTogglePause,
            ),
            EmulationMenuItem(
              icon: Icons.skip_next,
              title: t.emulation.advanceFrame,
              iconsOnly: iconsOnly,
              enabled: isPaused,
              onTap: actions.onAdvanceFrame,
            ),
          ],
        ),
        EmulationMenuSection(
          title: t.emulation.menuSectionTools,
          iconsOnly: iconsOnly,
          children: [
            EmulationMenuItem(
              icon: Icons.code,
              title: t.emulation.cheats,
              iconsOnly: iconsOnly,
              enabled: actions.onCheats != null,
              onTap: actions.onCheats,
            ),
          ],
        ),
        EmulationMenuSection(
          title: t.emulation.menuSectionOther,
          iconsOnly: iconsOnly,
          children: [
            EmulationMenuItem(
              icon: Icons.save,
              title: t.emulation.saveAndExit,
              iconsOnly: iconsOnly,
              onTap: actions.onSaveAndExit,
            ),
            EmulationMenuItem(
              icon: Icons.delete_forever,
              title: t.emulation.exitWithoutSaving,
              iconsOnly: iconsOnly,
              onTap: actions.onExitWithoutSaving,
            ),
          ],
        ),
      ],
    );
  }
}
