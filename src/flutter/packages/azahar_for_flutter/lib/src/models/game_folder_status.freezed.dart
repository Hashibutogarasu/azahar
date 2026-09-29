// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_folder_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameFolderStatus {

 bool get app; bool get save; bool get updates; bool get dlc; bool get extra; bool get textures; bool get mods;
/// Create a copy of GameFolderStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameFolderStatusCopyWith<GameFolderStatus> get copyWith => _$GameFolderStatusCopyWithImpl<GameFolderStatus>(this as GameFolderStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GameFolderStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameFolderStatus&&(identical(other.app, _this.app) || other.app == _this.app)&&(identical(other.save, _this.save) || other.save == _this.save)&&(identical(other.updates, _this.updates) || other.updates == _this.updates)&&(identical(other.dlc, _this.dlc) || other.dlc == _this.dlc)&&(identical(other.extra, _this.extra) || other.extra == _this.extra)&&(identical(other.textures, _this.textures) || other.textures == _this.textures)&&(identical(other.mods, _this.mods) || other.mods == _this.mods));
}


@override
int get hashCode {
  final _this = this as GameFolderStatus;
  return Object.hash(runtimeType,_this.app,_this.save,_this.updates,_this.dlc,_this.extra,_this.textures,_this.mods);
}

@override
String toString() {
  final _this = this as GameFolderStatus;
  return 'GameFolderStatus(app: ${_this.app}, save: ${_this.save}, updates: ${_this.updates}, dlc: ${_this.dlc}, extra: ${_this.extra}, textures: ${_this.textures}, mods: ${_this.mods})';
}


}

/// @nodoc
abstract mixin class $GameFolderStatusCopyWith<$Res>  {
  factory $GameFolderStatusCopyWith(GameFolderStatus value, $Res Function(GameFolderStatus) _then) = _$GameFolderStatusCopyWithImpl;
@useResult
$Res call({
 bool app, bool save, bool updates, bool dlc, bool extra, bool textures, bool mods
});




}
/// @nodoc
class _$GameFolderStatusCopyWithImpl<$Res>
    implements $GameFolderStatusCopyWith<$Res> {
  _$GameFolderStatusCopyWithImpl(this._self, this._then);

  final GameFolderStatus _self;
  final $Res Function(GameFolderStatus) _then;

/// Create a copy of GameFolderStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? app = null,Object? save = null,Object? updates = null,Object? dlc = null,Object? extra = null,Object? textures = null,Object? mods = null,}) {
  return _then(GameFolderStatus(
app: null == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as bool,save: null == save ? _self.save : save // ignore: cast_nullable_to_non_nullable
as bool,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as bool,dlc: null == dlc ? _self.dlc : dlc // ignore: cast_nullable_to_non_nullable
as bool,extra: null == extra ? _self.extra : extra // ignore: cast_nullable_to_non_nullable
as bool,textures: null == textures ? _self.textures : textures // ignore: cast_nullable_to_non_nullable
as bool,mods: null == mods ? _self.mods : mods // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GameFolderStatus].
extension GameFolderStatusPatterns on GameFolderStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameFolderStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameFolderStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameFolderStatus value)  $default,){
final _that = this;
switch (_that) {
case _GameFolderStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameFolderStatus value)?  $default,){
final _that = this;
switch (_that) {
case _GameFolderStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool app,  bool save,  bool updates,  bool dlc,  bool extra,  bool textures,  bool mods)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameFolderStatus() when $default != null:
return $default(_that.app,_that.save,_that.updates,_that.dlc,_that.extra,_that.textures,_that.mods);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool app,  bool save,  bool updates,  bool dlc,  bool extra,  bool textures,  bool mods)  $default,) {final _that = this;
switch (_that) {
case _GameFolderStatus():
return $default(_that.app,_that.save,_that.updates,_that.dlc,_that.extra,_that.textures,_that.mods);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool app,  bool save,  bool updates,  bool dlc,  bool extra,  bool textures,  bool mods)?  $default,) {final _that = this;
switch (_that) {
case _GameFolderStatus() when $default != null:
return $default(_that.app,_that.save,_that.updates,_that.dlc,_that.extra,_that.textures,_that.mods);case _:
  return null;

}
}

}

/// @nodoc


class _GameFolderStatus implements GameFolderStatus {
  const _GameFolderStatus({required this.app, required this.save, required this.updates, required this.dlc, required this.extra, required this.textures, required this.mods});
  

@override final  bool app;
@override final  bool save;
@override final  bool updates;
@override final  bool dlc;
@override final  bool extra;
@override final  bool textures;
@override final  bool mods;

/// Create a copy of GameFolderStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameFolderStatusCopyWith<_GameFolderStatus> get copyWith => __$GameFolderStatusCopyWithImpl<_GameFolderStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameFolderStatus&&(identical(other.app, app) || other.app == app)&&(identical(other.save, save) || other.save == save)&&(identical(other.updates, updates) || other.updates == updates)&&(identical(other.dlc, dlc) || other.dlc == dlc)&&(identical(other.extra, extra) || other.extra == extra)&&(identical(other.textures, textures) || other.textures == textures)&&(identical(other.mods, mods) || other.mods == mods));
}


@override
int get hashCode {
    return Object.hash(runtimeType,app,save,updates,dlc,extra,textures,mods);
}

@override
String toString() {
    return 'GameFolderStatus(app: $app, save: $save, updates: $updates, dlc: $dlc, extra: $extra, textures: $textures, mods: $mods)';
}


}

/// @nodoc
abstract mixin class _$GameFolderStatusCopyWith<$Res> implements $GameFolderStatusCopyWith<$Res> {
  factory _$GameFolderStatusCopyWith(_GameFolderStatus value, $Res Function(_GameFolderStatus) _then) = __$GameFolderStatusCopyWithImpl;
@override @useResult
$Res call({
 bool app, bool save, bool updates, bool dlc, bool extra, bool textures, bool mods
});




}
/// @nodoc
class __$GameFolderStatusCopyWithImpl<$Res>
    implements _$GameFolderStatusCopyWith<$Res> {
  __$GameFolderStatusCopyWithImpl(this._self, this._then);

  final _GameFolderStatus _self;
  final $Res Function(_GameFolderStatus) _then;

/// Create a copy of GameFolderStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? app = null,Object? save = null,Object? updates = null,Object? dlc = null,Object? extra = null,Object? textures = null,Object? mods = null,}) {
  return _then(_GameFolderStatus(
app: null == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as bool,save: null == save ? _self.save : save // ignore: cast_nullable_to_non_nullable
as bool,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as bool,dlc: null == dlc ? _self.dlc : dlc // ignore: cast_nullable_to_non_nullable
as bool,extra: null == extra ? _self.extra : extra // ignore: cast_nullable_to_non_nullable
as bool,textures: null == textures ? _self.textures : textures // ignore: cast_nullable_to_non_nullable
as bool,mods: null == mods ? _self.mods : mods // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
