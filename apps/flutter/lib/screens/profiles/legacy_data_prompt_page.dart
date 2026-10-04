import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';

/// Asks at startup whether to move the core data found in [path] into the built-in profile.
class LegacyDataPromptPage extends StatefulWidget {
  const LegacyDataPromptPage({
    super.key,
    required this.path,
    required this.onChoice,
    required this.onDone,
  });

  final String path;
  final Future<void> Function(bool migrate) onChoice;

  final VoidCallback onDone;

  @override
  State<LegacyDataPromptPage> createState() => _LegacyDataPromptPageState();
}

class _LegacyDataPromptPageState extends State<LegacyDataPromptPage> {
  bool _busy = false;
  Object? _error;

  Future<void> _choose(bool migrate) async {
    setState(() => _busy = true);
    try {
      await widget.onChoice(migrate);
    } catch (error) {
      setState(() {
        _busy = false;
        _error = error;
      });
      return;
    }
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.profiles.legacyMigration;
    return Scaffold(
      body: Center(
        child: switch ((_busy, _error)) {
          (true, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(t.migrating),
            ],
          ),
          (false, final Object error) => AlertDialog(
            title: Text(t.title),
            content: Text(t.failed(error: error)),
            actions: [
              TextButton(onPressed: widget.onDone, child: Text(t.proceed)),
            ],
          ),
          _ => AlertDialog(
            title: Text(t.title),
            content: Text(t.description(path: widget.path)),
            actions: [
              TextButton(
                onPressed: () => _choose(false),
                child: Text(t.keep),
              ),
              FilledButton(
                onPressed: () => _choose(true),
                child: Text(t.migrate),
              ),
            ],
          ),
        },
      ),
    );
  }
}
