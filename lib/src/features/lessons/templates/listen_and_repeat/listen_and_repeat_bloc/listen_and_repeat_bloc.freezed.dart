// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listen_and_repeat_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListenAndRepeatEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListenAndRepeatEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListenAndRepeatEvent()';
}


}

/// @nodoc
class $ListenAndRepeatEventCopyWith<$Res>  {
$ListenAndRepeatEventCopyWith(ListenAndRepeatEvent _, $Res Function(ListenAndRepeatEvent) __);
}


/// Adds pattern-matching-related methods to [ListenAndRepeatEvent].
extension ListenAndRepeatEventPatterns on ListenAndRepeatEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _AudioFinished value)?  audioFinished,TResult Function( _RecordingTimerTick value)?  recordingTimerTick,TResult Function( _RecordingCompleted value)?  recordingCompleted,TResult Function( _RecordingFailed value)?  recordingFailed,TResult Function( _RetryRequested value)?  retryRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AudioFinished() when audioFinished != null:
return audioFinished(_that);case _RecordingTimerTick() when recordingTimerTick != null:
return recordingTimerTick(_that);case _RecordingCompleted() when recordingCompleted != null:
return recordingCompleted(_that);case _RecordingFailed() when recordingFailed != null:
return recordingFailed(_that);case _RetryRequested() when retryRequested != null:
return retryRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _AudioFinished value)  audioFinished,required TResult Function( _RecordingTimerTick value)  recordingTimerTick,required TResult Function( _RecordingCompleted value)  recordingCompleted,required TResult Function( _RecordingFailed value)  recordingFailed,required TResult Function( _RetryRequested value)  retryRequested,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _AudioFinished():
return audioFinished(_that);case _RecordingTimerTick():
return recordingTimerTick(_that);case _RecordingCompleted():
return recordingCompleted(_that);case _RecordingFailed():
return recordingFailed(_that);case _RetryRequested():
return retryRequested(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _AudioFinished value)?  audioFinished,TResult? Function( _RecordingTimerTick value)?  recordingTimerTick,TResult? Function( _RecordingCompleted value)?  recordingCompleted,TResult? Function( _RecordingFailed value)?  recordingFailed,TResult? Function( _RetryRequested value)?  retryRequested,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AudioFinished() when audioFinished != null:
return audioFinished(_that);case _RecordingTimerTick() when recordingTimerTick != null:
return recordingTimerTick(_that);case _RecordingCompleted() when recordingCompleted != null:
return recordingCompleted(_that);case _RecordingFailed() when recordingFailed != null:
return recordingFailed(_that);case _RetryRequested() when retryRequested != null:
return retryRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ListenAndRepeatLessonContent content)?  started,TResult Function()?  audioFinished,TResult Function( int elapsed)?  recordingTimerTick,TResult Function( String audioPath)?  recordingCompleted,TResult Function( String error)?  recordingFailed,TResult Function()?  retryRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _AudioFinished() when audioFinished != null:
return audioFinished();case _RecordingTimerTick() when recordingTimerTick != null:
return recordingTimerTick(_that.elapsed);case _RecordingCompleted() when recordingCompleted != null:
return recordingCompleted(_that.audioPath);case _RecordingFailed() when recordingFailed != null:
return recordingFailed(_that.error);case _RetryRequested() when retryRequested != null:
return retryRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ListenAndRepeatLessonContent content)  started,required TResult Function()  audioFinished,required TResult Function( int elapsed)  recordingTimerTick,required TResult Function( String audioPath)  recordingCompleted,required TResult Function( String error)  recordingFailed,required TResult Function()  retryRequested,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _AudioFinished():
return audioFinished();case _RecordingTimerTick():
return recordingTimerTick(_that.elapsed);case _RecordingCompleted():
return recordingCompleted(_that.audioPath);case _RecordingFailed():
return recordingFailed(_that.error);case _RetryRequested():
return retryRequested();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ListenAndRepeatLessonContent content)?  started,TResult? Function()?  audioFinished,TResult? Function( int elapsed)?  recordingTimerTick,TResult? Function( String audioPath)?  recordingCompleted,TResult? Function( String error)?  recordingFailed,TResult? Function()?  retryRequested,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _AudioFinished() when audioFinished != null:
return audioFinished();case _RecordingTimerTick() when recordingTimerTick != null:
return recordingTimerTick(_that.elapsed);case _RecordingCompleted() when recordingCompleted != null:
return recordingCompleted(_that.audioPath);case _RecordingFailed() when recordingFailed != null:
return recordingFailed(_that.error);case _RetryRequested() when retryRequested != null:
return retryRequested();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ListenAndRepeatEvent {
  const _Started(this.content);
  

 final  ListenAndRepeatLessonContent content;

/// Create a copy of ListenAndRepeatEvent
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
  return 'ListenAndRepeatEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $ListenAndRepeatEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 ListenAndRepeatLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of ListenAndRepeatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ListenAndRepeatLessonContent,
  ));
}


}

/// @nodoc


class _AudioFinished implements ListenAndRepeatEvent {
  const _AudioFinished();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioFinished);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListenAndRepeatEvent.audioFinished()';
}


}




/// @nodoc


class _RecordingTimerTick implements ListenAndRepeatEvent {
  const _RecordingTimerTick(this.elapsed);
  

 final  int elapsed;

/// Create a copy of ListenAndRepeatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordingTimerTickCopyWith<_RecordingTimerTick> get copyWith => __$RecordingTimerTickCopyWithImpl<_RecordingTimerTick>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordingTimerTick&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed));
}


@override
int get hashCode => Object.hash(runtimeType,elapsed);

@override
String toString() {
  return 'ListenAndRepeatEvent.recordingTimerTick(elapsed: $elapsed)';
}


}

/// @nodoc
abstract mixin class _$RecordingTimerTickCopyWith<$Res> implements $ListenAndRepeatEventCopyWith<$Res> {
  factory _$RecordingTimerTickCopyWith(_RecordingTimerTick value, $Res Function(_RecordingTimerTick) _then) = __$RecordingTimerTickCopyWithImpl;
@useResult
$Res call({
 int elapsed
});




}
/// @nodoc
class __$RecordingTimerTickCopyWithImpl<$Res>
    implements _$RecordingTimerTickCopyWith<$Res> {
  __$RecordingTimerTickCopyWithImpl(this._self, this._then);

  final _RecordingTimerTick _self;
  final $Res Function(_RecordingTimerTick) _then;

/// Create a copy of ListenAndRepeatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? elapsed = null,}) {
  return _then(_RecordingTimerTick(
null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _RecordingCompleted implements ListenAndRepeatEvent {
  const _RecordingCompleted(this.audioPath);
  

 final  String audioPath;

/// Create a copy of ListenAndRepeatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordingCompletedCopyWith<_RecordingCompleted> get copyWith => __$RecordingCompletedCopyWithImpl<_RecordingCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordingCompleted&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath));
}


@override
int get hashCode => Object.hash(runtimeType,audioPath);

@override
String toString() {
  return 'ListenAndRepeatEvent.recordingCompleted(audioPath: $audioPath)';
}


}

/// @nodoc
abstract mixin class _$RecordingCompletedCopyWith<$Res> implements $ListenAndRepeatEventCopyWith<$Res> {
  factory _$RecordingCompletedCopyWith(_RecordingCompleted value, $Res Function(_RecordingCompleted) _then) = __$RecordingCompletedCopyWithImpl;
@useResult
$Res call({
 String audioPath
});




}
/// @nodoc
class __$RecordingCompletedCopyWithImpl<$Res>
    implements _$RecordingCompletedCopyWith<$Res> {
  __$RecordingCompletedCopyWithImpl(this._self, this._then);

  final _RecordingCompleted _self;
  final $Res Function(_RecordingCompleted) _then;

/// Create a copy of ListenAndRepeatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? audioPath = null,}) {
  return _then(_RecordingCompleted(
null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RecordingFailed implements ListenAndRepeatEvent {
  const _RecordingFailed(this.error);
  

 final  String error;

/// Create a copy of ListenAndRepeatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordingFailedCopyWith<_RecordingFailed> get copyWith => __$RecordingFailedCopyWithImpl<_RecordingFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordingFailed&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'ListenAndRepeatEvent.recordingFailed(error: $error)';
}


}

/// @nodoc
abstract mixin class _$RecordingFailedCopyWith<$Res> implements $ListenAndRepeatEventCopyWith<$Res> {
  factory _$RecordingFailedCopyWith(_RecordingFailed value, $Res Function(_RecordingFailed) _then) = __$RecordingFailedCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$RecordingFailedCopyWithImpl<$Res>
    implements _$RecordingFailedCopyWith<$Res> {
  __$RecordingFailedCopyWithImpl(this._self, this._then);

  final _RecordingFailed _self;
  final $Res Function(_RecordingFailed) _then;

/// Create a copy of ListenAndRepeatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_RecordingFailed(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RetryRequested implements ListenAndRepeatEvent {
  const _RetryRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RetryRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListenAndRepeatEvent.retryRequested()';
}


}




/// @nodoc
mixin _$ListenAndRepeatState {

 ListenAndRepeatLessonContent? get content; ListenAndRepeatPhase get phase; int get recordingElapsed; int get recordingDuration;// seconds
 String? get recordedAudioPath; String? get errorMessage;
/// Create a copy of ListenAndRepeatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListenAndRepeatStateCopyWith<ListenAndRepeatState> get copyWith => _$ListenAndRepeatStateCopyWithImpl<ListenAndRepeatState>(this as ListenAndRepeatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListenAndRepeatState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.recordingElapsed, recordingElapsed) || other.recordingElapsed == recordingElapsed)&&(identical(other.recordingDuration, recordingDuration) || other.recordingDuration == recordingDuration)&&(identical(other.recordedAudioPath, recordedAudioPath) || other.recordedAudioPath == recordedAudioPath)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),phase,recordingElapsed,recordingDuration,recordedAudioPath,errorMessage);

@override
String toString() {
  return 'ListenAndRepeatState(content: $content, phase: $phase, recordingElapsed: $recordingElapsed, recordingDuration: $recordingDuration, recordedAudioPath: $recordedAudioPath, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ListenAndRepeatStateCopyWith<$Res>  {
  factory $ListenAndRepeatStateCopyWith(ListenAndRepeatState value, $Res Function(ListenAndRepeatState) _then) = _$ListenAndRepeatStateCopyWithImpl;
@useResult
$Res call({
 ListenAndRepeatLessonContent? content, ListenAndRepeatPhase phase, int recordingElapsed, int recordingDuration, String? recordedAudioPath, String? errorMessage
});




}
/// @nodoc
class _$ListenAndRepeatStateCopyWithImpl<$Res>
    implements $ListenAndRepeatStateCopyWith<$Res> {
  _$ListenAndRepeatStateCopyWithImpl(this._self, this._then);

  final ListenAndRepeatState _self;
  final $Res Function(ListenAndRepeatState) _then;

/// Create a copy of ListenAndRepeatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? phase = null,Object? recordingElapsed = null,Object? recordingDuration = null,Object? recordedAudioPath = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ListenAndRepeatLessonContent?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ListenAndRepeatPhase,recordingElapsed: null == recordingElapsed ? _self.recordingElapsed : recordingElapsed // ignore: cast_nullable_to_non_nullable
as int,recordingDuration: null == recordingDuration ? _self.recordingDuration : recordingDuration // ignore: cast_nullable_to_non_nullable
as int,recordedAudioPath: freezed == recordedAudioPath ? _self.recordedAudioPath : recordedAudioPath // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ListenAndRepeatState].
extension ListenAndRepeatStatePatterns on ListenAndRepeatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListenAndRepeatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListenAndRepeatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListenAndRepeatState value)  $default,){
final _that = this;
switch (_that) {
case _ListenAndRepeatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListenAndRepeatState value)?  $default,){
final _that = this;
switch (_that) {
case _ListenAndRepeatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ListenAndRepeatLessonContent? content,  ListenAndRepeatPhase phase,  int recordingElapsed,  int recordingDuration,  String? recordedAudioPath,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListenAndRepeatState() when $default != null:
return $default(_that.content,_that.phase,_that.recordingElapsed,_that.recordingDuration,_that.recordedAudioPath,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ListenAndRepeatLessonContent? content,  ListenAndRepeatPhase phase,  int recordingElapsed,  int recordingDuration,  String? recordedAudioPath,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ListenAndRepeatState():
return $default(_that.content,_that.phase,_that.recordingElapsed,_that.recordingDuration,_that.recordedAudioPath,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ListenAndRepeatLessonContent? content,  ListenAndRepeatPhase phase,  int recordingElapsed,  int recordingDuration,  String? recordedAudioPath,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ListenAndRepeatState() when $default != null:
return $default(_that.content,_that.phase,_that.recordingElapsed,_that.recordingDuration,_that.recordedAudioPath,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ListenAndRepeatState extends ListenAndRepeatState {
  const _ListenAndRepeatState({this.content, this.phase = ListenAndRepeatPhase.idle, this.recordingElapsed = 0, this.recordingDuration = 3, this.recordedAudioPath, this.errorMessage}): super._();
  

@override final  ListenAndRepeatLessonContent? content;
@override@JsonKey() final  ListenAndRepeatPhase phase;
@override@JsonKey() final  int recordingElapsed;
@override@JsonKey() final  int recordingDuration;
// seconds
@override final  String? recordedAudioPath;
@override final  String? errorMessage;

/// Create a copy of ListenAndRepeatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListenAndRepeatStateCopyWith<_ListenAndRepeatState> get copyWith => __$ListenAndRepeatStateCopyWithImpl<_ListenAndRepeatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListenAndRepeatState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.recordingElapsed, recordingElapsed) || other.recordingElapsed == recordingElapsed)&&(identical(other.recordingDuration, recordingDuration) || other.recordingDuration == recordingDuration)&&(identical(other.recordedAudioPath, recordedAudioPath) || other.recordedAudioPath == recordedAudioPath)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),phase,recordingElapsed,recordingDuration,recordedAudioPath,errorMessage);

@override
String toString() {
  return 'ListenAndRepeatState(content: $content, phase: $phase, recordingElapsed: $recordingElapsed, recordingDuration: $recordingDuration, recordedAudioPath: $recordedAudioPath, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ListenAndRepeatStateCopyWith<$Res> implements $ListenAndRepeatStateCopyWith<$Res> {
  factory _$ListenAndRepeatStateCopyWith(_ListenAndRepeatState value, $Res Function(_ListenAndRepeatState) _then) = __$ListenAndRepeatStateCopyWithImpl;
@override @useResult
$Res call({
 ListenAndRepeatLessonContent? content, ListenAndRepeatPhase phase, int recordingElapsed, int recordingDuration, String? recordedAudioPath, String? errorMessage
});




}
/// @nodoc
class __$ListenAndRepeatStateCopyWithImpl<$Res>
    implements _$ListenAndRepeatStateCopyWith<$Res> {
  __$ListenAndRepeatStateCopyWithImpl(this._self, this._then);

  final _ListenAndRepeatState _self;
  final $Res Function(_ListenAndRepeatState) _then;

/// Create a copy of ListenAndRepeatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? phase = null,Object? recordingElapsed = null,Object? recordingDuration = null,Object? recordedAudioPath = freezed,Object? errorMessage = freezed,}) {
  return _then(_ListenAndRepeatState(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ListenAndRepeatLessonContent?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ListenAndRepeatPhase,recordingElapsed: null == recordingElapsed ? _self.recordingElapsed : recordingElapsed // ignore: cast_nullable_to_non_nullable
as int,recordingDuration: null == recordingDuration ? _self.recordingDuration : recordingDuration // ignore: cast_nullable_to_non_nullable
as int,recordedAudioPath: freezed == recordedAudioPath ? _self.recordedAudioPath : recordedAudioPath // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
