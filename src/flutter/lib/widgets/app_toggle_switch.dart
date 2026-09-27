import 'package:flutter/material.dart';

import '../theme/extensions/app_toggle_switch_theme.dart';

/// A pill-shaped toggle switch. Its colors and size come entirely from [AppToggleSwitchTheme],
/// so this single widget renders both the Azahar and Legacy looks.
class AppToggleSwitch extends StatelessWidget {
  const AppToggleSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppToggleSwitchTheme>()!;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: theme.trackSize.width,
        height: theme.trackSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: value ? theme.trackColorOn : theme.trackColorOff,
          borderRadius: BorderRadius.circular(theme.trackSize.height / 2),
          border: value ? null : Border.all(color: theme.trackBorderColorOff),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: theme.thumbSize,
          height: theme.thumbSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value ? theme.thumbColorOn : theme.thumbColorOff,
          ),
        ),
      ),
    );
  }
}
