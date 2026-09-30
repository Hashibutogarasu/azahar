import 'package:freezed_annotation/freezed_annotation.dart';

part 'cheat.freezed.dart';
part 'cheat.g.dart';

/// A single cheat entry held by the native cheat engine of the running title.
@freezed
abstract class Cheat with _$Cheat {
  const factory Cheat({
    required String name,
    required String notes,
    required String code,
    required bool enabled,
  }) = _Cheat;

  factory Cheat.fromJson(Map<String, dynamic> json) => _$CheatFromJson(json);
}
