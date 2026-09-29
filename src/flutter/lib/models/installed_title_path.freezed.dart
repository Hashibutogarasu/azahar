// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'installed_title_path.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InstalledTitlePath {

 InstalledTitleRoot get root; String get path;
/// Create a copy of InstalledTitlePath
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstalledTitlePathCopyWith<InstalledTitlePath> get copyWith => _$InstalledTitlePathCopyWithImpl<InstalledTitlePath>(this as InstalledTitlePath, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstalledTitlePath&&(identical(other.root, root) || other.root == root)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,root,path);

@override
String toString() {
  return 'InstalledTitlePath(root: $root, path: $path)';
}


}

/// @nodoc
abstract mixin class $InstalledTitlePathCopyWith<$Res>  {
  factory $InstalledTitlePathCopyWith(InstalledTitlePath value, $Res Function(InstalledTitlePath) _then) = _$InstalledTitlePathCopyWithImpl;
@useResult
$Res call({
 InstalledTitleRoot root, String path
});




}
/// @nodoc
class _$InstalledTitlePathCopyWithImpl<$Res>
    implements $InstalledTitlePathCopyWith<$Res> {
  _$InstalledTitlePathCopyWithImpl(this._self, this._then);

  final InstalledTitlePath _self;
  final $Res Function(InstalledTitlePath) _then;

/// Create a copy of InstalledTitlePath
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? root = null,Object? path = null,}) {
  return _then(InstalledTitlePath(
root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as InstalledTitleRoot,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InstalledTitlePath].
extension InstalledTitlePathPatterns on InstalledTitlePath {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstalledTitlePath value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstalledTitlePath() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstalledTitlePath value)  $default,){
final _that = this;
switch (_that) {
case _InstalledTitlePath():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstalledTitlePath value)?  $default,){
final _that = this;
switch (_that) {
case _InstalledTitlePath() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InstalledTitleRoot root,  String path)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstalledTitlePath() when $default != null:
return $default(_that.root,_that.path);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InstalledTitleRoot root,  String path)  $default,) {final _that = this;
switch (_that) {
case _InstalledTitlePath():
return $default(_that.root,_that.path);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InstalledTitleRoot root,  String path)?  $default,) {final _that = this;
switch (_that) {
case _InstalledTitlePath() when $default != null:
return $default(_that.root,_that.path);case _:
  return null;

}
}

}

/// @nodoc


class _InstalledTitlePath implements InstalledTitlePath {
  const _InstalledTitlePath({required this.root, required this.path});
  

@override final  InstalledTitleRoot root;
@override final  String path;

/// Create a copy of InstalledTitlePath
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstalledTitlePathCopyWith<_InstalledTitlePath> get copyWith => __$InstalledTitlePathCopyWithImpl<_InstalledTitlePath>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstalledTitlePath&&(identical(other.root, root) || other.root == root)&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,root,path);

@override
String toString() {
  return 'InstalledTitlePath(root: $root, path: $path)';
}


}

/// @nodoc
abstract mixin class _$InstalledTitlePathCopyWith<$Res> implements $InstalledTitlePathCopyWith<$Res> {
  factory _$InstalledTitlePathCopyWith(_InstalledTitlePath value, $Res Function(_InstalledTitlePath) _then) = __$InstalledTitlePathCopyWithImpl;
@override @useResult
$Res call({
 InstalledTitleRoot root, String path
});




}
/// @nodoc
class __$InstalledTitlePathCopyWithImpl<$Res>
    implements _$InstalledTitlePathCopyWith<$Res> {
  __$InstalledTitlePathCopyWithImpl(this._self, this._then);

  final _InstalledTitlePath _self;
  final $Res Function(_InstalledTitlePath) _then;

/// Create a copy of InstalledTitlePath
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? root = null,Object? path = null,}) {
  return _then(_InstalledTitlePath(
root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as InstalledTitleRoot,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
