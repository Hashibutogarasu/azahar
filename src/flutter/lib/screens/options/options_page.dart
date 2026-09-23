import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';
import '../settings/settings_routes.dart';

/// The Options tab's grid of app-level settings and shortcuts, mirroring the original app's
/// `HomeSettingsScreen`.
class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      body: SafeArea(
        child: GridView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: 88,
          ),
          children: [
            _OptionCard(
              icon: Icons.settings_outlined,
              title: t.options.emulatorSettings,
              description: t.options.emulatorSettingsDescription,
              onTap: () => const SettingsMenuRoute().push(context),
            ),
            _OptionCard(
              icon: Icons.palette_outlined,
              title: t.options.themeAndColor,
              description: t.options.themeAndColorDescription,
              onTap: () => const ThemeSettingsRoute().push(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(description, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
