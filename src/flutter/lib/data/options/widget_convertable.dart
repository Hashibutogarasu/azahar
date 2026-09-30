import 'package:flutter/widgets.dart';

/// Something that can turn itself into the widget that shows and edits it.
mixin WidgetConvertable {
  /// Builds the widget for this object. [onAccessed] is called when the widget changes or opens
  /// what it stands for, and [onLongPress] when it is pressed and held.
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  });
}
