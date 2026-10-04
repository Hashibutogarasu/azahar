import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/busy_provider.dart';

/// Keeps the route from being popped by the system back gesture or button while
/// [isBusyProvider] is true, so leaving a page cannot interrupt an operation that must finish.
class BusyPopScope extends ConsumerWidget {
  const BusyPopScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(canPop: !ref.watch(isBusyProvider), child: child);
  }
}

/// The back button of an app bar. While [isBusyProvider] is true it turns into a circular
/// progress indicator, so the user sees why the page cannot be left. [BackButton] cannot be
/// used, because a missing callback makes it pop the route instead of disabling it.
class BusyBackButton extends ConsumerWidget {
  const BusyBackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(isBusyProvider)) {
      return const Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }
    return IconButton(
      icon: const BackButtonIcon(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () => Navigator.maybePop(context),
    );
  }
}

/// [BusyBackButton] when the route can be left, and nothing otherwise, matching the back button
/// an [AppBar] adds by itself.
Widget? busyBackButtonFor(BuildContext context) {
  final canLeave = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
  return canLeave ? const BusyBackButton() : null;
}
