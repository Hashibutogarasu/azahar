import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';
import 'widgets/real_network_tab.dart';
import 'widgets/virtual_network_tab.dart';

class EmulatedNetworkPage extends StatelessWidget {
  const EmulatedNetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final n = t.settings.networking;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(n.emulatedNetwork),
          bottom: TabBar(
            tabs: [Tab(text: n.realNetworkTab), Tab(text: n.virtualNetworkTab)],
          ),
        ),
        body: const TabBarView(children: [RealNetworkTab(), VirtualNetworkTab()]),
      ),
    );
  }
}
