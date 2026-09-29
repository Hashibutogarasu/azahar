import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/advanced_settings_provider.dart';
import '../../../data/settings/animation_speed.dart';
import '../../../i18n/translations.g.dart';
import '../widgets/slider_settings_card.dart';

class AdvancedSettingsPage extends ConsumerWidget {
  const AdvancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final advanced = t.settings.advanced;
    final settings = ref.watch(advancedSettingsProvider);
    final notifier = ref.read(advancedSettingsProvider.notifier);
    final speedLabels = {
      AnimationSpeed.fast: advanced.animationSpeed.fast,
      AnimationSpeed.normal: advanced.animationSpeed.normal,
      AnimationSpeed.slow: advanced.animationSpeed.slow,
    };
    final selectedLabel = speedLabels[settings.animationSpeed] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(advanced.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SliderSettingsCard(
            title: advanced.animationSpeedLabel,
            valueLabel: selectedLabel,
            description: advanced.animationSpeedDescription,
            value: AnimationSpeed.values
                .indexOf(settings.animationSpeed)
                .toDouble(),
            min: 0,
            max: (AnimationSpeed.values.length - 1).toDouble(),
            divisions: AnimationSpeed.values.length - 1,
            label: selectedLabel,
            onChanged: (value) => notifier.setAnimationSpeed(
              AnimationSpeed.values[value.round()],
            ),
          ),
        ],
      ),
    );
  }
}
