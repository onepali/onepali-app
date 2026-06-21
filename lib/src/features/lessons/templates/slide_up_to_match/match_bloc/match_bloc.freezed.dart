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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _OnAccept value)?  onAccept,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _OnAccept() when onAccept != null:
return onAccept(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _OnAccept value)  onAccept,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _OnAccept():
return onAccept(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _OnAccept value)?  onAccept,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _OnAccept() when onAccept != null:
return onAccept(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( SlideUpToMatchLessonContent content)?  started,TResult Function( String nepaliWord)?  onAccept,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _OnAccept() when onAccept != null:
return onAccept(_that.nepaliWord);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( SlideUpToMatchLessonContent content)  started,required TResult Function( String nepaliWord)  onAccept,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _OnAccept():
return onAccept(_that.nepaliWord);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( SlideUpToMatchLessonContent content)?  started,TResult? Function( String nepaliWord)?  onAccept,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _OnAccept() when onAccept != null:
return onAccept(_that.nepaliWord);case _:
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
mixin _$MatchState {

 SlideUpToMatchLessonContent? get content; List<String> get nepaliWords; bool get isAnsweredAll;
/// Create a copy of MatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchStateCopyWith<MatchState> get copyWith => _$MatchStateCopyWithImpl<MatchState>(this as MatchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchState&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other.nepaliWords, nepaliWords)&&(identical(other.isAnsweredAll, isAnsweredAll) || other.isAnsweredAll == isAnsweredAll));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(nepaliWords),isAnsweredAll);

@override
String toString() {
  return 'MatchState(content: $content, nepaliWords: $nepaliWords, isAnsweredAll: $isAnsweredAll)';
}


}

/// @nodoc
abstract mixin class $MatchStateCopyWith<$Res>  {
  factory $MatchStateCopyWith(MatchState value, $Res Function(MatchState) _then) = _$MatchStateCopyWithImpl;
@useResult
$Res call({
 SlideUpToMatchLessonContent? content, List<String> nepaliWords, bool isAnsweredAll
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
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? nepaliWords = null,Object? isAnsweredAll = null,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as SlideUpToMatchLessonContent?,nepaliWords: null == nepaliWords ? _self.nepaliWords : nepaliWords // ignore: cast_nullable_to_non_nullable
as List<String>,isAnsweredAll: null == isAnsweredAll ? _self.isAnsweredAll : isAnsweredAll // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SlideUpToMatchLessonContent? content,  List<String> nepaliWords,  bool isAnsweredAll)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchState() when $default != null:
return $default(_that.content,_that.nepaliWords,_that.isAnsweredAll);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SlideUpToMatchLessonContent? content,  List<String> nepaliWords,  bool isAnsweredAll)  $default,) {final _that = this;
switch (_that) {
case _MatchState():
return $default(_that.content,_that.nepaliWords,_that.isAnsweredAll);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SlideUpToMatchLessonContent? content,  List<String> nepaliWords,  bool isAnsweredAll)?  $default,) {final _that = this;
switch (_that) {
case _MatchState() when $default != null:
return $default(_that.content,_that.nepaliWords,_that.isAnsweredAll);case _:
  return null;

}
}

}

/// @nodoc


class _MatchState implements MatchState {
  const _MatchState({this.content, final  List<String> nepaliWords = const [], this.isAnsweredAll = false}): _nepaliWords = nepaliWords;
  

@override final  SlideUpToMatchLessonContent? content;
 final  List<String> _nepaliWords;
@override@JsonKey() List<String> get nepaliWords {
  if (_nepaliWords is EqualUnmodifiableListView) return _nepaliWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nepaliWords);
}

@override@JsonKey() final  bool isAnsweredAll;

/// Create a copy of MatchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchStateCopyWith<_MatchState> get copyWith => __$MatchStateCopyWithImpl<_MatchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchState&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other._nepaliWords, _nepaliWords)&&(identical(other.isAnsweredAll, isAnsweredAll) || other.isAnsweredAll == isAnsweredAll));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(_nepaliWords),isAnsweredAll);

@override
String toString() {
  return 'MatchState(content: $content, nepaliWords: $nepaliWords, isAnsweredAll: $isAnsweredAll)';
}


}

/// @nodoc
abstract mixin class _$MatchStateCopyWith<$Res> implements $MatchStateCopyWith<$Res> {
  factory _$MatchStateCopyWith(_MatchState value, $Res Function(_MatchState) _then) = __$MatchStateCopyWithImpl;
@override @useResult
$Res call({
 SlideUpToMatchLessonContent? content, List<String> nepaliWords, bool isAnsweredAll
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
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? nepaliWords = null,Object? isAnsweredAll = null,}) {
  return _then(_MatchState(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as SlideUpToMatchLessonContent?,nepaliWords: null == nepaliWords ? _self._nepaliWords : nepaliWords // ignore: cast_nullable_to_non_nullable
as List<String>,isAnsweredAll: null == isAnsweredAll ? _self.isAnsweredAll : isAnsweredAll // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
