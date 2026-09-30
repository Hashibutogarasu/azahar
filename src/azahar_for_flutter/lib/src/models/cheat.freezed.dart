// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cheat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Cheat {

 String get name; String get notes; String get code; bool get enabled;
/// Create a copy of Cheat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheatCopyWith<Cheat> get copyWith => _$CheatCopyWithImpl<Cheat>(this as Cheat, _$identity);

  /// Serializes this Cheat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Cheat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cheat&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Cheat;
  return Object.hash(runtimeType,_this.name,_this.notes,_this.code,_this.enabled);
}

@override
String toString() {
  final _this = this as Cheat;
  return 'Cheat(name: ${_this.name}, notes: ${_this.notes}, code: ${_this.code}, enabled: ${_this.enabled})';
}


}

/// @nodoc
abstract mixin class $CheatCopyWith<$Res>  {
  factory $CheatCopyWith(Cheat value, $Res Function(Cheat) _then) = _$CheatCopyWithImpl;
@useResult
$Res call({
 String name, String notes, String code, bool enabled
});




}
/// @nodoc
class _$CheatCopyWithImpl<$Res>
    implements $CheatCopyWith<$Res> {
  _$CheatCopyWithImpl(this._self, this._then);

  final Cheat _self;
  final $Res Function(Cheat) _then;

/// Create a copy of Cheat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? notes = null,Object? code = null,Object? enabled = null,}) {
  return _then(Cheat(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Cheat].
extension CheatPatterns on Cheat {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cheat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cheat() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cheat value)  $default,){
final _that = this;
switch (_that) {
case _Cheat():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cheat value)?  $default,){
final _that = this;
switch (_that) {
case _Cheat() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String notes,  String code,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cheat() when $default != null:
return $default(_that.name,_that.notes,_that.code,_that.enabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String notes,  String code,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _Cheat():
return $default(_that.name,_that.notes,_that.code,_that.enabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String notes,  String code,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _Cheat() when $default != null:
return $default(_that.name,_that.notes,_that.code,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cheat implements Cheat {
  const _Cheat({required this.name, required this.notes, required this.code, required this.enabled});
  factory _Cheat.fromJson(Map<String, dynamic> json) => _$CheatFromJson(json);

@override final  String name;
@override final  String notes;
@override final  String code;
@override final  bool enabled;

/// Create a copy of Cheat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheatCopyWith<_Cheat> get copyWith => __$CheatCopyWithImpl<_Cheat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cheat&&(identical(other.name, name) || other.name == name)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.code, code) || other.code == code)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,notes,code,enabled);
}

@override
String toString() {
    return 'Cheat(name: $name, notes: $notes, code: $code, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$CheatCopyWith<$Res> implements $CheatCopyWith<$Res> {
  factory _$CheatCopyWith(_Cheat value, $Res Function(_Cheat) _then) = __$CheatCopyWithImpl;
@override @useResult
$Res call({
 String name, String notes, String code, bool enabled
});




}
/// @nodoc
class __$CheatCopyWithImpl<$Res>
    implements _$CheatCopyWith<$Res> {
  __$CheatCopyWithImpl(this._self, this._then);

  final _Cheat _self;
  final $Res Function(_Cheat) _then;

/// Create a copy of Cheat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? notes = null,Object? code = null,Object? enabled = null,}) {
  return _then(_Cheat(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
