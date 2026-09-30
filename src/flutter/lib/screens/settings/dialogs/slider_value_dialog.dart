import 'package:flutter/material.dart';

import '../../../errors/app_exception.dart';
import '../../../i18n/translations.g.dart';
import '../../../widgets/dialog_cancel_button.dart';

/// Edits an integer within [min]..[max] with a text field and a slider, popping the chosen value.
class SliderValueDialog extends StatefulWidget {
  const SliderValueDialog({
    super.key,
    required this.title,
    required this.min,
    required this.max,
    required this.units,
    required this.initialValue,
    required this.defaultValue,
  });

  final String title;
  final int min;
  final int max;
  final String units;
  final int initialValue;
  final int defaultValue;

  static Future<int?> show(
    BuildContext context, {
    required String title,
    required int min,
    required int max,
    required String units,
    required int initialValue,
    required int defaultValue,
  }) {
    return showDialog<int>(
      context: context,
      builder: (_) => SliderValueDialog(
        title: title,
        min: min,
        max: max,
        units: units,
        initialValue: initialValue,
        defaultValue: defaultValue,
      ),
    );
  }

  @override
  State<SliderValueDialog> createState() => _SliderValueDialogState();
}

class _SliderValueDialogState extends State<SliderValueDialog> {
  late int _sliderValue = widget.initialValue;
  late String _pendingText = widget.initialValue.toString();
  late final TextEditingController _textController = TextEditingController(
    text: _pendingText,
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _applySliderValue(int value) {
    _sliderValue = value;
    _pendingText = value.toString();
    _textController.value = TextEditingValue(
      text: _pendingText,
      selection: TextSelection.collapsed(offset: _pendingText.length),
    );
  }

  void _submit() {
    final t = context.t;
    final parsed = int.tryParse(_pendingText);
    if (parsed == null || parsed < widget.min || parsed > widget.max) {
      throw InvalidSettingValueException(
        t.settings.sliderDialog.invalidValue(
          title: widget.title,
          min: widget.min,
          max: widget.max,
        ),
      );
    }
    Navigator.of(context).pop(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(suffixText: widget.units),
            onChanged: (text) {
              _pendingText = text;
              final parsed = int.tryParse(text);
              if (parsed != null &&
                  parsed >= widget.min &&
                  parsed <= widget.max) {
                setState(() => _sliderValue = parsed);
              }
            },
          ),
          Slider(
            value: _sliderValue.toDouble(),
            min: widget.min.toDouble(),
            max: widget.max.toDouble(),
            divisions: widget.max - widget.min,
            label: '$_sliderValue${widget.units}',
            onChanged: (value) =>
                setState(() => _applySliderValue(value.round())),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () =>
              setState(() => _applySliderValue(widget.defaultValue)),
          child: Text(t.settings.sliderDialog.kDefault),
        ),
        const DialogCancelButton(),
        TextButton(
          onPressed: _submit,
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
