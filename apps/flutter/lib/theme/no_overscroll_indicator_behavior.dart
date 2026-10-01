import 'package:flutter/material.dart';

class NoOverscrollIndicatorBehavior extends MaterialScrollBehavior {
  const NoOverscrollIndicatorBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
