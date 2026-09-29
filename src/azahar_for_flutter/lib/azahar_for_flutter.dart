/// Native integration for Azahar on Android and Linux.
///
/// Adding this package to a Flutter application registers the native
/// implementation automatically. The Dart side is reached through
/// [NativeBridge] and [AppletChannel].
library;

export 'src/models/access_point.dart';
export 'src/models/cia_install_result.dart';
export 'src/models/copy_dir_progress.dart';
export 'src/models/create_shortcut_request.dart';
export 'src/models/game.dart';
export 'src/models/game_folder_kind.dart';
export 'src/models/game_folder_status.dart';
export 'src/models/game_uninstall_target.dart';
export 'src/models/gpu_driver_info.dart';
export 'src/models/installed_title_path.dart';
export 'src/models/shader_cache_backend.dart';
export 'src/models/shader_cache_progress.dart';
export 'src/models/wifi_channel.dart';
export 'src/native/applet_channel.dart';
export 'src/native/native_bridge.dart';
