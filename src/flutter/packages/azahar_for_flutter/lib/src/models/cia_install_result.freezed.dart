// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cia_install_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CiaInstallResult {

 String get filename; bool get success;
/// Create a copy of CiaInstallResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CiaInstallResultCopyWith<CiaInstallResult> get copyWith => _$CiaInstallResultCopyWithImpl<CiaInstallResult>(this as CiaInstallResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CiaInstallResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CiaInstallResult&&(identical(other.filename, _this.filename) || other.filename == _this.filename)&&(identical(other.success, _this.success) || other.success == _this.success));
}


@override
int get hashCode {
  final _this = this as CiaInstallResult;
  return Object.hash(runtimeType,_this.filename,_this.success);
}

@override
String toString() {
  final _this = this as CiaInstallResult;
  return 'CiaInstallResult(filename: ${_this.filename}, success: ${_this.success})';
}


}

/// @nodoc
abstract mixin class $CiaInstallResultCopyWith<$Res>  {
  factory $CiaInstallResultCopyWith(CiaInstallResult value, $Res Function(CiaInstallResult) _then) = _$CiaInstallResultCopyWithImpl;
@useResult
$Res call({
 String filename, bool success
});




}
/// @nodoc
class _$CiaInstallResultCopyWithImpl<$Res>
    implements $CiaInstallResultCopyWith<$Res> {
  _$CiaInstallResultCopyWithImpl(this._self, this._then);

  final CiaInstallResult _self;
  final $Res Function(CiaInstallResult) _then;

/// Create a copy of CiaInstallResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filename = null,Object? success = null,}) {
  return _then(CiaInstallResult(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CiaInstallResult].
extension CiaInstallResultPatterns on CiaInstallResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CiaInstallResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CiaInstallResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CiaInstallResult value)  $default,){
final _that = this;
switch (_that) {
case _CiaInstallResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CiaInstallResult value)?  $default,){
final _that = this;
switch (_that) {
case _CiaInstallResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String filename,  bool success)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CiaInstallResult() when $default != null:
return $default(_that.filename,_that.success);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String filename,  bool success)  $default,) {final _that = this;
switch (_that) {
case _CiaInstallResult():
return $default(_that.filename,_that.success);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String filename,  bool success)?  $default,) {final _that = this;
switch (_that) {
case _CiaInstallResult() when $default != null:
return $default(_that.filename,_that.success);case _:
  return null;

}
}

}

/// @nodoc


class _CiaInstallResult implements CiaInstallResult {
  const _CiaInstallResult({required this.filename, required this.success});
  

@override final  String filename;
@override final  bool success;

/// Create a copy of CiaInstallResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CiaInstallResultCopyWith<_CiaInstallResult> get copyWith => __$CiaInstallResultCopyWithImpl<_CiaInstallResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CiaInstallResult&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.success, success) || other.success == success));
}


@override
int get hashCode {
    return Object.hash(runtimeType,filename,success);
}

@override
String toString() {
    return 'CiaInstallResult(filename: $filename, success: $success)';
}


}

/// @nodoc
abstract mixin class _$CiaInstallResultCopyWith<$Res> implements $CiaInstallResultCopyWith<$Res> {
  factory _$CiaInstallResultCopyWith(_CiaInstallResult value, $Res Function(_CiaInstallResult) _then) = __$CiaInstallResultCopyWithImpl;
@override @useResult
$Res call({
 String filename, bool success
});




}
/// @nodoc
class __$CiaInstallResultCopyWithImpl<$Res>
    implements _$CiaInstallResultCopyWith<$Res> {
  __$CiaInstallResultCopyWithImpl(this._self, this._then);

  final _CiaInstallResult _self;
  final $Res Function(_CiaInstallResult) _then;

/// Create a copy of CiaInstallResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filename = null,Object? success = null,}) {
  return _then(_CiaInstallResult(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
