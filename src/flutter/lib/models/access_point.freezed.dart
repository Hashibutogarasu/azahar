// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccessPoint {

 String get ssid; String get bssid; int get frequency; int get level;
/// Create a copy of AccessPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessPointCopyWith<AccessPoint> get copyWith => _$AccessPointCopyWithImpl<AccessPoint>(this as AccessPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessPoint&&(identical(other.ssid, ssid) || other.ssid == ssid)&&(identical(other.bssid, bssid) || other.bssid == bssid)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,ssid,bssid,frequency,level);

@override
String toString() {
  return 'AccessPoint(ssid: $ssid, bssid: $bssid, frequency: $frequency, level: $level)';
}


}

/// @nodoc
abstract mixin class $AccessPointCopyWith<$Res>  {
  factory $AccessPointCopyWith(AccessPoint value, $Res Function(AccessPoint) _then) = _$AccessPointCopyWithImpl;
@useResult
$Res call({
 String ssid, String bssid, int frequency, int level
});




}
/// @nodoc
class _$AccessPointCopyWithImpl<$Res>
    implements $AccessPointCopyWith<$Res> {
  _$AccessPointCopyWithImpl(this._self, this._then);

  final AccessPoint _self;
  final $Res Function(AccessPoint) _then;

/// Create a copy of AccessPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ssid = null,Object? bssid = null,Object? frequency = null,Object? level = null,}) {
  return _then(AccessPoint(
ssid: null == ssid ? _self.ssid : ssid // ignore: cast_nullable_to_non_nullable
as String,bssid: null == bssid ? _self.bssid : bssid // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessPoint].
extension AccessPointPatterns on AccessPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessPoint value)  $default,){
final _that = this;
switch (_that) {
case _AccessPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessPoint value)?  $default,){
final _that = this;
switch (_that) {
case _AccessPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ssid,  String bssid,  int frequency,  int level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessPoint() when $default != null:
return $default(_that.ssid,_that.bssid,_that.frequency,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ssid,  String bssid,  int frequency,  int level)  $default,) {final _that = this;
switch (_that) {
case _AccessPoint():
return $default(_that.ssid,_that.bssid,_that.frequency,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ssid,  String bssid,  int frequency,  int level)?  $default,) {final _that = this;
switch (_that) {
case _AccessPoint() when $default != null:
return $default(_that.ssid,_that.bssid,_that.frequency,_that.level);case _:
  return null;

}
}

}

/// @nodoc


class _AccessPoint implements AccessPoint {
  const _AccessPoint({required this.ssid, required this.bssid, required this.frequency, required this.level});
  

@override final  String ssid;
@override final  String bssid;
@override final  int frequency;
@override final  int level;

/// Create a copy of AccessPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessPointCopyWith<_AccessPoint> get copyWith => __$AccessPointCopyWithImpl<_AccessPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessPoint&&(identical(other.ssid, ssid) || other.ssid == ssid)&&(identical(other.bssid, bssid) || other.bssid == bssid)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,ssid,bssid,frequency,level);

@override
String toString() {
  return 'AccessPoint(ssid: $ssid, bssid: $bssid, frequency: $frequency, level: $level)';
}


}

/// @nodoc
abstract mixin class _$AccessPointCopyWith<$Res> implements $AccessPointCopyWith<$Res> {
  factory _$AccessPointCopyWith(_AccessPoint value, $Res Function(_AccessPoint) _then) = __$AccessPointCopyWithImpl;
@override @useResult
$Res call({
 String ssid, String bssid, int frequency, int level
});




}
/// @nodoc
class __$AccessPointCopyWithImpl<$Res>
    implements _$AccessPointCopyWith<$Res> {
  __$AccessPointCopyWithImpl(this._self, this._then);

  final _AccessPoint _self;
  final $Res Function(_AccessPoint) _then;

/// Create a copy of AccessPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ssid = null,Object? bssid = null,Object? frequency = null,Object? level = null,}) {
  return _then(_AccessPoint(
ssid: null == ssid ? _self.ssid : ssid // ignore: cast_nullable_to_non_nullable
as String,bssid: null == bssid ? _self.bssid : bssid // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
