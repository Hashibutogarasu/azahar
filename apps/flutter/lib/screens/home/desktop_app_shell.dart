import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/extensions/background_blob_theme.dart';
import '../../widgets/app_side_bar.dart';
import '../../widgets/background_blobs.dart';

/// The Games/Options shell on desktop: [AppSideBar] at the left of the branch content instead of
/// the floating bottom navigation used by [AppShell]. The decorative background blobs cover the
/// whole window, so the sidebar's translucent surface shows them through like the content does.
class DesktopAppShell extends StatelessWidget {
  const DesktopAppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final blobVariant =
        BackgroundBlobVariant.values[navigationShell.currentIndex];
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: BackgroundBlobs(variant: blobVariant)),
          Row(
            children: [
              AppSideBar(navigationShell: navigationShell),
              Expanded(child: navigationShell),
            ],
          ),
        ],
      ),
    );
  }
}
