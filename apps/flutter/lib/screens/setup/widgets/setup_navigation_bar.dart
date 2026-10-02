import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';

class SetupNavigationBar extends StatelessWidget {
  const SetupNavigationBar({
    super.key,
    required this.showBack,
    required this.showNext,
    required this.onBack,
    required this.onNext,
    this.nextLabel,
  });

  final bool showBack;
  final bool showNext;
  final String? nextLabel;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          if (showBack)
            TextButton(onPressed: onBack, child: Text(t.setup.back)),
          const Spacer(),
          if (showNext)
            TextButton(
              onPressed: onNext,
              child: Text(nextLabel ?? t.setup.next),
            ),
        ],
      ),
    );
  }
}
