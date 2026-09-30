// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OptionCategory {

 String get id; TranslationText get title; List<OptionSection> get sections;
/// Create a copy of OptionCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionCategoryCopyWith<OptionCategory> get copyWith => _$OptionCategoryCopyWithImpl<OptionCategory>(this as OptionCategory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptionCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.sections, sections));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'OptionCategory(id: $id, title: $title, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $OptionCategoryCopyWith<$Res>  {
  factory $OptionCategoryCopyWith(OptionCategory value, $Res Function(OptionCategory) _then) = _$OptionCategoryCopyWithImpl;
@useResult
$Res call({
 String id, TranslationText title, List<OptionSection> sections
});




}
/// @nodoc
class _$OptionCategoryCopyWithImpl<$Res>
    implements $OptionCategoryCopyWith<$Res> {
  _$OptionCategoryCopyWithImpl(this._self, this._then);

  final OptionCategory _self;
  final $Res Function(OptionCategory) _then;

/// Create a copy of OptionCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? sections = null,}) {
  return _then(OptionCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as TranslationText,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<OptionSection>,
  ));
}

}


/// Adds pattern-matching-related methods to [OptionCategory].
extension OptionCategoryPatterns on OptionCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OptionCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OptionCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OptionCategory value)  $default,){
final _that = this;
switch (_that) {
case _OptionCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OptionCategory value)?  $default,){
final _that = this;
switch (_that) {
case _OptionCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TranslationText title,  List<OptionSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OptionCategory() when $default != null:
return $default(_that.id,_that.title,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TranslationText title,  List<OptionSection> sections)  $default,) {final _that = this;
switch (_that) {
case _OptionCategory():
return $default(_that.id,_that.title,_that.sections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TranslationText title,  List<OptionSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _OptionCategory() when $default != null:
return $default(_that.id,_that.title,_that.sections);case _:
  return null;

}
}

}

/// @nodoc


class _OptionCategory extends OptionCategory {
  const _OptionCategory({required this.id, required this.title, required  List<OptionSection> sections}): _sections = sections,super._();
  

@override final  String id;
@override final  TranslationText title;
 final  List<OptionSection> _sections;
@override List<OptionSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of OptionCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptionCategoryCopyWith<_OptionCategory> get copyWith => __$OptionCategoryCopyWithImpl<_OptionCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptionCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._sections, _sections));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'OptionCategory(id: $id, title: $title, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$OptionCategoryCopyWith<$Res> implements $OptionCategoryCopyWith<$Res> {
  factory _$OptionCategoryCopyWith(_OptionCategory value, $Res Function(_OptionCategory) _then) = __$OptionCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, TranslationText title, List<OptionSection> sections
});




}
/// @nodoc
class __$OptionCategoryCopyWithImpl<$Res>
    implements _$OptionCategoryCopyWith<$Res> {
  __$OptionCategoryCopyWithImpl(this._self, this._then);

  final _OptionCategory _self;
  final $Res Function(_OptionCategory) _then;

/// Create a copy of OptionCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? sections = null,}) {
  return _then(_OptionCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as TranslationText,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<OptionSection>,
  ));
}


}

// dart format on
