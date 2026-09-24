import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_shortcut_request.freezed.dart';

@freezed
abstract class CreateShortcutRequest with _$CreateShortcutRequest {
  const factory CreateShortcutRequest({
    required int titleId,
    required String path,
    required String name,
    String? iconFilePath,
    required bool stretch,
  }) = _CreateShortcutRequest;
}
