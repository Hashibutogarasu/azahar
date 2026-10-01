// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AzaharError {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AzaharError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AzaharError()';
}


}

/// @nodoc
class $AzaharErrorCopyWith<$Res>  {
$AzaharErrorCopyWith(AzaharError _, $Res Function(AzaharError) __);
}


/// Adds pattern-matching-related methods to [AzaharError].
extension AzaharErrorPatterns on AzaharError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AzaharError_SessionActive value)?  sessionActive,TResult Function( AzaharError_NoSession value)?  noSession,TResult Function( AzaharError_InvalidPath value)?  invalidPath,TResult Function( AzaharError_CreateFailed value)?  createFailed,TResult Function( AzaharError_InvalidState value)?  invalidState,TResult Function( AzaharError_Core value)?  core,TResult Function( AzaharError_InvalidAddress value)?  invalidAddress,TResult Function( AzaharError_Audio value)?  audio,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AzaharError_SessionActive() when sessionActive != null:
return sessionActive(_that);case AzaharError_NoSession() when noSession != null:
return noSession(_that);case AzaharError_InvalidPath() when invalidPath != null:
return invalidPath(_that);case AzaharError_CreateFailed() when createFailed != null:
return createFailed(_that);case AzaharError_InvalidState() when invalidState != null:
return invalidState(_that);case AzaharError_Core() when core != null:
return core(_that);case AzaharError_InvalidAddress() when invalidAddress != null:
return invalidAddress(_that);case AzaharError_Audio() when audio != null:
return audio(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AzaharError_SessionActive value)  sessionActive,required TResult Function( AzaharError_NoSession value)  noSession,required TResult Function( AzaharError_InvalidPath value)  invalidPath,required TResult Function( AzaharError_CreateFailed value)  createFailed,required TResult Function( AzaharError_InvalidState value)  invalidState,required TResult Function( AzaharError_Core value)  core,required TResult Function( AzaharError_InvalidAddress value)  invalidAddress,required TResult Function( AzaharError_Audio value)  audio,}){
final _that = this;
switch (_that) {
case AzaharError_SessionActive():
return sessionActive(_that);case AzaharError_NoSession():
return noSession(_that);case AzaharError_InvalidPath():
return invalidPath(_that);case AzaharError_CreateFailed():
return createFailed(_that);case AzaharError_InvalidState():
return invalidState(_that);case AzaharError_Core():
return core(_that);case AzaharError_InvalidAddress():
return invalidAddress(_that);case AzaharError_Audio():
return audio(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AzaharError_SessionActive value)?  sessionActive,TResult? Function( AzaharError_NoSession value)?  noSession,TResult? Function( AzaharError_InvalidPath value)?  invalidPath,TResult? Function( AzaharError_CreateFailed value)?  createFailed,TResult? Function( AzaharError_InvalidState value)?  invalidState,TResult? Function( AzaharError_Core value)?  core,TResult? Function( AzaharError_InvalidAddress value)?  invalidAddress,TResult? Function( AzaharError_Audio value)?  audio,}){
final _that = this;
switch (_that) {
case AzaharError_SessionActive() when sessionActive != null:
return sessionActive(_that);case AzaharError_NoSession() when noSession != null:
return noSession(_that);case AzaharError_InvalidPath() when invalidPath != null:
return invalidPath(_that);case AzaharError_CreateFailed() when createFailed != null:
return createFailed(_that);case AzaharError_InvalidState() when invalidState != null:
return invalidState(_that);case AzaharError_Core() when core != null:
return core(_that);case AzaharError_InvalidAddress() when invalidAddress != null:
return invalidAddress(_that);case AzaharError_Audio() when audio != null:
return audio(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  sessionActive,TResult Function()?  noSession,TResult Function()?  invalidPath,TResult Function()?  createFailed,TResult Function()?  invalidState,TResult Function( int field0)?  core,TResult Function( int address,  int len)?  invalidAddress,TResult Function( String field0)?  audio,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AzaharError_SessionActive() when sessionActive != null:
return sessionActive();case AzaharError_NoSession() when noSession != null:
return noSession();case AzaharError_InvalidPath() when invalidPath != null:
return invalidPath();case AzaharError_CreateFailed() when createFailed != null:
return createFailed();case AzaharError_InvalidState() when invalidState != null:
return invalidState();case AzaharError_Core() when core != null:
return core(_that.field0);case AzaharError_InvalidAddress() when invalidAddress != null:
return invalidAddress(_that.address,_that.len);case AzaharError_Audio() when audio != null:
return audio(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  sessionActive,required TResult Function()  noSession,required TResult Function()  invalidPath,required TResult Function()  createFailed,required TResult Function()  invalidState,required TResult Function( int field0)  core,required TResult Function( int address,  int len)  invalidAddress,required TResult Function( String field0)  audio,}) {final _that = this;
switch (_that) {
case AzaharError_SessionActive():
return sessionActive();case AzaharError_NoSession():
return noSession();case AzaharError_InvalidPath():
return invalidPath();case AzaharError_CreateFailed():
return createFailed();case AzaharError_InvalidState():
return invalidState();case AzaharError_Core():
return core(_that.field0);case AzaharError_InvalidAddress():
return invalidAddress(_that.address,_that.len);case AzaharError_Audio():
return audio(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  sessionActive,TResult? Function()?  noSession,TResult? Function()?  invalidPath,TResult? Function()?  createFailed,TResult? Function()?  invalidState,TResult? Function( int field0)?  core,TResult? Function( int address,  int len)?  invalidAddress,TResult? Function( String field0)?  audio,}) {final _that = this;
switch (_that) {
case AzaharError_SessionActive() when sessionActive != null:
return sessionActive();case AzaharError_NoSession() when noSession != null:
return noSession();case AzaharError_InvalidPath() when invalidPath != null:
return invalidPath();case AzaharError_CreateFailed() when createFailed != null:
return createFailed();case AzaharError_InvalidState() when invalidState != null:
return invalidState();case AzaharError_Core() when core != null:
return core(_that.field0);case AzaharError_InvalidAddress() when invalidAddress != null:
return invalidAddress(_that.address,_that.len);case AzaharError_Audio() when audio != null:
return audio(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class AzaharError_SessionActive extends AzaharError {
  const AzaharError_SessionActive(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AzaharError_SessionActive);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AzaharError.sessionActive()';
}


}




/// @nodoc


class AzaharError_NoSession extends AzaharError {
  const AzaharError_NoSession(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AzaharError_NoSession);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AzaharError.noSession()';
}


}




/// @nodoc


class AzaharError_InvalidPath extends AzaharError {
  const AzaharError_InvalidPath(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AzaharError_InvalidPath);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AzaharError.invalidPath()';
}


}




/// @nodoc


class AzaharError_CreateFailed extends AzaharError {
  const AzaharError_CreateFailed(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AzaharError_CreateFailed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AzaharError.createFailed()';
}


}




/// @nodoc


class AzaharError_InvalidState extends AzaharError {
  const AzaharError_InvalidState(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AzaharError_InvalidState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AzaharError.invalidState()';
}


}




/// @nodoc


class AzaharError_Core extends AzaharError {
  const AzaharError_Core(this.field0): super._();
  

 final  int field0;

/// Create a copy of AzaharError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AzaharError_CoreCopyWith<AzaharError_Core> get copyWith => _$AzaharError_CoreCopyWithImpl<AzaharError_Core>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AzaharError_Core&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'AzaharError.core(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $AzaharError_CoreCopyWith<$Res> implements $AzaharErrorCopyWith<$Res> {
  factory $AzaharError_CoreCopyWith(AzaharError_Core value, $Res Function(AzaharError_Core) _then) = _$AzaharError_CoreCopyWithImpl;
@useResult
$Res call({
 int field0
});




}
/// @nodoc
class _$AzaharError_CoreCopyWithImpl<$Res>
    implements $AzaharError_CoreCopyWith<$Res> {
  _$AzaharError_CoreCopyWithImpl(this._self, this._then);

  final AzaharError_Core _self;
  final $Res Function(AzaharError_Core) _then;

/// Create a copy of AzaharError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(AzaharError_Core(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class AzaharError_InvalidAddress extends AzaharError {
  const AzaharError_InvalidAddress({required this.address, required this.len}): super._();
  

 final  int address;
 final  int len;

/// Create a copy of AzaharError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AzaharError_InvalidAddressCopyWith<AzaharError_InvalidAddress> get copyWith => _$AzaharError_InvalidAddressCopyWithImpl<AzaharError_InvalidAddress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AzaharError_InvalidAddress&&(identical(other.address, address) || other.address == address)&&(identical(other.len, len) || other.len == len));
}


@override
int get hashCode {
    return Object.hash(runtimeType,address,len);
}

@override
String toString() {
    return 'AzaharError.invalidAddress(address: $address, len: $len)';
}


}

/// @nodoc
abstract mixin class $AzaharError_InvalidAddressCopyWith<$Res> implements $AzaharErrorCopyWith<$Res> {
  factory $AzaharError_InvalidAddressCopyWith(AzaharError_InvalidAddress value, $Res Function(AzaharError_InvalidAddress) _then) = _$AzaharError_InvalidAddressCopyWithImpl;
@useResult
$Res call({
 int address, int len
});




}
/// @nodoc
class _$AzaharError_InvalidAddressCopyWithImpl<$Res>
    implements $AzaharError_InvalidAddressCopyWith<$Res> {
  _$AzaharError_InvalidAddressCopyWithImpl(this._self, this._then);

  final AzaharError_InvalidAddress _self;
  final $Res Function(AzaharError_InvalidAddress) _then;

/// Create a copy of AzaharError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? address = null,Object? len = null,}) {
  return _then(AzaharError_InvalidAddress(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as int,len: null == len ? _self.len : len // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class AzaharError_Audio extends AzaharError {
  const AzaharError_Audio(this.field0): super._();
  

 final  String field0;

/// Create a copy of AzaharError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AzaharError_AudioCopyWith<AzaharError_Audio> get copyWith => _$AzaharError_AudioCopyWithImpl<AzaharError_Audio>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AzaharError_Audio&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'AzaharError.audio(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $AzaharError_AudioCopyWith<$Res> implements $AzaharErrorCopyWith<$Res> {
  factory $AzaharError_AudioCopyWith(AzaharError_Audio value, $Res Function(AzaharError_Audio) _then) = _$AzaharError_AudioCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$AzaharError_AudioCopyWithImpl<$Res>
    implements $AzaharError_AudioCopyWith<$Res> {
  _$AzaharError_AudioCopyWithImpl(this._self, this._then);

  final AzaharError_Audio _self;
  final $Res Function(AzaharError_Audio) _then;

/// Create a copy of AzaharError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(AzaharError_Audio(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
