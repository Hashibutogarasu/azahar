import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/settings/wifi_access_points_provider.dart';
import '../../i18n/translations.g.dart';
import '../../models/access_point.dart';
import 'widgets/real_network_tab.dart';
import 'widgets/virtual_network_tab.dart';

class EmulatedNetworkPage extends ConsumerStatefulWidget {
  const EmulatedNetworkPage({super.key});

  @override
  ConsumerState<EmulatedNetworkPage> createState() =>
      _EmulatedNetworkPageState();
}

class _EmulatedNetworkPageState extends ConsumerState<EmulatedNetworkPage>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this)
    ..addListener(() => setState(() {}));

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final n = t.settings.networking;
    final isRealTab = _tabController.index == 0;
    final selected = ref.watch(selectedRealAccessPointsProvider);
    final copied = ref.watch(copiedAccessPointsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(n.emulatedNetwork),
        actions: [
          if (isRealTab)
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: n.copySelected,
              onPressed: selected.isEmpty
                  ? null
                  : () => _copySelected(selected),
            )
          else
            IconButton(
              icon: const Icon(Icons.paste),
              tooltip: n.pasteAccessPoints,
              onPressed: copied.isEmpty ? null : () => _paste(copied),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: n.realNetworkTab),
            Tab(text: n.virtualNetworkTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [RealNetworkTab(), VirtualNetworkTab()],
      ),
    );
  }

  void _copySelected(Set<AccessPoint> selected) {
    ref.read(copiedAccessPointsProvider.notifier).copy(selected.toList());
    ref.read(selectedRealAccessPointsProvider.notifier).clear();
  }

  Future<void> _paste(List<AccessPoint> copied) {
    return ref.read(virtualAccessPointsProvider.notifier).addAll(copied);
  }
}
