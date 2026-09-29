import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/wifi_access_points_provider.dart';
import '../../../i18n/translations.g.dart';
import 'wifi_signal_icon.dart';

class RealNetworkTab extends ConsumerWidget {
  const RealNetworkTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final accessPoints = ref.watch(realAccessPointsProvider);
    final selected = ref.watch(selectedRealAccessPointsProvider);
    final selectionNotifier = ref.read(
      selectedRealAccessPointsProvider.notifier,
    );
    final isSelecting = selected.isNotEmpty;
    return RefreshIndicator(
      onRefresh: () => ref.read(realAccessPointsProvider.notifier).refresh(),
      child: accessPoints.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text('$error'),
              ),
            ),
          ],
        ),
        data: (data) {
          if (data.isEmpty) {
            return ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(t.settings.networking.noAccessPointsFound),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final accessPoint = data[index];
              return ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: isSelecting,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Checkbox(
                        value: selected.contains(accessPoint),
                        onChanged: (_) => selectionNotifier.toggle(accessPoint),
                      ),
                    ),
                    WifiSignalIcon(level: accessPoint.level),
                  ],
                ),
                title: Text(
                  accessPoint.ssid.isEmpty
                      ? t.settings.networking.hiddenNetwork
                      : accessPoint.ssid,
                ),
                subtitle: Text(
                  '${t.settings.networking.bssid}: ${accessPoint.bssid}  '
                  '${t.settings.networking.frequency}: ${accessPoint.frequency} MHz',
                ),
                onTap: isSelecting
                    ? () => selectionNotifier.toggle(accessPoint)
                    : null,
                onLongPress: () => selectionNotifier.toggle(accessPoint),
              );
            },
          );
        },
      ),
    );
  }
}
