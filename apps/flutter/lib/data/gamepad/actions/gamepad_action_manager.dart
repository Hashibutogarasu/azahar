import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamepads/gamepads.dart';

import '../gamepad_hub.dart';
import 'gamepad_action.dart';
import 'gamepad_action_registry.dart';
import 'gamepad_key_combo.dart';
import 'key_bindings_providers.dart';

/// The [GamepadActionManager] of the app.
final gamepadActionManagerProvider =
    NotifierProvider<GamepadActionManager, GamepadInputSnapshot>(
      GamepadActionManager.new,
    );

/// Ticks the registered actions once per frame while controller input is held, with the state of
/// the key combination bound to each of them.
///
/// A held combination hides the smaller ones it contains, and a combination only counts as
/// pressed when its last input goes down while its action is available. No action is available
/// while something such as a key binding dialog captures the controller input.
class GamepadActionManager extends Notifier<GamepadInputSnapshot> {
  final Set<GamepadButton> _buttons = {};
  final Map<GamepadAxis, double> _axes = {};
  final Map<String, Duration> _pressedSince = {};
  final Stopwatch _clock = Stopwatch()..start();
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _tickScheduled = false;
  GamepadInputSnapshot _previous = GamepadInputSnapshot.empty;
  int _captures = 0;

  @override
  GamepadInputSnapshot build() {
    ref.listen(normalizedGamepadEventsProvider, (_, next) {
      final event = next.value;
      if (event != null) _onEvent(event);
    });
    for (final scope in GamepadActionScope.values) {
      ref.listen(keyBindingsProvider(scope), (_, _) {});
    }
    ref.listen(gamepadInputModeProvider, (_, mode) {
      FocusManager.instance.highlightStrategy = switch (mode) {
        GamepadInputMode.controller => FocusHighlightStrategy.alwaysTraditional,
        GamepadInputMode.touch => FocusHighlightStrategy.automatic,
      };
    });
    return GamepadInputSnapshot.empty;
  }

  /// Sets the navigator at the root of the app, which the actions reach through their context.
  void attach(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  /// Stops every action from running until [endCapture] is called as many times, releasing the
  /// actions that are held, so that the caller gets the controller input to itself.
  void beginCapture() {
    _captures++;
    _scheduleTick();
  }

  void endCapture() {
    if (_captures > 0) _captures--;
  }

  void _onEvent(NormalizedGamepadEvent event) {
    final button = event.button;
    final axis = event.axis;
    if (button != null) {
      if (event.value != 0) {
        _buttons.add(button);
      } else {
        _buttons.remove(button);
      }
    } else if (axis != null) {
      _axes[axis] = event.value;
    }
    _scheduleTick();
  }

  GamepadInputSnapshot _snapshot() {
    final buttons = {..._buttons};
    if ((_axes[GamepadAxis.leftTrigger] ?? 0) >=
        GamepadButtonInput.triggerThreshold) {
      buttons.add(GamepadButton.leftTrigger);
    }
    if ((_axes[GamepadAxis.rightTrigger] ?? 0) >=
        GamepadButtonInput.triggerThreshold) {
      buttons.add(GamepadButton.rightTrigger);
    }
    return GamepadInputSnapshot(buttons: buttons, axes: {..._axes});
  }

  void _scheduleTick() {
    if (_tickScheduled) return;
    _tickScheduled = true;
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      _tickScheduled = false;
      if (ref.mounted) _tick();
    });
    SchedulerBinding.instance.scheduleFrame();
  }

  void _tick() {
    final snapshot = _snapshot();
    state = snapshot;
    final context = GamepadActionContext(
      ref: ref,
      snapshot: snapshot,
      navigatorKey: _navigatorKey,
    );
    final candidates = [
      for (final action in ref.read(gamepadActionRegistryProvider).actions)
        (
          action: action,
          combo: comboOf(ref, action),
          available: _captures == 0 && action.isAvailable(context),
        ),
    ];
    final held = [
      for (final candidate in candidates)
        if (candidate.available && candidate.combo.isActive(snapshot))
          candidate.combo,
    ];
    final now = _clock.elapsed;
    for (final candidate in candidates) {
      final id = candidate.action.id;
      final wasPressed = _pressedSince.containsKey(id);
      if (!candidate.available && !wasPressed) continue;
      final isPressed =
          candidate.available &&
          candidate.combo.isActive(snapshot) &&
          !held.any((other) => other.strictlyContains(candidate.combo)) &&
          (wasPressed || !candidate.combo.isActive(_previous));
      if (isPressed && !wasPressed) _pressedSince[id] = now;
      final heldDuration = isPressed ? now - _pressedSince[id]! : Duration.zero;
      if (!isPressed) _pressedSince.remove(id);
      candidate.action.tick(
        context,
        GamepadComboState(
          combo: candidate.combo,
          isPressed: isPressed,
          justPressed: isPressed && !wasPressed,
          justReleased: !isPressed && wasPressed,
          heldDuration: heldDuration,
        ),
      );
    }
    _previous = snapshot;
    if (!snapshot.isIdle || _pressedSince.isNotEmpty) _scheduleTick();
  }
}
