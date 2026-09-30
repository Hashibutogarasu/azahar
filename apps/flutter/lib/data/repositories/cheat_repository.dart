import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import 'loadable.dart';

/// Mirrors the native cheat engine of one running title in memory.
///
/// Every mutation is written through to the native engine and saved to the cheat file, then the
/// list is reloaded so [cheats] always reflects what the engine holds.
class CheatRepository implements Loadable {
  CheatRepository(this._bridge, this.titleId);

  final NativeBridge _bridge;
  final int titleId;

  List<Cheat> _cheats = const [];

  List<Cheat> get cheats => _cheats;

  @override
  Future<void> load() async {
    await _bridge.loadCheatFile(titleId);
    _cheats = await _bridge.getCheats();
  }

  Future<void> setEnabled(int index, bool enabled) async {
    await _bridge.setCheatEnabled(index, enabled);
    await _save();
  }

  Future<void> add({
    required String name,
    required String notes,
    required String code,
  }) async {
    await _bridge.addCheat(name: name, notes: notes, code: code);
    await _save();
  }

  /// Returns 0 when [code] is valid, otherwise the 1-based number of the first invalid line.
  Future<int> validateCode(String code) => _bridge.validateCheatCode(code);

  Future<void> _save() async {
    await _bridge.saveCheatFile(titleId);
    await load();
  }
}
