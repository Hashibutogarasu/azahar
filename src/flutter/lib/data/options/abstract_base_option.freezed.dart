// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'abstract_base_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActionOption {

 String get titleKey; String? get descriptionKey; IconData get icon; Future<void> Function(BuildContext context, WidgetRef ref) get onTap; bool get destructive;
/// Create a copy of ActionOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionOptionCopyWith<ActionOption> get copyWith => _$ActionOptionCopyWithImpl<ActionOption>(this as ActionOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap)&&(identical(other.destructive, destructive) || other.destructive == destructive));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,onTap,destructive);

@override
String toString() {
  return 'ActionOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, onTap: $onTap, destructive: $destructive)';
}


}

/// @nodoc
abstract mixin class $ActionOptionCopyWith<$Res>  {
  factory $ActionOptionCopyWith(ActionOption value, $Res Function(ActionOption) _then) = _$ActionOptionCopyWithImpl;
@useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, Future<void> Function(BuildContext context, WidgetRef ref) onTap, bool destructive
});




}
/// @nodoc
class _$ActionOptionCopyWithImpl<$Res>
    implements $ActionOptionCopyWith<$Res> {
  _$ActionOptionCopyWithImpl(this._self, this._then);

  final ActionOption _self;
  final $Res Function(ActionOption) _then;

/// Create a copy of ActionOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? onTap = null,Object? destructive = null,}) {
  return _then(ActionOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as Future<void> Function(BuildContext context, WidgetRef ref),destructive: null == destructive ? _self.destructive : destructive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionOption].
extension ActionOptionPatterns on ActionOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionOption value)  $default,){
final _that = this;
switch (_that) {
case _ActionOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionOption value)?  $default,){
final _that = this;
switch (_that) {
case _ActionOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  Future<void> Function(BuildContext context, WidgetRef ref) onTap,  bool destructive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.onTap,_that.destructive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  Future<void> Function(BuildContext context, WidgetRef ref) onTap,  bool destructive)  $default,) {final _that = this;
switch (_that) {
case _ActionOption():
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.onTap,_that.destructive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleKey,  String? descriptionKey,  IconData icon,  Future<void> Function(BuildContext context, WidgetRef ref) onTap,  bool destructive)?  $default,) {final _that = this;
switch (_that) {
case _ActionOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.onTap,_that.destructive);case _:
  return null;

}
}

}

/// @nodoc


class _ActionOption extends ActionOption {
  const _ActionOption({required this.titleKey, this.descriptionKey, required this.icon, required this.onTap, this.destructive = false}): super._();
  

@override final  String titleKey;
@override final  String? descriptionKey;
@override final  IconData icon;
@override final  Future<void> Function(BuildContext context, WidgetRef ref) onTap;
@override@JsonKey() final  bool destructive;

/// Create a copy of ActionOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionOptionCopyWith<_ActionOption> get copyWith => __$ActionOptionCopyWithImpl<_ActionOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.onTap, onTap) || other.onTap == onTap)&&(identical(other.destructive, destructive) || other.destructive == destructive));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,onTap,destructive);

@override
String toString() {
  return 'ActionOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, onTap: $onTap, destructive: $destructive)';
}


}

/// @nodoc
abstract mixin class _$ActionOptionCopyWith<$Res> implements $ActionOptionCopyWith<$Res> {
  factory _$ActionOptionCopyWith(_ActionOption value, $Res Function(_ActionOption) _then) = __$ActionOptionCopyWithImpl;
@override @useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, Future<void> Function(BuildContext context, WidgetRef ref) onTap, bool destructive
});




}
/// @nodoc
class __$ActionOptionCopyWithImpl<$Res>
    implements _$ActionOptionCopyWith<$Res> {
  __$ActionOptionCopyWithImpl(this._self, this._then);

  final _ActionOption _self;
  final $Res Function(_ActionOption) _then;

/// Create a copy of ActionOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? onTap = null,Object? destructive = null,}) {
  return _then(_ActionOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as Future<void> Function(BuildContext context, WidgetRef ref),destructive: null == destructive ? _self.destructive : destructive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$BoolOption {

 String get titleKey; String? get descriptionKey; IconData get icon; OptionValue<bool> get value;
/// Create a copy of BoolOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoolOptionCopyWith<BoolOption> get copyWith => _$BoolOptionCopyWithImpl<BoolOption>(this as BoolOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoolOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value);

@override
String toString() {
  return 'BoolOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value)';
}


}

/// @nodoc
abstract mixin class $BoolOptionCopyWith<$Res>  {
  factory $BoolOptionCopyWith(BoolOption value, $Res Function(BoolOption) _then) = _$BoolOptionCopyWithImpl;
@useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<bool> value
});




}
/// @nodoc
class _$BoolOptionCopyWithImpl<$Res>
    implements $BoolOptionCopyWith<$Res> {
  _$BoolOptionCopyWithImpl(this._self, this._then);

  final BoolOption _self;
  final $Res Function(BoolOption) _then;

/// Create a copy of BoolOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,}) {
  return _then(BoolOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [BoolOption].
extension BoolOptionPatterns on BoolOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoolOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoolOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoolOption value)  $default,){
final _that = this;
switch (_that) {
case _BoolOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoolOption value)?  $default,){
final _that = this;
switch (_that) {
case _BoolOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<bool> value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoolOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<bool> value)  $default,) {final _that = this;
switch (_that) {
case _BoolOption():
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<bool> value)?  $default,) {final _that = this;
switch (_that) {
case _BoolOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _BoolOption extends BoolOption {
  const _BoolOption({required this.titleKey, this.descriptionKey, required this.icon, required this.value}): super._();
  

@override final  String titleKey;
@override final  String? descriptionKey;
@override final  IconData icon;
@override final  OptionValue<bool> value;

/// Create a copy of BoolOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoolOptionCopyWith<_BoolOption> get copyWith => __$BoolOptionCopyWithImpl<_BoolOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoolOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value);

@override
String toString() {
  return 'BoolOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value)';
}


}

/// @nodoc
abstract mixin class _$BoolOptionCopyWith<$Res> implements $BoolOptionCopyWith<$Res> {
  factory _$BoolOptionCopyWith(_BoolOption value, $Res Function(_BoolOption) _then) = __$BoolOptionCopyWithImpl;
@override @useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<bool> value
});




}
/// @nodoc
class __$BoolOptionCopyWithImpl<$Res>
    implements _$BoolOptionCopyWith<$Res> {
  __$BoolOptionCopyWithImpl(this._self, this._then);

  final _BoolOption _self;
  final $Res Function(_BoolOption) _then;

/// Create a copy of BoolOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,}) {
  return _then(_BoolOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<bool>,
  ));
}


}

/// @nodoc
mixin _$DateTimeOption {

 String get titleKey; String? get descriptionKey; IconData get icon; OptionValue<String> get value;
/// Create a copy of DateTimeOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateTimeOptionCopyWith<DateTimeOption> get copyWith => _$DateTimeOptionCopyWithImpl<DateTimeOption>(this as DateTimeOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateTimeOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value);

@override
String toString() {
  return 'DateTimeOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value)';
}


}

/// @nodoc
abstract mixin class $DateTimeOptionCopyWith<$Res>  {
  factory $DateTimeOptionCopyWith(DateTimeOption value, $Res Function(DateTimeOption) _then) = _$DateTimeOptionCopyWithImpl;
@useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<String> value
});




}
/// @nodoc
class _$DateTimeOptionCopyWithImpl<$Res>
    implements $DateTimeOptionCopyWith<$Res> {
  _$DateTimeOptionCopyWithImpl(this._self, this._then);

  final DateTimeOption _self;
  final $Res Function(DateTimeOption) _then;

/// Create a copy of DateTimeOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,}) {
  return _then(DateTimeOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DateTimeOption].
extension DateTimeOptionPatterns on DateTimeOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateTimeOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateTimeOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateTimeOption value)  $default,){
final _that = this;
switch (_that) {
case _DateTimeOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateTimeOption value)?  $default,){
final _that = this;
switch (_that) {
case _DateTimeOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<String> value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateTimeOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<String> value)  $default,) {final _that = this;
switch (_that) {
case _DateTimeOption():
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<String> value)?  $default,) {final _that = this;
switch (_that) {
case _DateTimeOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _DateTimeOption extends DateTimeOption {
  const _DateTimeOption({required this.titleKey, this.descriptionKey, required this.icon, required this.value}): super._();
  

@override final  String titleKey;
@override final  String? descriptionKey;
@override final  IconData icon;
@override final  OptionValue<String> value;

/// Create a copy of DateTimeOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateTimeOptionCopyWith<_DateTimeOption> get copyWith => __$DateTimeOptionCopyWithImpl<_DateTimeOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateTimeOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value);

@override
String toString() {
  return 'DateTimeOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value)';
}


}

/// @nodoc
abstract mixin class _$DateTimeOptionCopyWith<$Res> implements $DateTimeOptionCopyWith<$Res> {
  factory _$DateTimeOptionCopyWith(_DateTimeOption value, $Res Function(_DateTimeOption) _then) = __$DateTimeOptionCopyWithImpl;
@override @useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<String> value
});




}
/// @nodoc
class __$DateTimeOptionCopyWithImpl<$Res>
    implements _$DateTimeOptionCopyWith<$Res> {
  __$DateTimeOptionCopyWithImpl(this._self, this._then);

  final _DateTimeOption _self;
  final $Res Function(_DateTimeOption) _then;

/// Create a copy of DateTimeOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,}) {
  return _then(_DateTimeOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<String>,
  ));
}


}

/// @nodoc
mixin _$EnumChoice<T> {

 String get labelKey; T get value;
/// Create a copy of EnumChoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnumChoiceCopyWith<T, EnumChoice<T>> get copyWith => _$EnumChoiceCopyWithImpl<T, EnumChoice<T>>(this as EnumChoice<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnumChoice<T>&&(identical(other.labelKey, labelKey) || other.labelKey == labelKey)&&const DeepCollectionEquality().equals(other.value, value));
}


@override
int get hashCode => Object.hash(runtimeType,labelKey,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'EnumChoice<$T>(labelKey: $labelKey, value: $value)';
}


}

/// @nodoc
abstract mixin class $EnumChoiceCopyWith<T,$Res>  {
  factory $EnumChoiceCopyWith(EnumChoice<T> value, $Res Function(EnumChoice<T>) _then) = _$EnumChoiceCopyWithImpl;
@useResult
$Res call({
 String labelKey, T value
});




}
/// @nodoc
class _$EnumChoiceCopyWithImpl<T,$Res>
    implements $EnumChoiceCopyWith<T, $Res> {
  _$EnumChoiceCopyWithImpl(this._self, this._then);

  final EnumChoice<T> _self;
  final $Res Function(EnumChoice<T>) _then;

/// Create a copy of EnumChoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? labelKey = null,Object? value = freezed,}) {
  return _then(EnumChoice(
labelKey: null == labelKey ? _self.labelKey : labelKey // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as T,
  ));
}

}


/// Adds pattern-matching-related methods to [EnumChoice].
extension EnumChoicePatterns<T> on EnumChoice<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnumChoice<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnumChoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnumChoice<T> value)  $default,){
final _that = this;
switch (_that) {
case _EnumChoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnumChoice<T> value)?  $default,){
final _that = this;
switch (_that) {
case _EnumChoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String labelKey,  T value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnumChoice() when $default != null:
return $default(_that.labelKey,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String labelKey,  T value)  $default,) {final _that = this;
switch (_that) {
case _EnumChoice():
return $default(_that.labelKey,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String labelKey,  T value)?  $default,) {final _that = this;
switch (_that) {
case _EnumChoice() when $default != null:
return $default(_that.labelKey,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _EnumChoice<T> implements EnumChoice<T> {
  const _EnumChoice({required this.labelKey, required this.value});
  

@override final  String labelKey;
@override final  T value;

/// Create a copy of EnumChoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnumChoiceCopyWith<T, _EnumChoice<T>> get copyWith => __$EnumChoiceCopyWithImpl<T, _EnumChoice<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnumChoice<T>&&(identical(other.labelKey, labelKey) || other.labelKey == labelKey)&&const DeepCollectionEquality().equals(other.value, value));
}


@override
int get hashCode => Object.hash(runtimeType,labelKey,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'EnumChoice<$T>(labelKey: $labelKey, value: $value)';
}


}

/// @nodoc
abstract mixin class _$EnumChoiceCopyWith<T,$Res> implements $EnumChoiceCopyWith<T, $Res> {
  factory _$EnumChoiceCopyWith(_EnumChoice<T> value, $Res Function(_EnumChoice<T>) _then) = __$EnumChoiceCopyWithImpl;
@override @useResult
$Res call({
 String labelKey, T value
});




}
/// @nodoc
class __$EnumChoiceCopyWithImpl<T,$Res>
    implements _$EnumChoiceCopyWith<T, $Res> {
  __$EnumChoiceCopyWithImpl(this._self, this._then);

  final _EnumChoice<T> _self;
  final $Res Function(_EnumChoice<T>) _then;

/// Create a copy of EnumChoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? labelKey = null,Object? value = freezed,}) {
  return _then(_EnumChoice<T>(
labelKey: null == labelKey ? _self.labelKey : labelKey // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc
mixin _$EnumOption<T> {

 String get titleKey; String? get descriptionKey; IconData get icon; OptionValue<T> get value; List<EnumChoice<T>> get choices;
/// Create a copy of EnumOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnumOptionCopyWith<T, EnumOption<T>> get copyWith => _$EnumOptionCopyWithImpl<T, EnumOption<T>>(this as EnumOption<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnumOption<T>&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.choices, choices));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value,const DeepCollectionEquality().hash(choices));

@override
String toString() {
  return 'EnumOption<$T>(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value, choices: $choices)';
}


}

/// @nodoc
abstract mixin class $EnumOptionCopyWith<T,$Res>  {
  factory $EnumOptionCopyWith(EnumOption<T> value, $Res Function(EnumOption<T>) _then) = _$EnumOptionCopyWithImpl;
@useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<T> value, List<EnumChoice<T>> choices
});




}
/// @nodoc
class _$EnumOptionCopyWithImpl<T,$Res>
    implements $EnumOptionCopyWith<T, $Res> {
  _$EnumOptionCopyWithImpl(this._self, this._then);

  final EnumOption<T> _self;
  final $Res Function(EnumOption<T>) _then;

/// Create a copy of EnumOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,Object? choices = null,}) {
  return _then(EnumOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<T>,choices: null == choices ? _self.choices : choices // ignore: cast_nullable_to_non_nullable
as List<EnumChoice<T>>,
  ));
}

}


/// Adds pattern-matching-related methods to [EnumOption].
extension EnumOptionPatterns<T> on EnumOption<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnumOption<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnumOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnumOption<T> value)  $default,){
final _that = this;
switch (_that) {
case _EnumOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnumOption<T> value)?  $default,){
final _that = this;
switch (_that) {
case _EnumOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<T> value,  List<EnumChoice<T>> choices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnumOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.choices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<T> value,  List<EnumChoice<T>> choices)  $default,) {final _that = this;
switch (_that) {
case _EnumOption():
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.choices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<T> value,  List<EnumChoice<T>> choices)?  $default,) {final _that = this;
switch (_that) {
case _EnumOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.choices);case _:
  return null;

}
}

}

/// @nodoc


class _EnumOption<T> extends EnumOption<T> {
  const _EnumOption({required this.titleKey, this.descriptionKey, required this.icon, required this.value, required  List<EnumChoice<T>> choices}): _choices = choices,super._();
  

@override final  String titleKey;
@override final  String? descriptionKey;
@override final  IconData icon;
@override final  OptionValue<T> value;
 final  List<EnumChoice<T>> _choices;
@override List<EnumChoice<T>> get choices {
  if (_choices is EqualUnmodifiableListView) return _choices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_choices);
}


/// Create a copy of EnumOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnumOptionCopyWith<T, _EnumOption<T>> get copyWith => __$EnumOptionCopyWithImpl<T, _EnumOption<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnumOption<T>&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other._choices, _choices));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value,const DeepCollectionEquality().hash(_choices));

@override
String toString() {
  return 'EnumOption<$T>(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value, choices: $choices)';
}


}

/// @nodoc
abstract mixin class _$EnumOptionCopyWith<T,$Res> implements $EnumOptionCopyWith<T, $Res> {
  factory _$EnumOptionCopyWith(_EnumOption<T> value, $Res Function(_EnumOption<T>) _then) = __$EnumOptionCopyWithImpl;
@override @useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<T> value, List<EnumChoice<T>> choices
});




}
/// @nodoc
class __$EnumOptionCopyWithImpl<T,$Res>
    implements _$EnumOptionCopyWith<T, $Res> {
  __$EnumOptionCopyWithImpl(this._self, this._then);

  final _EnumOption<T> _self;
  final $Res Function(_EnumOption<T>) _then;

/// Create a copy of EnumOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,Object? choices = null,}) {
  return _then(_EnumOption<T>(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<T>,choices: null == choices ? _self._choices : choices // ignore: cast_nullable_to_non_nullable
as List<EnumChoice<T>>,
  ));
}


}

/// @nodoc
mixin _$FloatOption {

 String get titleKey; String? get descriptionKey; IconData get icon; OptionValue<double> get value; double get min; double get max; double get defaultValue; String get units;
/// Create a copy of FloatOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloatOptionCopyWith<FloatOption> get copyWith => _$FloatOptionCopyWithImpl<FloatOption>(this as FloatOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloatOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.units, units) || other.units == units));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value,min,max,defaultValue,units);

@override
String toString() {
  return 'FloatOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value, min: $min, max: $max, defaultValue: $defaultValue, units: $units)';
}


}

/// @nodoc
abstract mixin class $FloatOptionCopyWith<$Res>  {
  factory $FloatOptionCopyWith(FloatOption value, $Res Function(FloatOption) _then) = _$FloatOptionCopyWithImpl;
@useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<double> value, double min, double max, double defaultValue, String units
});




}
/// @nodoc
class _$FloatOptionCopyWithImpl<$Res>
    implements $FloatOptionCopyWith<$Res> {
  _$FloatOptionCopyWithImpl(this._self, this._then);

  final FloatOption _self;
  final $Res Function(FloatOption) _then;

/// Create a copy of FloatOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,Object? min = null,Object? max = null,Object? defaultValue = null,Object? units = null,}) {
  return _then(FloatOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<double>,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as double,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FloatOption].
extension FloatOptionPatterns on FloatOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloatOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloatOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloatOption value)  $default,){
final _that = this;
switch (_that) {
case _FloatOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloatOption value)?  $default,){
final _that = this;
switch (_that) {
case _FloatOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<double> value,  double min,  double max,  double defaultValue,  String units)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloatOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.min,_that.max,_that.defaultValue,_that.units);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<double> value,  double min,  double max,  double defaultValue,  String units)  $default,) {final _that = this;
switch (_that) {
case _FloatOption():
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.min,_that.max,_that.defaultValue,_that.units);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<double> value,  double min,  double max,  double defaultValue,  String units)?  $default,) {final _that = this;
switch (_that) {
case _FloatOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.min,_that.max,_that.defaultValue,_that.units);case _:
  return null;

}
}

}

/// @nodoc


class _FloatOption extends FloatOption {
  const _FloatOption({required this.titleKey, this.descriptionKey, required this.icon, required this.value, required this.min, required this.max, required this.defaultValue, this.units = ''}): super._();
  

@override final  String titleKey;
@override final  String? descriptionKey;
@override final  IconData icon;
@override final  OptionValue<double> value;
@override final  double min;
@override final  double max;
@override final  double defaultValue;
@override@JsonKey() final  String units;

/// Create a copy of FloatOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloatOptionCopyWith<_FloatOption> get copyWith => __$FloatOptionCopyWithImpl<_FloatOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloatOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.units, units) || other.units == units));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value,min,max,defaultValue,units);

@override
String toString() {
  return 'FloatOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value, min: $min, max: $max, defaultValue: $defaultValue, units: $units)';
}


}

/// @nodoc
abstract mixin class _$FloatOptionCopyWith<$Res> implements $FloatOptionCopyWith<$Res> {
  factory _$FloatOptionCopyWith(_FloatOption value, $Res Function(_FloatOption) _then) = __$FloatOptionCopyWithImpl;
@override @useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<double> value, double min, double max, double defaultValue, String units
});




}
/// @nodoc
class __$FloatOptionCopyWithImpl<$Res>
    implements _$FloatOptionCopyWith<$Res> {
  __$FloatOptionCopyWithImpl(this._self, this._then);

  final _FloatOption _self;
  final $Res Function(_FloatOption) _then;

/// Create a copy of FloatOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,Object? min = null,Object? max = null,Object? defaultValue = null,Object? units = null,}) {
  return _then(_FloatOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<double>,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as double,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$InputBindingOption {

 String get titleKey; String? get descriptionKey; IconData get icon; OptionValue<String> get value;
/// Create a copy of InputBindingOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InputBindingOptionCopyWith<InputBindingOption> get copyWith => _$InputBindingOptionCopyWithImpl<InputBindingOption>(this as InputBindingOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputBindingOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value);

@override
String toString() {
  return 'InputBindingOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value)';
}


}

/// @nodoc
abstract mixin class $InputBindingOptionCopyWith<$Res>  {
  factory $InputBindingOptionCopyWith(InputBindingOption value, $Res Function(InputBindingOption) _then) = _$InputBindingOptionCopyWithImpl;
@useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<String> value
});




}
/// @nodoc
class _$InputBindingOptionCopyWithImpl<$Res>
    implements $InputBindingOptionCopyWith<$Res> {
  _$InputBindingOptionCopyWithImpl(this._self, this._then);

  final InputBindingOption _self;
  final $Res Function(InputBindingOption) _then;

/// Create a copy of InputBindingOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,}) {
  return _then(InputBindingOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [InputBindingOption].
extension InputBindingOptionPatterns on InputBindingOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InputBindingOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InputBindingOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InputBindingOption value)  $default,){
final _that = this;
switch (_that) {
case _InputBindingOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InputBindingOption value)?  $default,){
final _that = this;
switch (_that) {
case _InputBindingOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<String> value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InputBindingOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<String> value)  $default,) {final _that = this;
switch (_that) {
case _InputBindingOption():
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<String> value)?  $default,) {final _that = this;
switch (_that) {
case _InputBindingOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _InputBindingOption extends InputBindingOption {
  const _InputBindingOption({required this.titleKey, this.descriptionKey, required this.icon, required this.value}): super._();
  

@override final  String titleKey;
@override final  String? descriptionKey;
@override final  IconData icon;
@override final  OptionValue<String> value;

/// Create a copy of InputBindingOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InputBindingOptionCopyWith<_InputBindingOption> get copyWith => __$InputBindingOptionCopyWithImpl<_InputBindingOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InputBindingOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value);

@override
String toString() {
  return 'InputBindingOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value)';
}


}

/// @nodoc
abstract mixin class _$InputBindingOptionCopyWith<$Res> implements $InputBindingOptionCopyWith<$Res> {
  factory _$InputBindingOptionCopyWith(_InputBindingOption value, $Res Function(_InputBindingOption) _then) = __$InputBindingOptionCopyWithImpl;
@override @useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<String> value
});




}
/// @nodoc
class __$InputBindingOptionCopyWithImpl<$Res>
    implements _$InputBindingOptionCopyWith<$Res> {
  __$InputBindingOptionCopyWithImpl(this._self, this._then);

  final _InputBindingOption _self;
  final $Res Function(_InputBindingOption) _then;

/// Create a copy of InputBindingOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,}) {
  return _then(_InputBindingOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<String>,
  ));
}


}

/// @nodoc
mixin _$IntOption {

 String get titleKey; String? get descriptionKey; IconData get icon; OptionValue<int> get value; int get min; int get max; int get defaultValue; String get units;
/// Create a copy of IntOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntOptionCopyWith<IntOption> get copyWith => _$IntOptionCopyWithImpl<IntOption>(this as IntOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.units, units) || other.units == units));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value,min,max,defaultValue,units);

@override
String toString() {
  return 'IntOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value, min: $min, max: $max, defaultValue: $defaultValue, units: $units)';
}


}

/// @nodoc
abstract mixin class $IntOptionCopyWith<$Res>  {
  factory $IntOptionCopyWith(IntOption value, $Res Function(IntOption) _then) = _$IntOptionCopyWithImpl;
@useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<int> value, int min, int max, int defaultValue, String units
});




}
/// @nodoc
class _$IntOptionCopyWithImpl<$Res>
    implements $IntOptionCopyWith<$Res> {
  _$IntOptionCopyWithImpl(this._self, this._then);

  final IntOption _self;
  final $Res Function(IntOption) _then;

/// Create a copy of IntOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,Object? min = null,Object? max = null,Object? defaultValue = null,Object? units = null,}) {
  return _then(IntOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<int>,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as int,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IntOption].
extension IntOptionPatterns on IntOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IntOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IntOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IntOption value)  $default,){
final _that = this;
switch (_that) {
case _IntOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IntOption value)?  $default,){
final _that = this;
switch (_that) {
case _IntOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<int> value,  int min,  int max,  int defaultValue,  String units)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IntOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.min,_that.max,_that.defaultValue,_that.units);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<int> value,  int min,  int max,  int defaultValue,  String units)  $default,) {final _that = this;
switch (_that) {
case _IntOption():
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.min,_that.max,_that.defaultValue,_that.units);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<int> value,  int min,  int max,  int defaultValue,  String units)?  $default,) {final _that = this;
switch (_that) {
case _IntOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.min,_that.max,_that.defaultValue,_that.units);case _:
  return null;

}
}

}

/// @nodoc


class _IntOption extends IntOption {
  const _IntOption({required this.titleKey, this.descriptionKey, required this.icon, required this.value, required this.min, required this.max, required this.defaultValue, this.units = ''}): super._();
  

@override final  String titleKey;
@override final  String? descriptionKey;
@override final  IconData icon;
@override final  OptionValue<int> value;
@override final  int min;
@override final  int max;
@override final  int defaultValue;
@override@JsonKey() final  String units;

/// Create a copy of IntOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntOptionCopyWith<_IntOption> get copyWith => __$IntOptionCopyWithImpl<_IntOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IntOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.units, units) || other.units == units));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value,min,max,defaultValue,units);

@override
String toString() {
  return 'IntOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value, min: $min, max: $max, defaultValue: $defaultValue, units: $units)';
}


}

/// @nodoc
abstract mixin class _$IntOptionCopyWith<$Res> implements $IntOptionCopyWith<$Res> {
  factory _$IntOptionCopyWith(_IntOption value, $Res Function(_IntOption) _then) = __$IntOptionCopyWithImpl;
@override @useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<int> value, int min, int max, int defaultValue, String units
});




}
/// @nodoc
class __$IntOptionCopyWithImpl<$Res>
    implements _$IntOptionCopyWith<$Res> {
  __$IntOptionCopyWithImpl(this._self, this._then);

  final _IntOption _self;
  final $Res Function(_IntOption) _then;

/// Create a copy of IntOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,Object? min = null,Object? max = null,Object? defaultValue = null,Object? units = null,}) {
  return _then(_IntOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<int>,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,defaultValue: null == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as int,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$NestedOption {

 String get titleKey; String? get descriptionKey; IconData get icon; GoRouteData get destination;
/// Create a copy of NestedOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NestedOptionCopyWith<NestedOption> get copyWith => _$NestedOptionCopyWithImpl<NestedOption>(this as NestedOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NestedOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.destination, destination) || other.destination == destination));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,destination);

@override
String toString() {
  return 'NestedOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, destination: $destination)';
}


}

/// @nodoc
abstract mixin class $NestedOptionCopyWith<$Res>  {
  factory $NestedOptionCopyWith(NestedOption value, $Res Function(NestedOption) _then) = _$NestedOptionCopyWithImpl;
@useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, GoRouteData destination
});




}
/// @nodoc
class _$NestedOptionCopyWithImpl<$Res>
    implements $NestedOptionCopyWith<$Res> {
  _$NestedOptionCopyWithImpl(this._self, this._then);

  final NestedOption _self;
  final $Res Function(NestedOption) _then;

/// Create a copy of NestedOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? destination = null,}) {
  return _then(NestedOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as GoRouteData,
  ));
}

}


/// Adds pattern-matching-related methods to [NestedOption].
extension NestedOptionPatterns on NestedOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NestedOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NestedOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NestedOption value)  $default,){
final _that = this;
switch (_that) {
case _NestedOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NestedOption value)?  $default,){
final _that = this;
switch (_that) {
case _NestedOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  GoRouteData destination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NestedOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.destination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  GoRouteData destination)  $default,) {final _that = this;
switch (_that) {
case _NestedOption():
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.destination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleKey,  String? descriptionKey,  IconData icon,  GoRouteData destination)?  $default,) {final _that = this;
switch (_that) {
case _NestedOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.destination);case _:
  return null;

}
}

}

/// @nodoc


class _NestedOption extends NestedOption {
  const _NestedOption({required this.titleKey, this.descriptionKey, required this.icon, required this.destination}): super._();
  

@override final  String titleKey;
@override final  String? descriptionKey;
@override final  IconData icon;
@override final  GoRouteData destination;

/// Create a copy of NestedOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NestedOptionCopyWith<_NestedOption> get copyWith => __$NestedOptionCopyWithImpl<_NestedOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NestedOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.destination, destination) || other.destination == destination));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,destination);

@override
String toString() {
  return 'NestedOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, destination: $destination)';
}


}

/// @nodoc
abstract mixin class _$NestedOptionCopyWith<$Res> implements $NestedOptionCopyWith<$Res> {
  factory _$NestedOptionCopyWith(_NestedOption value, $Res Function(_NestedOption) _then) = __$NestedOptionCopyWithImpl;
@override @useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, GoRouteData destination
});




}
/// @nodoc
class __$NestedOptionCopyWithImpl<$Res>
    implements _$NestedOptionCopyWith<$Res> {
  __$NestedOptionCopyWithImpl(this._self, this._then);

  final _NestedOption _self;
  final $Res Function(_NestedOption) _then;

/// Create a copy of NestedOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? destination = null,}) {
  return _then(_NestedOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as GoRouteData,
  ));
}


}

/// @nodoc
mixin _$StringOption {

 String get titleKey; String? get descriptionKey; IconData get icon; OptionValue<String> get value; int? get maxLength;
/// Create a copy of StringOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringOptionCopyWith<StringOption> get copyWith => _$StringOptionCopyWithImpl<StringOption>(this as StringOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value,maxLength);

@override
String toString() {
  return 'StringOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value, maxLength: $maxLength)';
}


}

/// @nodoc
abstract mixin class $StringOptionCopyWith<$Res>  {
  factory $StringOptionCopyWith(StringOption value, $Res Function(StringOption) _then) = _$StringOptionCopyWithImpl;
@useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<String> value, int? maxLength
});




}
/// @nodoc
class _$StringOptionCopyWithImpl<$Res>
    implements $StringOptionCopyWith<$Res> {
  _$StringOptionCopyWithImpl(this._self, this._then);

  final StringOption _self;
  final $Res Function(StringOption) _then;

/// Create a copy of StringOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,Object? maxLength = freezed,}) {
  return _then(StringOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<String>,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StringOption].
extension StringOptionPatterns on StringOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StringOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StringOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StringOption value)  $default,){
final _that = this;
switch (_that) {
case _StringOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StringOption value)?  $default,){
final _that = this;
switch (_that) {
case _StringOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<String> value,  int? maxLength)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StringOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.maxLength);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<String> value,  int? maxLength)  $default,) {final _that = this;
switch (_that) {
case _StringOption():
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.maxLength);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String titleKey,  String? descriptionKey,  IconData icon,  OptionValue<String> value,  int? maxLength)?  $default,) {final _that = this;
switch (_that) {
case _StringOption() when $default != null:
return $default(_that.titleKey,_that.descriptionKey,_that.icon,_that.value,_that.maxLength);case _:
  return null;

}
}

}

/// @nodoc


class _StringOption extends StringOption {
  const _StringOption({required this.titleKey, this.descriptionKey, required this.icon, required this.value, this.maxLength}): super._();
  

@override final  String titleKey;
@override final  String? descriptionKey;
@override final  IconData icon;
@override final  OptionValue<String> value;
@override final  int? maxLength;

/// Create a copy of StringOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StringOptionCopyWith<_StringOption> get copyWith => __$StringOptionCopyWithImpl<_StringOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StringOption&&(identical(other.titleKey, titleKey) || other.titleKey == titleKey)&&(identical(other.descriptionKey, descriptionKey) || other.descriptionKey == descriptionKey)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.value, value) || other.value == value)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength));
}


@override
int get hashCode => Object.hash(runtimeType,titleKey,descriptionKey,icon,value,maxLength);

@override
String toString() {
  return 'StringOption(titleKey: $titleKey, descriptionKey: $descriptionKey, icon: $icon, value: $value, maxLength: $maxLength)';
}


}

/// @nodoc
abstract mixin class _$StringOptionCopyWith<$Res> implements $StringOptionCopyWith<$Res> {
  factory _$StringOptionCopyWith(_StringOption value, $Res Function(_StringOption) _then) = __$StringOptionCopyWithImpl;
@override @useResult
$Res call({
 String titleKey, String? descriptionKey, IconData icon, OptionValue<String> value, int? maxLength
});




}
/// @nodoc
class __$StringOptionCopyWithImpl<$Res>
    implements _$StringOptionCopyWith<$Res> {
  __$StringOptionCopyWithImpl(this._self, this._then);

  final _StringOption _self;
  final $Res Function(_StringOption) _then;

/// Create a copy of StringOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? titleKey = null,Object? descriptionKey = freezed,Object? icon = null,Object? value = null,Object? maxLength = freezed,}) {
  return _then(_StringOption(
titleKey: null == titleKey ? _self.titleKey : titleKey // ignore: cast_nullable_to_non_nullable
as String,descriptionKey: freezed == descriptionKey ? _self.descriptionKey : descriptionKey // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as OptionValue<String>,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
