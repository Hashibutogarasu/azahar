import 'package:freezed_annotation/freezed_annotation.dart';

part 'cia_install_result.freezed.dart';

@freezed
abstract class CiaInstallResult with _$CiaInstallResult {
  const factory CiaInstallResult({
    required String filename,
    required bool success,
  }) = _CiaInstallResult;
}
