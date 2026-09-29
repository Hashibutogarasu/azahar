import 'dart:io';

import 'package:flutter/material.dart';

class GameIcon extends StatelessWidget {
  const GameIcon({super.key, required this.iconPath});

  final String? iconPath;

  static const _placeholderAsset = 'assets/images/no_icon.png';
  static const _placeholderAssetDark = 'assets/images/no_icon_dark.png';

  Widget _placeholder(BuildContext context) {
    return Image.asset(
      Theme.of(context).brightness == Brightness.dark
          ? _placeholderAssetDark
          : _placeholderAsset,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = iconPath;
    if (path == null) {
      return _placeholder(context);
    }
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholder(context),
    );
  }
}
