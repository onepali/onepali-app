// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letter_tracing_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LetterTracingEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LetterTracingEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LetterTracingEvent()';
}


}

/// @nodoc
class $LetterTracingEventCopyWith<$Res>  {
$LetterTracingEventCopyWith(LetterTracingEvent _, $Res Function(LetterTracingEvent) __);
}


/// Adds pattern-matching-related methods to [LetterTracingEvent].
extension LetterTracingEventPatterns on LetterTracingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _OnPanStart value)?  onPanStart,TResult Function( _OnPanUpdate value)?  onPanUpdate,TResult Function( _OnPanEnd value)?  onPanEnd,TResult Function( _Reset value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _OnPanStart() when onPanStart != null:
return onPanStart(_that);case _OnPanUpdate() when onPanUpdate != null:
return onPanUpdate(_that);case _OnPanEnd() when onPanEnd != null:
return onPanEnd(_that);case _Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _OnPanStart value)  onPanStart,required TResult Function( _OnPanUpdate value)  onPanUpdate,required TResult Function( _OnPanEnd value)  onPanEnd,required TResult Function( _Reset value)  reset,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _OnPanStart():
return onPanStart(_that);case _OnPanUpdate():
return onPanUpdate(_that);case _OnPanEnd():
return onPanEnd(_that);case _Reset():
return reset(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _OnPanStart value)?  onPanStart,TResult? Function( _OnPanUpdate value)?  onPanUpdate,TResult? Function( _OnPanEnd value)?  onPanEnd,TResult? Function( _Reset value)?  reset,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _OnPanStart() when onPanStart != null:
return onPanStart(_that);case _OnPanUpdate() when onPanUpdate != null:
return onPanUpdate(_that);case _OnPanEnd() when onPanEnd != null:
return onPanEnd(_that);case _Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CharTracingLessonContent content)?  started,TResult Function( Offset position)?  onPanStart,TResult Function( Offset position)?  onPanUpdate,TResult Function( Offset position)?  onPanEnd,TResult Function()?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _OnPanStart() when onPanStart != null:
return onPanStart(_that.position);case _OnPanUpdate() when onPanUpdate != null:
return onPanUpdate(_that.position);case _OnPanEnd() when onPanEnd != null:
return onPanEnd(_that.position);case _Reset() when reset != null:
return reset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CharTracingLessonContent content)  started,required TResult Function( Offset position)  onPanStart,required TResult Function( Offset position)  onPanUpdate,required TResult Function( Offset position)  onPanEnd,required TResult Function()  reset,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _OnPanStart():
return onPanStart(_that.position);case _OnPanUpdate():
return onPanUpdate(_that.position);case _OnPanEnd():
return onPanEnd(_that.position);case _Reset():
return reset();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CharTracingLessonContent content)?  started,TResult? Function( Offset position)?  onPanStart,TResult? Function( Offset position)?  onPanUpdate,TResult? Function( Offset position)?  onPanEnd,TResult? Function()?  reset,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _OnPanStart() when onPanStart != null:
return onPanStart(_that.position);case _OnPanUpdate() when onPanUpdate != null:
return onPanUpdate(_that.position);case _OnPanEnd() when onPanEnd != null:
return onPanEnd(_that.position);case _Reset() when reset != null:
return reset();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements LetterTracingEvent {
  const _Started(this.content);
  

 final  CharTracingLessonContent content;

/// Create a copy of LetterTracingEvent
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
  return 'LetterTracingEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $LetterTracingEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 CharTracingLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of LetterTracingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as CharTracingLessonContent,
  ));
}


}

/// @nodoc


class _OnPanStart implements LetterTracingEvent {
  const _OnPanStart(this.position);
  

 final  Offset position;

/// Create a copy of LetterTracingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnPanStartCopyWith<_OnPanStart> get copyWith => __$OnPanStartCopyWithImpl<_OnPanStart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnPanStart&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,position);

@override
String toString() {
  return 'LetterTracingEvent.onPanStart(position: $position)';
}


}

/// @nodoc
abstract mixin class _$OnPanStartCopyWith<$Res> implements $LetterTracingEventCopyWith<$Res> {
  factory _$OnPanStartCopyWith(_OnPanStart value, $Res Function(_OnPanStart) _then) = __$OnPanStartCopyWithImpl;
@useResult
$Res call({
 Offset position
});




}
/// @nodoc
class __$OnPanStartCopyWithImpl<$Res>
    implements _$OnPanStartCopyWith<$Res> {
  __$OnPanStartCopyWithImpl(this._self, this._then);

  final _OnPanStart _self;
  final $Res Function(_OnPanStart) _then;

/// Create a copy of LetterTracingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? position = null,}) {
  return _then(_OnPanStart(
null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Offset,
  ));
}


}

/// @nodoc


class _OnPanUpdate implements LetterTracingEvent {
  const _OnPanUpdate(this.position);
  

 final  Offset position;

/// Create a copy of LetterTracingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnPanUpdateCopyWith<_OnPanUpdate> get copyWith => __$OnPanUpdateCopyWithImpl<_OnPanUpdate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnPanUpdate&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,position);

@override
String toString() {
  return 'LetterTracingEvent.onPanUpdate(position: $position)';
}


}

/// @nodoc
abstract mixin class _$OnPanUpdateCopyWith<$Res> implements $LetterTracingEventCopyWith<$Res> {
  factory _$OnPanUpdateCopyWith(_OnPanUpdate value, $Res Function(_OnPanUpdate) _then) = __$OnPanUpdateCopyWithImpl;
@useResult
$Res call({
 Offset position
});




}
/// @nodoc
class __$OnPanUpdateCopyWithImpl<$Res>
    implements _$OnPanUpdateCopyWith<$Res> {
  __$OnPanUpdateCopyWithImpl(this._self, this._then);

  final _OnPanUpdate _self;
  final $Res Function(_OnPanUpdate) _then;

/// Create a copy of LetterTracingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? position = null,}) {
  return _then(_OnPanUpdate(
null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Offset,
  ));
}


}

/// @nodoc


class _OnPanEnd implements LetterTracingEvent {
  const _OnPanEnd(this.position);
  

 final  Offset position;

/// Create a copy of LetterTracingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnPanEndCopyWith<_OnPanEnd> get copyWith => __$OnPanEndCopyWithImpl<_OnPanEnd>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnPanEnd&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,position);

@override
String toString() {
  return 'LetterTracingEvent.onPanEnd(position: $position)';
}


}

/// @nodoc
abstract mixin class _$OnPanEndCopyWith<$Res> implements $LetterTracingEventCopyWith<$Res> {
  factory _$OnPanEndCopyWith(_OnPanEnd value, $Res Function(_OnPanEnd) _then) = __$OnPanEndCopyWithImpl;
@useResult
$Res call({
 Offset position
});




}
/// @nodoc
class __$OnPanEndCopyWithImpl<$Res>
    implements _$OnPanEndCopyWith<$Res> {
  __$OnPanEndCopyWithImpl(this._self, this._then);

  final _OnPanEnd _self;
  final $Res Function(_OnPanEnd) _then;

/// Create a copy of LetterTracingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? position = null,}) {
  return _then(_OnPanEnd(
null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Offset,
  ));
}


}

/// @nodoc


class _Reset implements LetterTracingEvent {
  const _Reset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LetterTracingEvent.reset()';
}


}




/// @nodoc
mixin _$LetterTracingState {

 NepaliLetter? get letter; Size get letterSize; int get numberOfStrokes; double get strokeWidth; int get currentStrokeIndex; List<Path> get letterPaths; List<Path> get completedPaths; List<List<Offset>> get pathsPoints; List<Offset> get userStrokes;
/// Create a copy of LetterTracingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LetterTracingStateCopyWith<LetterTracingState> get copyWith => _$LetterTracingStateCopyWithImpl<LetterTracingState>(this as LetterTracingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LetterTracingState&&(identical(other.letter, letter) || other.letter == letter)&&(identical(other.letterSize, letterSize) || other.letterSize == letterSize)&&(identical(other.numberOfStrokes, numberOfStrokes) || other.numberOfStrokes == numberOfStrokes)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.currentStrokeIndex, currentStrokeIndex) || other.currentStrokeIndex == currentStrokeIndex)&&const DeepCollectionEquality().equals(other.letterPaths, letterPaths)&&const DeepCollectionEquality().equals(other.completedPaths, completedPaths)&&const DeepCollectionEquality().equals(other.pathsPoints, pathsPoints)&&const DeepCollectionEquality().equals(other.userStrokes, userStrokes));
}


@override
int get hashCode => Object.hash(runtimeType,letter,letterSize,numberOfStrokes,strokeWidth,currentStrokeIndex,const DeepCollectionEquality().hash(letterPaths),const DeepCollectionEquality().hash(completedPaths),const DeepCollectionEquality().hash(pathsPoints),const DeepCollectionEquality().hash(userStrokes));

@override
String toString() {
  return 'LetterTracingState(letter: $letter, letterSize: $letterSize, numberOfStrokes: $numberOfStrokes, strokeWidth: $strokeWidth, currentStrokeIndex: $currentStrokeIndex, letterPaths: $letterPaths, completedPaths: $completedPaths, pathsPoints: $pathsPoints, userStrokes: $userStrokes)';
}


}

/// @nodoc
abstract mixin class $LetterTracingStateCopyWith<$Res>  {
  factory $LetterTracingStateCopyWith(LetterTracingState value, $Res Function(LetterTracingState) _then) = _$LetterTracingStateCopyWithImpl;
@useResult
$Res call({
 NepaliLetter? letter, Size letterSize, int numberOfStrokes, double strokeWidth, int currentStrokeIndex, List<Path> letterPaths, List<Path> completedPaths, List<List<Offset>> pathsPoints, List<Offset> userStrokes
});




}
/// @nodoc
class _$LetterTracingStateCopyWithImpl<$Res>
    implements $LetterTracingStateCopyWith<$Res> {
  _$LetterTracingStateCopyWithImpl(this._self, this._then);

  final LetterTracingState _self;
  final $Res Function(LetterTracingState) _then;

/// Create a copy of LetterTracingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? letter = freezed,Object? letterSize = null,Object? numberOfStrokes = null,Object? strokeWidth = null,Object? currentStrokeIndex = null,Object? letterPaths = null,Object? completedPaths = null,Object? pathsPoints = null,Object? userStrokes = null,}) {
  return _then(_self.copyWith(
letter: freezed == letter ? _self.letter : letter // ignore: cast_nullable_to_non_nullable
as NepaliLetter?,letterSize: null == letterSize ? _self.letterSize : letterSize // ignore: cast_nullable_to_non_nullable
as Size,numberOfStrokes: null == numberOfStrokes ? _self.numberOfStrokes : numberOfStrokes // ignore: cast_nullable_to_non_nullable
as int,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,currentStrokeIndex: null == currentStrokeIndex ? _self.currentStrokeIndex : currentStrokeIndex // ignore: cast_nullable_to_non_nullable
as int,letterPaths: null == letterPaths ? _self.letterPaths : letterPaths // ignore: cast_nullable_to_non_nullable
as List<Path>,completedPaths: null == completedPaths ? _self.completedPaths : completedPaths // ignore: cast_nullable_to_non_nullable
as List<Path>,pathsPoints: null == pathsPoints ? _self.pathsPoints : pathsPoints // ignore: cast_nullable_to_non_nullable
as List<List<Offset>>,userStrokes: null == userStrokes ? _self.userStrokes : userStrokes // ignore: cast_nullable_to_non_nullable
as List<Offset>,
  ));
}

}


/// Adds pattern-matching-related methods to [LetterTracingState].
extension LetterTracingStatePatterns on LetterTracingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LetterTracingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LetterTracingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LetterTracingState value)  $default,){
final _that = this;
switch (_that) {
case _LetterTracingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LetterTracingState value)?  $default,){
final _that = this;
switch (_that) {
case _LetterTracingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NepaliLetter? letter,  Size letterSize,  int numberOfStrokes,  double strokeWidth,  int currentStrokeIndex,  List<Path> letterPaths,  List<Path> completedPaths,  List<List<Offset>> pathsPoints,  List<Offset> userStrokes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LetterTracingState() when $default != null:
return $default(_that.letter,_that.letterSize,_that.numberOfStrokes,_that.strokeWidth,_that.currentStrokeIndex,_that.letterPaths,_that.completedPaths,_that.pathsPoints,_that.userStrokes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NepaliLetter? letter,  Size letterSize,  int numberOfStrokes,  double strokeWidth,  int currentStrokeIndex,  List<Path> letterPaths,  List<Path> completedPaths,  List<List<Offset>> pathsPoints,  List<Offset> userStrokes)  $default,) {final _that = this;
switch (_that) {
case _LetterTracingState():
return $default(_that.letter,_that.letterSize,_that.numberOfStrokes,_that.strokeWidth,_that.currentStrokeIndex,_that.letterPaths,_that.completedPaths,_that.pathsPoints,_that.userStrokes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NepaliLetter? letter,  Size letterSize,  int numberOfStrokes,  double strokeWidth,  int currentStrokeIndex,  List<Path> letterPaths,  List<Path> completedPaths,  List<List<Offset>> pathsPoints,  List<Offset> userStrokes)?  $default,) {final _that = this;
switch (_that) {
case _LetterTracingState() when $default != null:
return $default(_that.letter,_that.letterSize,_that.numberOfStrokes,_that.strokeWidth,_that.currentStrokeIndex,_that.letterPaths,_that.completedPaths,_that.pathsPoints,_that.userStrokes);case _:
  return null;

}
}

}

/// @nodoc


class _LetterTracingState implements LetterTracingState {
  const _LetterTracingState({this.letter, this.letterSize = Size.zero, this.numberOfStrokes = 0, this.strokeWidth = 20, this.currentStrokeIndex = 0, final  List<Path> letterPaths = const [], final  List<Path> completedPaths = const [], final  List<List<Offset>> pathsPoints = const [], final  List<Offset> userStrokes = const []}): _letterPaths = letterPaths,_completedPaths = completedPaths,_pathsPoints = pathsPoints,_userStrokes = userStrokes;
  

@override final  NepaliLetter? letter;
@override@JsonKey() final  Size letterSize;
@override@JsonKey() final  int numberOfStrokes;
@override@JsonKey() final  double strokeWidth;
@override@JsonKey() final  int currentStrokeIndex;
 final  List<Path> _letterPaths;
@override@JsonKey() List<Path> get letterPaths {
  if (_letterPaths is EqualUnmodifiableListView) return _letterPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_letterPaths);
}

 final  List<Path> _completedPaths;
@override@JsonKey() List<Path> get completedPaths {
  if (_completedPaths is EqualUnmodifiableListView) return _completedPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedPaths);
}

 final  List<List<Offset>> _pathsPoints;
@override@JsonKey() List<List<Offset>> get pathsPoints {
  if (_pathsPoints is EqualUnmodifiableListView) return _pathsPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pathsPoints);
}

 final  List<Offset> _userStrokes;
@override@JsonKey() List<Offset> get userStrokes {
  if (_userStrokes is EqualUnmodifiableListView) return _userStrokes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userStrokes);
}


/// Create a copy of LetterTracingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LetterTracingStateCopyWith<_LetterTracingState> get copyWith => __$LetterTracingStateCopyWithImpl<_LetterTracingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LetterTracingState&&(identical(other.letter, letter) || other.letter == letter)&&(identical(other.letterSize, letterSize) || other.letterSize == letterSize)&&(identical(other.numberOfStrokes, numberOfStrokes) || other.numberOfStrokes == numberOfStrokes)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.currentStrokeIndex, currentStrokeIndex) || other.currentStrokeIndex == currentStrokeIndex)&&const DeepCollectionEquality().equals(other._letterPaths, _letterPaths)&&const DeepCollectionEquality().equals(other._completedPaths, _completedPaths)&&const DeepCollectionEquality().equals(other._pathsPoints, _pathsPoints)&&const DeepCollectionEquality().equals(other._userStrokes, _userStrokes));
}


@override
int get hashCode => Object.hash(runtimeType,letter,letterSize,numberOfStrokes,strokeWidth,currentStrokeIndex,const DeepCollectionEquality().hash(_letterPaths),const DeepCollectionEquality().hash(_completedPaths),const DeepCollectionEquality().hash(_pathsPoints),const DeepCollectionEquality().hash(_userStrokes));

@override
String toString() {
  return 'LetterTracingState(letter: $letter, letterSize: $letterSize, numberOfStrokes: $numberOfStrokes, strokeWidth: $strokeWidth, currentStrokeIndex: $currentStrokeIndex, letterPaths: $letterPaths, completedPaths: $completedPaths, pathsPoints: $pathsPoints, userStrokes: $userStrokes)';
}


}

/// @nodoc
abstract mixin class _$LetterTracingStateCopyWith<$Res> implements $LetterTracingStateCopyWith<$Res> {
  factory _$LetterTracingStateCopyWith(_LetterTracingState value, $Res Function(_LetterTracingState) _then) = __$LetterTracingStateCopyWithImpl;
@override @useResult
$Res call({
 NepaliLetter? letter, Size letterSize, int numberOfStrokes, double strokeWidth, int currentStrokeIndex, List<Path> letterPaths, List<Path> completedPaths, List<List<Offset>> pathsPoints, List<Offset> userStrokes
});




}
/// @nodoc
class __$LetterTracingStateCopyWithImpl<$Res>
    implements _$LetterTracingStateCopyWith<$Res> {
  __$LetterTracingStateCopyWithImpl(this._self, this._then);

  final _LetterTracingState _self;
  final $Res Function(_LetterTracingState) _then;

/// Create a copy of LetterTracingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? letter = freezed,Object? letterSize = null,Object? numberOfStrokes = null,Object? strokeWidth = null,Object? currentStrokeIndex = null,Object? letterPaths = null,Object? completedPaths = null,Object? pathsPoints = null,Object? userStrokes = null,}) {
  return _then(_LetterTracingState(
letter: freezed == letter ? _self.letter : letter // ignore: cast_nullable_to_non_nullable
as NepaliLetter?,letterSize: null == letterSize ? _self.letterSize : letterSize // ignore: cast_nullable_to_non_nullable
as Size,numberOfStrokes: null == numberOfStrokes ? _self.numberOfStrokes : numberOfStrokes // ignore: cast_nullable_to_non_nullable
as int,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,currentStrokeIndex: null == currentStrokeIndex ? _self.currentStrokeIndex : currentStrokeIndex // ignore: cast_nullable_to_non_nullable
as int,letterPaths: null == letterPaths ? _self._letterPaths : letterPaths // ignore: cast_nullable_to_non_nullable
as List<Path>,completedPaths: null == completedPaths ? _self._completedPaths : completedPaths // ignore: cast_nullable_to_non_nullable
as List<Path>,pathsPoints: null == pathsPoints ? _self._pathsPoints : pathsPoints // ignore: cast_nullable_to_non_nullable
as List<List<Offset>>,userStrokes: null == userStrokes ? _self._userStrokes : userStrokes // ignore: cast_nullable_to_non_nullable
as List<Offset>,
  ));
}


}

// dart format on
