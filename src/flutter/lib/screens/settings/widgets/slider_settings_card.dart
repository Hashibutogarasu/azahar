import 'package:flutter/material.dart';

/// A titled card with a description and a [Slider], used for settings whose value is a
/// continuous or stepped range (e.g. master volume, animation speed).
class SliderSettingsCard extends StatelessWidget {
  const SliderSettingsCard({
    super.key,
    required this.title,
    required this.valueLabel,
    this.description,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.label,
    required this.onChanged,
    this.onChangeEnd,
  });

  final String title;
  final String valueLabel;
  final String? description;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(valueLabel),
              ],
            ),
            if (description != null)
              Text(description!, style: Theme.of(context).textTheme.bodyMedium),
            Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              label: label,
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
            ),
          ],
        ),
      ),
    );
  }
}
