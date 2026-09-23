// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'copy_dir_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CopyDirProgress {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CopyDirProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CopyDirProgress()';
}


}

/// @nodoc
class $CopyDirProgressCopyWith<$Res>  {
$CopyDirProgressCopyWith(CopyDirProgress _, $Res Function(CopyDirProgress) __);
}


/// Adds pattern-matching-related methods to [CopyDirProgress].
extension CopyDirProgressPatterns on CopyDirProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CopyDirSearching value)?  searching,TResult Function( CopyDirCopying value)?  copying,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CopyDirSearching() when searching != null:
return searching(_that);case CopyDirCopying() when copying != null:
return copying(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CopyDirSearching value)  searching,required TResult Function( CopyDirCopying value)  copying,}){
final _that = this;
switch (_that) {
case CopyDirSearching():
return searching(_that);case CopyDirCopying():
return copying(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CopyDirSearching value)?  searching,TResult? Function( CopyDirCopying value)?  copying,}){
final _that = this;
switch (_that) {
case CopyDirSearching() when searching != null:
return searching(_that);case CopyDirCopying() when copying != null:
return copying(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String directoryName)?  searching,TResult Function( String filename,  int progress,  int max)?  copying,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CopyDirSearching() when searching != null:
return searching(_that.directoryName);case CopyDirCopying() when copying != null:
return copying(_that.filename,_that.progress,_that.max);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String directoryName)  searching,required TResult Function( String filename,  int progress,  int max)  copying,}) {final _that = this;
switch (_that) {
case CopyDirSearching():
return searching(_that.directoryName);case CopyDirCopying():
return copying(_that.filename,_that.progress,_that.max);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String directoryName)?  searching,TResult? Function( String filename,  int progress,  int max)?  copying,}) {final _that = this;
switch (_that) {
case CopyDirSearching() when searching != null:
return searching(_that.directoryName);case CopyDirCopying() when copying != null:
return copying(_that.filename,_that.progress,_that.max);case _:
  return null;

}
}

}

/// @nodoc


class CopyDirSearching implements CopyDirProgress {
  const CopyDirSearching(this.directoryName);


 final  String directoryName;

/// Create a copy of CopyDirProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CopyDirSearchingCopyWith<CopyDirSearching> get copyWith => _$CopyDirSearchingCopyWithImpl<CopyDirSearching>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CopyDirSearching&&(identical(other.directoryName, directoryName) || other.directoryName == directoryName));
}


@override
int get hashCode => Object.hash(runtimeType,directoryName);

@override
String toString() {
  return 'CopyDirProgress.searching(directoryName: $directoryName)';
}


}

/// @nodoc
abstract mixin class $CopyDirSearchingCopyWith<$Res> implements $CopyDirProgressCopyWith<$Res> {
  factory $CopyDirSearchingCopyWith(CopyDirSearching value, $Res Function(CopyDirSearching) _then) = _$CopyDirSearchingCopyWithImpl;
@useResult
$Res call({
 String directoryName
});




}
/// @nodoc
class _$CopyDirSearchingCopyWithImpl<$Res>
    implements $CopyDirSearchingCopyWith<$Res> {
  _$CopyDirSearchingCopyWithImpl(this._self, this._then);

  final CopyDirSearching _self;
  final $Res Function(CopyDirSearching) _then;

/// Create a copy of CopyDirProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? directoryName = null,}) {
  return _then(CopyDirSearching(
null == directoryName ? _self.directoryName : directoryName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CopyDirCopying implements CopyDirProgress {
  const CopyDirCopying(this.filename, this.progress, this.max);


 final  String filename;
 final  int progress;
 final  int max;

/// Create a copy of CopyDirProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CopyDirCopyingCopyWith<CopyDirCopying> get copyWith => _$CopyDirCopyingCopyWithImpl<CopyDirCopying>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CopyDirCopying&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.max, max) || other.max == max));
}


@override
int get hashCode => Object.hash(runtimeType,filename,progress,max);

@override
String toString() {
  return 'CopyDirProgress.copying(filename: $filename, progress: $progress, max: $max)';
}


}

/// @nodoc
abstract mixin class $CopyDirCopyingCopyWith<$Res> implements $CopyDirProgressCopyWith<$Res> {
  factory $CopyDirCopyingCopyWith(CopyDirCopying value, $Res Function(CopyDirCopying) _then) = _$CopyDirCopyingCopyWithImpl;
@useResult
$Res call({
 String filename, int progress, int max
});




}
/// @nodoc
class _$CopyDirCopyingCopyWithImpl<$Res>
    implements $CopyDirCopyingCopyWith<$Res> {
  _$CopyDirCopyingCopyWithImpl(this._self, this._then);

  final CopyDirCopying _self;
  final $Res Function(CopyDirCopying) _then;

/// Create a copy of CopyDirProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filename = null,Object? progress = null,Object? max = null,}) {
  return _then(CopyDirCopying(
null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
