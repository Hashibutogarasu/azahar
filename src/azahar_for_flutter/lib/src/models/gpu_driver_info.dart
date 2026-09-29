import 'package:freezed_annotation/freezed_annotation.dart';

part 'gpu_driver_info.freezed.dart';

@freezed
abstract class GpuDriverInfo with _$GpuDriverInfo {
  const factory GpuDriverInfo({
    required String uri,
    String? name,
    String? description,
    String? author,
    String? vendor,
    String? version,
  }) = _GpuDriverInfo;
}
