// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoriteState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoriteState()';
}


}

/// @nodoc
class $FavoriteStateCopyWith<$Res>  {
$FavoriteStateCopyWith(FavoriteState _, $Res Function(FavoriteState) __);
}


/// Adds pattern-matching-related methods to [FavoriteState].
extension FavoriteStatePatterns on FavoriteState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FavoriteInitial value)?  initial,TResult Function( FavoriteLoading value)?  loading,TResult Function( FavoriteLoaded value)?  loaded,TResult Function( FavoriteEmpty value)?  empty,TResult Function( FavoriteError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FavoriteInitial() when initial != null:
return initial(_that);case FavoriteLoading() when loading != null:
return loading(_that);case FavoriteLoaded() when loaded != null:
return loaded(_that);case FavoriteEmpty() when empty != null:
return empty(_that);case FavoriteError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FavoriteInitial value)  initial,required TResult Function( FavoriteLoading value)  loading,required TResult Function( FavoriteLoaded value)  loaded,required TResult Function( FavoriteEmpty value)  empty,required TResult Function( FavoriteError value)  error,}){
final _that = this;
switch (_that) {
case FavoriteInitial():
return initial(_that);case FavoriteLoading():
return loading(_that);case FavoriteLoaded():
return loaded(_that);case FavoriteEmpty():
return empty(_that);case FavoriteError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FavoriteInitial value)?  initial,TResult? Function( FavoriteLoading value)?  loading,TResult? Function( FavoriteLoaded value)?  loaded,TResult? Function( FavoriteEmpty value)?  empty,TResult? Function( FavoriteError value)?  error,}){
final _that = this;
switch (_that) {
case FavoriteInitial() when initial != null:
return initial(_that);case FavoriteLoading() when loading != null:
return loading(_that);case FavoriteLoaded() when loaded != null:
return loaded(_that);case FavoriteEmpty() when empty != null:
return empty(_that);case FavoriteError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ApartmentModel> apartments)?  loaded,TResult Function()?  empty,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FavoriteInitial() when initial != null:
return initial();case FavoriteLoading() when loading != null:
return loading();case FavoriteLoaded() when loaded != null:
return loaded(_that.apartments);case FavoriteEmpty() when empty != null:
return empty();case FavoriteError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ApartmentModel> apartments)  loaded,required TResult Function()  empty,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case FavoriteInitial():
return initial();case FavoriteLoading():
return loading();case FavoriteLoaded():
return loaded(_that.apartments);case FavoriteEmpty():
return empty();case FavoriteError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ApartmentModel> apartments)?  loaded,TResult? Function()?  empty,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case FavoriteInitial() when initial != null:
return initial();case FavoriteLoading() when loading != null:
return loading();case FavoriteLoaded() when loaded != null:
return loaded(_that.apartments);case FavoriteEmpty() when empty != null:
return empty();case FavoriteError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class FavoriteInitial implements FavoriteState {
  const FavoriteInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoriteState.initial()';
}


}




/// @nodoc


class FavoriteLoading implements FavoriteState {
  const FavoriteLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoriteState.loading()';
}


}




/// @nodoc


class FavoriteLoaded implements FavoriteState {
  const FavoriteLoaded(final  List<ApartmentModel> apartments): _apartments = apartments;
  

 final  List<ApartmentModel> _apartments;
 List<ApartmentModel> get apartments {
  if (_apartments is EqualUnmodifiableListView) return _apartments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_apartments);
}


/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteLoadedCopyWith<FavoriteLoaded> get copyWith => _$FavoriteLoadedCopyWithImpl<FavoriteLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteLoaded&&const DeepCollectionEquality().equals(other._apartments, _apartments));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_apartments));

@override
String toString() {
  return 'FavoriteState.loaded(apartments: $apartments)';
}


}

/// @nodoc
abstract mixin class $FavoriteLoadedCopyWith<$Res> implements $FavoriteStateCopyWith<$Res> {
  factory $FavoriteLoadedCopyWith(FavoriteLoaded value, $Res Function(FavoriteLoaded) _then) = _$FavoriteLoadedCopyWithImpl;
@useResult
$Res call({
 List<ApartmentModel> apartments
});




}
/// @nodoc
class _$FavoriteLoadedCopyWithImpl<$Res>
    implements $FavoriteLoadedCopyWith<$Res> {
  _$FavoriteLoadedCopyWithImpl(this._self, this._then);

  final FavoriteLoaded _self;
  final $Res Function(FavoriteLoaded) _then;

/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? apartments = null,}) {
  return _then(FavoriteLoaded(
null == apartments ? _self._apartments : apartments // ignore: cast_nullable_to_non_nullable
as List<ApartmentModel>,
  ));
}


}

/// @nodoc


class FavoriteEmpty implements FavoriteState {
  const FavoriteEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FavoriteState.empty()';
}


}




/// @nodoc


class FavoriteError implements FavoriteState {
  const FavoriteError(this.message);
  

 final  String message;

/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteErrorCopyWith<FavoriteError> get copyWith => _$FavoriteErrorCopyWithImpl<FavoriteError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FavoriteState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $FavoriteErrorCopyWith<$Res> implements $FavoriteStateCopyWith<$Res> {
  factory $FavoriteErrorCopyWith(FavoriteError value, $Res Function(FavoriteError) _then) = _$FavoriteErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FavoriteErrorCopyWithImpl<$Res>
    implements $FavoriteErrorCopyWith<$Res> {
  _$FavoriteErrorCopyWithImpl(this._self, this._then);

  final FavoriteError _self;
  final $Res Function(FavoriteError) _then;

/// Create a copy of FavoriteState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(FavoriteError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
