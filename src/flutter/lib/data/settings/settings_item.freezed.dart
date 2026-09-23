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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsHeaderItem value)?  header,TResult Function( SettingsSwitchItem value)?  switch_,TResult Function( SettingsSliderItem value)?  slider,TResult Function( SettingsSingleChoiceItem value)?  singleChoice,TResult Function( SettingsFloatSliderItem value)?  floatSlider,TResult Function( SettingsStringSingleChoiceItem value)?  stringSingleChoice,TResult Function( SettingsStringInputItem value)?  stringInput,TResult Function( SettingsDateTimeItem value)?  dateTime,TResult Function( SettingsActionItem value)?  action,TResult Function( SettingsSubmenuItem value)?  submenu,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsHeaderItem() when header != null:
return header(_that);case SettingsSwitchItem() when switch_ != null:
return switch_(_that);case SettingsSliderItem() when slider != null:
return slider(_that);case SettingsSingleChoiceItem() when singleChoice != null:
return singleChoice(_that);case SettingsFloatSliderItem() when floatSlider != null:
return floatSlider(_that);case SettingsStringSingleChoiceItem() when stringSingleChoice != null:
return stringSingleChoice(_that);case SettingsStringInputItem() when stringInput != null:
return stringInput(_that);case SettingsDateTimeItem() when dateTime != null:
return dateTime(_that);case SettingsActionItem() when action != null:
return action(_that);case SettingsSubmenuItem() when submenu != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsHeaderItem value)  header,required TResult Function( SettingsSwitchItem value)  switch_,required TResult Function( SettingsSliderItem value)  slider,required TResult Function( SettingsSingleChoiceItem value)  singleChoice,required TResult Function( SettingsFloatSliderItem value)  floatSlider,required TResult Function( SettingsStringSingleChoiceItem value)  stringSingleChoice,required TResult Function( SettingsStringInputItem value)  stringInput,required TResult Function( SettingsDateTimeItem value)  dateTime,required TResult Function( SettingsActionItem value)  action,required TResult Function( SettingsSubmenuItem value)  submenu,}){
final _that = this;
switch (_that) {
case SettingsHeaderItem():
return header(_that);case SettingsSwitchItem():
return switch_(_that);case SettingsSliderItem():
return slider(_that);case SettingsSingleChoiceItem():
return singleChoice(_that);case SettingsFloatSliderItem():
return floatSlider(_that);case SettingsStringSingleChoiceItem():
return stringSingleChoice(_that);case SettingsStringInputItem():
return stringInput(_that);case SettingsDateTimeItem():
return dateTime(_that);case SettingsActionItem():
return action(_that);case SettingsSubmenuItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsHeaderItem value)?  header,TResult? Function( SettingsSwitchItem value)?  switch_,TResult? Function( SettingsSliderItem value)?  slider,TResult? Function( SettingsSingleChoiceItem value)?  singleChoice,TResult? Function( SettingsFloatSliderItem value)?  floatSlider,TResult? Function( SettingsStringSingleChoiceItem value)?  stringSingleChoice,TResult? Function( SettingsStringInputItem value)?  stringInput,TResult? Function( SettingsDateTimeItem value)?  dateTime,TResult? Function( SettingsActionItem value)?  action,TResult? Function( SettingsSubmenuItem value)?  submenu,}){
final _that = this;
switch (_that) {
case SettingsHeaderItem() when header != null:
return header(_that);case SettingsSwitchItem() when switch_ != null:
return switch_(_that);case SettingsSliderItem() when slider != null:
return slider(_that);case SettingsSingleChoiceItem() when singleChoice != null:
return singleChoice(_that);case SettingsFloatSliderItem() when floatSlider != null:
return floatSlider(_that);case SettingsStringSingleChoiceItem() when stringSingleChoice != null:
return stringSingleChoice(_that);case SettingsStringInputItem() when stringInput != null:
return stringInput(_that);case SettingsDateTimeItem() when dateTime != null:
return dateTime(_that);case SettingsActionItem() when action != null:
return action(_that);case SettingsSubmenuItem() when submenu != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String title,  String? description)?  header,TResult Function( String title,  String? description,  IntBoolKey setting,  SettingsValueStore? store)?  switch_,TResult Function( String title,  String? description,  IntKey setting,  int min,  int max,  String units,  SettingsValueStore? store)?  slider,TResult Function( String title,  String? description,  IntKey setting,  List<String> choiceLabels,  List<int> choiceValues,  SettingsValueStore? store)?  singleChoice,TResult Function( String title,  String? description,  FloatKey setting,  double min,  double max,  String units,  SettingsValueStore? store)?  floatSlider,TResult Function( String title,  String? description,  StringKey setting,  List<String> choiceLabels,  List<String> choiceValues,  SettingsValueStore? store)?  stringSingleChoice,TResult Function( String title,  String? description,  StringKey setting,  int? maxLength,  SettingsValueStore? store)?  stringInput,TResult Function( String title,  String? description,  StringKey setting,  SettingsValueStore? store)?  dateTime,TResult Function( String title,  String? description,  void Function(BuildContext context) onTap)?  action,TResult Function( String title,  String? description,  void Function(BuildContext context) onTap)?  submenu,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsHeaderItem() when header != null:
return header(_that.title,_that.description);case SettingsSwitchItem() when switch_ != null:
return switch_(_that.title,_that.description,_that.setting,_that.store);case SettingsSliderItem() when slider != null:
return slider(_that.title,_that.description,_that.setting,_that.min,_that.max,_that.units,_that.store);case SettingsSingleChoiceItem() when singleChoice != null:
return singleChoice(_that.title,_that.description,_that.setting,_that.choiceLabels,_that.choiceValues,_that.store);case SettingsFloatSliderItem() when floatSlider != null:
return floatSlider(_that.title,_that.description,_that.setting,_that.min,_that.max,_that.units,_that.store);case SettingsStringSingleChoiceItem() when stringSingleChoice != null:
return stringSingleChoice(_that.title,_that.description,_that.setting,_that.choiceLabels,_that.choiceValues,_that.store);case SettingsStringInputItem() when stringInput != null:
return stringInput(_that.title,_that.description,_that.setting,_that.maxLength,_that.store);case SettingsDateTimeItem() when dateTime != null:
return dateTime(_that.title,_that.description,_that.setting,_that.store);case SettingsActionItem() when action != null:
return action(_that.title,_that.description,_that.onTap);case SettingsSubmenuItem() when submenu != null:
return submenu(_that.title,_that.description,_that.onTap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String title,  String? description)  header,required TResult Function( String title,  String? description,  IntBoolKey setting,  SettingsValueStore? store)  switch_,required TResult Function( String title,  String? description,  IntKey setting,  int min,  int max,  String units,  SettingsValueStore? store)  slider,required TResult Function( String title,  String? description,  IntKey setting,  List<String> choiceLabels,  List<int> choiceValues,  SettingsValueStore? store)  singleChoice,required TResult Function( String title,  String? description,  FloatKey setting,  double min,  double max,  String units,  SettingsValueStore? store)  floatSlider,required TResult Function( String title,  String? description,  StringKey setting,  List<String> choiceLabels,  List<String> choiceValues,  SettingsValueStore? store)  stringSingleChoice,required TResult Function( String title,  String? description,  StringKey setting,  int? maxLength,  SettingsValueStore? store)  stringInput,required TResult Function( String title,  String? description,  StringKey setting,  SettingsValueStore? store)  dateTime,required TResult Function( String title,  String? description,  void Function(BuildContext context) onTap)  action,required TResult Function( String title,  String? description,  void Function(BuildContext context) onTap)  submenu,}) {final _that = this;
switch (_that) {
case SettingsHeaderItem():
return header(_that.title,_that.description);case SettingsSwitchItem():
return switch_(_that.title,_that.description,_that.setting,_that.store);case SettingsSliderItem():
return slider(_that.title,_that.description,_that.setting,_that.min,_that.max,_that.units,_that.store);case SettingsSingleChoiceItem():
return singleChoice(_that.title,_that.description,_that.setting,_that.choiceLabels,_that.choiceValues,_that.store);case SettingsFloatSliderItem():
return floatSlider(_that.title,_that.description,_that.setting,_that.min,_that.max,_that.units,_that.store);case SettingsStringSingleChoiceItem():
return stringSingleChoice(_that.title,_that.description,_that.setting,_that.choiceLabels,_that.choiceValues,_that.store);case SettingsStringInputItem():
return stringInput(_that.title,_that.description,_that.setting,_that.maxLength,_that.store);case SettingsDateTimeItem():
return dateTime(_that.title,_that.description,_that.setting,_that.store);case SettingsActionItem():
return action(_that.title,_that.description,_that.onTap);case SettingsSubmenuItem():
return submenu(_that.title,_that.description,_that.onTap);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String title,  String? description)?  header,TResult? Function( String title,  String? description,  IntBoolKey setting,  SettingsValueStore? store)?  switch_,TResult? Function( String title,  String? description,  IntKey setting,  int min,  int max,  String units,  SettingsValueStore? store)?  slider,TResult? Function( String title,  String? description,  IntKey setting,  List<String> choiceLabels,  List<int> choiceValues,  SettingsValueStore? store)?  singleChoice,TResult? Function( String title,  String? description,  FloatKey setting,  double min,  double max,  String units,  SettingsValueStore? store)?  floatSlider,TResult? Function( String title,  String? description,  StringKey setting,  List<String> choiceLabels,  List<String> choiceValues,  SettingsValueStore? store)?  stringSingleChoice,TResult? Function( String title,  String? description,  StringKey setting,  int? maxLength,  SettingsValueStore? store)?  stringInput,TResult? Function( String title,  String? description,  StringKey setting,  SettingsValueStore? store)?  dateTime,TResult? Function( String title,  String? description,  void Function(BuildContext context) onTap)?  action,TResult? Function( String title,  String? description,  void Function(BuildContext context) onTap)?  submenu,}) {final _that = this;
switch (_that) {
case SettingsHeaderItem() when header != null:
return header(_that.title,_that.description);case SettingsSwitchItem() when switch_ != null:
return switch_(_that.title,_that.description,_that.setting,_that.store);case SettingsSliderItem() when slider != null:
return slider(_that.title,_that.description,_that.setting,_that.min,_that.max,_that.units,_that.store);case SettingsSingleChoiceItem() when singleChoice != null:
return singleChoice(_that.title,_that.description,_that.setting,_that.choiceLabels,_that.choiceValues,_that.store);case SettingsFloatSliderItem() when floatSlider != null:
return floatSlider(_that.title,_that.description,_that.setting,_that.min,_that.max,_that.units,_that.store);case SettingsStringSingleChoiceItem() when stringSingleChoice != null:
return stringSingleChoice(_that.title,_that.description,_that.setting,_that.choiceLabels,_that.choiceValues,_that.store);case SettingsStringInputItem() when stringInput != null:
return stringInput(_that.title,_that.description,_that.setting,_that.maxLength,_that.store);case SettingsDateTimeItem() when dateTime != null:
return dateTime(_that.title,_that.description,_that.setting,_that.store);case SettingsActionItem() when action != null:
return action(_that.title,_that.description,_that.onTap);case SettingsSubmenuItem() when submenu != null:
return submenu(_that.title,_that.description,_that.onTap);case _:
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
  const SettingsSwitchItem({required this.title, this.description, required this.setting, this.store});
  

@override final  String title;
@override final  String? description;
 final  IntBoolKey setting;
 final  SettingsValueStore? store;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSwitchItemCopyWith<SettingsSwitchItem> get copyWith => _$SettingsSwitchItemCopyWithImpl<SettingsSwitchItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSwitchItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.setting, setting) || other.setting == setting)&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,setting,store);

@override
String toString() {
  return 'SettingsItem.switch_(title: $title, description: $description, setting: $setting, store: $store)';
}


}

/// @nodoc
abstract mixin class $SettingsSwitchItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsSwitchItemCopyWith(SettingsSwitchItem value, $Res Function(SettingsSwitchItem) _then) = _$SettingsSwitchItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, IntBoolKey setting, SettingsValueStore? store
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
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? setting = null,Object? store = freezed,}) {
  return _then(SettingsSwitchItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as IntBoolKey,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as SettingsValueStore?,
  ));
}


}

/// @nodoc


class SettingsSliderItem implements SettingsItem {
  const SettingsSliderItem({required this.title, this.description, required this.setting, required this.min, required this.max, required this.units, this.store});
  

@override final  String title;
@override final  String? description;
 final  IntKey setting;
 final  int min;
 final  int max;
 final  String units;
 final  SettingsValueStore? store;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSliderItemCopyWith<SettingsSliderItem> get copyWith => _$SettingsSliderItemCopyWithImpl<SettingsSliderItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSliderItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.setting, setting) || other.setting == setting)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.units, units) || other.units == units)&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,setting,min,max,units,store);

@override
String toString() {
  return 'SettingsItem.slider(title: $title, description: $description, setting: $setting, min: $min, max: $max, units: $units, store: $store)';
}


}

/// @nodoc
abstract mixin class $SettingsSliderItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsSliderItemCopyWith(SettingsSliderItem value, $Res Function(SettingsSliderItem) _then) = _$SettingsSliderItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, IntKey setting, int min, int max, String units, SettingsValueStore? store
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
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? setting = null,Object? min = null,Object? max = null,Object? units = null,Object? store = freezed,}) {
  return _then(SettingsSliderItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as IntKey,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as SettingsValueStore?,
  ));
}


}

/// @nodoc


class SettingsSingleChoiceItem implements SettingsItem {
  const SettingsSingleChoiceItem({required this.title, this.description, required this.setting, required  List<String> choiceLabels, required  List<int> choiceValues, this.store}): _choiceLabels = choiceLabels,_choiceValues = choiceValues;
  

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

 final  SettingsValueStore? store;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSingleChoiceItemCopyWith<SettingsSingleChoiceItem> get copyWith => _$SettingsSingleChoiceItemCopyWithImpl<SettingsSingleChoiceItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSingleChoiceItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.setting, setting) || other.setting == setting)&&const DeepCollectionEquality().equals(other._choiceLabels, _choiceLabels)&&const DeepCollectionEquality().equals(other._choiceValues, _choiceValues)&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,setting,const DeepCollectionEquality().hash(_choiceLabels),const DeepCollectionEquality().hash(_choiceValues),store);

@override
String toString() {
  return 'SettingsItem.singleChoice(title: $title, description: $description, setting: $setting, choiceLabels: $choiceLabels, choiceValues: $choiceValues, store: $store)';
}


}

/// @nodoc
abstract mixin class $SettingsSingleChoiceItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsSingleChoiceItemCopyWith(SettingsSingleChoiceItem value, $Res Function(SettingsSingleChoiceItem) _then) = _$SettingsSingleChoiceItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, IntKey setting, List<String> choiceLabels, List<int> choiceValues, SettingsValueStore? store
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
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? setting = null,Object? choiceLabels = null,Object? choiceValues = null,Object? store = freezed,}) {
  return _then(SettingsSingleChoiceItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as IntKey,choiceLabels: null == choiceLabels ? _self._choiceLabels : choiceLabels // ignore: cast_nullable_to_non_nullable
as List<String>,choiceValues: null == choiceValues ? _self._choiceValues : choiceValues // ignore: cast_nullable_to_non_nullable
as List<int>,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as SettingsValueStore?,
  ));
}


}

/// @nodoc


class SettingsFloatSliderItem implements SettingsItem {
  const SettingsFloatSliderItem({required this.title, this.description, required this.setting, required this.min, required this.max, required this.units, this.store});
  

@override final  String title;
@override final  String? description;
 final  FloatKey setting;
 final  double min;
 final  double max;
 final  String units;
 final  SettingsValueStore? store;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsFloatSliderItemCopyWith<SettingsFloatSliderItem> get copyWith => _$SettingsFloatSliderItemCopyWithImpl<SettingsFloatSliderItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsFloatSliderItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.setting, setting) || other.setting == setting)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.units, units) || other.units == units)&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,setting,min,max,units,store);

@override
String toString() {
  return 'SettingsItem.floatSlider(title: $title, description: $description, setting: $setting, min: $min, max: $max, units: $units, store: $store)';
}


}

/// @nodoc
abstract mixin class $SettingsFloatSliderItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsFloatSliderItemCopyWith(SettingsFloatSliderItem value, $Res Function(SettingsFloatSliderItem) _then) = _$SettingsFloatSliderItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, FloatKey setting, double min, double max, String units, SettingsValueStore? store
});




}
/// @nodoc
class _$SettingsFloatSliderItemCopyWithImpl<$Res>
    implements $SettingsFloatSliderItemCopyWith<$Res> {
  _$SettingsFloatSliderItemCopyWithImpl(this._self, this._then);

  final SettingsFloatSliderItem _self;
  final $Res Function(SettingsFloatSliderItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? setting = null,Object? min = null,Object? max = null,Object? units = null,Object? store = freezed,}) {
  return _then(SettingsFloatSliderItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as FloatKey,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as String,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as SettingsValueStore?,
  ));
}


}

/// @nodoc


class SettingsStringSingleChoiceItem implements SettingsItem {
  const SettingsStringSingleChoiceItem({required this.title, this.description, required this.setting, required  List<String> choiceLabels, required  List<String> choiceValues, this.store}): _choiceLabels = choiceLabels,_choiceValues = choiceValues;
  

@override final  String title;
@override final  String? description;
 final  StringKey setting;
 final  List<String> _choiceLabels;
 List<String> get choiceLabels {
  if (_choiceLabels is EqualUnmodifiableListView) return _choiceLabels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_choiceLabels);
}

 final  List<String> _choiceValues;
 List<String> get choiceValues {
  if (_choiceValues is EqualUnmodifiableListView) return _choiceValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_choiceValues);
}

 final  SettingsValueStore? store;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStringSingleChoiceItemCopyWith<SettingsStringSingleChoiceItem> get copyWith => _$SettingsStringSingleChoiceItemCopyWithImpl<SettingsStringSingleChoiceItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsStringSingleChoiceItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.setting, setting) || other.setting == setting)&&const DeepCollectionEquality().equals(other._choiceLabels, _choiceLabels)&&const DeepCollectionEquality().equals(other._choiceValues, _choiceValues)&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,setting,const DeepCollectionEquality().hash(_choiceLabels),const DeepCollectionEquality().hash(_choiceValues),store);

@override
String toString() {
  return 'SettingsItem.stringSingleChoice(title: $title, description: $description, setting: $setting, choiceLabels: $choiceLabels, choiceValues: $choiceValues, store: $store)';
}


}

/// @nodoc
abstract mixin class $SettingsStringSingleChoiceItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsStringSingleChoiceItemCopyWith(SettingsStringSingleChoiceItem value, $Res Function(SettingsStringSingleChoiceItem) _then) = _$SettingsStringSingleChoiceItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, StringKey setting, List<String> choiceLabels, List<String> choiceValues, SettingsValueStore? store
});




}
/// @nodoc
class _$SettingsStringSingleChoiceItemCopyWithImpl<$Res>
    implements $SettingsStringSingleChoiceItemCopyWith<$Res> {
  _$SettingsStringSingleChoiceItemCopyWithImpl(this._self, this._then);

  final SettingsStringSingleChoiceItem _self;
  final $Res Function(SettingsStringSingleChoiceItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? setting = null,Object? choiceLabels = null,Object? choiceValues = null,Object? store = freezed,}) {
  return _then(SettingsStringSingleChoiceItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as StringKey,choiceLabels: null == choiceLabels ? _self._choiceLabels : choiceLabels // ignore: cast_nullable_to_non_nullable
as List<String>,choiceValues: null == choiceValues ? _self._choiceValues : choiceValues // ignore: cast_nullable_to_non_nullable
as List<String>,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as SettingsValueStore?,
  ));
}


}

/// @nodoc


class SettingsStringInputItem implements SettingsItem {
  const SettingsStringInputItem({required this.title, this.description, required this.setting, this.maxLength, this.store});
  

@override final  String title;
@override final  String? description;
 final  StringKey setting;
 final  int? maxLength;
 final  SettingsValueStore? store;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStringInputItemCopyWith<SettingsStringInputItem> get copyWith => _$SettingsStringInputItemCopyWithImpl<SettingsStringInputItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsStringInputItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.setting, setting) || other.setting == setting)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,setting,maxLength,store);

@override
String toString() {
  return 'SettingsItem.stringInput(title: $title, description: $description, setting: $setting, maxLength: $maxLength, store: $store)';
}


}

/// @nodoc
abstract mixin class $SettingsStringInputItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsStringInputItemCopyWith(SettingsStringInputItem value, $Res Function(SettingsStringInputItem) _then) = _$SettingsStringInputItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, StringKey setting, int? maxLength, SettingsValueStore? store
});




}
/// @nodoc
class _$SettingsStringInputItemCopyWithImpl<$Res>
    implements $SettingsStringInputItemCopyWith<$Res> {
  _$SettingsStringInputItemCopyWithImpl(this._self, this._then);

  final SettingsStringInputItem _self;
  final $Res Function(SettingsStringInputItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? setting = null,Object? maxLength = freezed,Object? store = freezed,}) {
  return _then(SettingsStringInputItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as StringKey,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as SettingsValueStore?,
  ));
}


}

/// @nodoc


class SettingsDateTimeItem implements SettingsItem {
  const SettingsDateTimeItem({required this.title, this.description, required this.setting, this.store});
  

@override final  String title;
@override final  String? description;
 final  StringKey setting;
 final  SettingsValueStore? store;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsDateTimeItemCopyWith<SettingsDateTimeItem> get copyWith => _$SettingsDateTimeItemCopyWithImpl<SettingsDateTimeItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsDateTimeItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.setting, setting) || other.setting == setting)&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,setting,store);

@override
String toString() {
  return 'SettingsItem.dateTime(title: $title, description: $description, setting: $setting, store: $store)';
}


}

/// @nodoc
abstract mixin class $SettingsDateTimeItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsDateTimeItemCopyWith(SettingsDateTimeItem value, $Res Function(SettingsDateTimeItem) _then) = _$SettingsDateTimeItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, StringKey setting, SettingsValueStore? store
});




}
/// @nodoc
class _$SettingsDateTimeItemCopyWithImpl<$Res>
    implements $SettingsDateTimeItemCopyWith<$Res> {
  _$SettingsDateTimeItemCopyWithImpl(this._self, this._then);

  final SettingsDateTimeItem _self;
  final $Res Function(SettingsDateTimeItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? setting = null,Object? store = freezed,}) {
  return _then(SettingsDateTimeItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,setting: null == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as StringKey,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as SettingsValueStore?,
  ));
}


}

/// @nodoc


class SettingsActionItem implements SettingsItem {
  const SettingsActionItem({required this.title, this.description, required this.onTap});
  

@override final  String title;
@override final  String? description;
 final  void Function(BuildContext context) onTap;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsActionItemCopyWith<SettingsActionItem> get copyWith => _$SettingsActionItemCopyWithImpl<SettingsActionItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsActionItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.onTap, onTap) || other.onTap == onTap));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,onTap);

@override
String toString() {
  return 'SettingsItem.action(title: $title, description: $description, onTap: $onTap)';
}


}

/// @nodoc
abstract mixin class $SettingsActionItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsActionItemCopyWith(SettingsActionItem value, $Res Function(SettingsActionItem) _then) = _$SettingsActionItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, void Function(BuildContext context) onTap
});




}
/// @nodoc
class _$SettingsActionItemCopyWithImpl<$Res>
    implements $SettingsActionItemCopyWith<$Res> {
  _$SettingsActionItemCopyWithImpl(this._self, this._then);

  final SettingsActionItem _self;
  final $Res Function(SettingsActionItem) _then;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? onTap = null,}) {
  return _then(SettingsActionItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as void Function(BuildContext context),
  ));
}


}

/// @nodoc


class SettingsSubmenuItem implements SettingsItem {
  const SettingsSubmenuItem({required this.title, this.description, required this.onTap});
  

@override final  String title;
@override final  String? description;
 final  void Function(BuildContext context) onTap;

/// Create a copy of SettingsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSubmenuItemCopyWith<SettingsSubmenuItem> get copyWith => _$SettingsSubmenuItemCopyWithImpl<SettingsSubmenuItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSubmenuItem&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.onTap, onTap) || other.onTap == onTap));
}


@override
int get hashCode => Object.hash(runtimeType,title,description,onTap);

@override
String toString() {
  return 'SettingsItem.submenu(title: $title, description: $description, onTap: $onTap)';
}


}

/// @nodoc
abstract mixin class $SettingsSubmenuItemCopyWith<$Res> implements $SettingsItemCopyWith<$Res> {
  factory $SettingsSubmenuItemCopyWith(SettingsSubmenuItem value, $Res Function(SettingsSubmenuItem) _then) = _$SettingsSubmenuItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, void Function(BuildContext context) onTap
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
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? onTap = null,}) {
  return _then(SettingsSubmenuItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,onTap: null == onTap ? _self.onTap : onTap // ignore: cast_nullable_to_non_nullable
as void Function(BuildContext context),
  ));
}


}

// dart format on
