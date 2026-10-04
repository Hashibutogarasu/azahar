// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OptionSection {

 TranslationText? get title; List<AbstractBaseOption> get options; ProviderListenable<bool>? get disabledWhen;
/// Create a copy of OptionSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionSectionCopyWith<OptionSection> get copyWith => _$OptionSectionCopyWithImpl<OptionSection>(this as OptionSection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OptionSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptionSection&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.disabledWhen, _this.disabledWhen) || other.disabledWhen == _this.disabledWhen));
}


@override
int get hashCode {
  final _this = this as OptionSection;
  return Object.hash(runtimeType,_this.title,const DeepCollectionEquality().hash(_this.options),_this.disabledWhen);
}

@override
String toString() {
  final _this = this as OptionSection;
  return 'OptionSection(title: ${_this.title}, options: ${_this.options}, disabledWhen: ${_this.disabledWhen})';
}


}

/// @nodoc
abstract mixin class $OptionSectionCopyWith<$Res>  {
  factory $OptionSectionCopyWith(OptionSection value, $Res Function(OptionSection) _then) = _$OptionSectionCopyWithImpl;
@useResult
$Res call({
 TranslationText? title, List<AbstractBaseOption> options, ProviderListenable<bool>? disabledWhen
});




}
/// @nodoc
class _$OptionSectionCopyWithImpl<$Res>
    implements $OptionSectionCopyWith<$Res> {
  _$OptionSectionCopyWithImpl(this._self, this._then);

  final OptionSection _self;
  final $Res Function(OptionSection) _then;

/// Create a copy of OptionSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? options = null,Object? disabledWhen = freezed,}) {
  return _then(OptionSection(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as TranslationText?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<AbstractBaseOption>,disabledWhen: freezed == disabledWhen ? _self.disabledWhen : disabledWhen // ignore: cast_nullable_to_non_nullable
as ProviderListenable<bool>?,
  ));
}

}


/// Adds pattern-matching-related methods to [OptionSection].
extension OptionSectionPatterns on OptionSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OptionSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OptionSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OptionSection value)  $default,){
final _that = this;
switch (_that) {
case _OptionSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OptionSection value)?  $default,){
final _that = this;
switch (_that) {
case _OptionSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TranslationText? title,  List<AbstractBaseOption> options,  ProviderListenable<bool>? disabledWhen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OptionSection() when $default != null:
return $default(_that.title,_that.options,_that.disabledWhen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TranslationText? title,  List<AbstractBaseOption> options,  ProviderListenable<bool>? disabledWhen)  $default,) {final _that = this;
switch (_that) {
case _OptionSection():
return $default(_that.title,_that.options,_that.disabledWhen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TranslationText? title,  List<AbstractBaseOption> options,  ProviderListenable<bool>? disabledWhen)?  $default,) {final _that = this;
switch (_that) {
case _OptionSection() when $default != null:
return $default(_that.title,_that.options,_that.disabledWhen);case _:
  return null;

}
}

}

/// @nodoc


class _OptionSection implements OptionSection {
  const _OptionSection({this.title, required  List<AbstractBaseOption> options, this.disabledWhen}): _options = options;
  

@override final  TranslationText? title;
 final  List<AbstractBaseOption> _options;
@override List<AbstractBaseOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  ProviderListenable<bool>? disabledWhen;

/// Create a copy of OptionSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptionSectionCopyWith<_OptionSection> get copyWith => __$OptionSectionCopyWithImpl<_OptionSection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptionSection&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.options, _options)&&(identical(other.disabledWhen, disabledWhen) || other.disabledWhen == disabledWhen));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_options),disabledWhen);
}

@override
String toString() {
    return 'OptionSection(title: $title, options: $options, disabledWhen: $disabledWhen)';
}


}

/// @nodoc
abstract mixin class _$OptionSectionCopyWith<$Res> implements $OptionSectionCopyWith<$Res> {
  factory _$OptionSectionCopyWith(_OptionSection value, $Res Function(_OptionSection) _then) = __$OptionSectionCopyWithImpl;
@override @useResult
$Res call({
 TranslationText? title, List<AbstractBaseOption> options, ProviderListenable<bool>? disabledWhen
});




}
/// @nodoc
class __$OptionSectionCopyWithImpl<$Res>
    implements _$OptionSectionCopyWith<$Res> {
  __$OptionSectionCopyWithImpl(this._self, this._then);

  final _OptionSection _self;
  final $Res Function(_OptionSection) _then;

/// Create a copy of OptionSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? options = null,Object? disabledWhen = freezed,}) {
  return _then(_OptionSection(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as TranslationText?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<AbstractBaseOption>,disabledWhen: freezed == disabledWhen ? _self.disabledWhen : disabledWhen // ignore: cast_nullable_to_non_nullable
as ProviderListenable<bool>?,
  ));
}


}

// dart format on
