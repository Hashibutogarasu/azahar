import '../../models/game.dart';
import '../../models/installed_title_path.dart';
import '../../native/native_bridge.dart';

class InstalledTitlesRepository {
  InstalledTitlesRepository(this._nativeBridge);

  final NativeBridge _nativeBridge;

  static const String _appsTitlePath =
      'Nintendo 3DS/00000000000000000000000000000000/'
      '00000000000000000000000000000000/title/00040000';

  static const String _systemTitlePath =
      '00000000000000000000000000000000/title/00040010';

  List<InstalledTitlePath> get scanPaths => const [
    InstalledTitlePath(root: InstalledTitleRoot.sdmc, path: _appsTitlePath),
    InstalledTitlePath(root: InstalledTitleRoot.nand, path: _systemTitlePath),
  ];

  Future<List<Game>> scan(String? gamesDirectory) {
    return _nativeBridge.getGames(
      gamesDirectory,
      installedTitlePaths: scanPaths,
    );
  }
}
