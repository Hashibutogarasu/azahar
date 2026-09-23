import 'package:freezed_annotation/freezed_annotation.dart';

part 'copy_dir_progress.freezed.dart';

@freezed
abstract class CopyDirProgress with _$CopyDirProgress {
  const factory CopyDirProgress.searching(String directoryName) = CopyDirSearching;
  const factory CopyDirProgress.copying(String filename, int progress, int max) = CopyDirCopying;
}
