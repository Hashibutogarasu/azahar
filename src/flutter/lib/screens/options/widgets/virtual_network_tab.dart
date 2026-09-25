import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/wifi_access_points_provider.dart';
import '../../../i18n/translations.g.dart';
import '../../../models/access_point.dart';
import '../dialogs/access_point_form_dialog.dart';
import 'wifi_signal_icon.dart';

class VirtualNetworkTab extends ConsumerWidget {
  const VirtualNetworkTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final n = t.settings.networking;
    final state = ref.watch(virtualAccessPointsProvider);
    final notifier = ref.read(virtualAccessPointsProvider.notifier);
    return Scaffold(
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(n.useVirtualNetwork),
            subtitle: Text(n.useVirtualNetworkDescription),
            value: state.enabled,
            onChanged: notifier.setEnabled,
          ),
          if (state.accessPoints.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text(n.noAccessPointsFound)),
            )
          else
            for (final accessPoint in state.accessPoints)
              ListTile(
                leading: WifiSignalIcon(level: accessPoint.level),
                title: Text(accessPoint.ssid.isEmpty ? n.hiddenNetwork : accessPoint.ssid),
                subtitle: Text(
                  '${n.bssid}: ${accessPoint.bssid}  ${n.frequency}: ${accessPoint.frequency} MHz',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => notifier.removeAccessPoint(accessPoint),
                ),
                onTap: () => _edit(context, notifier, accessPoint),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final accessPoint = await AccessPointFormDialog.show(context);
          if (accessPoint != null) {
            await notifier.addAccessPoint(accessPoint);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    VirtualAccessPointsNotifier notifier,
    AccessPoint accessPoint,
  ) async {
    final updated = await AccessPointFormDialog.show(context, initial: accessPoint);
    if (updated != null) {
      await notifier.updateAccessPoint(accessPoint, updated);
    }
  }
}
