// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tap_the_button_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TapTheButtonEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapTheButtonEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TapTheButtonEvent()';
}


}

/// @nodoc
class $TapTheButtonEventCopyWith<$Res>  {
$TapTheButtonEventCopyWith(TapTheButtonEvent _, $Res Function(TapTheButtonEvent) __);
}


/// Adds pattern-matching-related methods to [TapTheButtonEvent].
extension TapTheButtonEventPatterns on TapTheButtonEvent {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TapTheButtonLessonContent content)?  started,TResult Function( bool isCompleted)?  audioCompleted,TResult Function()?  tapped,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that.isCompleted);case _Tapped() when tapped != null:
return tapped();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TapTheButtonLessonContent content)  started,required TResult Function( bool isCompleted)  audioCompleted,required TResult Function()  tapped,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _AudioCompleted():
return audioCompleted(_that.isCompleted);case _Tapped():
return tapped();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TapTheButtonLessonContent content)?  started,TResult? Function( bool isCompleted)?  audioCompleted,TResult? Function()?  tapped,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that.isCompleted);case _Tapped() when tapped != null:
return tapped();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements TapTheButtonEvent {
  const _Started(this.content);


 final  TapTheButtonLessonContent content;

/// Create a copy of TapTheButtonEvent
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
  return 'TapTheButtonEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $TapTheButtonEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 TapTheButtonLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of TapTheButtonEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapTheButtonLessonContent,
  ));
}


}

/// @nodoc


class _AudioCompleted implements TapTheButtonEvent {
  const _AudioCompleted(this.isCompleted);


 final  bool isCompleted;

/// Create a copy of TapTheButtonEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioCompletedCopyWith<_AudioCompleted> get copyWith => __$AudioCompletedCopyWithImpl<_AudioCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioCompleted&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,isCompleted);

@override
String toString() {
  return 'TapTheButtonEvent.audioCompleted(isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$AudioCompletedCopyWith<$Res> implements $TapTheButtonEventCopyWith<$Res> {
  factory _$AudioCompletedCopyWith(_AudioCompleted value, $Res Function(_AudioCompleted) _then) = __$AudioCompletedCopyWithImpl;
@useResult
$Res call({
 bool isCompleted
});




}
/// @nodoc
class __$AudioCompletedCopyWithImpl<$Res>
    implements _$AudioCompletedCopyWith<$Res> {
  __$AudioCompletedCopyWithImpl(this._self, this._then);

  final _AudioCompleted _self;
  final $Res Function(_AudioCompleted) _then;

/// Create a copy of TapTheButtonEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isCompleted = null,}) {
  return _then(_AudioCompleted(
null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Tapped implements TapTheButtonEvent {
  const _Tapped();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tapped);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TapTheButtonEvent.tapped()';
}


}




/// @nodoc
mixin _$TapTheButtonState {

 TapTheButtonLessonContent? get content; TapTheButtonStatus get status;
/// Create a copy of TapTheButtonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TapTheButtonStateCopyWith<TapTheButtonState> get copyWith => _$TapTheButtonStateCopyWithImpl<TapTheButtonState>(this as TapTheButtonState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapTheButtonState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),status);

@override
String toString() {
  return 'TapTheButtonState(content: $content, status: $status)';
}


}

/// @nodoc
abstract mixin class $TapTheButtonStateCopyWith<$Res>  {
  factory $TapTheButtonStateCopyWith(TapTheButtonState value, $Res Function(TapTheButtonState) _then) = _$TapTheButtonStateCopyWithImpl;
@useResult
$Res call({
 TapTheButtonLessonContent? content, TapTheButtonStatus status
});




}
/// @nodoc
class _$TapTheButtonStateCopyWithImpl<$Res>
    implements $TapTheButtonStateCopyWith<$Res> {
  _$TapTheButtonStateCopyWithImpl(this._self, this._then);

  final TapTheButtonState _self;
  final $Res Function(TapTheButtonState) _then;

/// Create a copy of TapTheButtonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapTheButtonLessonContent?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TapTheButtonStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [TapTheButtonState].
extension TapTheButtonStatePatterns on TapTheButtonState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TapTheButtonState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TapTheButtonState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TapTheButtonState value)  $default,){
final _that = this;
switch (_that) {
case _TapTheButtonState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TapTheButtonState value)?  $default,){
final _that = this;
switch (_that) {
case _TapTheButtonState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TapTheButtonLessonContent? content,  TapTheButtonStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TapTheButtonState() when $default != null:
return $default(_that.content,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TapTheButtonLessonContent? content,  TapTheButtonStatus status)  $default,) {final _that = this;
switch (_that) {
case _TapTheButtonState():
return $default(_that.content,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TapTheButtonLessonContent? content,  TapTheButtonStatus status)?  $default,) {final _that = this;
switch (_that) {
case _TapTheButtonState() when $default != null:
return $default(_that.content,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _TapTheButtonState extends TapTheButtonState {
  const _TapTheButtonState({this.content, this.status = TapTheButtonStatus.initial}): super._();


@override final  TapTheButtonLessonContent? content;
@override@JsonKey() final  TapTheButtonStatus status;

/// Create a copy of TapTheButtonState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TapTheButtonStateCopyWith<_TapTheButtonState> get copyWith => __$TapTheButtonStateCopyWithImpl<_TapTheButtonState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TapTheButtonState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),status);

@override
String toString() {
  return 'TapTheButtonState(content: $content, status: $status)';
}


}

/// @nodoc
abstract mixin class _$TapTheButtonStateCopyWith<$Res> implements $TapTheButtonStateCopyWith<$Res> {
  factory _$TapTheButtonStateCopyWith(_TapTheButtonState value, $Res Function(_TapTheButtonState) _then) = __$TapTheButtonStateCopyWithImpl;
@override @useResult
$Res call({
 TapTheButtonLessonContent? content, TapTheButtonStatus status
});




}
/// @nodoc
class __$TapTheButtonStateCopyWithImpl<$Res>
    implements _$TapTheButtonStateCopyWith<$Res> {
  __$TapTheButtonStateCopyWithImpl(this._self, this._then);

  final _TapTheButtonState _self;
  final $Res Function(_TapTheButtonState) _then;

/// Create a copy of TapTheButtonState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? status = null,}) {
  return _then(_TapTheButtonState(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapTheButtonLessonContent?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TapTheButtonStatus,
  ));
}


}

// dart format on
