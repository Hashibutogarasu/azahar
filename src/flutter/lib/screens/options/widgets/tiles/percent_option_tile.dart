import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/options/abstract_base_option.dart';
import '../../../../data/options/option_values_revision_provider.dart';
import '../../../../i18n/translations.g.dart';
import '../../../settings/widgets/slider_settings_card.dart';
import 'option_commit.dart';

/// The tile of a [PercentOption]: a [SliderSettingsCard] that shows the fraction as a percentage
/// and changes it in steps of 1% within the option's range. The value is written when the slider
/// is released; while it is dragged, only [PercentOption.preview] is called.
class PercentOptionTile extends ConsumerStatefulWidget {
  const PercentOptionTile({
    super.key,
    required this.option,
    required this.onAccessed,
    required this.onLongPress,
  });

  final PercentOption option;
  final VoidCallback onAccessed;
  final VoidCallback onLongPress;

  @override
  ConsumerState<PercentOptionTile> createState() => _PercentOptionTileState();
}

class _PercentOptionTileState extends ConsumerState<PercentOptionTile> {
  static const _units = '%';

  /// The value under the slider while it is dragged, before it is written.
  double? _dragValue;

  static int _toPercent(double fraction) => (fraction * 100).round();

  void _onChanged(double value) {
    setState(() => _dragValue = value);
    final preview = widget.option.preview;
    if (preview != null) unawaited(preview(ref, value));
  }

  Future<void> _onChangeEnd(double value) async {
    await ref.commitOptionValue(
      context,
      widget.option.value,
      value,
      widget.onAccessed,
    );
    if (mounted) setState(() => _dragValue = null);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(optionValuesRevisionProvider);
    final t = context.t;
    final option = widget.option;
    final value = _dragValue ?? option.value.read(ref);
    final percentLabel = '${_toPercent(value)}$_units';
    final steps = _toPercent(option.max - option.min);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: widget.onLongPress,
      child: SliderSettingsCard(
        title: option.title(t),
        valueLabel: percentLabel,
        description: option.description?.call(t),
        value: value,
        min: option.min,
        max: option.max,
        divisions: steps > 0 ? steps : null,
        label: percentLabel,
        onChanged: _onChanged,
        onChangeEnd: _onChangeEnd,
      ),
    );
  }
}
