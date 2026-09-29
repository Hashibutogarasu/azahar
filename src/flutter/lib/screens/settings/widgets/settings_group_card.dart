import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';

import '../../../theme/extensions/glass_surface_theme.dart';
import '../../../widgets/app_liquid_glass.dart';

/// Renders a titled group of [babstrap.SettingsItem]s with the same title/card layout as
/// [babstrap.SettingsGroup], but paints the card background with [AppLiquidGlass] instead of
/// [babstrap.SettingsGroup]'s own [Container] decoration. [babstrap.SettingsGroup] draws that
/// background with a `DecoratedBox` sitting between its `ListTile`s and the nearest `Material`
/// ancestor, which trips `ListTile`'s "background color or ink splashes may be invisible"
/// assertion; passing `backgroundColor: Colors.transparent` through to it and painting the same
/// color on an outer [Material] keeps the same look while giving `ListTile` an unobstructed
/// `Material` ancestor to paint its background/ink splashes onto.
class SettingsGroupCard extends StatelessWidget {
  const SettingsGroupCard({
    super.key,
    this.settingsGroupTitle,
    required this.items,
  });

  final String? settingsGroupTitle;
  final List<babstrap.SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    final surfaceTheme = Theme.of(context).extension<GlassSurfaceTheme>()!;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (settingsGroupTitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                settingsGroupTitle!,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          AppLiquidGlass(
            borderRadius: BorderRadius.circular(15),
            blurSigma: surfaceTheme.blurSigma,
            fillColor: surfaceTheme.blurSigma > 0
                ? surfaceTheme.fillColor
                : Theme.of(context).cardColor,
            borderColor: surfaceTheme.borderColor,
            child: babstrap.SettingsGroup(
              backgroundColor: Colors.transparent,
              margin: EdgeInsets.zero,
              items: items,
            ),
          ),
        ],
      ),
    );
  }
}
