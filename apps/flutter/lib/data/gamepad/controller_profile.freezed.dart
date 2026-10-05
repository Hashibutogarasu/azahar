// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'controller_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ControllerProfile {

 String get cuid; String get name; bool get isBuiltIn; DateTime get createdAt;
/// Create a copy of ControllerProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ControllerProfileCopyWith<ControllerProfile> get copyWith => _$ControllerProfileCopyWithImpl<ControllerProfile>(this as ControllerProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ControllerProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ControllerProfile&&(identical(other.cuid, _this.cuid) || other.cuid == _this.cuid)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isBuiltIn, _this.isBuiltIn) || other.isBuiltIn == _this.isBuiltIn)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as ControllerProfile;
  return Object.hash(runtimeType,_this.cuid,_this.name,_this.isBuiltIn,_this.createdAt);
}

@override
String toString() {
  final _this = this as ControllerProfile;
  return 'ControllerProfile(cuid: ${_this.cuid}, name: ${_this.name}, isBuiltIn: ${_this.isBuiltIn}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ControllerProfileCopyWith<$Res>  {
  factory $ControllerProfileCopyWith(ControllerProfile value, $Res Function(ControllerProfile) _then) = _$ControllerProfileCopyWithImpl;
@useResult
$Res call({
 String cuid, String name, bool isBuiltIn, DateTime createdAt
});




}
/// @nodoc
class _$ControllerProfileCopyWithImpl<$Res>
    implements $ControllerProfileCopyWith<$Res> {
  _$ControllerProfileCopyWithImpl(this._self, this._then);

  final ControllerProfile _self;
  final $Res Function(ControllerProfile) _then;

/// Create a copy of ControllerProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cuid = null,Object? name = null,Object? isBuiltIn = null,Object? createdAt = null,}) {
  return _then(ControllerProfile(
cuid: null == cuid ? _self.cuid : cuid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isBuiltIn: null == isBuiltIn ? _self.isBuiltIn : isBuiltIn // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ControllerProfile].
extension ControllerProfilePatterns on ControllerProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ControllerProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ControllerProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ControllerProfile value)  $default,){
final _that = this;
switch (_that) {
case _ControllerProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ControllerProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ControllerProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cuid,  String name,  bool isBuiltIn,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ControllerProfile() when $default != null:
return $default(_that.cuid,_that.name,_that.isBuiltIn,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cuid,  String name,  bool isBuiltIn,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ControllerProfile():
return $default(_that.cuid,_that.name,_that.isBuiltIn,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cuid,  String name,  bool isBuiltIn,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ControllerProfile() when $default != null:
return $default(_that.cuid,_that.name,_that.isBuiltIn,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ControllerProfile implements ControllerProfile {
  const _ControllerProfile({required this.cuid, required this.name, required this.isBuiltIn, required this.createdAt});
  

@override final  String cuid;
@override final  String name;
@override final  bool isBuiltIn;
@override final  DateTime createdAt;

/// Create a copy of ControllerProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ControllerProfileCopyWith<_ControllerProfile> get copyWith => __$ControllerProfileCopyWithImpl<_ControllerProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ControllerProfile&&(identical(other.cuid, cuid) || other.cuid == cuid)&&(identical(other.name, name) || other.name == name)&&(identical(other.isBuiltIn, isBuiltIn) || other.isBuiltIn == isBuiltIn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,cuid,name,isBuiltIn,createdAt);
}

@override
String toString() {
    return 'ControllerProfile(cuid: $cuid, name: $name, isBuiltIn: $isBuiltIn, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ControllerProfileCopyWith<$Res> implements $ControllerProfileCopyWith<$Res> {
  factory _$ControllerProfileCopyWith(_ControllerProfile value, $Res Function(_ControllerProfile) _then) = __$ControllerProfileCopyWithImpl;
@override @useResult
$Res call({
 String cuid, String name, bool isBuiltIn, DateTime createdAt
});




}
/// @nodoc
class __$ControllerProfileCopyWithImpl<$Res>
    implements _$ControllerProfileCopyWith<$Res> {
  __$ControllerProfileCopyWithImpl(this._self, this._then);

  final _ControllerProfile _self;
  final $Res Function(_ControllerProfile) _then;

/// Create a copy of ControllerProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cuid = null,Object? name = null,Object? isBuiltIn = null,Object? createdAt = null,}) {
  return _then(_ControllerProfile(
cuid: null == cuid ? _self.cuid : cuid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isBuiltIn: null == isBuiltIn ? _self.isBuiltIn : isBuiltIn // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
