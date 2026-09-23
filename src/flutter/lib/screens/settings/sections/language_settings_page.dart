import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../i18n/translations.g.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  late Future<String?> _selected = AppServices.settingsRepository.languageCode();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.language.title)),
      body: FutureBuilder<String?>(
        future: _selected,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final selected = snapshot.data;
          return RadioGroup<String?>(
            groupValue: selected,
            onChanged: (value) async {
              await AppServices.settingsRepository.setLanguageCode(value);
              if (value == null) {
                await LocaleSettings.useDeviceLocale();
              } else {
                await LocaleSettings.setLocaleRaw(value);
              }
              setState(() {
                _selected = AppServices.settingsRepository.languageCode();
              });
            },
            child: Column(
              children: [
                RadioListTile<String?>(title: Text(t.settings.language.systemDefault), value: null),
                for (final locale in AppLocale.values)
                  RadioListTile<String?>(
                    title: Text(t.settings.language.english),
                    value: locale.languageCode,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
