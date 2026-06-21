// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'info_lesson_content_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InfoLessonContentEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InfoLessonContentEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InfoLessonContentEvent()';
}


}

/// @nodoc
class $InfoLessonContentEventCopyWith<$Res>  {
$InfoLessonContentEventCopyWith(InfoLessonContentEvent _, $Res Function(InfoLessonContentEvent) __);
}


/// Adds pattern-matching-related methods to [InfoLessonContentEvent].
extension InfoLessonContentEventPatterns on InfoLessonContentEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _VideoCompleted value)?  videoCompleted,TResult Function( _AudioStarted value)?  audioStarted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _VideoCompleted() when videoCompleted != null:
return videoCompleted(_that);case _AudioStarted() when audioStarted != null:
return audioStarted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _VideoCompleted value)  videoCompleted,required TResult Function( _AudioStarted value)  audioStarted,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _VideoCompleted():
return videoCompleted(_that);case _AudioStarted():
return audioStarted(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _VideoCompleted value)?  videoCompleted,TResult? Function( _AudioStarted value)?  audioStarted,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _VideoCompleted() when videoCompleted != null:
return videoCompleted(_that);case _AudioStarted() when audioStarted != null:
return audioStarted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( InfoLessonContent lessonInformation)?  started,TResult Function()?  videoCompleted,TResult Function()?  audioStarted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.lessonInformation);case _VideoCompleted() when videoCompleted != null:
return videoCompleted();case _AudioStarted() when audioStarted != null:
return audioStarted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( InfoLessonContent lessonInformation)  started,required TResult Function()  videoCompleted,required TResult Function()  audioStarted,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.lessonInformation);case _VideoCompleted():
return videoCompleted();case _AudioStarted():
return audioStarted();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( InfoLessonContent lessonInformation)?  started,TResult? Function()?  videoCompleted,TResult? Function()?  audioStarted,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.lessonInformation);case _VideoCompleted() when videoCompleted != null:
return videoCompleted();case _AudioStarted() when audioStarted != null:
return audioStarted();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements InfoLessonContentEvent {
  const _Started(this.lessonInformation);
  

 final  InfoLessonContent lessonInformation;

/// Create a copy of InfoLessonContentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&const DeepCollectionEquality().equals(other.lessonInformation, lessonInformation));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(lessonInformation));

@override
String toString() {
  return 'InfoLessonContentEvent.started(lessonInformation: $lessonInformation)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $InfoLessonContentEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 InfoLessonContent lessonInformation
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of InfoLessonContentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lessonInformation = freezed,}) {
  return _then(_Started(
freezed == lessonInformation ? _self.lessonInformation : lessonInformation // ignore: cast_nullable_to_non_nullable
as InfoLessonContent,
  ));
}


}

/// @nodoc


class _VideoCompleted implements InfoLessonContentEvent {
  const _VideoCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InfoLessonContentEvent.videoCompleted()';
}


}




/// @nodoc


class _AudioStarted implements InfoLessonContentEvent {
  const _AudioStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InfoLessonContentEvent.audioStarted()';
}


}




/// @nodoc
mixin _$InfoLessonContentState {

 String? get errorMsg; InfoLessonContent? get lessonContent; bool get isVideoCompleted; bool get isAudioPlaying;
/// Create a copy of InfoLessonContentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfoLessonContentStateCopyWith<InfoLessonContentState> get copyWith => _$InfoLessonContentStateCopyWithImpl<InfoLessonContentState>(this as InfoLessonContentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InfoLessonContentState&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg)&&const DeepCollectionEquality().equals(other.lessonContent, lessonContent)&&(identical(other.isVideoCompleted, isVideoCompleted) || other.isVideoCompleted == isVideoCompleted)&&(identical(other.isAudioPlaying, isAudioPlaying) || other.isAudioPlaying == isAudioPlaying));
}


@override
int get hashCode => Object.hash(runtimeType,errorMsg,const DeepCollectionEquality().hash(lessonContent),isVideoCompleted,isAudioPlaying);

@override
String toString() {
  return 'InfoLessonContentState(errorMsg: $errorMsg, lessonContent: $lessonContent, isVideoCompleted: $isVideoCompleted, isAudioPlaying: $isAudioPlaying)';
}


}

/// @nodoc
abstract mixin class $InfoLessonContentStateCopyWith<$Res>  {
  factory $InfoLessonContentStateCopyWith(InfoLessonContentState value, $Res Function(InfoLessonContentState) _then) = _$InfoLessonContentStateCopyWithImpl;
@useResult
$Res call({
 String? errorMsg, InfoLessonContent? lessonContent, bool isVideoCompleted, bool isAudioPlaying
});




}
/// @nodoc
class _$InfoLessonContentStateCopyWithImpl<$Res>
    implements $InfoLessonContentStateCopyWith<$Res> {
  _$InfoLessonContentStateCopyWithImpl(this._self, this._then);

  final InfoLessonContentState _self;
  final $Res Function(InfoLessonContentState) _then;

/// Create a copy of InfoLessonContentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? errorMsg = freezed,Object? lessonContent = freezed,Object? isVideoCompleted = null,Object? isAudioPlaying = null,}) {
  return _then(_self.copyWith(
errorMsg: freezed == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String?,lessonContent: freezed == lessonContent ? _self.lessonContent : lessonContent // ignore: cast_nullable_to_non_nullable
as InfoLessonContent?,isVideoCompleted: null == isVideoCompleted ? _self.isVideoCompleted : isVideoCompleted // ignore: cast_nullable_to_non_nullable
as bool,isAudioPlaying: null == isAudioPlaying ? _self.isAudioPlaying : isAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InfoLessonContentState].
extension InfoLessonContentStatePatterns on InfoLessonContentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InfoLessonContentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InfoLessonContentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InfoLessonContentState value)  $default,){
final _that = this;
switch (_that) {
case _InfoLessonContentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InfoLessonContentState value)?  $default,){
final _that = this;
switch (_that) {
case _InfoLessonContentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? errorMsg,  InfoLessonContent? lessonContent,  bool isVideoCompleted,  bool isAudioPlaying)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InfoLessonContentState() when $default != null:
return $default(_that.errorMsg,_that.lessonContent,_that.isVideoCompleted,_that.isAudioPlaying);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? errorMsg,  InfoLessonContent? lessonContent,  bool isVideoCompleted,  bool isAudioPlaying)  $default,) {final _that = this;
switch (_that) {
case _InfoLessonContentState():
return $default(_that.errorMsg,_that.lessonContent,_that.isVideoCompleted,_that.isAudioPlaying);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? errorMsg,  InfoLessonContent? lessonContent,  bool isVideoCompleted,  bool isAudioPlaying)?  $default,) {final _that = this;
switch (_that) {
case _InfoLessonContentState() when $default != null:
return $default(_that.errorMsg,_that.lessonContent,_that.isVideoCompleted,_that.isAudioPlaying);case _:
  return null;

}
}

}

/// @nodoc


class _InfoLessonContentState implements InfoLessonContentState {
  const _InfoLessonContentState({this.errorMsg, this.lessonContent, this.isVideoCompleted = false, this.isAudioPlaying = false});
  

@override final  String? errorMsg;
@override final  InfoLessonContent? lessonContent;
@override@JsonKey() final  bool isVideoCompleted;
@override@JsonKey() final  bool isAudioPlaying;

/// Create a copy of InfoLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InfoLessonContentStateCopyWith<_InfoLessonContentState> get copyWith => __$InfoLessonContentStateCopyWithImpl<_InfoLessonContentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InfoLessonContentState&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg)&&const DeepCollectionEquality().equals(other.lessonContent, lessonContent)&&(identical(other.isVideoCompleted, isVideoCompleted) || other.isVideoCompleted == isVideoCompleted)&&(identical(other.isAudioPlaying, isAudioPlaying) || other.isAudioPlaying == isAudioPlaying));
}


@override
int get hashCode => Object.hash(runtimeType,errorMsg,const DeepCollectionEquality().hash(lessonContent),isVideoCompleted,isAudioPlaying);

@override
String toString() {
  return 'InfoLessonContentState(errorMsg: $errorMsg, lessonContent: $lessonContent, isVideoCompleted: $isVideoCompleted, isAudioPlaying: $isAudioPlaying)';
}


}

/// @nodoc
abstract mixin class _$InfoLessonContentStateCopyWith<$Res> implements $InfoLessonContentStateCopyWith<$Res> {
  factory _$InfoLessonContentStateCopyWith(_InfoLessonContentState value, $Res Function(_InfoLessonContentState) _then) = __$InfoLessonContentStateCopyWithImpl;
@override @useResult
$Res call({
 String? errorMsg, InfoLessonContent? lessonContent, bool isVideoCompleted, bool isAudioPlaying
});




}
/// @nodoc
class __$InfoLessonContentStateCopyWithImpl<$Res>
    implements _$InfoLessonContentStateCopyWith<$Res> {
  __$InfoLessonContentStateCopyWithImpl(this._self, this._then);

  final _InfoLessonContentState _self;
  final $Res Function(_InfoLessonContentState) _then;

/// Create a copy of InfoLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? errorMsg = freezed,Object? lessonContent = freezed,Object? isVideoCompleted = null,Object? isAudioPlaying = null,}) {
  return _then(_InfoLessonContentState(
errorMsg: freezed == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String?,lessonContent: freezed == lessonContent ? _self.lessonContent : lessonContent // ignore: cast_nullable_to_non_nullable
as InfoLessonContent?,isVideoCompleted: null == isVideoCompleted ? _self.isVideoCompleted : isVideoCompleted // ignore: cast_nullable_to_non_nullable
as bool,isAudioPlaying: null == isAudioPlaying ? _self.isAudioPlaying : isAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
