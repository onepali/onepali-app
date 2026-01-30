// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'choose_correct_lesson_content_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChooseCorrectLessonContentEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChooseCorrectLessonContentEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChooseCorrectLessonContentEvent()';
}


}

/// @nodoc
class $ChooseCorrectLessonContentEventCopyWith<$Res>  {
$ChooseCorrectLessonContentEventCopyWith(ChooseCorrectLessonContentEvent _, $Res Function(ChooseCorrectLessonContentEvent) __);
}


/// Adds pattern-matching-related methods to [ChooseCorrectLessonContentEvent].
extension ChooseCorrectLessonContentEventPatterns on ChooseCorrectLessonContentEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _QuestionAudioCompleted value)?  questionAudioCompleted,TResult Function( _ItemTapped value)?  itemTapped,TResult Function( _CorrectAudioCompleted value)?  correctAudioCompleted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _QuestionAudioCompleted() when questionAudioCompleted != null:
return questionAudioCompleted(_that);case _ItemTapped() when itemTapped != null:
return itemTapped(_that);case _CorrectAudioCompleted() when correctAudioCompleted != null:
return correctAudioCompleted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _QuestionAudioCompleted value)  questionAudioCompleted,required TResult Function( _ItemTapped value)  itemTapped,required TResult Function( _CorrectAudioCompleted value)  correctAudioCompleted,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _QuestionAudioCompleted():
return questionAudioCompleted(_that);case _ItemTapped():
return itemTapped(_that);case _CorrectAudioCompleted():
return correctAudioCompleted(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _QuestionAudioCompleted value)?  questionAudioCompleted,TResult? Function( _ItemTapped value)?  itemTapped,TResult? Function( _CorrectAudioCompleted value)?  correctAudioCompleted,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _QuestionAudioCompleted() when questionAudioCompleted != null:
return questionAudioCompleted(_that);case _ItemTapped() when itemTapped != null:
return itemTapped(_that);case _CorrectAudioCompleted() when correctAudioCompleted != null:
return correctAudioCompleted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ChooseCorrectLessonContent lessonContent)?  started,TResult Function()?  questionAudioCompleted,TResult Function( Item tappedItem)?  itemTapped,TResult Function()?  correctAudioCompleted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.lessonContent);case _QuestionAudioCompleted() when questionAudioCompleted != null:
return questionAudioCompleted();case _ItemTapped() when itemTapped != null:
return itemTapped(_that.tappedItem);case _CorrectAudioCompleted() when correctAudioCompleted != null:
return correctAudioCompleted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ChooseCorrectLessonContent lessonContent)  started,required TResult Function()  questionAudioCompleted,required TResult Function( Item tappedItem)  itemTapped,required TResult Function()  correctAudioCompleted,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.lessonContent);case _QuestionAudioCompleted():
return questionAudioCompleted();case _ItemTapped():
return itemTapped(_that.tappedItem);case _CorrectAudioCompleted():
return correctAudioCompleted();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ChooseCorrectLessonContent lessonContent)?  started,TResult? Function()?  questionAudioCompleted,TResult? Function( Item tappedItem)?  itemTapped,TResult? Function()?  correctAudioCompleted,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.lessonContent);case _QuestionAudioCompleted() when questionAudioCompleted != null:
return questionAudioCompleted();case _ItemTapped() when itemTapped != null:
return itemTapped(_that.tappedItem);case _CorrectAudioCompleted() when correctAudioCompleted != null:
return correctAudioCompleted();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ChooseCorrectLessonContentEvent {
  const _Started(this.lessonContent);
  

 final  ChooseCorrectLessonContent lessonContent;

/// Create a copy of ChooseCorrectLessonContentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&const DeepCollectionEquality().equals(other.lessonContent, lessonContent));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(lessonContent));

@override
String toString() {
  return 'ChooseCorrectLessonContentEvent.started(lessonContent: $lessonContent)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $ChooseCorrectLessonContentEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 ChooseCorrectLessonContent lessonContent
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of ChooseCorrectLessonContentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lessonContent = freezed,}) {
  return _then(_Started(
freezed == lessonContent ? _self.lessonContent : lessonContent // ignore: cast_nullable_to_non_nullable
as ChooseCorrectLessonContent,
  ));
}


}

/// @nodoc


class _QuestionAudioCompleted implements ChooseCorrectLessonContentEvent {
  const _QuestionAudioCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionAudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChooseCorrectLessonContentEvent.questionAudioCompleted()';
}


}




/// @nodoc


class _ItemTapped implements ChooseCorrectLessonContentEvent {
  const _ItemTapped(this.tappedItem);
  

 final  Item tappedItem;

/// Create a copy of ChooseCorrectLessonContentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemTappedCopyWith<_ItemTapped> get copyWith => __$ItemTappedCopyWithImpl<_ItemTapped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemTapped&&(identical(other.tappedItem, tappedItem) || other.tappedItem == tappedItem));
}


@override
int get hashCode => Object.hash(runtimeType,tappedItem);

@override
String toString() {
  return 'ChooseCorrectLessonContentEvent.itemTapped(tappedItem: $tappedItem)';
}


}

/// @nodoc
abstract mixin class _$ItemTappedCopyWith<$Res> implements $ChooseCorrectLessonContentEventCopyWith<$Res> {
  factory _$ItemTappedCopyWith(_ItemTapped value, $Res Function(_ItemTapped) _then) = __$ItemTappedCopyWithImpl;
@useResult
$Res call({
 Item tappedItem
});


$ItemCopyWith<$Res> get tappedItem;

}
/// @nodoc
class __$ItemTappedCopyWithImpl<$Res>
    implements _$ItemTappedCopyWith<$Res> {
  __$ItemTappedCopyWithImpl(this._self, this._then);

  final _ItemTapped _self;
  final $Res Function(_ItemTapped) _then;

/// Create a copy of ChooseCorrectLessonContentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tappedItem = null,}) {
  return _then(_ItemTapped(
null == tappedItem ? _self.tappedItem : tappedItem // ignore: cast_nullable_to_non_nullable
as Item,
  ));
}

/// Create a copy of ChooseCorrectLessonContentEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res> get tappedItem {
  
  return $ItemCopyWith<$Res>(_self.tappedItem, (value) {
    return _then(_self.copyWith(tappedItem: value));
  });
}
}

/// @nodoc


class _CorrectAudioCompleted implements ChooseCorrectLessonContentEvent {
  const _CorrectAudioCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorrectAudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChooseCorrectLessonContentEvent.correctAudioCompleted()';
}


}




/// @nodoc
mixin _$ChooseCorrectLessonContentState {

 ChooseCorrectLessonContent? get lessonContent; Item? get currentQuestion; bool get isQuestionAudioPlaying; bool get isQuestionAudioCompleted; Item? get selectedItem; bool get isCorrect; bool get isAnswered; bool get isAudioPlaying; String? get errorMessage;
/// Create a copy of ChooseCorrectLessonContentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChooseCorrectLessonContentStateCopyWith<ChooseCorrectLessonContentState> get copyWith => _$ChooseCorrectLessonContentStateCopyWithImpl<ChooseCorrectLessonContentState>(this as ChooseCorrectLessonContentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChooseCorrectLessonContentState&&const DeepCollectionEquality().equals(other.lessonContent, lessonContent)&&(identical(other.currentQuestion, currentQuestion) || other.currentQuestion == currentQuestion)&&(identical(other.isQuestionAudioPlaying, isQuestionAudioPlaying) || other.isQuestionAudioPlaying == isQuestionAudioPlaying)&&(identical(other.isQuestionAudioCompleted, isQuestionAudioCompleted) || other.isQuestionAudioCompleted == isQuestionAudioCompleted)&&(identical(other.selectedItem, selectedItem) || other.selectedItem == selectedItem)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.isAnswered, isAnswered) || other.isAnswered == isAnswered)&&(identical(other.isAudioPlaying, isAudioPlaying) || other.isAudioPlaying == isAudioPlaying)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(lessonContent),currentQuestion,isQuestionAudioPlaying,isQuestionAudioCompleted,selectedItem,isCorrect,isAnswered,isAudioPlaying,errorMessage);

@override
String toString() {
  return 'ChooseCorrectLessonContentState(lessonContent: $lessonContent, currentQuestion: $currentQuestion, isQuestionAudioPlaying: $isQuestionAudioPlaying, isQuestionAudioCompleted: $isQuestionAudioCompleted, selectedItem: $selectedItem, isCorrect: $isCorrect, isAnswered: $isAnswered, isAudioPlaying: $isAudioPlaying, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ChooseCorrectLessonContentStateCopyWith<$Res>  {
  factory $ChooseCorrectLessonContentStateCopyWith(ChooseCorrectLessonContentState value, $Res Function(ChooseCorrectLessonContentState) _then) = _$ChooseCorrectLessonContentStateCopyWithImpl;
@useResult
$Res call({
 ChooseCorrectLessonContent? lessonContent, Item? currentQuestion, bool isQuestionAudioPlaying, bool isQuestionAudioCompleted, Item? selectedItem, bool isCorrect, bool isAnswered, bool isAudioPlaying, String? errorMessage
});


$ItemCopyWith<$Res>? get currentQuestion;$ItemCopyWith<$Res>? get selectedItem;

}
/// @nodoc
class _$ChooseCorrectLessonContentStateCopyWithImpl<$Res>
    implements $ChooseCorrectLessonContentStateCopyWith<$Res> {
  _$ChooseCorrectLessonContentStateCopyWithImpl(this._self, this._then);

  final ChooseCorrectLessonContentState _self;
  final $Res Function(ChooseCorrectLessonContentState) _then;

/// Create a copy of ChooseCorrectLessonContentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonContent = freezed,Object? currentQuestion = freezed,Object? isQuestionAudioPlaying = null,Object? isQuestionAudioCompleted = null,Object? selectedItem = freezed,Object? isCorrect = null,Object? isAnswered = null,Object? isAudioPlaying = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
lessonContent: freezed == lessonContent ? _self.lessonContent : lessonContent // ignore: cast_nullable_to_non_nullable
as ChooseCorrectLessonContent?,currentQuestion: freezed == currentQuestion ? _self.currentQuestion : currentQuestion // ignore: cast_nullable_to_non_nullable
as Item?,isQuestionAudioPlaying: null == isQuestionAudioPlaying ? _self.isQuestionAudioPlaying : isQuestionAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,isQuestionAudioCompleted: null == isQuestionAudioCompleted ? _self.isQuestionAudioCompleted : isQuestionAudioCompleted // ignore: cast_nullable_to_non_nullable
as bool,selectedItem: freezed == selectedItem ? _self.selectedItem : selectedItem // ignore: cast_nullable_to_non_nullable
as Item?,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,isAnswered: null == isAnswered ? _self.isAnswered : isAnswered // ignore: cast_nullable_to_non_nullable
as bool,isAudioPlaying: null == isAudioPlaying ? _self.isAudioPlaying : isAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ChooseCorrectLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get currentQuestion {
    if (_self.currentQuestion == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.currentQuestion!, (value) {
    return _then(_self.copyWith(currentQuestion: value));
  });
}/// Create a copy of ChooseCorrectLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get selectedItem {
    if (_self.selectedItem == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.selectedItem!, (value) {
    return _then(_self.copyWith(selectedItem: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChooseCorrectLessonContentState].
extension ChooseCorrectLessonContentStatePatterns on ChooseCorrectLessonContentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChooseCorrectLessonContentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChooseCorrectLessonContentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChooseCorrectLessonContentState value)  $default,){
final _that = this;
switch (_that) {
case _ChooseCorrectLessonContentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChooseCorrectLessonContentState value)?  $default,){
final _that = this;
switch (_that) {
case _ChooseCorrectLessonContentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChooseCorrectLessonContent? lessonContent,  Item? currentQuestion,  bool isQuestionAudioPlaying,  bool isQuestionAudioCompleted,  Item? selectedItem,  bool isCorrect,  bool isAnswered,  bool isAudioPlaying,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChooseCorrectLessonContentState() when $default != null:
return $default(_that.lessonContent,_that.currentQuestion,_that.isQuestionAudioPlaying,_that.isQuestionAudioCompleted,_that.selectedItem,_that.isCorrect,_that.isAnswered,_that.isAudioPlaying,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChooseCorrectLessonContent? lessonContent,  Item? currentQuestion,  bool isQuestionAudioPlaying,  bool isQuestionAudioCompleted,  Item? selectedItem,  bool isCorrect,  bool isAnswered,  bool isAudioPlaying,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ChooseCorrectLessonContentState():
return $default(_that.lessonContent,_that.currentQuestion,_that.isQuestionAudioPlaying,_that.isQuestionAudioCompleted,_that.selectedItem,_that.isCorrect,_that.isAnswered,_that.isAudioPlaying,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChooseCorrectLessonContent? lessonContent,  Item? currentQuestion,  bool isQuestionAudioPlaying,  bool isQuestionAudioCompleted,  Item? selectedItem,  bool isCorrect,  bool isAnswered,  bool isAudioPlaying,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ChooseCorrectLessonContentState() when $default != null:
return $default(_that.lessonContent,_that.currentQuestion,_that.isQuestionAudioPlaying,_that.isQuestionAudioCompleted,_that.selectedItem,_that.isCorrect,_that.isAnswered,_that.isAudioPlaying,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ChooseCorrectLessonContentState implements ChooseCorrectLessonContentState {
  const _ChooseCorrectLessonContentState({this.lessonContent, this.currentQuestion, this.isQuestionAudioPlaying = false, this.isQuestionAudioCompleted = false, this.selectedItem, this.isCorrect = false, this.isAnswered = false, this.isAudioPlaying = false, this.errorMessage});
  

@override final  ChooseCorrectLessonContent? lessonContent;
@override final  Item? currentQuestion;
@override@JsonKey() final  bool isQuestionAudioPlaying;
@override@JsonKey() final  bool isQuestionAudioCompleted;
@override final  Item? selectedItem;
@override@JsonKey() final  bool isCorrect;
@override@JsonKey() final  bool isAnswered;
@override@JsonKey() final  bool isAudioPlaying;
@override final  String? errorMessage;

/// Create a copy of ChooseCorrectLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChooseCorrectLessonContentStateCopyWith<_ChooseCorrectLessonContentState> get copyWith => __$ChooseCorrectLessonContentStateCopyWithImpl<_ChooseCorrectLessonContentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChooseCorrectLessonContentState&&const DeepCollectionEquality().equals(other.lessonContent, lessonContent)&&(identical(other.currentQuestion, currentQuestion) || other.currentQuestion == currentQuestion)&&(identical(other.isQuestionAudioPlaying, isQuestionAudioPlaying) || other.isQuestionAudioPlaying == isQuestionAudioPlaying)&&(identical(other.isQuestionAudioCompleted, isQuestionAudioCompleted) || other.isQuestionAudioCompleted == isQuestionAudioCompleted)&&(identical(other.selectedItem, selectedItem) || other.selectedItem == selectedItem)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.isAnswered, isAnswered) || other.isAnswered == isAnswered)&&(identical(other.isAudioPlaying, isAudioPlaying) || other.isAudioPlaying == isAudioPlaying)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(lessonContent),currentQuestion,isQuestionAudioPlaying,isQuestionAudioCompleted,selectedItem,isCorrect,isAnswered,isAudioPlaying,errorMessage);

@override
String toString() {
  return 'ChooseCorrectLessonContentState(lessonContent: $lessonContent, currentQuestion: $currentQuestion, isQuestionAudioPlaying: $isQuestionAudioPlaying, isQuestionAudioCompleted: $isQuestionAudioCompleted, selectedItem: $selectedItem, isCorrect: $isCorrect, isAnswered: $isAnswered, isAudioPlaying: $isAudioPlaying, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ChooseCorrectLessonContentStateCopyWith<$Res> implements $ChooseCorrectLessonContentStateCopyWith<$Res> {
  factory _$ChooseCorrectLessonContentStateCopyWith(_ChooseCorrectLessonContentState value, $Res Function(_ChooseCorrectLessonContentState) _then) = __$ChooseCorrectLessonContentStateCopyWithImpl;
@override @useResult
$Res call({
 ChooseCorrectLessonContent? lessonContent, Item? currentQuestion, bool isQuestionAudioPlaying, bool isQuestionAudioCompleted, Item? selectedItem, bool isCorrect, bool isAnswered, bool isAudioPlaying, String? errorMessage
});


@override $ItemCopyWith<$Res>? get currentQuestion;@override $ItemCopyWith<$Res>? get selectedItem;

}
/// @nodoc
class __$ChooseCorrectLessonContentStateCopyWithImpl<$Res>
    implements _$ChooseCorrectLessonContentStateCopyWith<$Res> {
  __$ChooseCorrectLessonContentStateCopyWithImpl(this._self, this._then);

  final _ChooseCorrectLessonContentState _self;
  final $Res Function(_ChooseCorrectLessonContentState) _then;

/// Create a copy of ChooseCorrectLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonContent = freezed,Object? currentQuestion = freezed,Object? isQuestionAudioPlaying = null,Object? isQuestionAudioCompleted = null,Object? selectedItem = freezed,Object? isCorrect = null,Object? isAnswered = null,Object? isAudioPlaying = null,Object? errorMessage = freezed,}) {
  return _then(_ChooseCorrectLessonContentState(
lessonContent: freezed == lessonContent ? _self.lessonContent : lessonContent // ignore: cast_nullable_to_non_nullable
as ChooseCorrectLessonContent?,currentQuestion: freezed == currentQuestion ? _self.currentQuestion : currentQuestion // ignore: cast_nullable_to_non_nullable
as Item?,isQuestionAudioPlaying: null == isQuestionAudioPlaying ? _self.isQuestionAudioPlaying : isQuestionAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,isQuestionAudioCompleted: null == isQuestionAudioCompleted ? _self.isQuestionAudioCompleted : isQuestionAudioCompleted // ignore: cast_nullable_to_non_nullable
as bool,selectedItem: freezed == selectedItem ? _self.selectedItem : selectedItem // ignore: cast_nullable_to_non_nullable
as Item?,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,isAnswered: null == isAnswered ? _self.isAnswered : isAnswered // ignore: cast_nullable_to_non_nullable
as bool,isAudioPlaying: null == isAudioPlaying ? _self.isAudioPlaying : isAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ChooseCorrectLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get currentQuestion {
    if (_self.currentQuestion == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.currentQuestion!, (value) {
    return _then(_self.copyWith(currentQuestion: value));
  });
}/// Create a copy of ChooseCorrectLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get selectedItem {
    if (_self.selectedItem == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.selectedItem!, (value) {
    return _then(_self.copyWith(selectedItem: value));
  });
}
}

// dart format on
