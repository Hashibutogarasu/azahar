import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Holds the navigation shell of the Games/Options tabs while it is shown, so that controller
/// actions can switch its tabs.
class ShellNavigationController {
  StatefulNavigationShell? _shell;

  /// Records [shell] as the one being shown. Called by the shell each time it builds.
  void attach(StatefulNavigationShell shell) => _shell = shell;

  /// Forgets [shell] if it is the one recorded.
  void detach(StatefulNavigationShell shell) {
    if (identical(_shell, shell)) _shell = null;
  }

  bool get isAttached => _shell != null;

  /// Moves to the tab [offset] places after the current one, wrapping around at both ends.
  void moveBy(int offset) {
    final shell = _shell;
    if (shell == null) return;
    final count = shell.route.branches.length;
    if (count == 0) return;
    shell.goBranch((shell.currentIndex + offset) % count);
  }
}

/// The [ShellNavigationController] of the app.
final shellNavigationProvider = Provider<ShellNavigationController>(
  (ref) => ShellNavigationController(),
);
