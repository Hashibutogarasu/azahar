// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cheat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Cheat _$CheatFromJson(Map<String, dynamic> json) => _Cheat(
  name: json['name'] as String,
  notes: json['notes'] as String,
  code: json['code'] as String,
  enabled: json['enabled'] as bool,
);

Map<String, dynamic> _$CheatToJson(_Cheat instance) => <String, dynamic>{
  'name': instance.name,
  'notes': instance.notes,
  'code': instance.code,
  'enabled': instance.enabled,
};
