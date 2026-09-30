import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/settings/artic_base_provider.dart';
import '../dialogs/artic_base_connect_dialog.dart';

/// Asks for the address of an Artic Base server and connects to it.
abstract final class ConnectArticBaseAction {
  static Future<void> run(BuildContext context, WidgetRef ref) async {
    final service = ref.read(articBaseProvider);
    final previousAddress = await service.previousAddress();
    if (!context.mounted) return;
    final address = await ArticBaseConnectDialog.show(
      context,
      initialAddress: previousAddress ?? '',
    );
    if (address == null || address.isEmpty) return;
    await service.connect(address);
  }
}
