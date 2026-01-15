// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState()';
}


}

/// @nodoc
class $ProfileStateCopyWith<$Res>  {
$ProfileStateCopyWith(ProfileState _, $Res Function(ProfileState) __);
}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _LoadInProgress value)?  loadInProgress,TResult Function( _LoadSuccess value)?  loadSuccess,TResult Function( _LoadFailure value)?  loadFailure,TResult Function( _UpdateInProgress value)?  updateInProgress,TResult Function( _UpdateSuccess value)?  updateSuccess,TResult Function( _UpdateFailure value)?  updateFailure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that);case _LoadSuccess() when loadSuccess != null:
return loadSuccess(_that);case _LoadFailure() when loadFailure != null:
return loadFailure(_that);case _UpdateInProgress() when updateInProgress != null:
return updateInProgress(_that);case _UpdateSuccess() when updateSuccess != null:
return updateSuccess(_that);case _UpdateFailure() when updateFailure != null:
return updateFailure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _LoadInProgress value)  loadInProgress,required TResult Function( _LoadSuccess value)  loadSuccess,required TResult Function( _LoadFailure value)  loadFailure,required TResult Function( _UpdateInProgress value)  updateInProgress,required TResult Function( _UpdateSuccess value)  updateSuccess,required TResult Function( _UpdateFailure value)  updateFailure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _LoadInProgress():
return loadInProgress(_that);case _LoadSuccess():
return loadSuccess(_that);case _LoadFailure():
return loadFailure(_that);case _UpdateInProgress():
return updateInProgress(_that);case _UpdateSuccess():
return updateSuccess(_that);case _UpdateFailure():
return updateFailure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _LoadInProgress value)?  loadInProgress,TResult? Function( _LoadSuccess value)?  loadSuccess,TResult? Function( _LoadFailure value)?  loadFailure,TResult? Function( _UpdateInProgress value)?  updateInProgress,TResult? Function( _UpdateSuccess value)?  updateSuccess,TResult? Function( _UpdateFailure value)?  updateFailure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _LoadInProgress() when loadInProgress != null:
return loadInProgress(_that);case _LoadSuccess() when loadSuccess != null:
return loadSuccess(_that);case _LoadFailure() when loadFailure != null:
return loadFailure(_that);case _UpdateInProgress() when updateInProgress != null:
return updateInProgress(_that);case _UpdateSuccess() when updateSuccess != null:
return updateSuccess(_that);case _UpdateFailure() when updateFailure != null:
return updateFailure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loadInProgress,TResult Function( UserModel user)?  loadSuccess,TResult Function( String message)?  loadFailure,TResult Function()?  updateInProgress,TResult Function( UserModel updatedUser)?  updateSuccess,TResult Function( String message)?  updateFailure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _LoadInProgress() when loadInProgress != null:
return loadInProgress();case _LoadSuccess() when loadSuccess != null:
return loadSuccess(_that.user);case _LoadFailure() when loadFailure != null:
return loadFailure(_that.message);case _UpdateInProgress() when updateInProgress != null:
return updateInProgress();case _UpdateSuccess() when updateSuccess != null:
return updateSuccess(_that.updatedUser);case _UpdateFailure() when updateFailure != null:
return updateFailure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loadInProgress,required TResult Function( UserModel user)  loadSuccess,required TResult Function( String message)  loadFailure,required TResult Function()  updateInProgress,required TResult Function( UserModel updatedUser)  updateSuccess,required TResult Function( String message)  updateFailure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _LoadInProgress():
return loadInProgress();case _LoadSuccess():
return loadSuccess(_that.user);case _LoadFailure():
return loadFailure(_that.message);case _UpdateInProgress():
return updateInProgress();case _UpdateSuccess():
return updateSuccess(_that.updatedUser);case _UpdateFailure():
return updateFailure(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loadInProgress,TResult? Function( UserModel user)?  loadSuccess,TResult? Function( String message)?  loadFailure,TResult? Function()?  updateInProgress,TResult? Function( UserModel updatedUser)?  updateSuccess,TResult? Function( String message)?  updateFailure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _LoadInProgress() when loadInProgress != null:
return loadInProgress();case _LoadSuccess() when loadSuccess != null:
return loadSuccess(_that.user);case _LoadFailure() when loadFailure != null:
return loadFailure(_that.message);case _UpdateInProgress() when updateInProgress != null:
return updateInProgress();case _UpdateSuccess() when updateSuccess != null:
return updateSuccess(_that.updatedUser);case _UpdateFailure() when updateFailure != null:
return updateFailure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ProfileState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.initial()';
}


}




/// @nodoc


class _LoadInProgress implements ProfileState {
  const _LoadInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.loadInProgress()';
}


}




/// @nodoc


class _LoadSuccess implements ProfileState {
  const _LoadSuccess(this.user);
  

 final  UserModel user;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadSuccessCopyWith<_LoadSuccess> get copyWith => __$LoadSuccessCopyWithImpl<_LoadSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadSuccess&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'ProfileState.loadSuccess(user: $user)';
}


}

/// @nodoc
abstract mixin class _$LoadSuccessCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$LoadSuccessCopyWith(_LoadSuccess value, $Res Function(_LoadSuccess) _then) = __$LoadSuccessCopyWithImpl;
@useResult
$Res call({
 UserModel user
});




}
/// @nodoc
class __$LoadSuccessCopyWithImpl<$Res>
    implements _$LoadSuccessCopyWith<$Res> {
  __$LoadSuccessCopyWithImpl(this._self, this._then);

  final _LoadSuccess _self;
  final $Res Function(_LoadSuccess) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(_LoadSuccess(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}


}

/// @nodoc


class _LoadFailure implements ProfileState {
  const _LoadFailure(this.message);
  

 final  String message;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadFailureCopyWith<_LoadFailure> get copyWith => __$LoadFailureCopyWithImpl<_LoadFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ProfileState.loadFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$LoadFailureCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$LoadFailureCopyWith(_LoadFailure value, $Res Function(_LoadFailure) _then) = __$LoadFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$LoadFailureCopyWithImpl<$Res>
    implements _$LoadFailureCopyWith<$Res> {
  __$LoadFailureCopyWithImpl(this._self, this._then);

  final _LoadFailure _self;
  final $Res Function(_LoadFailure) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_LoadFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UpdateInProgress implements ProfileState {
  const _UpdateInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.updateInProgress()';
}


}




/// @nodoc


class _UpdateSuccess implements ProfileState {
  const _UpdateSuccess(this.updatedUser);
  

 final  UserModel updatedUser;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateSuccessCopyWith<_UpdateSuccess> get copyWith => __$UpdateSuccessCopyWithImpl<_UpdateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateSuccess&&(identical(other.updatedUser, updatedUser) || other.updatedUser == updatedUser));
}


@override
int get hashCode => Object.hash(runtimeType,updatedUser);

@override
String toString() {
  return 'ProfileState.updateSuccess(updatedUser: $updatedUser)';
}


}

/// @nodoc
abstract mixin class _$UpdateSuccessCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$UpdateSuccessCopyWith(_UpdateSuccess value, $Res Function(_UpdateSuccess) _then) = __$UpdateSuccessCopyWithImpl;
@useResult
$Res call({
 UserModel updatedUser
});




}
/// @nodoc
class __$UpdateSuccessCopyWithImpl<$Res>
    implements _$UpdateSuccessCopyWith<$Res> {
  __$UpdateSuccessCopyWithImpl(this._self, this._then);

  final _UpdateSuccess _self;
  final $Res Function(_UpdateSuccess) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? updatedUser = null,}) {
  return _then(_UpdateSuccess(
null == updatedUser ? _self.updatedUser : updatedUser // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}


}

/// @nodoc


class _UpdateFailure implements ProfileState {
  const _UpdateFailure(this.message);
  

 final  String message;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateFailureCopyWith<_UpdateFailure> get copyWith => __$UpdateFailureCopyWithImpl<_UpdateFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ProfileState.updateFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$UpdateFailureCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$UpdateFailureCopyWith(_UpdateFailure value, $Res Function(_UpdateFailure) _then) = __$UpdateFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$UpdateFailureCopyWithImpl<$Res>
    implements _$UpdateFailureCopyWith<$Res> {
  __$UpdateFailureCopyWithImpl(this._self, this._then);

  final _UpdateFailure _self;
  final $Res Function(_UpdateFailure) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_UpdateFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
