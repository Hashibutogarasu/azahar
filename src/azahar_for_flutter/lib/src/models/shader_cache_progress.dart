import 'package:freezed_annotation/freezed_annotation.dart';

part 'shader_cache_progress.freezed.dart';

enum ShaderCacheStage { prepare, decompile, build, complete }

@freezed
abstract class ShaderCacheProgress with _$ShaderCacheProgress {
  const factory ShaderCacheProgress({
    required ShaderCacheStage stage,
    required int progress,
    required int max,
  }) = _ShaderCacheProgress;
}
