// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tap_to_change_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TapToChangeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToChangeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TapToChangeEvent()';
}


}

/// @nodoc
class $TapToChangeEventCopyWith<$Res>  {
$TapToChangeEventCopyWith(TapToChangeEvent _, $Res Function(TapToChangeEvent) __);
}


/// Adds pattern-matching-related methods to [TapToChangeEvent].
extension TapToChangeEventPatterns on TapToChangeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _AudioCompleted value)?  audioCompleted,TResult Function( _Tapped value)?  tapped,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that);case _Tapped() when tapped != null:
return tapped(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _AudioCompleted value)  audioCompleted,required TResult Function( _Tapped value)  tapped,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _AudioCompleted():
return audioCompleted(_that);case _Tapped():
return tapped(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _AudioCompleted value)?  audioCompleted,TResult? Function( _Tapped value)?  tapped,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that);case _Tapped() when tapped != null:
return tapped(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TapToChangeLessonContent content)?  started,TResult Function()?  audioCompleted,TResult Function( Offset point)?  tapped,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _AudioCompleted() when audioCompleted != null:
return audioCompleted();case _Tapped() when tapped != null:
return tapped(_that.point);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TapToChangeLessonContent content)  started,required TResult Function()  audioCompleted,required TResult Function( Offset point)  tapped,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _AudioCompleted():
return audioCompleted();case _Tapped():
return tapped(_that.point);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TapToChangeLessonContent content)?  started,TResult? Function()?  audioCompleted,TResult? Function( Offset point)?  tapped,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _AudioCompleted() when audioCompleted != null:
return audioCompleted();case _Tapped() when tapped != null:
return tapped(_that.point);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements TapToChangeEvent {
  const _Started(this.content);
  

 final  TapToChangeLessonContent content;

/// Create a copy of TapToChangeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&const DeepCollectionEquality().equals(other.content, content));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content));

@override
String toString() {
  return 'TapToChangeEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $TapToChangeEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 TapToChangeLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of TapToChangeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToChangeLessonContent,
  ));
}


}

/// @nodoc


class _AudioCompleted implements TapToChangeEvent {
  const _AudioCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TapToChangeEvent.audioCompleted()';
}


}




/// @nodoc


class _Tapped implements TapToChangeEvent {
  const _Tapped(this.point);
  

 final  Offset point;

/// Create a copy of TapToChangeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TappedCopyWith<_Tapped> get copyWith => __$TappedCopyWithImpl<_Tapped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tapped&&(identical(other.point, point) || other.point == point));
}


@override
int get hashCode => Object.hash(runtimeType,point);

@override
String toString() {
  return 'TapToChangeEvent.tapped(point: $point)';
}


}

/// @nodoc
abstract mixin class _$TappedCopyWith<$Res> implements $TapToChangeEventCopyWith<$Res> {
  factory _$TappedCopyWith(_Tapped value, $Res Function(_Tapped) _then) = __$TappedCopyWithImpl;
@useResult
$Res call({
 Offset point
});




}
/// @nodoc
class __$TappedCopyWithImpl<$Res>
    implements _$TappedCopyWith<$Res> {
  __$TappedCopyWithImpl(this._self, this._then);

  final _Tapped _self;
  final $Res Function(_Tapped) _then;

/// Create a copy of TapToChangeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? point = null,}) {
  return _then(_Tapped(
null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as Offset,
  ));
}


}

/// @nodoc
mixin _$TapToChangeState {

 TapToChangeStatus get status; TapToChangeLessonContent? get content; Offset? get tapPosition;
/// Create a copy of TapToChangeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TapToChangeStateCopyWith<TapToChangeState> get copyWith => _$TapToChangeStateCopyWithImpl<TapToChangeState>(this as TapToChangeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToChangeState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.tapPosition, tapPosition) || other.tapPosition == tapPosition));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(content),tapPosition);

@override
String toString() {
  return 'TapToChangeState(status: $status, content: $content, tapPosition: $tapPosition)';
}


}

/// @nodoc
abstract mixin class $TapToChangeStateCopyWith<$Res>  {
  factory $TapToChangeStateCopyWith(TapToChangeState value, $Res Function(TapToChangeState) _then) = _$TapToChangeStateCopyWithImpl;
@useResult
$Res call({
 TapToChangeStatus status, TapToChangeLessonContent? content, Offset? tapPosition
});




}
/// @nodoc
class _$TapToChangeStateCopyWithImpl<$Res>
    implements $TapToChangeStateCopyWith<$Res> {
  _$TapToChangeStateCopyWithImpl(this._self, this._then);

  final TapToChangeState _self;
  final $Res Function(TapToChangeState) _then;

/// Create a copy of TapToChangeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? content = freezed,Object? tapPosition = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TapToChangeStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToChangeLessonContent?,tapPosition: freezed == tapPosition ? _self.tapPosition : tapPosition // ignore: cast_nullable_to_non_nullable
as Offset?,
  ));
}

}


/// Adds pattern-matching-related methods to [TapToChangeState].
extension TapToChangeStatePatterns on TapToChangeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Initial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Initial value)  $default,){
final _that = this;
switch (_that) {
case _Initial():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Initial value)?  $default,){
final _that = this;
switch (_that) {
case _Initial() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TapToChangeStatus status,  TapToChangeLessonContent? content,  Offset? tapPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when $default != null:
return $default(_that.status,_that.content,_that.tapPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TapToChangeStatus status,  TapToChangeLessonContent? content,  Offset? tapPosition)  $default,) {final _that = this;
switch (_that) {
case _Initial():
return $default(_that.status,_that.content,_that.tapPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TapToChangeStatus status,  TapToChangeLessonContent? content,  Offset? tapPosition)?  $default,) {final _that = this;
switch (_that) {
case _Initial() when $default != null:
return $default(_that.status,_that.content,_that.tapPosition);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements TapToChangeState {
  const _Initial({this.status = TapToChangeStatus.initial, this.content, this.tapPosition});
  

@override@JsonKey() final  TapToChangeStatus status;
@override final  TapToChangeLessonContent? content;
@override final  Offset? tapPosition;

/// Create a copy of TapToChangeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.tapPosition, tapPosition) || other.tapPosition == tapPosition));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(content),tapPosition);

@override
String toString() {
  return 'TapToChangeState(status: $status, content: $content, tapPosition: $tapPosition)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $TapToChangeStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 TapToChangeStatus status, TapToChangeLessonContent? content, Offset? tapPosition
});




}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of TapToChangeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? content = freezed,Object? tapPosition = freezed,}) {
  return _then(_Initial(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TapToChangeStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToChangeLessonContent?,tapPosition: freezed == tapPosition ? _self.tapPosition : tapPosition // ignore: cast_nullable_to_non_nullable
as Offset?,
  ));
}


}

// dart format on
