import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/extensions/app_search_bar_theme.dart';

/// The games list search bar. Its blur, fill, and shape come entirely from [AppSearchBarTheme],
/// so this single widget renders both the Azahar and Legacy looks.
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onClear,
    this.onFocusChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  /// Called with true when the search field gains focus and with false when it loses it.
  final ValueChanged<bool>? onFocusChanged;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
      widget.onFocusChanged?.call(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppSearchBarTheme>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: theme.radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: theme.blurSigma,
            sigmaY: theme.blurSigma,
          ),
          child: Container(
            height: theme.height,
            decoration: BoxDecoration(
              color: theme.fillColor,
              borderRadius: theme.radius,
              border: Border.all(
                color: _focused ? theme.focusedBorderColor : theme.borderColor,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.search, size: 20, color: theme.iconColor),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    style: theme.textStyle,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: theme.textStyle.copyWith(
                        color: theme.hintColor,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: widget.onChanged,
                  ),
                ),
                if (widget.controller.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.clear, color: theme.iconColor),
                    onPressed: widget.onClear,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
