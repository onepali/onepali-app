// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tap_to_reveal_lesson_content_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TapToRevealLessonContentEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToRevealLessonContentEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TapToRevealLessonContentEvent()';
}


}

/// @nodoc
class $TapToRevealLessonContentEventCopyWith<$Res>  {
$TapToRevealLessonContentEventCopyWith(TapToRevealLessonContentEvent _, $Res Function(TapToRevealLessonContentEvent) __);
}


/// Adds pattern-matching-related methods to [TapToRevealLessonContentEvent].
extension TapToRevealLessonContentEventPatterns on TapToRevealLessonContentEvent {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TapToRevealLessonContent content)?  started,TResult Function()?  questionAudioCompleted,TResult Function( Item tappedItem)?  itemTapped,TResult Function()?  correctAudioCompleted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _QuestionAudioCompleted() when questionAudioCompleted != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TapToRevealLessonContent content)  started,required TResult Function()  questionAudioCompleted,required TResult Function( Item tappedItem)  itemTapped,required TResult Function()  correctAudioCompleted,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _QuestionAudioCompleted():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TapToRevealLessonContent content)?  started,TResult? Function()?  questionAudioCompleted,TResult? Function( Item tappedItem)?  itemTapped,TResult? Function()?  correctAudioCompleted,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _QuestionAudioCompleted() when questionAudioCompleted != null:
return questionAudioCompleted();case _ItemTapped() when itemTapped != null:
return itemTapped(_that.tappedItem);case _CorrectAudioCompleted() when correctAudioCompleted != null:
return correctAudioCompleted();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements TapToRevealLessonContentEvent {
  const _Started(this.content);
  

 final  TapToRevealLessonContent content;

/// Create a copy of TapToRevealLessonContentEvent
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
  return 'TapToRevealLessonContentEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $TapToRevealLessonContentEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 TapToRevealLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of TapToRevealLessonContentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToRevealLessonContent,
  ));
}


}

/// @nodoc


class _QuestionAudioCompleted implements TapToRevealLessonContentEvent {
  const _QuestionAudioCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionAudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TapToRevealLessonContentEvent.questionAudioCompleted()';
}


}




/// @nodoc


class _ItemTapped implements TapToRevealLessonContentEvent {
  const _ItemTapped(this.tappedItem);
  

 final  Item tappedItem;

/// Create a copy of TapToRevealLessonContentEvent
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
  return 'TapToRevealLessonContentEvent.itemTapped(tappedItem: $tappedItem)';
}


}

/// @nodoc
abstract mixin class _$ItemTappedCopyWith<$Res> implements $TapToRevealLessonContentEventCopyWith<$Res> {
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

/// Create a copy of TapToRevealLessonContentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tappedItem = null,}) {
  return _then(_ItemTapped(
null == tappedItem ? _self.tappedItem : tappedItem // ignore: cast_nullable_to_non_nullable
as Item,
  ));
}

/// Create a copy of TapToRevealLessonContentEvent
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


class _CorrectAudioCompleted implements TapToRevealLessonContentEvent {
  const _CorrectAudioCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorrectAudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TapToRevealLessonContentEvent.correctAudioCompleted()';
}


}




/// @nodoc
mixin _$TapToRevealLessonContentState {

 TapToRevealLessonContent? get content; List<Item> get selectedItems; int get currentQuestionIndex; Item? get currentQuestion; bool get isQuestionAudioPlaying; bool get isQuestionAudioCompleted; Item? get tappedItem; bool get isCorrect; bool get isAnswered; bool get isCorrectAudioPlaying; bool get allQuestionsCompleted; bool get showCorrectName; String? get errorMessage;
/// Create a copy of TapToRevealLessonContentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TapToRevealLessonContentStateCopyWith<TapToRevealLessonContentState> get copyWith => _$TapToRevealLessonContentStateCopyWithImpl<TapToRevealLessonContentState>(this as TapToRevealLessonContentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToRevealLessonContentState&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other.selectedItems, selectedItems)&&(identical(other.currentQuestionIndex, currentQuestionIndex) || other.currentQuestionIndex == currentQuestionIndex)&&(identical(other.currentQuestion, currentQuestion) || other.currentQuestion == currentQuestion)&&(identical(other.isQuestionAudioPlaying, isQuestionAudioPlaying) || other.isQuestionAudioPlaying == isQuestionAudioPlaying)&&(identical(other.isQuestionAudioCompleted, isQuestionAudioCompleted) || other.isQuestionAudioCompleted == isQuestionAudioCompleted)&&(identical(other.tappedItem, tappedItem) || other.tappedItem == tappedItem)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.isAnswered, isAnswered) || other.isAnswered == isAnswered)&&(identical(other.isCorrectAudioPlaying, isCorrectAudioPlaying) || other.isCorrectAudioPlaying == isCorrectAudioPlaying)&&(identical(other.allQuestionsCompleted, allQuestionsCompleted) || other.allQuestionsCompleted == allQuestionsCompleted)&&(identical(other.showCorrectName, showCorrectName) || other.showCorrectName == showCorrectName)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(selectedItems),currentQuestionIndex,currentQuestion,isQuestionAudioPlaying,isQuestionAudioCompleted,tappedItem,isCorrect,isAnswered,isCorrectAudioPlaying,allQuestionsCompleted,showCorrectName,errorMessage);

@override
String toString() {
  return 'TapToRevealLessonContentState(content: $content, selectedItems: $selectedItems, currentQuestionIndex: $currentQuestionIndex, currentQuestion: $currentQuestion, isQuestionAudioPlaying: $isQuestionAudioPlaying, isQuestionAudioCompleted: $isQuestionAudioCompleted, tappedItem: $tappedItem, isCorrect: $isCorrect, isAnswered: $isAnswered, isCorrectAudioPlaying: $isCorrectAudioPlaying, allQuestionsCompleted: $allQuestionsCompleted, showCorrectName: $showCorrectName, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $TapToRevealLessonContentStateCopyWith<$Res>  {
  factory $TapToRevealLessonContentStateCopyWith(TapToRevealLessonContentState value, $Res Function(TapToRevealLessonContentState) _then) = _$TapToRevealLessonContentStateCopyWithImpl;
@useResult
$Res call({
 TapToRevealLessonContent? content, List<Item> selectedItems, int currentQuestionIndex, Item? currentQuestion, bool isQuestionAudioPlaying, bool isQuestionAudioCompleted, Item? tappedItem, bool isCorrect, bool isAnswered, bool isCorrectAudioPlaying, bool allQuestionsCompleted, bool showCorrectName, String? errorMessage
});


$ItemCopyWith<$Res>? get currentQuestion;$ItemCopyWith<$Res>? get tappedItem;

}
/// @nodoc
class _$TapToRevealLessonContentStateCopyWithImpl<$Res>
    implements $TapToRevealLessonContentStateCopyWith<$Res> {
  _$TapToRevealLessonContentStateCopyWithImpl(this._self, this._then);

  final TapToRevealLessonContentState _self;
  final $Res Function(TapToRevealLessonContentState) _then;

/// Create a copy of TapToRevealLessonContentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? selectedItems = null,Object? currentQuestionIndex = null,Object? currentQuestion = freezed,Object? isQuestionAudioPlaying = null,Object? isQuestionAudioCompleted = null,Object? tappedItem = freezed,Object? isCorrect = null,Object? isAnswered = null,Object? isCorrectAudioPlaying = null,Object? allQuestionsCompleted = null,Object? showCorrectName = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToRevealLessonContent?,selectedItems: null == selectedItems ? _self.selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as List<Item>,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,currentQuestion: freezed == currentQuestion ? _self.currentQuestion : currentQuestion // ignore: cast_nullable_to_non_nullable
as Item?,isQuestionAudioPlaying: null == isQuestionAudioPlaying ? _self.isQuestionAudioPlaying : isQuestionAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,isQuestionAudioCompleted: null == isQuestionAudioCompleted ? _self.isQuestionAudioCompleted : isQuestionAudioCompleted // ignore: cast_nullable_to_non_nullable
as bool,tappedItem: freezed == tappedItem ? _self.tappedItem : tappedItem // ignore: cast_nullable_to_non_nullable
as Item?,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,isAnswered: null == isAnswered ? _self.isAnswered : isAnswered // ignore: cast_nullable_to_non_nullable
as bool,isCorrectAudioPlaying: null == isCorrectAudioPlaying ? _self.isCorrectAudioPlaying : isCorrectAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,allQuestionsCompleted: null == allQuestionsCompleted ? _self.allQuestionsCompleted : allQuestionsCompleted // ignore: cast_nullable_to_non_nullable
as bool,showCorrectName: null == showCorrectName ? _self.showCorrectName : showCorrectName // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TapToRevealLessonContentState
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
}/// Create a copy of TapToRevealLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get tappedItem {
    if (_self.tappedItem == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.tappedItem!, (value) {
    return _then(_self.copyWith(tappedItem: value));
  });
}
}


/// Adds pattern-matching-related methods to [TapToRevealLessonContentState].
extension TapToRevealLessonContentStatePatterns on TapToRevealLessonContentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TapToRevealLessonContentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TapToRevealLessonContentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TapToRevealLessonContentState value)  $default,){
final _that = this;
switch (_that) {
case _TapToRevealLessonContentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TapToRevealLessonContentState value)?  $default,){
final _that = this;
switch (_that) {
case _TapToRevealLessonContentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TapToRevealLessonContent? content,  List<Item> selectedItems,  int currentQuestionIndex,  Item? currentQuestion,  bool isQuestionAudioPlaying,  bool isQuestionAudioCompleted,  Item? tappedItem,  bool isCorrect,  bool isAnswered,  bool isCorrectAudioPlaying,  bool allQuestionsCompleted,  bool showCorrectName,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TapToRevealLessonContentState() when $default != null:
return $default(_that.content,_that.selectedItems,_that.currentQuestionIndex,_that.currentQuestion,_that.isQuestionAudioPlaying,_that.isQuestionAudioCompleted,_that.tappedItem,_that.isCorrect,_that.isAnswered,_that.isCorrectAudioPlaying,_that.allQuestionsCompleted,_that.showCorrectName,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TapToRevealLessonContent? content,  List<Item> selectedItems,  int currentQuestionIndex,  Item? currentQuestion,  bool isQuestionAudioPlaying,  bool isQuestionAudioCompleted,  Item? tappedItem,  bool isCorrect,  bool isAnswered,  bool isCorrectAudioPlaying,  bool allQuestionsCompleted,  bool showCorrectName,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TapToRevealLessonContentState():
return $default(_that.content,_that.selectedItems,_that.currentQuestionIndex,_that.currentQuestion,_that.isQuestionAudioPlaying,_that.isQuestionAudioCompleted,_that.tappedItem,_that.isCorrect,_that.isAnswered,_that.isCorrectAudioPlaying,_that.allQuestionsCompleted,_that.showCorrectName,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TapToRevealLessonContent? content,  List<Item> selectedItems,  int currentQuestionIndex,  Item? currentQuestion,  bool isQuestionAudioPlaying,  bool isQuestionAudioCompleted,  Item? tappedItem,  bool isCorrect,  bool isAnswered,  bool isCorrectAudioPlaying,  bool allQuestionsCompleted,  bool showCorrectName,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TapToRevealLessonContentState() when $default != null:
return $default(_that.content,_that.selectedItems,_that.currentQuestionIndex,_that.currentQuestion,_that.isQuestionAudioPlaying,_that.isQuestionAudioCompleted,_that.tappedItem,_that.isCorrect,_that.isAnswered,_that.isCorrectAudioPlaying,_that.allQuestionsCompleted,_that.showCorrectName,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TapToRevealLessonContentState implements TapToRevealLessonContentState {
  const _TapToRevealLessonContentState({this.content, final  List<Item> selectedItems = const [], this.currentQuestionIndex = 0, this.currentQuestion, this.isQuestionAudioPlaying = false, this.isQuestionAudioCompleted = false, this.tappedItem, this.isCorrect = false, this.isAnswered = false, this.isCorrectAudioPlaying = false, this.allQuestionsCompleted = false, this.showCorrectName = false, this.errorMessage}): _selectedItems = selectedItems;
  

@override final  TapToRevealLessonContent? content;
 final  List<Item> _selectedItems;
@override@JsonKey() List<Item> get selectedItems {
  if (_selectedItems is EqualUnmodifiableListView) return _selectedItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedItems);
}

@override@JsonKey() final  int currentQuestionIndex;
@override final  Item? currentQuestion;
@override@JsonKey() final  bool isQuestionAudioPlaying;
@override@JsonKey() final  bool isQuestionAudioCompleted;
@override final  Item? tappedItem;
@override@JsonKey() final  bool isCorrect;
@override@JsonKey() final  bool isAnswered;
@override@JsonKey() final  bool isCorrectAudioPlaying;
@override@JsonKey() final  bool allQuestionsCompleted;
@override@JsonKey() final  bool showCorrectName;
@override final  String? errorMessage;

/// Create a copy of TapToRevealLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TapToRevealLessonContentStateCopyWith<_TapToRevealLessonContentState> get copyWith => __$TapToRevealLessonContentStateCopyWithImpl<_TapToRevealLessonContentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TapToRevealLessonContentState&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other._selectedItems, _selectedItems)&&(identical(other.currentQuestionIndex, currentQuestionIndex) || other.currentQuestionIndex == currentQuestionIndex)&&(identical(other.currentQuestion, currentQuestion) || other.currentQuestion == currentQuestion)&&(identical(other.isQuestionAudioPlaying, isQuestionAudioPlaying) || other.isQuestionAudioPlaying == isQuestionAudioPlaying)&&(identical(other.isQuestionAudioCompleted, isQuestionAudioCompleted) || other.isQuestionAudioCompleted == isQuestionAudioCompleted)&&(identical(other.tappedItem, tappedItem) || other.tappedItem == tappedItem)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.isAnswered, isAnswered) || other.isAnswered == isAnswered)&&(identical(other.isCorrectAudioPlaying, isCorrectAudioPlaying) || other.isCorrectAudioPlaying == isCorrectAudioPlaying)&&(identical(other.allQuestionsCompleted, allQuestionsCompleted) || other.allQuestionsCompleted == allQuestionsCompleted)&&(identical(other.showCorrectName, showCorrectName) || other.showCorrectName == showCorrectName)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(_selectedItems),currentQuestionIndex,currentQuestion,isQuestionAudioPlaying,isQuestionAudioCompleted,tappedItem,isCorrect,isAnswered,isCorrectAudioPlaying,allQuestionsCompleted,showCorrectName,errorMessage);

@override
String toString() {
  return 'TapToRevealLessonContentState(content: $content, selectedItems: $selectedItems, currentQuestionIndex: $currentQuestionIndex, currentQuestion: $currentQuestion, isQuestionAudioPlaying: $isQuestionAudioPlaying, isQuestionAudioCompleted: $isQuestionAudioCompleted, tappedItem: $tappedItem, isCorrect: $isCorrect, isAnswered: $isAnswered, isCorrectAudioPlaying: $isCorrectAudioPlaying, allQuestionsCompleted: $allQuestionsCompleted, showCorrectName: $showCorrectName, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TapToRevealLessonContentStateCopyWith<$Res> implements $TapToRevealLessonContentStateCopyWith<$Res> {
  factory _$TapToRevealLessonContentStateCopyWith(_TapToRevealLessonContentState value, $Res Function(_TapToRevealLessonContentState) _then) = __$TapToRevealLessonContentStateCopyWithImpl;
@override @useResult
$Res call({
 TapToRevealLessonContent? content, List<Item> selectedItems, int currentQuestionIndex, Item? currentQuestion, bool isQuestionAudioPlaying, bool isQuestionAudioCompleted, Item? tappedItem, bool isCorrect, bool isAnswered, bool isCorrectAudioPlaying, bool allQuestionsCompleted, bool showCorrectName, String? errorMessage
});


@override $ItemCopyWith<$Res>? get currentQuestion;@override $ItemCopyWith<$Res>? get tappedItem;

}
/// @nodoc
class __$TapToRevealLessonContentStateCopyWithImpl<$Res>
    implements _$TapToRevealLessonContentStateCopyWith<$Res> {
  __$TapToRevealLessonContentStateCopyWithImpl(this._self, this._then);

  final _TapToRevealLessonContentState _self;
  final $Res Function(_TapToRevealLessonContentState) _then;

/// Create a copy of TapToRevealLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? selectedItems = null,Object? currentQuestionIndex = null,Object? currentQuestion = freezed,Object? isQuestionAudioPlaying = null,Object? isQuestionAudioCompleted = null,Object? tappedItem = freezed,Object? isCorrect = null,Object? isAnswered = null,Object? isCorrectAudioPlaying = null,Object? allQuestionsCompleted = null,Object? showCorrectName = null,Object? errorMessage = freezed,}) {
  return _then(_TapToRevealLessonContentState(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToRevealLessonContent?,selectedItems: null == selectedItems ? _self._selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as List<Item>,currentQuestionIndex: null == currentQuestionIndex ? _self.currentQuestionIndex : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
as int,currentQuestion: freezed == currentQuestion ? _self.currentQuestion : currentQuestion // ignore: cast_nullable_to_non_nullable
as Item?,isQuestionAudioPlaying: null == isQuestionAudioPlaying ? _self.isQuestionAudioPlaying : isQuestionAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,isQuestionAudioCompleted: null == isQuestionAudioCompleted ? _self.isQuestionAudioCompleted : isQuestionAudioCompleted // ignore: cast_nullable_to_non_nullable
as bool,tappedItem: freezed == tappedItem ? _self.tappedItem : tappedItem // ignore: cast_nullable_to_non_nullable
as Item?,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,isAnswered: null == isAnswered ? _self.isAnswered : isAnswered // ignore: cast_nullable_to_non_nullable
as bool,isCorrectAudioPlaying: null == isCorrectAudioPlaying ? _self.isCorrectAudioPlaying : isCorrectAudioPlaying // ignore: cast_nullable_to_non_nullable
as bool,allQuestionsCompleted: null == allQuestionsCompleted ? _self.allQuestionsCompleted : allQuestionsCompleted // ignore: cast_nullable_to_non_nullable
as bool,showCorrectName: null == showCorrectName ? _self.showCorrectName : showCorrectName // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TapToRevealLessonContentState
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
}/// Create a copy of TapToRevealLessonContentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get tappedItem {
    if (_self.tappedItem == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.tappedItem!, (value) {
    return _then(_self.copyWith(tappedItem: value));
  });
}
}

// dart format on
