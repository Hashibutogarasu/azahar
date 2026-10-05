// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'key_binding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KeyBinding {

 String get profileId; String get actionId; GamepadKeyCombo get combo;
/// Create a copy of KeyBinding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyBindingCopyWith<KeyBinding> get copyWith => _$KeyBindingCopyWithImpl<KeyBinding>(this as KeyBinding, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as KeyBinding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyBinding&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.actionId, _this.actionId) || other.actionId == _this.actionId)&&(identical(other.combo, _this.combo) || other.combo == _this.combo));
}


@override
int get hashCode {
  final _this = this as KeyBinding;
  return Object.hash(runtimeType,_this.profileId,_this.actionId,_this.combo);
}

@override
String toString() {
  final _this = this as KeyBinding;
  return 'KeyBinding(profileId: ${_this.profileId}, actionId: ${_this.actionId}, combo: ${_this.combo})';
}


}

/// @nodoc
abstract mixin class $KeyBindingCopyWith<$Res>  {
  factory $KeyBindingCopyWith(KeyBinding value, $Res Function(KeyBinding) _then) = _$KeyBindingCopyWithImpl;
@useResult
$Res call({
 String profileId, String actionId, GamepadKeyCombo combo
});




}
/// @nodoc
class _$KeyBindingCopyWithImpl<$Res>
    implements $KeyBindingCopyWith<$Res> {
  _$KeyBindingCopyWithImpl(this._self, this._then);

  final KeyBinding _self;
  final $Res Function(KeyBinding) _then;

/// Create a copy of KeyBinding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profileId = null,Object? actionId = null,Object? combo = null,}) {
  return _then(KeyBinding(
profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,actionId: null == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as String,combo: null == combo ? _self.combo : combo // ignore: cast_nullable_to_non_nullable
as GamepadKeyCombo,
  ));
}

}


/// Adds pattern-matching-related methods to [KeyBinding].
extension KeyBindingPatterns on KeyBinding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KeyBinding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KeyBinding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KeyBinding value)  $default,){
final _that = this;
switch (_that) {
case _KeyBinding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KeyBinding value)?  $default,){
final _that = this;
switch (_that) {
case _KeyBinding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String profileId,  String actionId,  GamepadKeyCombo combo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KeyBinding() when $default != null:
return $default(_that.profileId,_that.actionId,_that.combo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String profileId,  String actionId,  GamepadKeyCombo combo)  $default,) {final _that = this;
switch (_that) {
case _KeyBinding():
return $default(_that.profileId,_that.actionId,_that.combo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String profileId,  String actionId,  GamepadKeyCombo combo)?  $default,) {final _that = this;
switch (_that) {
case _KeyBinding() when $default != null:
return $default(_that.profileId,_that.actionId,_that.combo);case _:
  return null;

}
}

}

/// @nodoc


class _KeyBinding implements KeyBinding {
  const _KeyBinding({required this.profileId, required this.actionId, required this.combo});
  

@override final  String profileId;
@override final  String actionId;
@override final  GamepadKeyCombo combo;

/// Create a copy of KeyBinding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KeyBindingCopyWith<_KeyBinding> get copyWith => __$KeyBindingCopyWithImpl<_KeyBinding>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _KeyBinding&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.combo, combo) || other.combo == combo));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profileId,actionId,combo);
}

@override
String toString() {
    return 'KeyBinding(profileId: $profileId, actionId: $actionId, combo: $combo)';
}


}

/// @nodoc
abstract mixin class _$KeyBindingCopyWith<$Res> implements $KeyBindingCopyWith<$Res> {
  factory _$KeyBindingCopyWith(_KeyBinding value, $Res Function(_KeyBinding) _then) = __$KeyBindingCopyWithImpl;
@override @useResult
$Res call({
 String profileId, String actionId, GamepadKeyCombo combo
});




}
/// @nodoc
class __$KeyBindingCopyWithImpl<$Res>
    implements _$KeyBindingCopyWith<$Res> {
  __$KeyBindingCopyWithImpl(this._self, this._then);

  final _KeyBinding _self;
  final $Res Function(_KeyBinding) _then;

/// Create a copy of KeyBinding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profileId = null,Object? actionId = null,Object? combo = null,}) {
  return _then(_KeyBinding(
profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,actionId: null == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as String,combo: null == combo ? _self.combo : combo // ignore: cast_nullable_to_non_nullable
as GamepadKeyCombo,
  ));
}


}

// dart format on
