import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/options_settings_provider.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/settings_group_card.dart';

class LanguageSettingsPage extends ConsumerStatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  ConsumerState<LanguageSettingsPage> createState() =>
      _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends ConsumerState<LanguageSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final settings = ref.read(optionsSettingsProvider);
    final selected = settings.languageCode;

    Future<void> select(String? value) async {
      await settings.setLanguageCode(value);
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.settings.language.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsGroupCard(
            items: [
              babstrap.SettingsItem(
                icons: Icons.phone_android,
                title: t.settings.language.systemDefault,
                trailing: selected == null ? const Icon(Icons.check) : null,
                onTap: () => select(null),
              ),
              for (final locale in AppLocale.values)
                babstrap.SettingsItem(
                  icons: Icons.language,
                  title: _localeLabel(t, locale),
                  trailing: selected == locale.languageCode
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () => select(locale.languageCode),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _localeLabel(Translations t, AppLocale locale) {
    return switch (locale) {
      AppLocale.en => t.settings.language.english,
      AppLocale.ja => t.settings.language.japanese,
    };
  }
}
