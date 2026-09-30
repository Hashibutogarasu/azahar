import 'package:flutter/material.dart';

/// Lists [labels] as radio buttons and pops the value of the one the user picks.
class ChoiceDialog<T> extends StatelessWidget {
  const ChoiceDialog({
    super.key,
    required this.title,
    required this.labels,
    required this.values,
    required this.current,
  });

  final String title;
  final List<String> labels;
  final List<T> values;
  final T current;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<String> labels,
    required List<T> values,
    required T current,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => ChoiceDialog<T>(
        title: title,
        labels: labels,
        values: values,
        current: current,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        RadioGroup<T>(
          groupValue: current,
          onChanged: (value) => Navigator.of(context).pop(value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < values.length; i++)
                RadioListTile<T>(title: Text(labels[i]), value: values[i]),
            ],
          ),
        ),
      ],
    );
  }
}
