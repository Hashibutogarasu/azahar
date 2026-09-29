import 'package:freezed_annotation/freezed_annotation.dart';

part 'access_point.freezed.dart';

@freezed
abstract class AccessPoint with _$AccessPoint {
  const factory AccessPoint({
    required String ssid,
    required String bssid,
    required int frequency,
    required int level,
  }) = _AccessPoint;
}
