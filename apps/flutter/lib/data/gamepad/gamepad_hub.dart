import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamepads/gamepads.dart';

/// A physical controller that is currently connected.
class ConnectedGamepad {
  const ConnectedGamepad({required this.id, required this.name});

  final String id;
  final String name;
}

/// Every normalized input of every connected controller. It is the single entry point the rest
/// of the app reads controller input from.
final normalizedGamepadEventsProvider = StreamProvider<NormalizedGamepadEvent>(
  (ref) => Gamepads.normalizedEvents,
);

/// Every controller being connected or disconnected.
final gamepadConnectionEventsProvider = StreamProvider<GamepadConnectionEvent>(
  (ref) => Gamepads.connectionEvents,
);

/// The controllers that are currently connected, starting from the ones already connected when
/// the app started.
final connectedGamepadsProvider =
    NotifierProvider<ConnectedGamepadsNotifier, List<ConnectedGamepad>>(
      ConnectedGamepadsNotifier.new,
    );

/// Keeps [connectedGamepadsProvider] up to date.
class ConnectedGamepadsNotifier extends Notifier<List<ConnectedGamepad>> {
  @override
  List<ConnectedGamepad> build() {
    final subscription = Gamepads.connectionEvents.listen(
      _onConnectionEvent,
      onError: (_) {},
    );
    ref.onDispose(subscription.cancel);
    unawaited(_loadInitial());
    return const [];
  }

  Future<void> _loadInitial() async {
    final List<GamepadController> controllers;
    try {
      controllers = await Gamepads.list();
    } catch (_) {
      return;
    }
    final initial = [
      for (final controller in controllers)
        ConnectedGamepad(id: controller.id, name: controller.name),
    ];
    for (final controller in controllers) {
      unawaited(controller.dispose());
    }
    if (!ref.mounted) return;
    final known = {for (final gamepad in state) gamepad.id};
    state = [
      ...state,
      for (final gamepad in initial)
        if (!known.contains(gamepad.id)) gamepad,
    ];
  }

  void _onConnectionEvent(GamepadConnectionEvent event) {
    final others = [
      for (final gamepad in state)
        if (gamepad.id != event.gamepadId) gamepad,
    ];
    state = switch (event.type) {
      GamepadConnectionEventType.connected => [
        ...others,
        ConnectedGamepad(id: event.gamepadId, name: event.name),
      ],
      GamepadConnectionEventType.disconnected => others,
    };
  }
}

/// Whether the user is operating the app with the touch screen or mouse, or with a controller.
enum GamepadInputMode { touch, controller }

/// The way the user last operated the app.
final gamepadInputModeProvider =
    NotifierProvider<GamepadInputModeNotifier, GamepadInputMode>(
      GamepadInputModeNotifier.new,
    );

/// Switches [gamepadInputModeProvider] to [GamepadInputMode.controller] on a deliberate
/// controller input, and back to [GamepadInputMode.touch] when the screen is touched.
class GamepadInputModeNotifier extends Notifier<GamepadInputMode> {
  static const double activationThreshold = 0.5;

  @override
  GamepadInputMode build() {
    ref.listen(normalizedGamepadEventsProvider, (_, next) {
      final event = next.value;
      if (event == null) return;
      if (event.value.abs() >= activationThreshold) {
        state = GamepadInputMode.controller;
      }
    });
    ref.listen(connectedGamepadsProvider, (_, gamepads) {
      if (gamepads.isEmpty) state = GamepadInputMode.touch;
    });
    return GamepadInputMode.touch;
  }

  /// Records that the user touched or clicked the screen.
  void markTouch() {
    if (state != GamepadInputMode.touch) state = GamepadInputMode.touch;
  }
}
