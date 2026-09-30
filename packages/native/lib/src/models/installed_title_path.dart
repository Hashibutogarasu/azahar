import 'package:freezed_annotation/freezed_annotation.dart';

part 'installed_title_path.freezed.dart';

enum InstalledTitleRoot { sdmc, nand }

@freezed
abstract class InstalledTitlePath with _$InstalledTitlePath {
  const factory InstalledTitlePath({
    required InstalledTitleRoot root,
    required String path,
  }) = _InstalledTitlePath;
}
