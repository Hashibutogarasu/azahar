// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_session_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaSessionMetadata {

 String get title; String? get artworkPath;
/// Create a copy of MediaSessionMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaSessionMetadataCopyWith<MediaSessionMetadata> get copyWith => _$MediaSessionMetadataCopyWithImpl<MediaSessionMetadata>(this as MediaSessionMetadata, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaSessionMetadata&&(identical(other.title, title) || other.title == title)&&(identical(other.artworkPath, artworkPath) || other.artworkPath == artworkPath));
}


@override
int get hashCode => Object.hash(runtimeType,title,artworkPath);

@override
String toString() {
  return 'MediaSessionMetadata(title: $title, artworkPath: $artworkPath)';
}


}

/// @nodoc
abstract mixin class $MediaSessionMetadataCopyWith<$Res>  {
  factory $MediaSessionMetadataCopyWith(MediaSessionMetadata value, $Res Function(MediaSessionMetadata) _then) = _$MediaSessionMetadataCopyWithImpl;
@useResult
$Res call({
 String title, String? artworkPath
});




}
/// @nodoc
class _$MediaSessionMetadataCopyWithImpl<$Res>
    implements $MediaSessionMetadataCopyWith<$Res> {
  _$MediaSessionMetadataCopyWithImpl(this._self, this._then);

  final MediaSessionMetadata _self;
  final $Res Function(MediaSessionMetadata) _then;

/// Create a copy of MediaSessionMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? artworkPath = freezed,}) {
  return _then(MediaSessionMetadata(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artworkPath: freezed == artworkPath ? _self.artworkPath : artworkPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaSessionMetadata].
extension MediaSessionMetadataPatterns on MediaSessionMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaSessionMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaSessionMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaSessionMetadata value)  $default,){
final _that = this;
switch (_that) {
case _MediaSessionMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaSessionMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _MediaSessionMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? artworkPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaSessionMetadata() when $default != null:
return $default(_that.title,_that.artworkPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? artworkPath)  $default,) {final _that = this;
switch (_that) {
case _MediaSessionMetadata():
return $default(_that.title,_that.artworkPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? artworkPath)?  $default,) {final _that = this;
switch (_that) {
case _MediaSessionMetadata() when $default != null:
return $default(_that.title,_that.artworkPath);case _:
  return null;

}
}

}

/// @nodoc


class _MediaSessionMetadata implements MediaSessionMetadata {
  const _MediaSessionMetadata({required this.title, this.artworkPath});
  

@override final  String title;
@override final  String? artworkPath;

/// Create a copy of MediaSessionMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaSessionMetadataCopyWith<_MediaSessionMetadata> get copyWith => __$MediaSessionMetadataCopyWithImpl<_MediaSessionMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaSessionMetadata&&(identical(other.title, title) || other.title == title)&&(identical(other.artworkPath, artworkPath) || other.artworkPath == artworkPath));
}


@override
int get hashCode => Object.hash(runtimeType,title,artworkPath);

@override
String toString() {
  return 'MediaSessionMetadata(title: $title, artworkPath: $artworkPath)';
}


}

/// @nodoc
abstract mixin class _$MediaSessionMetadataCopyWith<$Res> implements $MediaSessionMetadataCopyWith<$Res> {
  factory _$MediaSessionMetadataCopyWith(_MediaSessionMetadata value, $Res Function(_MediaSessionMetadata) _then) = __$MediaSessionMetadataCopyWithImpl;
@override @useResult
$Res call({
 String title, String? artworkPath
});




}
/// @nodoc
class __$MediaSessionMetadataCopyWithImpl<$Res>
    implements _$MediaSessionMetadataCopyWith<$Res> {
  __$MediaSessionMetadataCopyWithImpl(this._self, this._then);

  final _MediaSessionMetadata _self;
  final $Res Function(_MediaSessionMetadata) _then;

/// Create a copy of MediaSessionMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? artworkPath = freezed,}) {
  return _then(_MediaSessionMetadata(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artworkPath: freezed == artworkPath ? _self.artworkPath : artworkPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
