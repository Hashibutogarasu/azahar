// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shader_cache_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShaderCacheProgress {

 ShaderCacheStage get stage; int get progress; int get max;
/// Create a copy of ShaderCacheProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShaderCacheProgressCopyWith<ShaderCacheProgress> get copyWith => _$ShaderCacheProgressCopyWithImpl<ShaderCacheProgress>(this as ShaderCacheProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShaderCacheProgress&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.max, max) || other.max == max));
}


@override
int get hashCode => Object.hash(runtimeType,stage,progress,max);

@override
String toString() {
  return 'ShaderCacheProgress(stage: $stage, progress: $progress, max: $max)';
}


}

/// @nodoc
abstract mixin class $ShaderCacheProgressCopyWith<$Res>  {
  factory $ShaderCacheProgressCopyWith(ShaderCacheProgress value, $Res Function(ShaderCacheProgress) _then) = _$ShaderCacheProgressCopyWithImpl;
@useResult
$Res call({
 ShaderCacheStage stage, int progress, int max
});




}
/// @nodoc
class _$ShaderCacheProgressCopyWithImpl<$Res>
    implements $ShaderCacheProgressCopyWith<$Res> {
  _$ShaderCacheProgressCopyWithImpl(this._self, this._then);

  final ShaderCacheProgress _self;
  final $Res Function(ShaderCacheProgress) _then;

/// Create a copy of ShaderCacheProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? progress = null,Object? max = null,}) {
  return _then(ShaderCacheProgress(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as ShaderCacheStage,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ShaderCacheProgress].
extension ShaderCacheProgressPatterns on ShaderCacheProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShaderCacheProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShaderCacheProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShaderCacheProgress value)  $default,){
final _that = this;
switch (_that) {
case _ShaderCacheProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShaderCacheProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ShaderCacheProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ShaderCacheStage stage,  int progress,  int max)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShaderCacheProgress() when $default != null:
return $default(_that.stage,_that.progress,_that.max);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ShaderCacheStage stage,  int progress,  int max)  $default,) {final _that = this;
switch (_that) {
case _ShaderCacheProgress():
return $default(_that.stage,_that.progress,_that.max);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ShaderCacheStage stage,  int progress,  int max)?  $default,) {final _that = this;
switch (_that) {
case _ShaderCacheProgress() when $default != null:
return $default(_that.stage,_that.progress,_that.max);case _:
  return null;

}
}

}

/// @nodoc


class _ShaderCacheProgress implements ShaderCacheProgress {
  const _ShaderCacheProgress({required this.stage, required this.progress, required this.max});


@override final  ShaderCacheStage stage;
@override final  int progress;
@override final  int max;

/// Create a copy of ShaderCacheProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShaderCacheProgressCopyWith<_ShaderCacheProgress> get copyWith => __$ShaderCacheProgressCopyWithImpl<_ShaderCacheProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShaderCacheProgress&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.max, max) || other.max == max));
}


@override
int get hashCode => Object.hash(runtimeType,stage,progress,max);

@override
String toString() {
  return 'ShaderCacheProgress(stage: $stage, progress: $progress, max: $max)';
}


}

/// @nodoc
abstract mixin class _$ShaderCacheProgressCopyWith<$Res> implements $ShaderCacheProgressCopyWith<$Res> {
  factory _$ShaderCacheProgressCopyWith(_ShaderCacheProgress value, $Res Function(_ShaderCacheProgress) _then) = __$ShaderCacheProgressCopyWithImpl;
@override @useResult
$Res call({
 ShaderCacheStage stage, int progress, int max
});




}
/// @nodoc
class __$ShaderCacheProgressCopyWithImpl<$Res>
    implements _$ShaderCacheProgressCopyWith<$Res> {
  __$ShaderCacheProgressCopyWithImpl(this._self, this._then);

  final _ShaderCacheProgress _self;
  final $Res Function(_ShaderCacheProgress) _then;

/// Create a copy of ShaderCacheProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? progress = null,Object? max = null,}) {
  return _then(_ShaderCacheProgress(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as ShaderCacheStage,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
