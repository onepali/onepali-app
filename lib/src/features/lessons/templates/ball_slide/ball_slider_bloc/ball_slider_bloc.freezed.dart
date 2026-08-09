// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ball_slider_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BallSliderEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BallSliderEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BallSliderEvent()';
}


}

/// @nodoc
class $BallSliderEventCopyWith<$Res>  {
$BallSliderEventCopyWith(BallSliderEvent _, $Res Function(BallSliderEvent) __);
}


/// Adds pattern-matching-related methods to [BallSliderEvent].
extension BallSliderEventPatterns on BallSliderEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _BallDragged value)?  ballDragged,TResult Function( _BallDragEnded value)?  ballDragEnded,TResult Function( _BallTapped value)?  ballTapped,TResult Function( _CompletionFeedbackCompleted value)?  completionFeedbackCompleted,TResult Function( _PhysicsTick value)?  physicsTick,TResult Function( _BallReset value)?  ballReset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _BallDragged() when ballDragged != null:
return ballDragged(_that);case _BallDragEnded() when ballDragEnded != null:
return ballDragEnded(_that);case _BallTapped() when ballTapped != null:
return ballTapped(_that);case _CompletionFeedbackCompleted() when completionFeedbackCompleted != null:
return completionFeedbackCompleted(_that);case _PhysicsTick() when physicsTick != null:
return physicsTick(_that);case _BallReset() when ballReset != null:
return ballReset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _BallDragged value)  ballDragged,required TResult Function( _BallDragEnded value)  ballDragEnded,required TResult Function( _BallTapped value)  ballTapped,required TResult Function( _CompletionFeedbackCompleted value)  completionFeedbackCompleted,required TResult Function( _PhysicsTick value)  physicsTick,required TResult Function( _BallReset value)  ballReset,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _BallDragged():
return ballDragged(_that);case _BallDragEnded():
return ballDragEnded(_that);case _BallTapped():
return ballTapped(_that);case _CompletionFeedbackCompleted():
return completionFeedbackCompleted(_that);case _PhysicsTick():
return physicsTick(_that);case _BallReset():
return ballReset(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _BallDragged value)?  ballDragged,TResult? Function( _BallDragEnded value)?  ballDragEnded,TResult? Function( _BallTapped value)?  ballTapped,TResult? Function( _CompletionFeedbackCompleted value)?  completionFeedbackCompleted,TResult? Function( _PhysicsTick value)?  physicsTick,TResult? Function( _BallReset value)?  ballReset,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _BallDragged() when ballDragged != null:
return ballDragged(_that);case _BallDragEnded() when ballDragEnded != null:
return ballDragEnded(_that);case _BallTapped() when ballTapped != null:
return ballTapped(_that);case _CompletionFeedbackCompleted() when completionFeedbackCompleted != null:
return completionFeedbackCompleted(_that);case _PhysicsTick() when physicsTick != null:
return physicsTick(_that);case _BallReset() when ballReset != null:
return ballReset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BallSlideLessonContent content)?  started,TResult Function( double delta,  double usableWidth)?  ballDragged,TResult Function( double velocityPx,  double usableWidth)?  ballDragEnded,TResult Function( double tapX,  double trackWidth)?  ballTapped,TResult Function()?  completionFeedbackCompleted,TResult Function()?  physicsTick,TResult Function()?  ballReset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _BallDragged() when ballDragged != null:
return ballDragged(_that.delta,_that.usableWidth);case _BallDragEnded() when ballDragEnded != null:
return ballDragEnded(_that.velocityPx,_that.usableWidth);case _BallTapped() when ballTapped != null:
return ballTapped(_that.tapX,_that.trackWidth);case _CompletionFeedbackCompleted() when completionFeedbackCompleted != null:
return completionFeedbackCompleted();case _PhysicsTick() when physicsTick != null:
return physicsTick();case _BallReset() when ballReset != null:
return ballReset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BallSlideLessonContent content)  started,required TResult Function( double delta,  double usableWidth)  ballDragged,required TResult Function( double velocityPx,  double usableWidth)  ballDragEnded,required TResult Function( double tapX,  double trackWidth)  ballTapped,required TResult Function()  completionFeedbackCompleted,required TResult Function()  physicsTick,required TResult Function()  ballReset,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _BallDragged():
return ballDragged(_that.delta,_that.usableWidth);case _BallDragEnded():
return ballDragEnded(_that.velocityPx,_that.usableWidth);case _BallTapped():
return ballTapped(_that.tapX,_that.trackWidth);case _CompletionFeedbackCompleted():
return completionFeedbackCompleted();case _PhysicsTick():
return physicsTick();case _BallReset():
return ballReset();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BallSlideLessonContent content)?  started,TResult? Function( double delta,  double usableWidth)?  ballDragged,TResult? Function( double velocityPx,  double usableWidth)?  ballDragEnded,TResult? Function( double tapX,  double trackWidth)?  ballTapped,TResult? Function()?  completionFeedbackCompleted,TResult? Function()?  physicsTick,TResult? Function()?  ballReset,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _BallDragged() when ballDragged != null:
return ballDragged(_that.delta,_that.usableWidth);case _BallDragEnded() when ballDragEnded != null:
return ballDragEnded(_that.velocityPx,_that.usableWidth);case _BallTapped() when ballTapped != null:
return ballTapped(_that.tapX,_that.trackWidth);case _CompletionFeedbackCompleted() when completionFeedbackCompleted != null:
return completionFeedbackCompleted();case _PhysicsTick() when physicsTick != null:
return physicsTick();case _BallReset() when ballReset != null:
return ballReset();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements BallSliderEvent {
  const _Started(this.content);
  

 final  BallSlideLessonContent content;

/// Create a copy of BallSliderEvent
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
  return 'BallSliderEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $BallSliderEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
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

/// Create a copy of BallSliderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as BallSlideLessonContent,
  ));
}


}

/// @nodoc


class _BallDragged implements BallSliderEvent {
  const _BallDragged({required this.delta, required this.usableWidth});
  

 final  double delta;
 final  double usableWidth;

/// Create a copy of BallSliderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BallDraggedCopyWith<_BallDragged> get copyWith => __$BallDraggedCopyWithImpl<_BallDragged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BallDragged&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.usableWidth, usableWidth) || other.usableWidth == usableWidth));
}


@override
int get hashCode => Object.hash(runtimeType,delta,usableWidth);

@override
String toString() {
  return 'BallSliderEvent.ballDragged(delta: $delta, usableWidth: $usableWidth)';
}


}

/// @nodoc
abstract mixin class _$BallDraggedCopyWith<$Res> implements $BallSliderEventCopyWith<$Res> {
  factory _$BallDraggedCopyWith(_BallDragged value, $Res Function(_BallDragged) _then) = __$BallDraggedCopyWithImpl;
@useResult
$Res call({
 double delta, double usableWidth
});




}
/// @nodoc
class __$BallDraggedCopyWithImpl<$Res>
    implements _$BallDraggedCopyWith<$Res> {
  __$BallDraggedCopyWithImpl(this._self, this._then);

  final _BallDragged _self;
  final $Res Function(_BallDragged) _then;

/// Create a copy of BallSliderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? delta = null,Object? usableWidth = null,}) {
  return _then(_BallDragged(
delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as double,usableWidth: null == usableWidth ? _self.usableWidth : usableWidth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _BallDragEnded implements BallSliderEvent {
  const _BallDragEnded({required this.velocityPx, required this.usableWidth});
  

 final  double velocityPx;
 final  double usableWidth;

/// Create a copy of BallSliderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BallDragEndedCopyWith<_BallDragEnded> get copyWith => __$BallDragEndedCopyWithImpl<_BallDragEnded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BallDragEnded&&(identical(other.velocityPx, velocityPx) || other.velocityPx == velocityPx)&&(identical(other.usableWidth, usableWidth) || other.usableWidth == usableWidth));
}


@override
int get hashCode => Object.hash(runtimeType,velocityPx,usableWidth);

@override
String toString() {
  return 'BallSliderEvent.ballDragEnded(velocityPx: $velocityPx, usableWidth: $usableWidth)';
}


}

/// @nodoc
abstract mixin class _$BallDragEndedCopyWith<$Res> implements $BallSliderEventCopyWith<$Res> {
  factory _$BallDragEndedCopyWith(_BallDragEnded value, $Res Function(_BallDragEnded) _then) = __$BallDragEndedCopyWithImpl;
@useResult
$Res call({
 double velocityPx, double usableWidth
});




}
/// @nodoc
class __$BallDragEndedCopyWithImpl<$Res>
    implements _$BallDragEndedCopyWith<$Res> {
  __$BallDragEndedCopyWithImpl(this._self, this._then);

  final _BallDragEnded _self;
  final $Res Function(_BallDragEnded) _then;

/// Create a copy of BallSliderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? velocityPx = null,Object? usableWidth = null,}) {
  return _then(_BallDragEnded(
velocityPx: null == velocityPx ? _self.velocityPx : velocityPx // ignore: cast_nullable_to_non_nullable
as double,usableWidth: null == usableWidth ? _self.usableWidth : usableWidth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _BallTapped implements BallSliderEvent {
  const _BallTapped({required this.tapX, required this.trackWidth});
  

 final  double tapX;
 final  double trackWidth;

/// Create a copy of BallSliderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BallTappedCopyWith<_BallTapped> get copyWith => __$BallTappedCopyWithImpl<_BallTapped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BallTapped&&(identical(other.tapX, tapX) || other.tapX == tapX)&&(identical(other.trackWidth, trackWidth) || other.trackWidth == trackWidth));
}


@override
int get hashCode => Object.hash(runtimeType,tapX,trackWidth);

@override
String toString() {
  return 'BallSliderEvent.ballTapped(tapX: $tapX, trackWidth: $trackWidth)';
}


}

/// @nodoc
abstract mixin class _$BallTappedCopyWith<$Res> implements $BallSliderEventCopyWith<$Res> {
  factory _$BallTappedCopyWith(_BallTapped value, $Res Function(_BallTapped) _then) = __$BallTappedCopyWithImpl;
@useResult
$Res call({
 double tapX, double trackWidth
});




}
/// @nodoc
class __$BallTappedCopyWithImpl<$Res>
    implements _$BallTappedCopyWith<$Res> {
  __$BallTappedCopyWithImpl(this._self, this._then);

  final _BallTapped _self;
  final $Res Function(_BallTapped) _then;

/// Create a copy of BallSliderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tapX = null,Object? trackWidth = null,}) {
  return _then(_BallTapped(
tapX: null == tapX ? _self.tapX : tapX // ignore: cast_nullable_to_non_nullable
as double,trackWidth: null == trackWidth ? _self.trackWidth : trackWidth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _CompletionFeedbackCompleted implements BallSliderEvent {
  const _CompletionFeedbackCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompletionFeedbackCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BallSliderEvent.completionFeedbackCompleted()';
}


}




/// @nodoc


class _PhysicsTick implements BallSliderEvent {
  const _PhysicsTick();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhysicsTick);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BallSliderEvent.physicsTick()';
}


}




/// @nodoc


class _BallReset implements BallSliderEvent {
  const _BallReset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BallReset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BallSliderEvent.ballReset()';
}


}




/// @nodoc
mixin _$BallSliderState {

 BallSlideLessonContent? get content; double get value; double get rotationAngle; bool get isComplete; bool get isAnimating; bool get isAllAudioCompleted; bool get completionFeedbackReady;
/// Create a copy of BallSliderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BallSliderStateCopyWith<BallSliderState> get copyWith => _$BallSliderStateCopyWithImpl<BallSliderState>(this as BallSliderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BallSliderState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.value, value) || other.value == value)&&(identical(other.rotationAngle, rotationAngle) || other.rotationAngle == rotationAngle)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.isAnimating, isAnimating) || other.isAnimating == isAnimating)&&(identical(other.isAllAudioCompleted, isAllAudioCompleted) || other.isAllAudioCompleted == isAllAudioCompleted)&&(identical(other.completionFeedbackReady, completionFeedbackReady) || other.completionFeedbackReady == completionFeedbackReady));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),value,rotationAngle,isComplete,isAnimating,isAllAudioCompleted,completionFeedbackReady);

@override
String toString() {
  return 'BallSliderState(content: $content, value: $value, rotationAngle: $rotationAngle, isComplete: $isComplete, isAnimating: $isAnimating, isAllAudioCompleted: $isAllAudioCompleted, completionFeedbackReady: $completionFeedbackReady)';
}


}

/// @nodoc
abstract mixin class $BallSliderStateCopyWith<$Res>  {
  factory $BallSliderStateCopyWith(BallSliderState value, $Res Function(BallSliderState) _then) = _$BallSliderStateCopyWithImpl;
@useResult
$Res call({
 BallSlideLessonContent? content, double value, double rotationAngle, bool isComplete, bool isAnimating, bool isAllAudioCompleted, bool completionFeedbackReady
});




}
/// @nodoc
class _$BallSliderStateCopyWithImpl<$Res>
    implements $BallSliderStateCopyWith<$Res> {
  _$BallSliderStateCopyWithImpl(this._self, this._then);

  final BallSliderState _self;
  final $Res Function(BallSliderState) _then;

/// Create a copy of BallSliderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? value = null,Object? rotationAngle = null,Object? isComplete = null,Object? isAnimating = null,Object? isAllAudioCompleted = null,Object? completionFeedbackReady = null,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as BallSlideLessonContent?,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,rotationAngle: null == rotationAngle ? _self.rotationAngle : rotationAngle // ignore: cast_nullable_to_non_nullable
as double,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,isAnimating: null == isAnimating ? _self.isAnimating : isAnimating // ignore: cast_nullable_to_non_nullable
as bool,isAllAudioCompleted: null == isAllAudioCompleted ? _self.isAllAudioCompleted : isAllAudioCompleted // ignore: cast_nullable_to_non_nullable
as bool,completionFeedbackReady: null == completionFeedbackReady ? _self.completionFeedbackReady : completionFeedbackReady // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BallSliderState].
extension BallSliderStatePatterns on BallSliderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BallSliderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BallSliderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BallSliderState value)  $default,){
final _that = this;
switch (_that) {
case _BallSliderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BallSliderState value)?  $default,){
final _that = this;
switch (_that) {
case _BallSliderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BallSlideLessonContent? content,  double value,  double rotationAngle,  bool isComplete,  bool isAnimating,  bool isAllAudioCompleted,  bool completionFeedbackReady)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BallSliderState() when $default != null:
return $default(_that.content,_that.value,_that.rotationAngle,_that.isComplete,_that.isAnimating,_that.isAllAudioCompleted,_that.completionFeedbackReady);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BallSlideLessonContent? content,  double value,  double rotationAngle,  bool isComplete,  bool isAnimating,  bool isAllAudioCompleted,  bool completionFeedbackReady)  $default,) {final _that = this;
switch (_that) {
case _BallSliderState():
return $default(_that.content,_that.value,_that.rotationAngle,_that.isComplete,_that.isAnimating,_that.isAllAudioCompleted,_that.completionFeedbackReady);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BallSlideLessonContent? content,  double value,  double rotationAngle,  bool isComplete,  bool isAnimating,  bool isAllAudioCompleted,  bool completionFeedbackReady)?  $default,) {final _that = this;
switch (_that) {
case _BallSliderState() when $default != null:
return $default(_that.content,_that.value,_that.rotationAngle,_that.isComplete,_that.isAnimating,_that.isAllAudioCompleted,_that.completionFeedbackReady);case _:
  return null;

}
}

}

/// @nodoc


class _BallSliderState implements BallSliderState {
  const _BallSliderState({this.content, this.value = 0.0, this.rotationAngle = 0.0, this.isComplete = false, this.isAnimating = false, this.isAllAudioCompleted = false, this.completionFeedbackReady = false});
  

@override final  BallSlideLessonContent? content;
@override@JsonKey() final  double value;
@override@JsonKey() final  double rotationAngle;
@override@JsonKey() final  bool isComplete;
@override@JsonKey() final  bool isAnimating;
@override@JsonKey() final  bool isAllAudioCompleted;
@override@JsonKey() final  bool completionFeedbackReady;

/// Create a copy of BallSliderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BallSliderStateCopyWith<_BallSliderState> get copyWith => __$BallSliderStateCopyWithImpl<_BallSliderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BallSliderState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.value, value) || other.value == value)&&(identical(other.rotationAngle, rotationAngle) || other.rotationAngle == rotationAngle)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.isAnimating, isAnimating) || other.isAnimating == isAnimating)&&(identical(other.isAllAudioCompleted, isAllAudioCompleted) || other.isAllAudioCompleted == isAllAudioCompleted)&&(identical(other.completionFeedbackReady, completionFeedbackReady) || other.completionFeedbackReady == completionFeedbackReady));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),value,rotationAngle,isComplete,isAnimating,isAllAudioCompleted,completionFeedbackReady);

@override
String toString() {
  return 'BallSliderState(content: $content, value: $value, rotationAngle: $rotationAngle, isComplete: $isComplete, isAnimating: $isAnimating, isAllAudioCompleted: $isAllAudioCompleted, completionFeedbackReady: $completionFeedbackReady)';
}


}

/// @nodoc
abstract mixin class _$BallSliderStateCopyWith<$Res> implements $BallSliderStateCopyWith<$Res> {
  factory _$BallSliderStateCopyWith(_BallSliderState value, $Res Function(_BallSliderState) _then) = __$BallSliderStateCopyWithImpl;
@override @useResult
$Res call({
 BallSlideLessonContent? content, double value, double rotationAngle, bool isComplete, bool isAnimating, bool isAllAudioCompleted, bool completionFeedbackReady
});




}
/// @nodoc
class __$BallSliderStateCopyWithImpl<$Res>
    implements _$BallSliderStateCopyWith<$Res> {
  __$BallSliderStateCopyWithImpl(this._self, this._then);

  final _BallSliderState _self;
  final $Res Function(_BallSliderState) _then;

/// Create a copy of BallSliderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? value = null,Object? rotationAngle = null,Object? isComplete = null,Object? isAnimating = null,Object? isAllAudioCompleted = null,Object? completionFeedbackReady = null,}) {
  return _then(_BallSliderState(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as BallSlideLessonContent?,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,rotationAngle: null == rotationAngle ? _self.rotationAngle : rotationAngle // ignore: cast_nullable_to_non_nullable
as double,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,isAnimating: null == isAnimating ? _self.isAnimating : isAnimating // ignore: cast_nullable_to_non_nullable
as bool,isAllAudioCompleted: null == isAllAudioCompleted ? _self.isAllAudioCompleted : isAllAudioCompleted // ignore: cast_nullable_to_non_nullable
as bool,completionFeedbackReady: null == completionFeedbackReady ? _self.completionFeedbackReady : completionFeedbackReady // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
