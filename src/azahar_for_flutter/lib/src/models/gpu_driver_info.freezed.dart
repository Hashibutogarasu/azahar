// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gpu_driver_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GpuDriverInfo {

 String get uri; String? get name; String? get description; String? get author; String? get vendor; String? get version;
/// Create a copy of GpuDriverInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GpuDriverInfoCopyWith<GpuDriverInfo> get copyWith => _$GpuDriverInfoCopyWithImpl<GpuDriverInfo>(this as GpuDriverInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GpuDriverInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GpuDriverInfo&&(identical(other.uri, _this.uri) || other.uri == _this.uri)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.vendor, _this.vendor) || other.vendor == _this.vendor)&&(identical(other.version, _this.version) || other.version == _this.version));
}


@override
int get hashCode {
  final _this = this as GpuDriverInfo;
  return Object.hash(runtimeType,_this.uri,_this.name,_this.description,_this.author,_this.vendor,_this.version);
}

@override
String toString() {
  final _this = this as GpuDriverInfo;
  return 'GpuDriverInfo(uri: ${_this.uri}, name: ${_this.name}, description: ${_this.description}, author: ${_this.author}, vendor: ${_this.vendor}, version: ${_this.version})';
}


}

/// @nodoc
abstract mixin class $GpuDriverInfoCopyWith<$Res>  {
  factory $GpuDriverInfoCopyWith(GpuDriverInfo value, $Res Function(GpuDriverInfo) _then) = _$GpuDriverInfoCopyWithImpl;
@useResult
$Res call({
 String uri, String? name, String? description, String? author, String? vendor, String? version
});




}
/// @nodoc
class _$GpuDriverInfoCopyWithImpl<$Res>
    implements $GpuDriverInfoCopyWith<$Res> {
  _$GpuDriverInfoCopyWithImpl(this._self, this._then);

  final GpuDriverInfo _self;
  final $Res Function(GpuDriverInfo) _then;

/// Create a copy of GpuDriverInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uri = null,Object? name = freezed,Object? description = freezed,Object? author = freezed,Object? vendor = freezed,Object? version = freezed,}) {
  return _then(GpuDriverInfo(
uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GpuDriverInfo].
extension GpuDriverInfoPatterns on GpuDriverInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GpuDriverInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GpuDriverInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GpuDriverInfo value)  $default,){
final _that = this;
switch (_that) {
case _GpuDriverInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GpuDriverInfo value)?  $default,){
final _that = this;
switch (_that) {
case _GpuDriverInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uri,  String? name,  String? description,  String? author,  String? vendor,  String? version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GpuDriverInfo() when $default != null:
return $default(_that.uri,_that.name,_that.description,_that.author,_that.vendor,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uri,  String? name,  String? description,  String? author,  String? vendor,  String? version)  $default,) {final _that = this;
switch (_that) {
case _GpuDriverInfo():
return $default(_that.uri,_that.name,_that.description,_that.author,_that.vendor,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uri,  String? name,  String? description,  String? author,  String? vendor,  String? version)?  $default,) {final _that = this;
switch (_that) {
case _GpuDriverInfo() when $default != null:
return $default(_that.uri,_that.name,_that.description,_that.author,_that.vendor,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _GpuDriverInfo implements GpuDriverInfo {
  const _GpuDriverInfo({required this.uri, this.name, this.description, this.author, this.vendor, this.version});
  

@override final  String uri;
@override final  String? name;
@override final  String? description;
@override final  String? author;
@override final  String? vendor;
@override final  String? version;

/// Create a copy of GpuDriverInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GpuDriverInfoCopyWith<_GpuDriverInfo> get copyWith => __$GpuDriverInfoCopyWithImpl<_GpuDriverInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GpuDriverInfo&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.author, author) || other.author == author)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode {
    return Object.hash(runtimeType,uri,name,description,author,vendor,version);
}

@override
String toString() {
    return 'GpuDriverInfo(uri: $uri, name: $name, description: $description, author: $author, vendor: $vendor, version: $version)';
}


}

/// @nodoc
abstract mixin class _$GpuDriverInfoCopyWith<$Res> implements $GpuDriverInfoCopyWith<$Res> {
  factory _$GpuDriverInfoCopyWith(_GpuDriverInfo value, $Res Function(_GpuDriverInfo) _then) = __$GpuDriverInfoCopyWithImpl;
@override @useResult
$Res call({
 String uri, String? name, String? description, String? author, String? vendor, String? version
});




}
/// @nodoc
class __$GpuDriverInfoCopyWithImpl<$Res>
    implements _$GpuDriverInfoCopyWith<$Res> {
  __$GpuDriverInfoCopyWithImpl(this._self, this._then);

  final _GpuDriverInfo _self;
  final $Res Function(_GpuDriverInfo) _then;

/// Create a copy of GpuDriverInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uri = null,Object? name = freezed,Object? description = freezed,Object? author = freezed,Object? vendor = freezed,Object? version = freezed,}) {
  return _then(_GpuDriverInfo(
uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
