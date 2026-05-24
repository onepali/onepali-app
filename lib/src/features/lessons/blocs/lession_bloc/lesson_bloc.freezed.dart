// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LessonEvent()';
}


}

/// @nodoc
class $LessonEventCopyWith<$Res>  {
$LessonEventCopyWith(LessonEvent _, $Res Function(LessonEvent) __);
}


/// Adds pattern-matching-related methods to [LessonEvent].
extension LessonEventPatterns on LessonEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _PlayInfo value)?  playInfo,TResult Function( _PlayItemAudio value)?  playItemAudio,TResult Function( _PlayChooseCorrectItem value)?  playChooseCorrectItem,TResult Function( _ChooseItem value)?  chooseItem,TResult Function( _NextContent value)?  nextContent,TResult Function( _PreviousContent value)?  previousContent,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _PlayInfo() when playInfo != null:
return playInfo(_that);case _PlayItemAudio() when playItemAudio != null:
return playItemAudio(_that);case _PlayChooseCorrectItem() when playChooseCorrectItem != null:
return playChooseCorrectItem(_that);case _ChooseItem() when chooseItem != null:
return chooseItem(_that);case _NextContent() when nextContent != null:
return nextContent(_that);case _PreviousContent() when previousContent != null:
return previousContent(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _PlayInfo value)  playInfo,required TResult Function( _PlayItemAudio value)  playItemAudio,required TResult Function( _PlayChooseCorrectItem value)  playChooseCorrectItem,required TResult Function( _ChooseItem value)  chooseItem,required TResult Function( _NextContent value)  nextContent,required TResult Function( _PreviousContent value)  previousContent,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _PlayInfo():
return playInfo(_that);case _PlayItemAudio():
return playItemAudio(_that);case _PlayChooseCorrectItem():
return playChooseCorrectItem(_that);case _ChooseItem():
return chooseItem(_that);case _NextContent():
return nextContent(_that);case _PreviousContent():
return previousContent(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _PlayInfo value)?  playInfo,TResult? Function( _PlayItemAudio value)?  playItemAudio,TResult? Function( _PlayChooseCorrectItem value)?  playChooseCorrectItem,TResult? Function( _ChooseItem value)?  chooseItem,TResult? Function( _NextContent value)?  nextContent,TResult? Function( _PreviousContent value)?  previousContent,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _PlayInfo() when playInfo != null:
return playInfo(_that);case _PlayItemAudio() when playItemAudio != null:
return playItemAudio(_that);case _PlayChooseCorrectItem() when playChooseCorrectItem != null:
return playChooseCorrectItem(_that);case _ChooseItem() when chooseItem != null:
return chooseItem(_that);case _NextContent() when nextContent != null:
return nextContent(_that);case _PreviousContent() when previousContent != null:
return previousContent(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String lessonId)?  started,TResult Function( int index)?  playInfo,TResult Function()?  playItemAudio,TResult Function()?  playChooseCorrectItem,TResult Function( Item item)?  chooseItem,TResult Function()?  nextContent,TResult Function()?  previousContent,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.lessonId);case _PlayInfo() when playInfo != null:
return playInfo(_that.index);case _PlayItemAudio() when playItemAudio != null:
return playItemAudio();case _PlayChooseCorrectItem() when playChooseCorrectItem != null:
return playChooseCorrectItem();case _ChooseItem() when chooseItem != null:
return chooseItem(_that.item);case _NextContent() when nextContent != null:
return nextContent();case _PreviousContent() when previousContent != null:
return previousContent();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String lessonId)  started,required TResult Function( int index)  playInfo,required TResult Function()  playItemAudio,required TResult Function()  playChooseCorrectItem,required TResult Function( Item item)  chooseItem,required TResult Function()  nextContent,required TResult Function()  previousContent,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.lessonId);case _PlayInfo():
return playInfo(_that.index);case _PlayItemAudio():
return playItemAudio();case _PlayChooseCorrectItem():
return playChooseCorrectItem();case _ChooseItem():
return chooseItem(_that.item);case _NextContent():
return nextContent();case _PreviousContent():
return previousContent();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String lessonId)?  started,TResult? Function( int index)?  playInfo,TResult? Function()?  playItemAudio,TResult? Function()?  playChooseCorrectItem,TResult? Function( Item item)?  chooseItem,TResult? Function()?  nextContent,TResult? Function()?  previousContent,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.lessonId);case _PlayInfo() when playInfo != null:
return playInfo(_that.index);case _PlayItemAudio() when playItemAudio != null:
return playItemAudio();case _PlayChooseCorrectItem() when playChooseCorrectItem != null:
return playChooseCorrectItem();case _ChooseItem() when chooseItem != null:
return chooseItem(_that.item);case _NextContent() when nextContent != null:
return nextContent();case _PreviousContent() when previousContent != null:
return previousContent();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements LessonEvent {
  const _Started(this.lessonId);
  

 final  String lessonId;

/// Create a copy of LessonEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId));
}


@override
int get hashCode => Object.hash(runtimeType,lessonId);

@override
String toString() {
  return 'LessonEvent.started(lessonId: $lessonId)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $LessonEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 String lessonId
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of LessonEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lessonId = null,}) {
  return _then(_Started(
null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PlayInfo implements LessonEvent {
  const _PlayInfo(this.index);
  

 final  int index;

/// Create a copy of LessonEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayInfoCopyWith<_PlayInfo> get copyWith => __$PlayInfoCopyWithImpl<_PlayInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayInfo&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'LessonEvent.playInfo(index: $index)';
}


}

/// @nodoc
abstract mixin class _$PlayInfoCopyWith<$Res> implements $LessonEventCopyWith<$Res> {
  factory _$PlayInfoCopyWith(_PlayInfo value, $Res Function(_PlayInfo) _then) = __$PlayInfoCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class __$PlayInfoCopyWithImpl<$Res>
    implements _$PlayInfoCopyWith<$Res> {
  __$PlayInfoCopyWithImpl(this._self, this._then);

  final _PlayInfo _self;
  final $Res Function(_PlayInfo) _then;

/// Create a copy of LessonEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(_PlayInfo(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _PlayItemAudio implements LessonEvent {
  const _PlayItemAudio();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayItemAudio);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LessonEvent.playItemAudio()';
}


}




/// @nodoc


class _PlayChooseCorrectItem implements LessonEvent {
  const _PlayChooseCorrectItem();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayChooseCorrectItem);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LessonEvent.playChooseCorrectItem()';
}


}




/// @nodoc


class _ChooseItem implements LessonEvent {
  const _ChooseItem(this.item);
  

 final  Item item;

/// Create a copy of LessonEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChooseItemCopyWith<_ChooseItem> get copyWith => __$ChooseItemCopyWithImpl<_ChooseItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChooseItem&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'LessonEvent.chooseItem(item: $item)';
}


}

/// @nodoc
abstract mixin class _$ChooseItemCopyWith<$Res> implements $LessonEventCopyWith<$Res> {
  factory _$ChooseItemCopyWith(_ChooseItem value, $Res Function(_ChooseItem) _then) = __$ChooseItemCopyWithImpl;
@useResult
$Res call({
 Item item
});


$ItemCopyWith<$Res> get item;

}
/// @nodoc
class __$ChooseItemCopyWithImpl<$Res>
    implements _$ChooseItemCopyWith<$Res> {
  __$ChooseItemCopyWithImpl(this._self, this._then);

  final _ChooseItem _self;
  final $Res Function(_ChooseItem) _then;

/// Create a copy of LessonEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(_ChooseItem(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,
  ));
}

/// Create a copy of LessonEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res> get item {
  
  return $ItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc


class _NextContent implements LessonEvent {
  const _NextContent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextContent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LessonEvent.nextContent()';
}


}




/// @nodoc


class _PreviousContent implements LessonEvent {
  const _PreviousContent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviousContent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LessonEvent.previousContent()';
}


}




/// @nodoc
mixin _$LessonState {

 String? get lessonId; LessonDetail? get lessonDetails; String? get errorMessage; int get currentIndex; LessonContent? get currentContent;// Choose correct related content state
 Item? get itemQuestioned; Item? get userSelectedItem; bool? get isAnswerCorrect;
/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonStateCopyWith<LessonState> get copyWith => _$LessonStateCopyWithImpl<LessonState>(this as LessonState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonState&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonDetails, lessonDetails) || other.lessonDetails == lessonDetails)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.currentContent, currentContent) || other.currentContent == currentContent)&&(identical(other.itemQuestioned, itemQuestioned) || other.itemQuestioned == itemQuestioned)&&(identical(other.userSelectedItem, userSelectedItem) || other.userSelectedItem == userSelectedItem)&&(identical(other.isAnswerCorrect, isAnswerCorrect) || other.isAnswerCorrect == isAnswerCorrect));
}


@override
int get hashCode => Object.hash(runtimeType,lessonId,lessonDetails,errorMessage,currentIndex,currentContent,itemQuestioned,userSelectedItem,isAnswerCorrect);

@override
String toString() {
  return 'LessonState(lessonId: $lessonId, lessonDetails: $lessonDetails, errorMessage: $errorMessage, currentIndex: $currentIndex, currentContent: $currentContent, itemQuestioned: $itemQuestioned, userSelectedItem: $userSelectedItem, isAnswerCorrect: $isAnswerCorrect)';
}


}

/// @nodoc
abstract mixin class $LessonStateCopyWith<$Res>  {
  factory $LessonStateCopyWith(LessonState value, $Res Function(LessonState) _then) = _$LessonStateCopyWithImpl;
@useResult
$Res call({
 String? lessonId, LessonDetail? lessonDetails, String? errorMessage, int currentIndex, LessonContent? currentContent, Item? itemQuestioned, Item? userSelectedItem, bool? isAnswerCorrect
});


$LessonContentCopyWith<$Res>? get currentContent;$ItemCopyWith<$Res>? get itemQuestioned;$ItemCopyWith<$Res>? get userSelectedItem;

}
/// @nodoc
class _$LessonStateCopyWithImpl<$Res>
    implements $LessonStateCopyWith<$Res> {
  _$LessonStateCopyWithImpl(this._self, this._then);

  final LessonState _self;
  final $Res Function(LessonState) _then;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonId = freezed,Object? lessonDetails = freezed,Object? errorMessage = freezed,Object? currentIndex = null,Object? currentContent = freezed,Object? itemQuestioned = freezed,Object? userSelectedItem = freezed,Object? isAnswerCorrect = freezed,}) {
  return _then(_self.copyWith(
lessonId: freezed == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String?,lessonDetails: freezed == lessonDetails ? _self.lessonDetails : lessonDetails // ignore: cast_nullable_to_non_nullable
as LessonDetail?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,currentContent: freezed == currentContent ? _self.currentContent : currentContent // ignore: cast_nullable_to_non_nullable
as LessonContent?,itemQuestioned: freezed == itemQuestioned ? _self.itemQuestioned : itemQuestioned // ignore: cast_nullable_to_non_nullable
as Item?,userSelectedItem: freezed == userSelectedItem ? _self.userSelectedItem : userSelectedItem // ignore: cast_nullable_to_non_nullable
as Item?,isAnswerCorrect: freezed == isAnswerCorrect ? _self.isAnswerCorrect : isAnswerCorrect // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonContentCopyWith<$Res>? get currentContent {
    if (_self.currentContent == null) {
    return null;
  }

  return $LessonContentCopyWith<$Res>(_self.currentContent!, (value) {
    return _then(_self.copyWith(currentContent: value));
  });
}/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get itemQuestioned {
    if (_self.itemQuestioned == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.itemQuestioned!, (value) {
    return _then(_self.copyWith(itemQuestioned: value));
  });
}/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get userSelectedItem {
    if (_self.userSelectedItem == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.userSelectedItem!, (value) {
    return _then(_self.copyWith(userSelectedItem: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonState].
extension LessonStatePatterns on LessonState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonState value)  $default,){
final _that = this;
switch (_that) {
case _LessonState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonState value)?  $default,){
final _that = this;
switch (_that) {
case _LessonState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? lessonId,  LessonDetail? lessonDetails,  String? errorMessage,  int currentIndex,  LessonContent? currentContent,  Item? itemQuestioned,  Item? userSelectedItem,  bool? isAnswerCorrect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonState() when $default != null:
return $default(_that.lessonId,_that.lessonDetails,_that.errorMessage,_that.currentIndex,_that.currentContent,_that.itemQuestioned,_that.userSelectedItem,_that.isAnswerCorrect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? lessonId,  LessonDetail? lessonDetails,  String? errorMessage,  int currentIndex,  LessonContent? currentContent,  Item? itemQuestioned,  Item? userSelectedItem,  bool? isAnswerCorrect)  $default,) {final _that = this;
switch (_that) {
case _LessonState():
return $default(_that.lessonId,_that.lessonDetails,_that.errorMessage,_that.currentIndex,_that.currentContent,_that.itemQuestioned,_that.userSelectedItem,_that.isAnswerCorrect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? lessonId,  LessonDetail? lessonDetails,  String? errorMessage,  int currentIndex,  LessonContent? currentContent,  Item? itemQuestioned,  Item? userSelectedItem,  bool? isAnswerCorrect)?  $default,) {final _that = this;
switch (_that) {
case _LessonState() when $default != null:
return $default(_that.lessonId,_that.lessonDetails,_that.errorMessage,_that.currentIndex,_that.currentContent,_that.itemQuestioned,_that.userSelectedItem,_that.isAnswerCorrect);case _:
  return null;

}
}

}

/// @nodoc


class _LessonState implements LessonState {
  const _LessonState({this.lessonId, this.lessonDetails, this.errorMessage, this.currentIndex = 0, this.currentContent, this.itemQuestioned, this.userSelectedItem, this.isAnswerCorrect});
  

@override final  String? lessonId;
@override final  LessonDetail? lessonDetails;
@override final  String? errorMessage;
@override@JsonKey() final  int currentIndex;
@override final  LessonContent? currentContent;
// Choose correct related content state
@override final  Item? itemQuestioned;
@override final  Item? userSelectedItem;
@override final  bool? isAnswerCorrect;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonStateCopyWith<_LessonState> get copyWith => __$LessonStateCopyWithImpl<_LessonState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonState&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonDetails, lessonDetails) || other.lessonDetails == lessonDetails)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.currentContent, currentContent) || other.currentContent == currentContent)&&(identical(other.itemQuestioned, itemQuestioned) || other.itemQuestioned == itemQuestioned)&&(identical(other.userSelectedItem, userSelectedItem) || other.userSelectedItem == userSelectedItem)&&(identical(other.isAnswerCorrect, isAnswerCorrect) || other.isAnswerCorrect == isAnswerCorrect));
}


@override
int get hashCode => Object.hash(runtimeType,lessonId,lessonDetails,errorMessage,currentIndex,currentContent,itemQuestioned,userSelectedItem,isAnswerCorrect);

@override
String toString() {
  return 'LessonState(lessonId: $lessonId, lessonDetails: $lessonDetails, errorMessage: $errorMessage, currentIndex: $currentIndex, currentContent: $currentContent, itemQuestioned: $itemQuestioned, userSelectedItem: $userSelectedItem, isAnswerCorrect: $isAnswerCorrect)';
}


}

/// @nodoc
abstract mixin class _$LessonStateCopyWith<$Res> implements $LessonStateCopyWith<$Res> {
  factory _$LessonStateCopyWith(_LessonState value, $Res Function(_LessonState) _then) = __$LessonStateCopyWithImpl;
@override @useResult
$Res call({
 String? lessonId, LessonDetail? lessonDetails, String? errorMessage, int currentIndex, LessonContent? currentContent, Item? itemQuestioned, Item? userSelectedItem, bool? isAnswerCorrect
});


@override $LessonContentCopyWith<$Res>? get currentContent;@override $ItemCopyWith<$Res>? get itemQuestioned;@override $ItemCopyWith<$Res>? get userSelectedItem;

}
/// @nodoc
class __$LessonStateCopyWithImpl<$Res>
    implements _$LessonStateCopyWith<$Res> {
  __$LessonStateCopyWithImpl(this._self, this._then);

  final _LessonState _self;
  final $Res Function(_LessonState) _then;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonId = freezed,Object? lessonDetails = freezed,Object? errorMessage = freezed,Object? currentIndex = null,Object? currentContent = freezed,Object? itemQuestioned = freezed,Object? userSelectedItem = freezed,Object? isAnswerCorrect = freezed,}) {
  return _then(_LessonState(
lessonId: freezed == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String?,lessonDetails: freezed == lessonDetails ? _self.lessonDetails : lessonDetails // ignore: cast_nullable_to_non_nullable
as LessonDetail?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,currentContent: freezed == currentContent ? _self.currentContent : currentContent // ignore: cast_nullable_to_non_nullable
as LessonContent?,itemQuestioned: freezed == itemQuestioned ? _self.itemQuestioned : itemQuestioned // ignore: cast_nullable_to_non_nullable
as Item?,userSelectedItem: freezed == userSelectedItem ? _self.userSelectedItem : userSelectedItem // ignore: cast_nullable_to_non_nullable
as Item?,isAnswerCorrect: freezed == isAnswerCorrect ? _self.isAnswerCorrect : isAnswerCorrect // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonContentCopyWith<$Res>? get currentContent {
    if (_self.currentContent == null) {
    return null;
  }

  return $LessonContentCopyWith<$Res>(_self.currentContent!, (value) {
    return _then(_self.copyWith(currentContent: value));
  });
}/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get itemQuestioned {
    if (_self.itemQuestioned == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.itemQuestioned!, (value) {
    return _then(_self.copyWith(itemQuestioned: value));
  });
}/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get userSelectedItem {
    if (_self.userSelectedItem == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.userSelectedItem!, (value) {
    return _then(_self.copyWith(userSelectedItem: value));
  });
}
}

// dart format on
