// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_controller_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewControllerProfile {

 String get name; bool get isBuiltIn;
/// Create a copy of NewControllerProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewControllerProfileCopyWith<NewControllerProfile> get copyWith => _$NewControllerProfileCopyWithImpl<NewControllerProfile>(this as NewControllerProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NewControllerProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewControllerProfile&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isBuiltIn, _this.isBuiltIn) || other.isBuiltIn == _this.isBuiltIn));
}


@override
int get hashCode {
  final _this = this as NewControllerProfile;
  return Object.hash(runtimeType,_this.name,_this.isBuiltIn);
}

@override
String toString() {
  final _this = this as NewControllerProfile;
  return 'NewControllerProfile(name: ${_this.name}, isBuiltIn: ${_this.isBuiltIn})';
}


}

/// @nodoc
abstract mixin class $NewControllerProfileCopyWith<$Res>  {
  factory $NewControllerProfileCopyWith(NewControllerProfile value, $Res Function(NewControllerProfile) _then) = _$NewControllerProfileCopyWithImpl;
@useResult
$Res call({
 String name, bool isBuiltIn
});




}
/// @nodoc
class _$NewControllerProfileCopyWithImpl<$Res>
    implements $NewControllerProfileCopyWith<$Res> {
  _$NewControllerProfileCopyWithImpl(this._self, this._then);

  final NewControllerProfile _self;
  final $Res Function(NewControllerProfile) _then;

/// Create a copy of NewControllerProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? isBuiltIn = null,}) {
  return _then(NewControllerProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isBuiltIn: null == isBuiltIn ? _self.isBuiltIn : isBuiltIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NewControllerProfile].
extension NewControllerProfilePatterns on NewControllerProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewControllerProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewControllerProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewControllerProfile value)  $default,){
final _that = this;
switch (_that) {
case _NewControllerProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewControllerProfile value)?  $default,){
final _that = this;
switch (_that) {
case _NewControllerProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool isBuiltIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewControllerProfile() when $default != null:
return $default(_that.name,_that.isBuiltIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool isBuiltIn)  $default,) {final _that = this;
switch (_that) {
case _NewControllerProfile():
return $default(_that.name,_that.isBuiltIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool isBuiltIn)?  $default,) {final _that = this;
switch (_that) {
case _NewControllerProfile() when $default != null:
return $default(_that.name,_that.isBuiltIn);case _:
  return null;

}
}

}

/// @nodoc


class _NewControllerProfile implements NewControllerProfile {
  const _NewControllerProfile({required this.name, this.isBuiltIn = false});
  

@override final  String name;
@override@JsonKey() final  bool isBuiltIn;

/// Create a copy of NewControllerProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewControllerProfileCopyWith<_NewControllerProfile> get copyWith => __$NewControllerProfileCopyWithImpl<_NewControllerProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewControllerProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.isBuiltIn, isBuiltIn) || other.isBuiltIn == isBuiltIn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,isBuiltIn);
}

@override
String toString() {
    return 'NewControllerProfile(name: $name, isBuiltIn: $isBuiltIn)';
}


}

/// @nodoc
abstract mixin class _$NewControllerProfileCopyWith<$Res> implements $NewControllerProfileCopyWith<$Res> {
  factory _$NewControllerProfileCopyWith(_NewControllerProfile value, $Res Function(_NewControllerProfile) _then) = __$NewControllerProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, bool isBuiltIn
});




}
/// @nodoc
class __$NewControllerProfileCopyWithImpl<$Res>
    implements _$NewControllerProfileCopyWith<$Res> {
  __$NewControllerProfileCopyWithImpl(this._self, this._then);

  final _NewControllerProfile _self;
  final $Res Function(_NewControllerProfile) _then;

/// Create a copy of NewControllerProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? isBuiltIn = null,}) {
  return _then(_NewControllerProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isBuiltIn: null == isBuiltIn ? _self.isBuiltIn : isBuiltIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
