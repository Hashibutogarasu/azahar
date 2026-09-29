import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import 'sections/networking_settings.dart';
import 'sections/system_settings.dart';

class NetworkingSettingsState {
  const NetworkingSettingsState({
    required this.accessNetwork,
    required this.useWireless,
  });

  final bool accessNetwork;
  final bool useWireless;
}

final networkingSettingsProvider =
    NotifierProvider<NetworkingSettingsNotifier, NetworkingSettingsState>(
      NetworkingSettingsNotifier.new,
    );

class NetworkingSettingsNotifier extends Notifier<NetworkingSettingsState> {
  NetworkAccessValueStore get _accessStore =>
      NetworkAccessValueStore(AppServices.emulatorSettingsRepository);

  @override
  NetworkingSettingsState build() {
    return NetworkingSettingsState(
      accessNetwork: _accessStore.readBool(
        SystemSettingKeys.requiredOnlineLleModules,
      ),
      useWireless: AppServices.emulatorSettingsRepository.readBool(
        SystemSettingKeys.scanRealWifiNetworks,
      ),
    );
  }

  Future<void> setAccessNetwork(bool value) async {
    await _accessStore.writeBool(
      SystemSettingKeys.requiredOnlineLleModules,
      value,
    );
    state = NetworkingSettingsState(
      accessNetwork: value,
      useWireless: state.useWireless,
    );
  }

  Future<void> setUseWireless(bool value) async {
    await AppServices.emulatorSettingsRepository.writeBool(
      SystemSettingKeys.scanRealWifiNetworks,
      value,
    );
    await AppServices.emulatorSettingsRepository.save();
    state = NetworkingSettingsState(
      accessNetwork: state.accessNetwork,
      useWireless: value,
    );
  }
}
