// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionEvent {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SessionEvent()';
}


}

/// @nodoc
class $SessionEventCopyWith<$Res>  {
$SessionEventCopyWith(SessionEvent _, $Res Function(SessionEvent) __);
}


/// Adds pattern-matching-related methods to [SessionEvent].
extension SessionEventPatterns on SessionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SessionEvent_ShaderProgress value)?  shaderProgress,TResult Function( SessionEvent_Texture value)?  texture,TResult Function( SessionEvent_StateChanged value)?  stateChanged,TResult Function( SessionEvent_Error value)?  error,TResult Function( SessionEvent_ShutdownRequested value)?  shutdownRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SessionEvent_ShaderProgress() when shaderProgress != null:
return shaderProgress(_that);case SessionEvent_Texture() when texture != null:
return texture(_that);case SessionEvent_StateChanged() when stateChanged != null:
return stateChanged(_that);case SessionEvent_Error() when error != null:
return error(_that);case SessionEvent_ShutdownRequested() when shutdownRequested != null:
return shutdownRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SessionEvent_ShaderProgress value)  shaderProgress,required TResult Function( SessionEvent_Texture value)  texture,required TResult Function( SessionEvent_StateChanged value)  stateChanged,required TResult Function( SessionEvent_Error value)  error,required TResult Function( SessionEvent_ShutdownRequested value)  shutdownRequested,}){
final _that = this;
switch (_that) {
case SessionEvent_ShaderProgress():
return shaderProgress(_that);case SessionEvent_Texture():
return texture(_that);case SessionEvent_StateChanged():
return stateChanged(_that);case SessionEvent_Error():
return error(_that);case SessionEvent_ShutdownRequested():
return shutdownRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SessionEvent_ShaderProgress value)?  shaderProgress,TResult? Function( SessionEvent_Texture value)?  texture,TResult? Function( SessionEvent_StateChanged value)?  stateChanged,TResult? Function( SessionEvent_Error value)?  error,TResult? Function( SessionEvent_ShutdownRequested value)?  shutdownRequested,}){
final _that = this;
switch (_that) {
case SessionEvent_ShaderProgress() when shaderProgress != null:
return shaderProgress(_that);case SessionEvent_Texture() when texture != null:
return texture(_that);case SessionEvent_StateChanged() when stateChanged != null:
return stateChanged(_that);case SessionEvent_Error() when error != null:
return error(_that);case SessionEvent_ShutdownRequested() when shutdownRequested != null:
return shutdownRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ShaderStage stage,  BigInt progress,  BigInt max)?  shaderProgress,TResult Function( PlatformInt64 textureId,  bool secondary)?  texture,TResult Function( SessionState state)?  stateChanged,TResult Function( String message)?  error,TResult Function()?  shutdownRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SessionEvent_ShaderProgress() when shaderProgress != null:
return shaderProgress(_that.stage,_that.progress,_that.max);case SessionEvent_Texture() when texture != null:
return texture(_that.textureId,_that.secondary);case SessionEvent_StateChanged() when stateChanged != null:
return stateChanged(_that.state);case SessionEvent_Error() when error != null:
return error(_that.message);case SessionEvent_ShutdownRequested() when shutdownRequested != null:
return shutdownRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ShaderStage stage,  BigInt progress,  BigInt max)  shaderProgress,required TResult Function( PlatformInt64 textureId,  bool secondary)  texture,required TResult Function( SessionState state)  stateChanged,required TResult Function( String message)  error,required TResult Function()  shutdownRequested,}) {final _that = this;
switch (_that) {
case SessionEvent_ShaderProgress():
return shaderProgress(_that.stage,_that.progress,_that.max);case SessionEvent_Texture():
return texture(_that.textureId,_that.secondary);case SessionEvent_StateChanged():
return stateChanged(_that.state);case SessionEvent_Error():
return error(_that.message);case SessionEvent_ShutdownRequested():
return shutdownRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ShaderStage stage,  BigInt progress,  BigInt max)?  shaderProgress,TResult? Function( PlatformInt64 textureId,  bool secondary)?  texture,TResult? Function( SessionState state)?  stateChanged,TResult? Function( String message)?  error,TResult? Function()?  shutdownRequested,}) {final _that = this;
switch (_that) {
case SessionEvent_ShaderProgress() when shaderProgress != null:
return shaderProgress(_that.stage,_that.progress,_that.max);case SessionEvent_Texture() when texture != null:
return texture(_that.textureId,_that.secondary);case SessionEvent_StateChanged() when stateChanged != null:
return stateChanged(_that.state);case SessionEvent_Error() when error != null:
return error(_that.message);case SessionEvent_ShutdownRequested() when shutdownRequested != null:
return shutdownRequested();case _:
  return null;

}
}

}

/// @nodoc


class SessionEvent_ShaderProgress extends SessionEvent {
  const SessionEvent_ShaderProgress({required this.stage, required this.progress, required this.max}): super._();
  

 final  ShaderStage stage;
 final  BigInt progress;
 final  BigInt max;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionEvent_ShaderProgressCopyWith<SessionEvent_ShaderProgress> get copyWith => _$SessionEvent_ShaderProgressCopyWithImpl<SessionEvent_ShaderProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEvent_ShaderProgress&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.max, max) || other.max == max));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stage,progress,max);
}

@override
String toString() {
    return 'SessionEvent.shaderProgress(stage: $stage, progress: $progress, max: $max)';
}


}

/// @nodoc
abstract mixin class $SessionEvent_ShaderProgressCopyWith<$Res> implements $SessionEventCopyWith<$Res> {
  factory $SessionEvent_ShaderProgressCopyWith(SessionEvent_ShaderProgress value, $Res Function(SessionEvent_ShaderProgress) _then) = _$SessionEvent_ShaderProgressCopyWithImpl;
@useResult
$Res call({
 ShaderStage stage, BigInt progress, BigInt max
});




}
/// @nodoc
class _$SessionEvent_ShaderProgressCopyWithImpl<$Res>
    implements $SessionEvent_ShaderProgressCopyWith<$Res> {
  _$SessionEvent_ShaderProgressCopyWithImpl(this._self, this._then);

  final SessionEvent_ShaderProgress _self;
  final $Res Function(SessionEvent_ShaderProgress) _then;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? progress = null,Object? max = null,}) {
  return _then(SessionEvent_ShaderProgress(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as ShaderStage,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as BigInt,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as BigInt,
  ));
}


}

/// @nodoc


class SessionEvent_Texture extends SessionEvent {
  const SessionEvent_Texture({required this.textureId, required this.secondary}): super._();
  

 final  PlatformInt64 textureId;
 final  bool secondary;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionEvent_TextureCopyWith<SessionEvent_Texture> get copyWith => _$SessionEvent_TextureCopyWithImpl<SessionEvent_Texture>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEvent_Texture&&(identical(other.textureId, textureId) || other.textureId == textureId)&&(identical(other.secondary, secondary) || other.secondary == secondary));
}


@override
int get hashCode {
    return Object.hash(runtimeType,textureId,secondary);
}

@override
String toString() {
    return 'SessionEvent.texture(textureId: $textureId, secondary: $secondary)';
}


}

/// @nodoc
abstract mixin class $SessionEvent_TextureCopyWith<$Res> implements $SessionEventCopyWith<$Res> {
  factory $SessionEvent_TextureCopyWith(SessionEvent_Texture value, $Res Function(SessionEvent_Texture) _then) = _$SessionEvent_TextureCopyWithImpl;
@useResult
$Res call({
 PlatformInt64 textureId, bool secondary
});




}
/// @nodoc
class _$SessionEvent_TextureCopyWithImpl<$Res>
    implements $SessionEvent_TextureCopyWith<$Res> {
  _$SessionEvent_TextureCopyWithImpl(this._self, this._then);

  final SessionEvent_Texture _self;
  final $Res Function(SessionEvent_Texture) _then;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? textureId = null,Object? secondary = null,}) {
  return _then(SessionEvent_Texture(
textureId: null == textureId ? _self.textureId : textureId // ignore: cast_nullable_to_non_nullable
as PlatformInt64,secondary: null == secondary ? _self.secondary : secondary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SessionEvent_StateChanged extends SessionEvent {
  const SessionEvent_StateChanged({required this.state}): super._();
  

 final  SessionState state;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionEvent_StateChangedCopyWith<SessionEvent_StateChanged> get copyWith => _$SessionEvent_StateChangedCopyWithImpl<SessionEvent_StateChanged>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEvent_StateChanged&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode {
    return Object.hash(runtimeType,state);
}

@override
String toString() {
    return 'SessionEvent.stateChanged(state: $state)';
}


}

/// @nodoc
abstract mixin class $SessionEvent_StateChangedCopyWith<$Res> implements $SessionEventCopyWith<$Res> {
  factory $SessionEvent_StateChangedCopyWith(SessionEvent_StateChanged value, $Res Function(SessionEvent_StateChanged) _then) = _$SessionEvent_StateChangedCopyWithImpl;
@useResult
$Res call({
 SessionState state
});




}
/// @nodoc
class _$SessionEvent_StateChangedCopyWithImpl<$Res>
    implements $SessionEvent_StateChangedCopyWith<$Res> {
  _$SessionEvent_StateChangedCopyWithImpl(this._self, this._then);

  final SessionEvent_StateChanged _self;
  final $Res Function(SessionEvent_StateChanged) _then;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? state = null,}) {
  return _then(SessionEvent_StateChanged(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as SessionState,
  ));
}


}

/// @nodoc


class SessionEvent_Error extends SessionEvent {
  const SessionEvent_Error({required this.message}): super._();
  

 final  String message;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionEvent_ErrorCopyWith<SessionEvent_Error> get copyWith => _$SessionEvent_ErrorCopyWithImpl<SessionEvent_Error>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEvent_Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'SessionEvent.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SessionEvent_ErrorCopyWith<$Res> implements $SessionEventCopyWith<$Res> {
  factory $SessionEvent_ErrorCopyWith(SessionEvent_Error value, $Res Function(SessionEvent_Error) _then) = _$SessionEvent_ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SessionEvent_ErrorCopyWithImpl<$Res>
    implements $SessionEvent_ErrorCopyWith<$Res> {
  _$SessionEvent_ErrorCopyWithImpl(this._self, this._then);

  final SessionEvent_Error _self;
  final $Res Function(SessionEvent_Error) _then;

/// Create a copy of SessionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SessionEvent_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SessionEvent_ShutdownRequested extends SessionEvent {
  const SessionEvent_ShutdownRequested(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEvent_ShutdownRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SessionEvent.shutdownRequested()';
}


}




// dart format on
