// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MatchEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MatchEvent()';
}


}

/// @nodoc
class $MatchEventCopyWith<$Res>  {
$MatchEventCopyWith(MatchEvent _, $Res Function(MatchEvent) __);
}


/// Adds pattern-matching-related methods to [MatchEvent].
extension MatchEventPatterns on MatchEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _OnAccept value)?  onAccept,TResult Function( _OnWrongAccept value)?  onWrongAccept,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _OnAccept() when onAccept != null:
return onAccept(_that);case _OnWrongAccept() when onWrongAccept != null:
return onWrongAccept(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _OnAccept value)  onAccept,required TResult Function( _OnWrongAccept value)  onWrongAccept,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _OnAccept():
return onAccept(_that);case _OnWrongAccept():
return onWrongAccept(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _OnAccept value)?  onAccept,TResult? Function( _OnWrongAccept value)?  onWrongAccept,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _OnAccept() when onAccept != null:
return onAccept(_that);case _OnWrongAccept() when onWrongAccept != null:
return onWrongAccept(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( SlideUpToMatchLessonContent content)?  started,TResult Function( String nepaliWord)?  onAccept,TResult Function()?  onWrongAccept,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _OnAccept() when onAccept != null:
return onAccept(_that.nepaliWord);case _OnWrongAccept() when onWrongAccept != null:
return onWrongAccept();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( SlideUpToMatchLessonContent content)  started,required TResult Function( String nepaliWord)  onAccept,required TResult Function()  onWrongAccept,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _OnAccept():
return onAccept(_that.nepaliWord);case _OnWrongAccept():
return onWrongAccept();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( SlideUpToMatchLessonContent content)?  started,TResult? Function( String nepaliWord)?  onAccept,TResult? Function()?  onWrongAccept,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _OnAccept() when onAccept != null:
return onAccept(_that.nepaliWord);case _OnWrongAccept() when onWrongAccept != null:
return onWrongAccept();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements MatchEvent {
  const _Started(this.content);
  

 final  SlideUpToMatchLessonContent content;

/// Create a copy of MatchEvent
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
  return 'MatchEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $MatchEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 SlideUpToMatchLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of MatchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as SlideUpToMatchLessonContent,
  ));
}


}

/// @nodoc


class _OnAccept implements MatchEvent {
  const _OnAccept(this.nepaliWord);
  

 final  String nepaliWord;

/// Create a copy of MatchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnAcceptCopyWith<_OnAccept> get copyWith => __$OnAcceptCopyWithImpl<_OnAccept>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnAccept&&(identical(other.nepaliWord, nepaliWord) || other.nepaliWord == nepaliWord));
}


@override
int get hashCode => Object.hash(runtimeType,nepaliWord);

@override
String toString() {
  return 'MatchEvent.onAccept(nepaliWord: $nepaliWord)';
}


}

/// @nodoc
abstract mixin class _$OnAcceptCopyWith<$Res> implements $MatchEventCopyWith<$Res> {
  factory _$OnAcceptCopyWith(_OnAccept value, $Res Function(_OnAccept) _then) = __$OnAcceptCopyWithImpl;
@useResult
$Res call({
 String nepaliWord
});




}
/// @nodoc
class __$OnAcceptCopyWithImpl<$Res>
    implements _$OnAcceptCopyWith<$Res> {
  __$OnAcceptCopyWithImpl(this._self, this._then);

  final _OnAccept _self;
  final $Res Function(_OnAccept) _then;

/// Create a copy of MatchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? nepaliWord = null,}) {
  return _then(_OnAccept(
null == nepaliWord ? _self.nepaliWord : nepaliWord // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _OnWrongAccept implements MatchEvent {
  const _OnWrongAccept();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnWrongAccept);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MatchEvent.onWrongAccept()';
}


}




/// @nodoc
mixin _$MatchState {

 SlideUpToMatchLessonContent? get content; List<NepaliWord> get nepaliWords; bool get isAnsweredAll; bool get completionFeedbackReady;
/// Create a copy of MatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchStateCopyWith<MatchState> get copyWith => _$MatchStateCopyWithImpl<MatchState>(this as MatchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchState&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other.nepaliWords, nepaliWords)&&(identical(other.isAnsweredAll, isAnsweredAll) || other.isAnsweredAll == isAnsweredAll)&&(identical(other.completionFeedbackReady, completionFeedbackReady) || other.completionFeedbackReady == completionFeedbackReady));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(nepaliWords),isAnsweredAll,completionFeedbackReady);

@override
String toString() {
  return 'MatchState(content: $content, nepaliWords: $nepaliWords, isAnsweredAll: $isAnsweredAll, completionFeedbackReady: $completionFeedbackReady)';
}


}

/// @nodoc
abstract mixin class $MatchStateCopyWith<$Res>  {
  factory $MatchStateCopyWith(MatchState value, $Res Function(MatchState) _then) = _$MatchStateCopyWithImpl;
@useResult
$Res call({
 SlideUpToMatchLessonContent? content, List<NepaliWord> nepaliWords, bool isAnsweredAll, bool completionFeedbackReady
});




}
/// @nodoc
class _$MatchStateCopyWithImpl<$Res>
    implements $MatchStateCopyWith<$Res> {
  _$MatchStateCopyWithImpl(this._self, this._then);

  final MatchState _self;
  final $Res Function(MatchState) _then;

/// Create a copy of MatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? nepaliWords = null,Object? isAnsweredAll = null,Object? completionFeedbackReady = null,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as SlideUpToMatchLessonContent?,nepaliWords: null == nepaliWords ? _self.nepaliWords : nepaliWords // ignore: cast_nullable_to_non_nullable
as List<NepaliWord>,isAnsweredAll: null == isAnsweredAll ? _self.isAnsweredAll : isAnsweredAll // ignore: cast_nullable_to_non_nullable
as bool,completionFeedbackReady: null == completionFeedbackReady ? _self.completionFeedbackReady : completionFeedbackReady // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchState].
extension MatchStatePatterns on MatchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchState value)  $default,){
final _that = this;
switch (_that) {
case _MatchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchState value)?  $default,){
final _that = this;
switch (_that) {
case _MatchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SlideUpToMatchLessonContent? content,  List<NepaliWord> nepaliWords,  bool isAnsweredAll,  bool completionFeedbackReady)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchState() when $default != null:
return $default(_that.content,_that.nepaliWords,_that.isAnsweredAll,_that.completionFeedbackReady);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SlideUpToMatchLessonContent? content,  List<NepaliWord> nepaliWords,  bool isAnsweredAll,  bool completionFeedbackReady)  $default,) {final _that = this;
switch (_that) {
case _MatchState():
return $default(_that.content,_that.nepaliWords,_that.isAnsweredAll,_that.completionFeedbackReady);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SlideUpToMatchLessonContent? content,  List<NepaliWord> nepaliWords,  bool isAnsweredAll,  bool completionFeedbackReady)?  $default,) {final _that = this;
switch (_that) {
case _MatchState() when $default != null:
return $default(_that.content,_that.nepaliWords,_that.isAnsweredAll,_that.completionFeedbackReady);case _:
  return null;

}
}

}

/// @nodoc


class _MatchState implements MatchState {
  const _MatchState({this.content, final  List<NepaliWord> nepaliWords = const [], this.isAnsweredAll = false, this.completionFeedbackReady = false}): _nepaliWords = nepaliWords;
  

@override final  SlideUpToMatchLessonContent? content;
 final  List<NepaliWord> _nepaliWords;
@override@JsonKey() List<NepaliWord> get nepaliWords {
  if (_nepaliWords is EqualUnmodifiableListView) return _nepaliWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nepaliWords);
}

@override@JsonKey() final  bool isAnsweredAll;
@override@JsonKey() final  bool completionFeedbackReady;

/// Create a copy of MatchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchStateCopyWith<_MatchState> get copyWith => __$MatchStateCopyWithImpl<_MatchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchState&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other._nepaliWords, _nepaliWords)&&(identical(other.isAnsweredAll, isAnsweredAll) || other.isAnsweredAll == isAnsweredAll)&&(identical(other.completionFeedbackReady, completionFeedbackReady) || other.completionFeedbackReady == completionFeedbackReady));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(_nepaliWords),isAnsweredAll,completionFeedbackReady);

@override
String toString() {
  return 'MatchState(content: $content, nepaliWords: $nepaliWords, isAnsweredAll: $isAnsweredAll, completionFeedbackReady: $completionFeedbackReady)';
}


}

/// @nodoc
abstract mixin class _$MatchStateCopyWith<$Res> implements $MatchStateCopyWith<$Res> {
  factory _$MatchStateCopyWith(_MatchState value, $Res Function(_MatchState) _then) = __$MatchStateCopyWithImpl;
@override @useResult
$Res call({
 SlideUpToMatchLessonContent? content, List<NepaliWord> nepaliWords, bool isAnsweredAll, bool completionFeedbackReady
});




}
/// @nodoc
class __$MatchStateCopyWithImpl<$Res>
    implements _$MatchStateCopyWith<$Res> {
  __$MatchStateCopyWithImpl(this._self, this._then);

  final _MatchState _self;
  final $Res Function(_MatchState) _then;

/// Create a copy of MatchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? nepaliWords = null,Object? isAnsweredAll = null,Object? completionFeedbackReady = null,}) {
  return _then(_MatchState(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as SlideUpToMatchLessonContent?,nepaliWords: null == nepaliWords ? _self._nepaliWords : nepaliWords // ignore: cast_nullable_to_non_nullable
as List<NepaliWord>,isAnsweredAll: null == isAnsweredAll ? _self.isAnsweredAll : isAnsweredAll // ignore: cast_nullable_to_non_nullable
as bool,completionFeedbackReady: null == completionFeedbackReady ? _self.completionFeedbackReady : completionFeedbackReady // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$NepaliWord {

 String get word; bool get isMatched;
/// Create a copy of NepaliWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NepaliWordCopyWith<NepaliWord> get copyWith => _$NepaliWordCopyWithImpl<NepaliWord>(this as NepaliWord, _$identity);

  /// Serializes this NepaliWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NepaliWord&&(identical(other.word, word) || other.word == word)&&(identical(other.isMatched, isMatched) || other.isMatched == isMatched));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,isMatched);

@override
String toString() {
  return 'NepaliWord(word: $word, isMatched: $isMatched)';
}


}

/// @nodoc
abstract mixin class $NepaliWordCopyWith<$Res>  {
  factory $NepaliWordCopyWith(NepaliWord value, $Res Function(NepaliWord) _then) = _$NepaliWordCopyWithImpl;
@useResult
$Res call({
 String word, bool isMatched
});




}
/// @nodoc
class _$NepaliWordCopyWithImpl<$Res>
    implements $NepaliWordCopyWith<$Res> {
  _$NepaliWordCopyWithImpl(this._self, this._then);

  final NepaliWord _self;
  final $Res Function(NepaliWord) _then;

/// Create a copy of NepaliWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? isMatched = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,isMatched: null == isMatched ? _self.isMatched : isMatched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NepaliWord].
extension NepaliWordPatterns on NepaliWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NepaliWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NepaliWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NepaliWord value)  $default,){
final _that = this;
switch (_that) {
case _NepaliWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NepaliWord value)?  $default,){
final _that = this;
switch (_that) {
case _NepaliWord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  bool isMatched)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NepaliWord() when $default != null:
return $default(_that.word,_that.isMatched);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  bool isMatched)  $default,) {final _that = this;
switch (_that) {
case _NepaliWord():
return $default(_that.word,_that.isMatched);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  bool isMatched)?  $default,) {final _that = this;
switch (_that) {
case _NepaliWord() when $default != null:
return $default(_that.word,_that.isMatched);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NepaliWord implements NepaliWord {
  const _NepaliWord({required this.word, this.isMatched = false});
  factory _NepaliWord.fromJson(Map<String, dynamic> json) => _$NepaliWordFromJson(json);

@override final  String word;
@override@JsonKey() final  bool isMatched;

/// Create a copy of NepaliWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NepaliWordCopyWith<_NepaliWord> get copyWith => __$NepaliWordCopyWithImpl<_NepaliWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NepaliWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NepaliWord&&(identical(other.word, word) || other.word == word)&&(identical(other.isMatched, isMatched) || other.isMatched == isMatched));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,isMatched);

@override
String toString() {
  return 'NepaliWord(word: $word, isMatched: $isMatched)';
}


}

/// @nodoc
abstract mixin class _$NepaliWordCopyWith<$Res> implements $NepaliWordCopyWith<$Res> {
  factory _$NepaliWordCopyWith(_NepaliWord value, $Res Function(_NepaliWord) _then) = __$NepaliWordCopyWithImpl;
@override @useResult
$Res call({
 String word, bool isMatched
});




}
/// @nodoc
class __$NepaliWordCopyWithImpl<$Res>
    implements _$NepaliWordCopyWith<$Res> {
  __$NepaliWordCopyWithImpl(this._self, this._then);

  final _NepaliWord _self;
  final $Res Function(_NepaliWord) _then;

/// Create a copy of NepaliWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? isMatched = null,}) {
  return _then(_NepaliWord(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,isMatched: null == isMatched ? _self.isMatched : isMatched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
