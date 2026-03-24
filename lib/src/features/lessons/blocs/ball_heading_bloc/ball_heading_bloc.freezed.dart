// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ball_heading_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BallHeadingEvent {

 BallSlideLessonContent get content;
/// Create a copy of BallHeadingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BallHeadingEventCopyWith<BallHeadingEvent> get copyWith => _$BallHeadingEventCopyWithImpl<BallHeadingEvent>(this as BallHeadingEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BallHeadingEvent&&const DeepCollectionEquality().equals(other.content, content));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content));

@override
String toString() {
  return 'BallHeadingEvent(content: $content)';
}


}

/// @nodoc
abstract mixin class $BallHeadingEventCopyWith<$Res>  {
  factory $BallHeadingEventCopyWith(BallHeadingEvent value, $Res Function(BallHeadingEvent) _then) = _$BallHeadingEventCopyWithImpl;
@useResult
$Res call({
 BallSlideLessonContent content
});




}
/// @nodoc
class _$BallHeadingEventCopyWithImpl<$Res>
    implements $BallHeadingEventCopyWith<$Res> {
  _$BallHeadingEventCopyWithImpl(this._self, this._then);

  final BallHeadingEvent _self;
  final $Res Function(BallHeadingEvent) _then;

/// Create a copy of BallHeadingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as BallSlideLessonContent,
  ));
}

}


/// Adds pattern-matching-related methods to [BallHeadingEvent].
extension BallHeadingEventPatterns on BallHeadingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BallSlideLessonContent content)?  started,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BallSlideLessonContent content)  started,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BallSlideLessonContent content)?  started,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements BallHeadingEvent {
  const _Started(this.content);
  

@override final  BallSlideLessonContent content;

/// Create a copy of BallHeadingEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
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
  return 'BallHeadingEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $BallHeadingEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@override @useResult
$Res call({
 BallSlideLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of BallHeadingEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as BallSlideLessonContent,
  ));
}


}

/// @nodoc
mixin _$BallHeadingState {

 BallSlideLessonContent? get content; bool get isAllAudioCompleted; bool get isComplete;
/// Create a copy of BallHeadingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BallHeadingStateCopyWith<BallHeadingState> get copyWith => _$BallHeadingStateCopyWithImpl<BallHeadingState>(this as BallHeadingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BallHeadingState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.isAllAudioCompleted, isAllAudioCompleted) || other.isAllAudioCompleted == isAllAudioCompleted)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),isAllAudioCompleted,isComplete);

@override
String toString() {
  return 'BallHeadingState(content: $content, isAllAudioCompleted: $isAllAudioCompleted, isComplete: $isComplete)';
}


}

/// @nodoc
abstract mixin class $BallHeadingStateCopyWith<$Res>  {
  factory $BallHeadingStateCopyWith(BallHeadingState value, $Res Function(BallHeadingState) _then) = _$BallHeadingStateCopyWithImpl;
@useResult
$Res call({
 BallSlideLessonContent? content, bool isAllAudioCompleted, bool isComplete
});




}
/// @nodoc
class _$BallHeadingStateCopyWithImpl<$Res>
    implements $BallHeadingStateCopyWith<$Res> {
  _$BallHeadingStateCopyWithImpl(this._self, this._then);

  final BallHeadingState _self;
  final $Res Function(BallHeadingState) _then;

/// Create a copy of BallHeadingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? isAllAudioCompleted = null,Object? isComplete = null,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as BallSlideLessonContent?,isAllAudioCompleted: null == isAllAudioCompleted ? _self.isAllAudioCompleted : isAllAudioCompleted // ignore: cast_nullable_to_non_nullable
as bool,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BallHeadingState].
extension BallHeadingStatePatterns on BallHeadingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BallHeadingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BallHeadingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BallHeadingState value)  $default,){
final _that = this;
switch (_that) {
case _BallHeadingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BallHeadingState value)?  $default,){
final _that = this;
switch (_that) {
case _BallHeadingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BallSlideLessonContent? content,  bool isAllAudioCompleted,  bool isComplete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BallHeadingState() when $default != null:
return $default(_that.content,_that.isAllAudioCompleted,_that.isComplete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BallSlideLessonContent? content,  bool isAllAudioCompleted,  bool isComplete)  $default,) {final _that = this;
switch (_that) {
case _BallHeadingState():
return $default(_that.content,_that.isAllAudioCompleted,_that.isComplete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BallSlideLessonContent? content,  bool isAllAudioCompleted,  bool isComplete)?  $default,) {final _that = this;
switch (_that) {
case _BallHeadingState() when $default != null:
return $default(_that.content,_that.isAllAudioCompleted,_that.isComplete);case _:
  return null;

}
}

}

/// @nodoc


class _BallHeadingState implements BallHeadingState {
  const _BallHeadingState({this.content, this.isAllAudioCompleted = false, this.isComplete = false});
  

@override final  BallSlideLessonContent? content;
@override@JsonKey() final  bool isAllAudioCompleted;
@override@JsonKey() final  bool isComplete;

/// Create a copy of BallHeadingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BallHeadingStateCopyWith<_BallHeadingState> get copyWith => __$BallHeadingStateCopyWithImpl<_BallHeadingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BallHeadingState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.isAllAudioCompleted, isAllAudioCompleted) || other.isAllAudioCompleted == isAllAudioCompleted)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),isAllAudioCompleted,isComplete);

@override
String toString() {
  return 'BallHeadingState(content: $content, isAllAudioCompleted: $isAllAudioCompleted, isComplete: $isComplete)';
}


}

/// @nodoc
abstract mixin class _$BallHeadingStateCopyWith<$Res> implements $BallHeadingStateCopyWith<$Res> {
  factory _$BallHeadingStateCopyWith(_BallHeadingState value, $Res Function(_BallHeadingState) _then) = __$BallHeadingStateCopyWithImpl;
@override @useResult
$Res call({
 BallSlideLessonContent? content, bool isAllAudioCompleted, bool isComplete
});




}
/// @nodoc
class __$BallHeadingStateCopyWithImpl<$Res>
    implements _$BallHeadingStateCopyWith<$Res> {
  __$BallHeadingStateCopyWithImpl(this._self, this._then);

  final _BallHeadingState _self;
  final $Res Function(_BallHeadingState) _then;

/// Create a copy of BallHeadingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? isAllAudioCompleted = null,Object? isComplete = null,}) {
  return _then(_BallHeadingState(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as BallSlideLessonContent?,isAllAudioCompleted: null == isAllAudioCompleted ? _self.isAllAudioCompleted : isAllAudioCompleted // ignore: cast_nullable_to_non_nullable
as bool,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
