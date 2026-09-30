import 'package:flutter/material.dart';

/// Maps an RSSI [level] in dBm to a graduated Wi-Fi signal icon instead of showing the raw
/// number.
class WifiSignalIcon extends StatelessWidget {
  const WifiSignalIcon({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Icon(_iconFor(level));
  }

  IconData _iconFor(int level) {
    if (level >= -50) return Icons.network_wifi;
    if (level >= -60) return Icons.network_wifi_3_bar;
    if (level >= -70) return Icons.network_wifi_2_bar;
    if (level >= -80) return Icons.network_wifi_1_bar;
    return Icons.signal_wifi_0_bar;
  }
}
