// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'put_in_bag_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PutInBagEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PutInBagEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PutInBagEvent()';
}


}

/// @nodoc
class $PutInBagEventCopyWith<$Res>  {
$PutInBagEventCopyWith(PutInBagEvent _, $Res Function(PutInBagEvent) __);
}


/// Adds pattern-matching-related methods to [PutInBagEvent].
extension PutInBagEventPatterns on PutInBagEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _ItemDropped value)?  itemDropped,TResult Function( _AudioCompleted value)?  audioCompleted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _ItemDropped() when itemDropped != null:
return itemDropped(_that);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _ItemDropped value)  itemDropped,required TResult Function( _AudioCompleted value)  audioCompleted,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _ItemDropped():
return itemDropped(_that);case _AudioCompleted():
return audioCompleted(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _ItemDropped value)?  itemDropped,TResult? Function( _AudioCompleted value)?  audioCompleted,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _ItemDropped() when itemDropped != null:
return itemDropped(_that);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PutInBagLessonContent content)?  started,TResult Function( int itemIndex)?  itemDropped,TResult Function( bool isCompleted)?  audioCompleted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _ItemDropped() when itemDropped != null:
return itemDropped(_that.itemIndex);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PutInBagLessonContent content)  started,required TResult Function( int itemIndex)  itemDropped,required TResult Function( bool isCompleted)  audioCompleted,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _ItemDropped():
return itemDropped(_that.itemIndex);case _AudioCompleted():
return audioCompleted(_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PutInBagLessonContent content)?  started,TResult? Function( int itemIndex)?  itemDropped,TResult? Function( bool isCompleted)?  audioCompleted,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _ItemDropped() when itemDropped != null:
return itemDropped(_that.itemIndex);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements PutInBagEvent {
  const _Started(this.content);


 final  PutInBagLessonContent content;

/// Create a copy of PutInBagEvent
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
  return 'PutInBagEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $PutInBagEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 PutInBagLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of PutInBagEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as PutInBagLessonContent,
  ));
}


}

/// @nodoc


class _ItemDropped implements PutInBagEvent {
  const _ItemDropped(this.itemIndex);


 final  int itemIndex;

/// Create a copy of PutInBagEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDroppedCopyWith<_ItemDropped> get copyWith => __$ItemDroppedCopyWithImpl<_ItemDropped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDropped&&(identical(other.itemIndex, itemIndex) || other.itemIndex == itemIndex));
}


@override
int get hashCode => Object.hash(runtimeType,itemIndex);

@override
String toString() {
  return 'PutInBagEvent.itemDropped(itemIndex: $itemIndex)';
}


}

/// @nodoc
abstract mixin class _$ItemDroppedCopyWith<$Res> implements $PutInBagEventCopyWith<$Res> {
  factory _$ItemDroppedCopyWith(_ItemDropped value, $Res Function(_ItemDropped) _then) = __$ItemDroppedCopyWithImpl;
@useResult
$Res call({
 int itemIndex
});




}
/// @nodoc
class __$ItemDroppedCopyWithImpl<$Res>
    implements _$ItemDroppedCopyWith<$Res> {
  __$ItemDroppedCopyWithImpl(this._self, this._then);

  final _ItemDropped _self;
  final $Res Function(_ItemDropped) _then;

/// Create a copy of PutInBagEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemIndex = null,}) {
  return _then(_ItemDropped(
null == itemIndex ? _self.itemIndex : itemIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _AudioCompleted implements PutInBagEvent {
  const _AudioCompleted(this.isCompleted);


 final  bool isCompleted;

/// Create a copy of PutInBagEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioCompletedCopyWith<_AudioCompleted> get copyWith => __$AudioCompletedCopyWithImpl<_AudioCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioCompleted&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,isCompleted);

@override
String toString() {
  return 'PutInBagEvent.audioCompleted(isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$AudioCompletedCopyWith<$Res> implements $PutInBagEventCopyWith<$Res> {
  factory _$AudioCompletedCopyWith(_AudioCompleted value, $Res Function(_AudioCompleted) _then) = __$AudioCompletedCopyWithImpl;
@useResult
$Res call({
 bool isCompleted
});




}
/// @nodoc
class __$AudioCompletedCopyWithImpl<$Res>
    implements _$AudioCompletedCopyWith<$Res> {
  __$AudioCompletedCopyWithImpl(this._self, this._then);

  final _AudioCompleted _self;
  final $Res Function(_AudioCompleted) _then;

/// Create a copy of PutInBagEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isCompleted = null,}) {
  return _then(_AudioCompleted(
null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PutInBagState {

 PutInBagStatus get status; PutInBagLessonContent? get content; List<int> get droppedItemIndexes; String? get currentBagItemImage; int? get currentPlayingItemIndex; bool get showActionButton;
/// Create a copy of PutInBagState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PutInBagStateCopyWith<PutInBagState> get copyWith => _$PutInBagStateCopyWithImpl<PutInBagState>(this as PutInBagState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PutInBagState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other.droppedItemIndexes, droppedItemIndexes)&&(identical(other.currentBagItemImage, currentBagItemImage) || other.currentBagItemImage == currentBagItemImage)&&(identical(other.currentPlayingItemIndex, currentPlayingItemIndex) || other.currentPlayingItemIndex == currentPlayingItemIndex)&&(identical(other.showActionButton, showActionButton) || other.showActionButton == showActionButton));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(droppedItemIndexes),currentBagItemImage,currentPlayingItemIndex,showActionButton);

@override
String toString() {
  return 'PutInBagState(status: $status, content: $content, droppedItemIndexes: $droppedItemIndexes, currentBagItemImage: $currentBagItemImage, currentPlayingItemIndex: $currentPlayingItemIndex, showActionButton: $showActionButton)';
}


}

/// @nodoc
abstract mixin class $PutInBagStateCopyWith<$Res>  {
  factory $PutInBagStateCopyWith(PutInBagState value, $Res Function(PutInBagState) _then) = _$PutInBagStateCopyWithImpl;
@useResult
$Res call({
 PutInBagStatus status, PutInBagLessonContent? content, List<int> droppedItemIndexes, String? currentBagItemImage, int? currentPlayingItemIndex, bool showActionButton
});




}
/// @nodoc
class _$PutInBagStateCopyWithImpl<$Res>
    implements $PutInBagStateCopyWith<$Res> {
  _$PutInBagStateCopyWithImpl(this._self, this._then);

  final PutInBagState _self;
  final $Res Function(PutInBagState) _then;

/// Create a copy of PutInBagState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? content = freezed,Object? droppedItemIndexes = null,Object? currentBagItemImage = freezed,Object? currentPlayingItemIndex = freezed,Object? showActionButton = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PutInBagStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as PutInBagLessonContent?,droppedItemIndexes: null == droppedItemIndexes ? _self.droppedItemIndexes : droppedItemIndexes // ignore: cast_nullable_to_non_nullable
as List<int>,currentBagItemImage: freezed == currentBagItemImage ? _self.currentBagItemImage : currentBagItemImage // ignore: cast_nullable_to_non_nullable
as String?,currentPlayingItemIndex: freezed == currentPlayingItemIndex ? _self.currentPlayingItemIndex : currentPlayingItemIndex // ignore: cast_nullable_to_non_nullable
as int?,showActionButton: null == showActionButton ? _self.showActionButton : showActionButton // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PutInBagState].
extension PutInBagStatePatterns on PutInBagState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PutInBagState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PutInBagState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PutInBagState value)  $default,){
final _that = this;
switch (_that) {
case _PutInBagState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PutInBagState value)?  $default,){
final _that = this;
switch (_that) {
case _PutInBagState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PutInBagStatus status,  PutInBagLessonContent? content,  List<int> droppedItemIndexes,  String? currentBagItemImage,  int? currentPlayingItemIndex,  bool showActionButton)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PutInBagState() when $default != null:
return $default(_that.status,_that.content,_that.droppedItemIndexes,_that.currentBagItemImage,_that.currentPlayingItemIndex,_that.showActionButton);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PutInBagStatus status,  PutInBagLessonContent? content,  List<int> droppedItemIndexes,  String? currentBagItemImage,  int? currentPlayingItemIndex,  bool showActionButton)  $default,) {final _that = this;
switch (_that) {
case _PutInBagState():
return $default(_that.status,_that.content,_that.droppedItemIndexes,_that.currentBagItemImage,_that.currentPlayingItemIndex,_that.showActionButton);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PutInBagStatus status,  PutInBagLessonContent? content,  List<int> droppedItemIndexes,  String? currentBagItemImage,  int? currentPlayingItemIndex,  bool showActionButton)?  $default,) {final _that = this;
switch (_that) {
case _PutInBagState() when $default != null:
return $default(_that.status,_that.content,_that.droppedItemIndexes,_that.currentBagItemImage,_that.currentPlayingItemIndex,_that.showActionButton);case _:
  return null;

}
}

}

/// @nodoc


class _PutInBagState extends PutInBagState {
  const _PutInBagState({this.status = PutInBagStatus.initial, this.content, final  List<int> droppedItemIndexes = const [], this.currentBagItemImage, this.currentPlayingItemIndex, this.showActionButton = false}): _droppedItemIndexes = droppedItemIndexes,super._();


@override@JsonKey() final  PutInBagStatus status;
@override final  PutInBagLessonContent? content;
 final  List<int> _droppedItemIndexes;
@override@JsonKey() List<int> get droppedItemIndexes {
  if (_droppedItemIndexes is EqualUnmodifiableListView) return _droppedItemIndexes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_droppedItemIndexes);
}

@override final  String? currentBagItemImage;
@override final  int? currentPlayingItemIndex;
@override@JsonKey() final  bool showActionButton;

/// Create a copy of PutInBagState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PutInBagStateCopyWith<_PutInBagState> get copyWith => __$PutInBagStateCopyWithImpl<_PutInBagState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PutInBagState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other._droppedItemIndexes, _droppedItemIndexes)&&(identical(other.currentBagItemImage, currentBagItemImage) || other.currentBagItemImage == currentBagItemImage)&&(identical(other.currentPlayingItemIndex, currentPlayingItemIndex) || other.currentPlayingItemIndex == currentPlayingItemIndex)&&(identical(other.showActionButton, showActionButton) || other.showActionButton == showActionButton));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(_droppedItemIndexes),currentBagItemImage,currentPlayingItemIndex,showActionButton);

@override
String toString() {
  return 'PutInBagState(status: $status, content: $content, droppedItemIndexes: $droppedItemIndexes, currentBagItemImage: $currentBagItemImage, currentPlayingItemIndex: $currentPlayingItemIndex, showActionButton: $showActionButton)';
}


}

/// @nodoc
abstract mixin class _$PutInBagStateCopyWith<$Res> implements $PutInBagStateCopyWith<$Res> {
  factory _$PutInBagStateCopyWith(_PutInBagState value, $Res Function(_PutInBagState) _then) = __$PutInBagStateCopyWithImpl;
@override @useResult
$Res call({
 PutInBagStatus status, PutInBagLessonContent? content, List<int> droppedItemIndexes, String? currentBagItemImage, int? currentPlayingItemIndex, bool showActionButton
});




}
/// @nodoc
class __$PutInBagStateCopyWithImpl<$Res>
    implements _$PutInBagStateCopyWith<$Res> {
  __$PutInBagStateCopyWithImpl(this._self, this._then);

  final _PutInBagState _self;
  final $Res Function(_PutInBagState) _then;

/// Create a copy of PutInBagState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? content = freezed,Object? droppedItemIndexes = null,Object? currentBagItemImage = freezed,Object? currentPlayingItemIndex = freezed,Object? showActionButton = null,}) {
  return _then(_PutInBagState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PutInBagStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as PutInBagLessonContent?,droppedItemIndexes: null == droppedItemIndexes ? _self._droppedItemIndexes : droppedItemIndexes // ignore: cast_nullable_to_non_nullable
as List<int>,currentBagItemImage: freezed == currentBagItemImage ? _self.currentBagItemImage : currentBagItemImage // ignore: cast_nullable_to_non_nullable
as String?,currentPlayingItemIndex: freezed == currentPlayingItemIndex ? _self.currentPlayingItemIndex : currentPlayingItemIndex // ignore: cast_nullable_to_non_nullable
as int?,showActionButton: null == showActionButton ? _self.showActionButton : showActionButton // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
