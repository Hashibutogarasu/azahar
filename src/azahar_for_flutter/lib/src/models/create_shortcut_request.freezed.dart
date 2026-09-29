// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_shortcut_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateShortcutRequest {

 int get titleId; String get path; String get name; String? get iconFilePath; bool get stretch;
/// Create a copy of CreateShortcutRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateShortcutRequestCopyWith<CreateShortcutRequest> get copyWith => _$CreateShortcutRequestCopyWithImpl<CreateShortcutRequest>(this as CreateShortcutRequest, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CreateShortcutRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateShortcutRequest&&(identical(other.titleId, _this.titleId) || other.titleId == _this.titleId)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.iconFilePath, _this.iconFilePath) || other.iconFilePath == _this.iconFilePath)&&(identical(other.stretch, _this.stretch) || other.stretch == _this.stretch));
}


@override
int get hashCode {
  final _this = this as CreateShortcutRequest;
  return Object.hash(runtimeType,_this.titleId,_this.path,_this.name,_this.iconFilePath,_this.stretch);
}

@override
String toString() {
  final _this = this as CreateShortcutRequest;
  return 'CreateShortcutRequest(titleId: ${_this.titleId}, path: ${_this.path}, name: ${_this.name}, iconFilePath: ${_this.iconFilePath}, stretch: ${_this.stretch})';
}


}

/// @nodoc
abstract mixin class $CreateShortcutRequestCopyWith<$Res>  {
  factory $CreateShortcutRequestCopyWith(CreateShortcutRequest value, $Res Function(CreateShortcutRequest) _then) = _$CreateShortcutRequestCopyWithImpl;
@useResult
$Res call({
 int titleId, String path, String name, String? iconFilePath, bool stretch
});




}
/// @nodoc
class _$CreateShortcutRequestCopyWithImpl<$Res>
    implements $CreateShortcutRequestCopyWith<$Res> {
  _$CreateShortcutRequestCopyWithImpl(this._self, this._then);

  final CreateShortcutRequest _self;
  final $Res Function(CreateShortcutRequest) _then;

/// Create a copy of CreateShortcutRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleId = null,Object? path = null,Object? name = null,Object? iconFilePath = freezed,Object? stretch = null,}) {
  return _then(CreateShortcutRequest(
titleId: null == titleId ? _self.titleId : titleId // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconFilePath: freezed == iconFilePath ? _self.iconFilePath : iconFilePath // ignore: cast_nullable_to_non_nullable
as String?,stretch: null == stretch ? _self.stretch : stretch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateShortcutRequest].
extension CreateShortcutRequestPatterns on CreateShortcutRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateShortcutRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateShortcutRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateShortcutRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateShortcutRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateShortcutRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateShortcutRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int titleId,  String path,  String name,  String? iconFilePath,  bool stretch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateShortcutRequest() when $default != null:
return $default(_that.titleId,_that.path,_that.name,_that.iconFilePath,_that.stretch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int titleId,  String path,  String name,  String? iconFilePath,  bool stretch)  $default,) {final _that = this;
switch (_that) {
case _CreateShortcutRequest():
return $default(_that.titleId,_that.path,_that.name,_that.iconFilePath,_that.stretch);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int titleId,  String path,  String name,  String? iconFilePath,  bool stretch)?  $default,) {final _that = this;
switch (_that) {
case _CreateShortcutRequest() when $default != null:
return $default(_that.titleId,_that.path,_that.name,_that.iconFilePath,_that.stretch);case _:
  return null;

}
}

}

/// @nodoc


class _CreateShortcutRequest implements CreateShortcutRequest {
  const _CreateShortcutRequest({required this.titleId, required this.path, required this.name, this.iconFilePath, required this.stretch});
  

@override final  int titleId;
@override final  String path;
@override final  String name;
@override final  String? iconFilePath;
@override final  bool stretch;

/// Create a copy of CreateShortcutRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateShortcutRequestCopyWith<_CreateShortcutRequest> get copyWith => __$CreateShortcutRequestCopyWithImpl<_CreateShortcutRequest>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateShortcutRequest&&(identical(other.titleId, titleId) || other.titleId == titleId)&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconFilePath, iconFilePath) || other.iconFilePath == iconFilePath)&&(identical(other.stretch, stretch) || other.stretch == stretch));
}


@override
int get hashCode {
    return Object.hash(runtimeType,titleId,path,name,iconFilePath,stretch);
}

@override
String toString() {
    return 'CreateShortcutRequest(titleId: $titleId, path: $path, name: $name, iconFilePath: $iconFilePath, stretch: $stretch)';
}


}

/// @nodoc
abstract mixin class _$CreateShortcutRequestCopyWith<$Res> implements $CreateShortcutRequestCopyWith<$Res> {
  factory _$CreateShortcutRequestCopyWith(_CreateShortcutRequest value, $Res Function(_CreateShortcutRequest) _then) = __$CreateShortcutRequestCopyWithImpl;
@override @useResult
$Res call({
 int titleId, String path, String name, String? iconFilePath, bool stretch
});




}
/// @nodoc
class __$CreateShortcutRequestCopyWithImpl<$Res>
    implements _$CreateShortcutRequestCopyWith<$Res> {
  __$CreateShortcutRequestCopyWithImpl(this._self, this._then);

  final _CreateShortcutRequest _self;
  final $Res Function(_CreateShortcutRequest) _then;

/// Create a copy of CreateShortcutRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleId = null,Object? path = null,Object? name = null,Object? iconFilePath = freezed,Object? stretch = null,}) {
  return _then(_CreateShortcutRequest(
titleId: null == titleId ? _self.titleId : titleId // ignore: cast_nullable_to_non_nullable
as int,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconFilePath: freezed == iconFilePath ? _self.iconFilePath : iconFilePath // ignore: cast_nullable_to_non_nullable
as String?,stretch: null == stretch ? _self.stretch : stretch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
