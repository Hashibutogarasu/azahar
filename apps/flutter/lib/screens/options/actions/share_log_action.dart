import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/logging_provider.dart';
import '../../../i18n/translations.g.dart';

/// Shares the log file, or tells the user there is none.
abstract final class ShareLogAction {
  static Future<void> run(BuildContext context, WidgetRef ref) async {
    final t = context.t;
    final found = await ref.read(loggingProvider).share();
    if (!found && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.options.shareLogNotFound)));
    }
  }
}
