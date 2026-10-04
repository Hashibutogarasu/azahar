import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamepads/gamepads.dart';

import '../data/gamepad/gamepad_hub.dart';
import '../data/settings/accessibility_settings_provider.dart';
import '../data/settings/advanced_settings_provider.dart';
import '../data/settings/animation_speed.dart';
import '../i18n/translations.g.dart';
import '../theme/extensions/gamepad_notification_bar_theme.dart';

/// A one-line bar, styled like a snack bar, that tells a controller was connected or
/// disconnected and hides itself after [GamepadNotificationBarTheme.displayDuration].
///
/// It takes no room while hidden and grows to its full height while shown, so the widgets below
/// it move down instead of being covered. A newer event replaces the one being shown.
class GamepadNotificationBar extends ConsumerStatefulWidget {
  const GamepadNotificationBar({super.key});

  @override
  ConsumerState<GamepadNotificationBar> createState() =>
      _GamepadNotificationBarState();
}

class _GamepadNotificationBarState
    extends ConsumerState<GamepadNotificationBar> {
  GamepadConnectionEventType? _shownType;
  bool _visible = false;
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _show(GamepadConnectionEventType type, Duration displayDuration) {
    _hideTimer?.cancel();
    setState(() {
      _shownType = type;
      _visible = true;
    });
    _hideTimer = Timer(displayDuration, () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GamepadNotificationBarTheme>()!;
    ref.listen(gamepadConnectionEventsProvider, (_, next) {
      final event = next.value;
      if (event == null) return;
      _show(event.type, theme.displayDuration);
    });
    final duration = resolveAnimationDuration(
      reduceMotion: ref.watch(accessibilitySettingsProvider).reduceMotion,
      speed: ref.watch(advancedSettingsProvider).animationSpeed,
    );
    final type = _shownType;
    return AnimatedSize(
      duration: duration,
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: !_visible || type == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: theme.margin,
              child: Material(
                color: type == GamepadConnectionEventType.connected
                    ? theme.connectedBackgroundColor
                    : theme.disconnectedBackgroundColor,
                borderRadius: theme.borderRadius,
                child: SizedBox(
                  height: theme.height,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          type == GamepadConnectionEventType.connected
                              ? Icons.sports_esports
                              : Icons.sports_esports_outlined,
                          color: theme.foregroundColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            type == GamepadConnectionEventType.connected
                                ? context.t.gamepad.connected
                                : context.t.gamepad.disconnected,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

/// Lays out a shell as a [Column] whose first item keeps the top system inset, whose second item
/// is the [GamepadNotificationBar], and whose last item is [child], which fills the rest without
/// the top inset already taken by the first item.
class GamepadNotificationColumn extends StatelessWidget {
  const GamepadNotificationColumn({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.paddingOf(context).top),
        const GamepadNotificationBar(),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}
