import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../i18n/translations.g.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final selected = AppServices.settingsRepository.languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings.language.title)),
      body: RadioGroup<String?>(
        groupValue: selected,
        onChanged: (value) async {
          await AppServices.settingsRepository.setLanguageCode(value);
          if (value == null) {
            await LocaleSettings.useDeviceLocale();
          } else {
            await LocaleSettings.setLocaleRaw(value);
          }
          setState(() {});
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
      ),
    );
  }
}
