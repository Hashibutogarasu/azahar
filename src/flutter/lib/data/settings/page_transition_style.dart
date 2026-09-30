import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// How the pages outside the bottom navigation animate when they are opened and closed. Each value
/// knows how to build the [Page] that animates that way, so a route only has to pick the value the
/// user chose.
///
/// The order of the values is stored in the database, so new values must be added at the end.
enum PageTransitionStyle {
  /// Slides in from the right.
  slide,

  /// The platform's standard page transition.
  standard,

  /// Switches pages at once, without any animation.
  none;

  /// Wraps [child] in a page that animates this way, for [duration] where the style allows it.
  Page<void> buildPage(LocalKey key, Widget child, Duration duration) {
    return switch (this) {
      PageTransitionStyle.slide => CustomTransitionPage<void>(
        key: key,
        child: child,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
            child: child,
          );
        },
      ),
      PageTransitionStyle.standard => MaterialPage<void>(
        key: key,
        child: child,
      ),
      PageTransitionStyle.none => NoTransitionPage<void>(
        key: key,
        child: child,
      ),
    };
  }
}
