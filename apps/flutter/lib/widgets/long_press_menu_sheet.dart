import 'package:flutter/material.dart';

/// The frame shared by the bottom sheets opened by pressing and holding a card: the drag handle
/// at the top, the sheet behavior, and the safe area and padding around [child]. What goes inside
/// is up to each sheet.
///
/// Open it with [show].
class LongPressMenuSheet extends StatelessWidget {
  const LongPressMenuSheet({super.key, required this.child});

  final Widget child;

  static Future<void> show(
    BuildContext context, {
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: child,
      ),
    );
  }
}
