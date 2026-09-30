import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDesktopPlatformProvider = Provider<bool>(
  (ref) => Platform.isLinux || Platform.isWindows,
);
