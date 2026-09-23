import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_services.dart';

final ciaInstallProvider = Provider<CiaInstallService>((ref) => CiaInstallService());

class CiaInstallService {
  Future<bool> pickAndInstall() async {
    final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['cia']);
    final paths = result.map((file) => file.path).whereType<String>().toList();
    if (paths.isEmpty) return false;
    await AppServices.nativeBridge.installCiaFiles(paths);
    return true;
  }
}
