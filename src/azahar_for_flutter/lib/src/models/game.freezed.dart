// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Game {

 String get title; String get description; String get path; int get titleId; String get company; String get regions; bool get isInstalled; bool get isSystemTitle; bool get isVisibleSystemTitle; String get filename; String? get iconPath;
/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameCopyWith<Game> get copyWith => _$GameCopyWithImpl<Game>(this as Game, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Game;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Game&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.titleId, _this.titleId) || other.titleId == _this.titleId)&&(identical(other.company, _this.company) || other.company == _this.company)&&(identical(other.regions, _this.regions) || other.regions == _this.regions)&&(identical(other.isInstalled, _this.isInstalled) || other.isInstalled == _this.isInstalled)&&(identical(other.isSystemTitle, _this.isSystemTitle) || other.isSystemTitle == _this.isSystemTitle)&&(identical(other.isVisibleSystemTitle, _this.isVisibleSystemTitle) || other.isVisibleSystemTitle == _this.isVisibleSystemTitle)&&(identical(other.filename, _this.filename) || other.filename == _this.filename)&&(identical(other.iconPath, _this.iconPath) || other.iconPath == _this.iconPath));
}


@override
int get hashCode {
  final _this = this as Game;
  return Object.hash(runtimeType,_this.title,_this.description,_this.path,_this.titleId,_this.company,_this.regions,_this.isInstalled,_this.isSystemTitle,_this.isVisibleSystemTitle,_this.filename,_this.iconPath);
}

@override
String toString() {
  final _this = this as Game;
  return 'Game(title: ${_this.title}, description: ${_this.description}, path: ${_this.path}, titleId: ${_this.titleId}, company: ${_this.company}, regions: ${_this.regions}, isInstalled: ${_this.isInstalled}, isSystemTitle: ${_this.isSystemTitle}, isVisibleSystemTitle: ${_this.isVisibleSystemTitle}, filename: ${_this.filename}, iconPath: ${_this.iconPath})';
}


}

/// @nodoc
abstract mixin class $GameCopyWith<$Res>  {
  factory $GameCopyWith(Game value, $Res Function(Game) _then) = _$GameCopyWithImpl;
@useResult
$Res call({
 String title, String description, String path, int titleId, String company, String regions, bool isInstalled, bool isSystemTitle, bool isVisibleSystemTitle, String filename, String? iconPath
});




}
/// @nodoc
class _$GameCopyWithImpl<$Res>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._self, this._then);

  final Game _self;
  final $Res Function(Game) _then;

/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? path = null,Object? titleId = null,Object? company = null,Object? regions = null,Object? isInstalled = null,Object? isSystemTitle = null,Object? isVisibleSystemTitle = null,Object? filename = null,Object? iconPath = freezed,}) {
  return _then(Game(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,titleId: null == titleId ? _self.titleId : titleId // ignore: cast_nullable_to_non_nullable
as int,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,regions: null == regions ? _self.regions : regions // ignore: cast_nullable_to_non_nullable
as String,isInstalled: null == isInstalled ? _self.isInstalled : isInstalled // ignore: cast_nullable_to_non_nullable
as bool,isSystemTitle: null == isSystemTitle ? _self.isSystemTitle : isSystemTitle // ignore: cast_nullable_to_non_nullable
as bool,isVisibleSystemTitle: null == isVisibleSystemTitle ? _self.isVisibleSystemTitle : isVisibleSystemTitle // ignore: cast_nullable_to_non_nullable
as bool,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,iconPath: freezed == iconPath ? _self.iconPath : iconPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Game].
extension GamePatterns on Game {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Game value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Game() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Game value)  $default,){
final _that = this;
switch (_that) {
case _Game():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Game value)?  $default,){
final _that = this;
switch (_that) {
case _Game() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  String path,  int titleId,  String company,  String regions,  bool isInstalled,  bool isSystemTitle,  bool isVisibleSystemTitle,  String filename,  String? iconPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Game() when $default != null:
return $default(_that.title,_that.description,_that.path,_that.titleId,_that.company,_that.regions,_that.isInstalled,_that.isSystemTitle,_that.isVisibleSystemTitle,_that.filename,_that.iconPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  String path,  int titleId,  String company,  String regions,  bool isInstalled,  bool isSystemTitle,  bool isVisibleSystemTitle,  String filename,  String? iconPath)  $default,) {final _that = this;
switch (_that) {
case _Game():
return $default(_that.title,_that.description,_that.path,_that.titleId,_that.company,_that.regions,_that.isInstalled,_that.isSystemTitle,_that.isVisibleSystemTitle,_that.filename,_that.iconPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  String path,  int titleId,  String company,  String regions,  bool isInstalled,  bool isSystemTitle,  bool isVisibleSystemTitle,  String filename,  String? iconPath)?  $default,) {final _that = this;
switch (_that) {
case _Game() when $default != null:
return $default(_that.title,_that.description,_that.path,_that.titleId,_that.company,_that.regions,_that.isInstalled,_that.isSystemTitle,_that.isVisibleSystemTitle,_that.filename,_that.iconPath);case _:
  return null;

}
}

}

/// @nodoc


class _Game implements Game {
  const _Game({required this.title, required this.description, required this.path, required this.titleId, required this.company, required this.regions, required this.isInstalled, required this.isSystemTitle, required this.isVisibleSystemTitle, required this.filename, this.iconPath});
  

@override final  String title;
@override final  String description;
@override final  String path;
@override final  int titleId;
@override final  String company;
@override final  String regions;
@override final  bool isInstalled;
@override final  bool isSystemTitle;
@override final  bool isVisibleSystemTitle;
@override final  String filename;
@override final  String? iconPath;

/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameCopyWith<_Game> get copyWith => __$GameCopyWithImpl<_Game>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Game&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.path, path) || other.path == path)&&(identical(other.titleId, titleId) || other.titleId == titleId)&&(identical(other.company, company) || other.company == company)&&(identical(other.regions, regions) || other.regions == regions)&&(identical(other.isInstalled, isInstalled) || other.isInstalled == isInstalled)&&(identical(other.isSystemTitle, isSystemTitle) || other.isSystemTitle == isSystemTitle)&&(identical(other.isVisibleSystemTitle, isVisibleSystemTitle) || other.isVisibleSystemTitle == isVisibleSystemTitle)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.iconPath, iconPath) || other.iconPath == iconPath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,description,path,titleId,company,regions,isInstalled,isSystemTitle,isVisibleSystemTitle,filename,iconPath);
}

@override
String toString() {
    return 'Game(title: $title, description: $description, path: $path, titleId: $titleId, company: $company, regions: $regions, isInstalled: $isInstalled, isSystemTitle: $isSystemTitle, isVisibleSystemTitle: $isVisibleSystemTitle, filename: $filename, iconPath: $iconPath)';
}


}

/// @nodoc
abstract mixin class _$GameCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$GameCopyWith(_Game value, $Res Function(_Game) _then) = __$GameCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, String path, int titleId, String company, String regions, bool isInstalled, bool isSystemTitle, bool isVisibleSystemTitle, String filename, String? iconPath
});




}
/// @nodoc
class __$GameCopyWithImpl<$Res>
    implements _$GameCopyWith<$Res> {
  __$GameCopyWithImpl(this._self, this._then);

  final _Game _self;
  final $Res Function(_Game) _then;

/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? path = null,Object? titleId = null,Object? company = null,Object? regions = null,Object? isInstalled = null,Object? isSystemTitle = null,Object? isVisibleSystemTitle = null,Object? filename = null,Object? iconPath = freezed,}) {
  return _then(_Game(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,titleId: null == titleId ? _self.titleId : titleId // ignore: cast_nullable_to_non_nullable
as int,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,regions: null == regions ? _self.regions : regions // ignore: cast_nullable_to_non_nullable
as String,isInstalled: null == isInstalled ? _self.isInstalled : isInstalled // ignore: cast_nullable_to_non_nullable
as bool,isSystemTitle: null == isSystemTitle ? _self.isSystemTitle : isSystemTitle // ignore: cast_nullable_to_non_nullable
as bool,isVisibleSystemTitle: null == isVisibleSystemTitle ? _self.isVisibleSystemTitle : isVisibleSystemTitle // ignore: cast_nullable_to_non_nullable
as bool,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,iconPath: freezed == iconPath ? _self.iconPath : iconPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
