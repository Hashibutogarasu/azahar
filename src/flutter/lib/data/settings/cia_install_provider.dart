import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';
import '../../i18n/translations.g.dart';
import '../../native/app_notification.dart';

final ciaInstallProvider = Provider<CiaInstallService>(
  (ref) => CiaInstallService(),
);

class CiaInstallService {
  Future<bool> pickAndInstall() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['cia'],
    );
    final paths = result.map((file) => file.path).whereType<String>().toList();
    if (paths.isEmpty) return false;
    final results = await AppServices.nativeBridge.installCiaFiles(paths);
    for (final result in results) {
      await AppNotification.show(
        title: result.success
            ? t.options.installGameContentSuccessTitle
            : t.options.installGameContentFailureTitle,
        body: result.filename,
      );
    }
    return true;
  }
}
