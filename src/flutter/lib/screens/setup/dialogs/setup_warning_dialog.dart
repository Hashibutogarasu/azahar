import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../i18n/translations.g.dart';

class SetupWarningDialog extends StatelessWidget {
  const SetupWarningDialog({super.key, required this.title, required this.description, this.helpUrl});

  final String title;
  final String description;
  final String? helpUrl;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String description,
    String? helpUrl,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => SetupWarningDialog(title: title, description: description, helpUrl: helpUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        if (helpUrl != null)
          TextButton(
            onPressed: () => launchUrl(Uri.parse(helpUrl!), mode: LaunchMode.externalApplication),
            child: Text(t.setup.warningHelp),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(t.setup.warningCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(t.setup.warningSkip),
        ),
      ],
    );
  }
}
