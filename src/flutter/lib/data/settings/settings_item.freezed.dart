// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsItem {

 String get title; String? get description;
/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsItemCopyWith<SettingsItem> get copyWith => _$SettingsItemCopyWithImpl<SettingsItem>(this as SettingsItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,title,description);

@override
String toString() {
  return 'SettingsItem(title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class $SettingsItemCopyWith<$Res>  {
  factory $SettingsItemCopyWith(SettingsItem value, $Res Function(SettingsItem) _then) = _$SettingsItemCopyWithImpl;
@useResult
$Res call({
 String title, String? description
});




}
/// @nodoc
class _$SettingsItemCopyWithImpl<$Res>
    implements $SettingsItemCopyWith<$Res> {
  _$SettingsItemCopyWithImpl(this._self, this._then);

  final SettingsItem _self;
  final $Res Function(SettingsItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsItem].
extension SettingsItemPatterns on SettingsItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsHeaderItem value)?  header,TResult Function( SettingsSwitchItem value)?  switch_,TResult Function( SettingsSliderItem value)?  slider,TResult Function( SettingsSingleChoiceItem value)?  singleChoice,TResult Function( SettingsSubmenuItem value)?  submenu,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsHeaderItem() when header != null:
return header(_that);case SettingsSwitchItem() when switch_ != null:
return switch_(_that);case SettingsSliderItem() when slider != null:
return slider(_that);case SettingsSingleChoiceItem() when singleChoice != null:
return singleChoice(_that);case SettingsSubmenuItem() when submenu != null:
return submenu(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsHeaderItem value)  header,required TResult Function( SettingsSwitchItem value)  switch_,required TResult Function( SettingsSliderItem value)  slider,required TResult Function( SettingsSingleChoiceItem value)  singleChoice,required TResult Function( SettingsSubmenuItem value)  submenu,}){
final _that = this;
switch (_that) {
case SettingsHeaderItem():
return header(_that);case SettingsSwitchItem():
return switch_(_that);case SettingsSliderItem():
return slider(_that);case SettingsSingleChoiceItem():
return singleChoice(_that);case SettingsSubmenuItem():
return submenu(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsHeaderItem value)?  header,TResult? Function( SettingsSwitchItem value)?  switch_,TResult? Function( SettingsSliderItem value)?  slider,TResult? Function( SettingsSingleChoiceItem value)?  singleChoice,TResult? Function( SettingsSubmenuItem value)?  submenu,}){
final _that = this;
switch (_that) {
case SettingsHeaderItem() when header != null:
return header(_that);case SettingsSwitchItem() when switch_ != null:
return switch_(_that);case SettingsSliderItem() when slider != null:
return slider(_that);case SettingsSingleChoiceItem() when singleChoice != null:
return singleChoice(_that);case SettingsSubmenuItem() when submenu != null:
return submenu(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String title,  String? description)?  header,TResult Function( String title,  String? description,  IntBoolKey setting)?  switch_,TResult Function( String title,  String? description,  IntKey setting,  int min,  int max,  String units)?  slider,TResult Function( String title,  String? description,  IntKey setting,  List<String> choiceLabels,  List<int> choiceValues)?  singleChoice,TResult Function( String title,  String? description,  String menuTag)?  submenu,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsHeaderItem() when header != null:
return header(_that.title,_that.description);case SettingsSwitchItem() when switch_ != null:
return switch_(_that.title,_that.description,_that.setting);case SettingsSliderItem() when slider != null:
return slider(_that.title,_that.description,_that.setting,_that.min,_that.max,_that.units);case SettingsSingleChoiceItem() when singleChoice != null:
return singleChoice(_that.title,_that.description,_that.setting,_that.choiceLabels,_that.choiceValues);case SettingsSubmenuItem() when submenu != null:
return submenu(_that.title,_that.description,_that.menuTag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String title,  String? description)  header,required TResult Function( String title,  String? description,  IntBoolKey setting)  switch_,required TResult Function( String title,  String? description,  IntKey setting,  int min,  int max,  String units)  slider,required TResult Function( String title,  String? description,  IntKey setting,  List<String> choiceLabels,  List<int> choiceValues)  singleChoice,required TResult Function( String title,  String? description,  String menuTag)  submenu,}) {final _that = this;
switch (_that) {
case SettingsHeaderItem():
return header(_that.title,_that.description);case SettingsSwitchItem():
return switch_(_that.title,_that.description,_that.setting);case SettingsSliderItem():
return slider(_that.title,_that.description,_that.setting,_that.min,_that.max,_that.units);case SettingsSingleChoiceItem():
return singleChoice(_that.title,_that.description,_that.setting,_that.choiceLabels,_that.choiceValues);case SettingsSubmenuItem():
return submenu(_that.title,_that.description,_that.menuTag);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String title,  String? description)?  header,TResult? Function( String title,  String? description,  IntBoolKey setting)?  switch_,TResult? Function( String title,  String? description,  IntKey setting,  int min,  int max,  String units)?  slider,TResult? Function( String title,  String? description,  IntKey setting,  List<String> choiceLabels,  List<int> choiceValues)?  singleChoice,TResult? Function( String title,  String? description,  String menuTag)?  submenu,}) {final _that = this;
switch (_that) {
case SettingsHeaderItem() when header != null:
return header(_that.title,_that.description);case SettingsSwitchItem() when switch_ != null:
return switch_(_that.title,_that.description,_that.setting);case SettingsSliderItem() when slider != null:
return slider(_that.title,_that.description,_that.setting,_that.min,_that.max,_that.units);case SettingsSingleChoiceItem() when singleChoice != null:
return singleChoice(_that.title,_that.description,_that.setting,_that.choiceLabels,_that.choiceValues);case SettingsSubmenuItem() when submenu != null:
return submenu(_that.title,_that.description,_that.menuTag);case _:
  return null;

}
}

}

/// @nodoc


class SettingsHeaderItem implements SettingsItem {
  const SettingsHeaderItem({required this.title, this.description});


@override final  String title;
@override final  String? description;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsHeaderItemCopyWith<SettingsHeaderItem> get copyWith => _$SettingsHeaderItemCopyWithImpl<SettingsHeaderItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsHeaderItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,title,description);

@override
String toString() {
  return 'SettingsItem.header(title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class $SettingsHeaderItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsHeaderItemCopyWith(SettingsHeaderItem value, $Res Function(SettingsHeaderItem) _then) = _$SettingsHeaderItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description
});




}
/// @nodoc
class _$SettingsHeaderItemCopyWithImpl<$Res>
    implements $SettingsHeaderItemCopyWith<$Res> {
  _$SettingsHeaderItemCopyWithImpl(this._self, this._then);

  final SettingsHeaderItem _self;
  final $Res Function(SettingsHeaderItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,}) {
  return _then(SettingsHeaderItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SettingsSwitchItem implements SettingsItem {
  const SettingsSwitchItem({required this.title, this.description, required this.setting});


@override final  String title;
@override final  String? description;
 final  IntBoolKey setting;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSwitchItemCopyWith<SettingsSwitchItem> get copyWith => _$SettingsSwitchItemCopyWithImpl<SettingsSwitchItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSwitchItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.setting, setting) || other.setting == setting));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,setting);

@override
String toString() {
  return 'SettingsItem.switch_(title: $title, description: $description, setting: $setting)';
}


}

/// @nodoc
abstract mixin class $SettingsSwitchItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsSwitchItemCopyWith(SettingsSwitchItem value, $Res Function(SettingsSwitchItem) _then) = _$SettingsSwitchItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, IntBoolKey setting
});




}
/// @nodoc
class _$SettingsSwitchItemCopyWithImpl<$Res>
    implements $SettingsSwitchItemCopyWith<$Res> {
  _$SettingsSwitchItemCopyWithImpl(this._self, this._then);

  final SettingsSwitchItem _self;
  final $Res Function(SettingsSwitchItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? setting = null,}) {
  return _then(SettingsSwitchItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as IntBoolKey,
  ));
}


}

/// @nodoc


class SettingsSliderItem implements SettingsItem {
  const SettingsSliderItem({required this.title, this.description, required this.setting, required this.min, required this.max, required this.units});


@override final  String title;
@override final  String? description;
 final  IntKey setting;
 final  int min;
 final  int max;
 final  String units;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSliderItemCopyWith<SettingsSliderItem> get copyWith => _$SettingsSliderItemCopyWithImpl<SettingsSliderItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSliderItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.setting, setting) || other.setting == setting)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.units, units) || other.units == units));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,setting,min,max,units);

@override
String toString() {
  return 'SettingsItem.slider(title: $title, description: $description, setting: $setting, min: $min, max: $max, units: $units)';
}


}

/// @nodoc
abstract mixin class $SettingsSliderItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsSliderItemCopyWith(SettingsSliderItem value, $Res Function(SettingsSliderItem) _then) = _$SettingsSliderItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, IntKey setting, int min, int max, String units
});




}
/// @nodoc
class _$SettingsSliderItemCopyWithImpl<$Res>
    implements $SettingsSliderItemCopyWith<$Res> {
  _$SettingsSliderItemCopyWithImpl(this._self, this._then);

  final SettingsSliderItem _self;
  final $Res Function(SettingsSliderItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? setting = null,Object? min = null,Object? max = null,Object? units = null,}) {
  return _then(SettingsSliderItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as IntKey,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SettingsSingleChoiceItem implements SettingsItem {
  const SettingsSingleChoiceItem({required this.title, this.description, required this.setting, required  List<String> choiceLabels, required  List<int> choiceValues}): _choiceLabels = choiceLabels,_choiceValues = choiceValues;


@override final  String title;
@override final  String? description;
 final  IntKey setting;
 final  List<String> _choiceLabels;
 List<String> get choiceLabels {
  if (_choiceLabels is EqualUnmodifiableListView) return _choiceLabels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_choiceLabels);
}

 final  List<int> _choiceValues;
 List<int> get choiceValues {
  if (_choiceValues is EqualUnmodifiableListView) return _choiceValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_choiceValues);
}


/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSingleChoiceItemCopyWith<SettingsSingleChoiceItem> get copyWith => _$SettingsSingleChoiceItemCopyWithImpl<SettingsSingleChoiceItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSingleChoiceItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.setting, setting) || other.setting == setting)&&const DeepCollectionEquality().equals(other._choiceLabels, _choiceLabels)&&const DeepCollectionEquality().equals(other._choiceValues, _choiceValues));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,setting,const DeepCollectionEquality().hash(_choiceLabels),const DeepCollectionEquality().hash(_choiceValues));

@override
String toString() {
  return 'SettingsItem.singleChoice(title: $title, description: $description, setting: $setting, choiceLabels: $choiceLabels, choiceValues: $choiceValues)';
}


}

/// @nodoc
abstract mixin class $SettingsSingleChoiceItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsSingleChoiceItemCopyWith(SettingsSingleChoiceItem value, $Res Function(SettingsSingleChoiceItem) _then) = _$SettingsSingleChoiceItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, IntKey setting, List<String> choiceLabels, List<int> choiceValues
});




}
/// @nodoc
class _$SettingsSingleChoiceItemCopyWithImpl<$Res>
    implements $SettingsSingleChoiceItemCopyWith<$Res> {
  _$SettingsSingleChoiceItemCopyWithImpl(this._self, this._then);

  final SettingsSingleChoiceItem _self;
  final $Res Function(SettingsSingleChoiceItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? setting = null,Object? choiceLabels = null,Object? choiceValues = null,}) {
  return _then(SettingsSingleChoiceItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as IntKey,choiceLabels: null == choiceLabels ? _self._choiceLabels : choiceLabels // ignore: cast_nullable_to_non_nullable
as List<String>,choiceValues: null == choiceValues ? _self._choiceValues : choiceValues // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc


class SettingsSubmenuItem implements SettingsItem {
  const SettingsSubmenuItem({required this.title, this.description, required this.menuTag});


@override final  String title;
@override final  String? description;
 final  String menuTag;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSubmenuItemCopyWith<SettingsSubmenuItem> get copyWith => _$SettingsSubmenuItemCopyWithImpl<SettingsSubmenuItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSubmenuItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.menuTag, menuTag) || other.menuTag == menuTag));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,menuTag);

@override
String toString() {
  return 'SettingsItem.submenu(title: $title, description: $description, menuTag: $menuTag)';
}


}

/// @nodoc
abstract mixin class $SettingsSubmenuItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsSubmenuItemCopyWith(SettingsSubmenuItem value, $Res Function(SettingsSubmenuItem) _then) = _$SettingsSubmenuItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, String menuTag
});




}
/// @nodoc
class _$SettingsSubmenuItemCopyWithImpl<$Res>
    implements $SettingsSubmenuItemCopyWith<$Res> {
  _$SettingsSubmenuItemCopyWithImpl(this._self, this._then);

  final SettingsSubmenuItem _self;
  final $Res Function(SettingsSubmenuItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? menuTag = null,}) {
  return _then(SettingsSubmenuItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,menuTag: null == menuTag ? _self.menuTag : menuTag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
