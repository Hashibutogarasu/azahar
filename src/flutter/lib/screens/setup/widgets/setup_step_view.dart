import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../setup_step.dart';

class SetupStepView extends StatelessWidget {
  const SetupStepView({super.key, required this.step, required this.onAction});

  final SetupStep step;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          step.imageAsset != null
              ? Image.asset(step.imageAsset!, width: 150, height: 150)
              : Icon(step.icon, size: 150),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              step.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              step.description,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          if (step.isCompleted)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                t.setup.stepComplete,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: FilledButton(
                onPressed: onAction,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(step.actionLabel),
                    if (step.buttonIcon != null) ...[
                      const SizedBox(width: 8),
                      Icon(step.buttonIcon, size: 18),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
