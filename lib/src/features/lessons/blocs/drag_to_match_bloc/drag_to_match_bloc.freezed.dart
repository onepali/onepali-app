// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drag_to_match_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DragToMatchState {

 List<ItemPosition> get itemPositions; List<ItemPosition> get outlinePositions; List<String> get matchedItemIds; int get currentHintIndex; bool get isPlayingHint; bool get isPlayingAudio; bool get showNepaliword; String? get currentPlayingAudioId; DragStatus get dragStatus; String? get draggedItemId; String? get targetOutlineId; String? get currentTargetItemId;
/// Create a copy of DragToMatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DragToMatchStateCopyWith<DragToMatchState> get copyWith => _$DragToMatchStateCopyWithImpl<DragToMatchState>(this as DragToMatchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DragToMatchState&&const DeepCollectionEquality().equals(other.itemPositions, itemPositions)&&const DeepCollectionEquality().equals(other.outlinePositions, outlinePositions)&&const DeepCollectionEquality().equals(other.matchedItemIds, matchedItemIds)&&(identical(other.currentHintIndex, currentHintIndex) || other.currentHintIndex == currentHintIndex)&&(identical(other.isPlayingHint, isPlayingHint) || other.isPlayingHint == isPlayingHint)&&(identical(other.isPlayingAudio, isPlayingAudio) || other.isPlayingAudio == isPlayingAudio)&&(identical(other.showNepaliword, showNepaliword) || other.showNepaliword == showNepaliword)&&(identical(other.currentPlayingAudioId, currentPlayingAudioId) || other.currentPlayingAudioId == currentPlayingAudioId)&&(identical(other.dragStatus, dragStatus) || other.dragStatus == dragStatus)&&(identical(other.draggedItemId, draggedItemId) || other.draggedItemId == draggedItemId)&&(identical(other.targetOutlineId, targetOutlineId) || other.targetOutlineId == targetOutlineId)&&(identical(other.currentTargetItemId, currentTargetItemId) || other.currentTargetItemId == currentTargetItemId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(itemPositions),const DeepCollectionEquality().hash(outlinePositions),const DeepCollectionEquality().hash(matchedItemIds),currentHintIndex,isPlayingHint,isPlayingAudio,showNepaliword,currentPlayingAudioId,dragStatus,draggedItemId,targetOutlineId,currentTargetItemId);

@override
String toString() {
  return 'DragToMatchState(itemPositions: $itemPositions, outlinePositions: $outlinePositions, matchedItemIds: $matchedItemIds, currentHintIndex: $currentHintIndex, isPlayingHint: $isPlayingHint, isPlayingAudio: $isPlayingAudio, showNepaliword: $showNepaliword, currentPlayingAudioId: $currentPlayingAudioId, dragStatus: $dragStatus, draggedItemId: $draggedItemId, targetOutlineId: $targetOutlineId, currentTargetItemId: $currentTargetItemId)';
}


}

/// @nodoc
abstract mixin class $DragToMatchStateCopyWith<$Res>  {
  factory $DragToMatchStateCopyWith(DragToMatchState value, $Res Function(DragToMatchState) _then) = _$DragToMatchStateCopyWithImpl;
@useResult
$Res call({
 List<ItemPosition> itemPositions, List<ItemPosition> outlinePositions, List<String> matchedItemIds, int currentHintIndex, bool isPlayingHint, bool isPlayingAudio, bool showNepaliword, String? currentPlayingAudioId, DragStatus dragStatus, String? draggedItemId, String? targetOutlineId, String? currentTargetItemId
});




}
/// @nodoc
class _$DragToMatchStateCopyWithImpl<$Res>
    implements $DragToMatchStateCopyWith<$Res> {
  _$DragToMatchStateCopyWithImpl(this._self, this._then);

  final DragToMatchState _self;
  final $Res Function(DragToMatchState) _then;

/// Create a copy of DragToMatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemPositions = null,Object? outlinePositions = null,Object? matchedItemIds = null,Object? currentHintIndex = null,Object? isPlayingHint = null,Object? isPlayingAudio = null,Object? showNepaliword = null,Object? currentPlayingAudioId = freezed,Object? dragStatus = null,Object? draggedItemId = freezed,Object? targetOutlineId = freezed,Object? currentTargetItemId = freezed,}) {
  return _then(_self.copyWith(
itemPositions: null == itemPositions ? _self.itemPositions : itemPositions // ignore: cast_nullable_to_non_nullable
as List<ItemPosition>,outlinePositions: null == outlinePositions ? _self.outlinePositions : outlinePositions // ignore: cast_nullable_to_non_nullable
as List<ItemPosition>,matchedItemIds: null == matchedItemIds ? _self.matchedItemIds : matchedItemIds // ignore: cast_nullable_to_non_nullable
as List<String>,currentHintIndex: null == currentHintIndex ? _self.currentHintIndex : currentHintIndex // ignore: cast_nullable_to_non_nullable
as int,isPlayingHint: null == isPlayingHint ? _self.isPlayingHint : isPlayingHint // ignore: cast_nullable_to_non_nullable
as bool,isPlayingAudio: null == isPlayingAudio ? _self.isPlayingAudio : isPlayingAudio // ignore: cast_nullable_to_non_nullable
as bool,showNepaliword: null == showNepaliword ? _self.showNepaliword : showNepaliword // ignore: cast_nullable_to_non_nullable
as bool,currentPlayingAudioId: freezed == currentPlayingAudioId ? _self.currentPlayingAudioId : currentPlayingAudioId // ignore: cast_nullable_to_non_nullable
as String?,dragStatus: null == dragStatus ? _self.dragStatus : dragStatus // ignore: cast_nullable_to_non_nullable
as DragStatus,draggedItemId: freezed == draggedItemId ? _self.draggedItemId : draggedItemId // ignore: cast_nullable_to_non_nullable
as String?,targetOutlineId: freezed == targetOutlineId ? _self.targetOutlineId : targetOutlineId // ignore: cast_nullable_to_non_nullable
as String?,currentTargetItemId: freezed == currentTargetItemId ? _self.currentTargetItemId : currentTargetItemId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DragToMatchState].
extension DragToMatchStatePatterns on DragToMatchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DragToMatchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DragToMatchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DragToMatchState value)  $default,){
final _that = this;
switch (_that) {
case _DragToMatchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DragToMatchState value)?  $default,){
final _that = this;
switch (_that) {
case _DragToMatchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ItemPosition> itemPositions,  List<ItemPosition> outlinePositions,  List<String> matchedItemIds,  int currentHintIndex,  bool isPlayingHint,  bool isPlayingAudio,  bool showNepaliword,  String? currentPlayingAudioId,  DragStatus dragStatus,  String? draggedItemId,  String? targetOutlineId,  String? currentTargetItemId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DragToMatchState() when $default != null:
return $default(_that.itemPositions,_that.outlinePositions,_that.matchedItemIds,_that.currentHintIndex,_that.isPlayingHint,_that.isPlayingAudio,_that.showNepaliword,_that.currentPlayingAudioId,_that.dragStatus,_that.draggedItemId,_that.targetOutlineId,_that.currentTargetItemId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ItemPosition> itemPositions,  List<ItemPosition> outlinePositions,  List<String> matchedItemIds,  int currentHintIndex,  bool isPlayingHint,  bool isPlayingAudio,  bool showNepaliword,  String? currentPlayingAudioId,  DragStatus dragStatus,  String? draggedItemId,  String? targetOutlineId,  String? currentTargetItemId)  $default,) {final _that = this;
switch (_that) {
case _DragToMatchState():
return $default(_that.itemPositions,_that.outlinePositions,_that.matchedItemIds,_that.currentHintIndex,_that.isPlayingHint,_that.isPlayingAudio,_that.showNepaliword,_that.currentPlayingAudioId,_that.dragStatus,_that.draggedItemId,_that.targetOutlineId,_that.currentTargetItemId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ItemPosition> itemPositions,  List<ItemPosition> outlinePositions,  List<String> matchedItemIds,  int currentHintIndex,  bool isPlayingHint,  bool isPlayingAudio,  bool showNepaliword,  String? currentPlayingAudioId,  DragStatus dragStatus,  String? draggedItemId,  String? targetOutlineId,  String? currentTargetItemId)?  $default,) {final _that = this;
switch (_that) {
case _DragToMatchState() when $default != null:
return $default(_that.itemPositions,_that.outlinePositions,_that.matchedItemIds,_that.currentHintIndex,_that.isPlayingHint,_that.isPlayingAudio,_that.showNepaliword,_that.currentPlayingAudioId,_that.dragStatus,_that.draggedItemId,_that.targetOutlineId,_that.currentTargetItemId);case _:
  return null;

}
}

}

/// @nodoc


class _DragToMatchState implements DragToMatchState {
  const _DragToMatchState({final  List<ItemPosition> itemPositions = const [], final  List<ItemPosition> outlinePositions = const [], final  List<String> matchedItemIds = const [], this.currentHintIndex = 0, this.isPlayingHint = false, this.isPlayingAudio = false, this.showNepaliword = false, this.currentPlayingAudioId, this.dragStatus = DragStatus.idle, this.draggedItemId, this.targetOutlineId, this.currentTargetItemId}): _itemPositions = itemPositions,_outlinePositions = outlinePositions,_matchedItemIds = matchedItemIds;
  

 final  List<ItemPosition> _itemPositions;
@override@JsonKey() List<ItemPosition> get itemPositions {
  if (_itemPositions is EqualUnmodifiableListView) return _itemPositions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itemPositions);
}

 final  List<ItemPosition> _outlinePositions;
@override@JsonKey() List<ItemPosition> get outlinePositions {
  if (_outlinePositions is EqualUnmodifiableListView) return _outlinePositions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_outlinePositions);
}

 final  List<String> _matchedItemIds;
@override@JsonKey() List<String> get matchedItemIds {
  if (_matchedItemIds is EqualUnmodifiableListView) return _matchedItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matchedItemIds);
}

@override@JsonKey() final  int currentHintIndex;
@override@JsonKey() final  bool isPlayingHint;
@override@JsonKey() final  bool isPlayingAudio;
@override@JsonKey() final  bool showNepaliword;
@override final  String? currentPlayingAudioId;
@override@JsonKey() final  DragStatus dragStatus;
@override final  String? draggedItemId;
@override final  String? targetOutlineId;
@override final  String? currentTargetItemId;

/// Create a copy of DragToMatchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DragToMatchStateCopyWith<_DragToMatchState> get copyWith => __$DragToMatchStateCopyWithImpl<_DragToMatchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DragToMatchState&&const DeepCollectionEquality().equals(other._itemPositions, _itemPositions)&&const DeepCollectionEquality().equals(other._outlinePositions, _outlinePositions)&&const DeepCollectionEquality().equals(other._matchedItemIds, _matchedItemIds)&&(identical(other.currentHintIndex, currentHintIndex) || other.currentHintIndex == currentHintIndex)&&(identical(other.isPlayingHint, isPlayingHint) || other.isPlayingHint == isPlayingHint)&&(identical(other.isPlayingAudio, isPlayingAudio) || other.isPlayingAudio == isPlayingAudio)&&(identical(other.showNepaliword, showNepaliword) || other.showNepaliword == showNepaliword)&&(identical(other.currentPlayingAudioId, currentPlayingAudioId) || other.currentPlayingAudioId == currentPlayingAudioId)&&(identical(other.dragStatus, dragStatus) || other.dragStatus == dragStatus)&&(identical(other.draggedItemId, draggedItemId) || other.draggedItemId == draggedItemId)&&(identical(other.targetOutlineId, targetOutlineId) || other.targetOutlineId == targetOutlineId)&&(identical(other.currentTargetItemId, currentTargetItemId) || other.currentTargetItemId == currentTargetItemId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_itemPositions),const DeepCollectionEquality().hash(_outlinePositions),const DeepCollectionEquality().hash(_matchedItemIds),currentHintIndex,isPlayingHint,isPlayingAudio,showNepaliword,currentPlayingAudioId,dragStatus,draggedItemId,targetOutlineId,currentTargetItemId);

@override
String toString() {
  return 'DragToMatchState(itemPositions: $itemPositions, outlinePositions: $outlinePositions, matchedItemIds: $matchedItemIds, currentHintIndex: $currentHintIndex, isPlayingHint: $isPlayingHint, isPlayingAudio: $isPlayingAudio, showNepaliword: $showNepaliword, currentPlayingAudioId: $currentPlayingAudioId, dragStatus: $dragStatus, draggedItemId: $draggedItemId, targetOutlineId: $targetOutlineId, currentTargetItemId: $currentTargetItemId)';
}


}

/// @nodoc
abstract mixin class _$DragToMatchStateCopyWith<$Res> implements $DragToMatchStateCopyWith<$Res> {
  factory _$DragToMatchStateCopyWith(_DragToMatchState value, $Res Function(_DragToMatchState) _then) = __$DragToMatchStateCopyWithImpl;
@override @useResult
$Res call({
 List<ItemPosition> itemPositions, List<ItemPosition> outlinePositions, List<String> matchedItemIds, int currentHintIndex, bool isPlayingHint, bool isPlayingAudio, bool showNepaliword, String? currentPlayingAudioId, DragStatus dragStatus, String? draggedItemId, String? targetOutlineId, String? currentTargetItemId
});




}
/// @nodoc
class __$DragToMatchStateCopyWithImpl<$Res>
    implements _$DragToMatchStateCopyWith<$Res> {
  __$DragToMatchStateCopyWithImpl(this._self, this._then);

  final _DragToMatchState _self;
  final $Res Function(_DragToMatchState) _then;

/// Create a copy of DragToMatchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemPositions = null,Object? outlinePositions = null,Object? matchedItemIds = null,Object? currentHintIndex = null,Object? isPlayingHint = null,Object? isPlayingAudio = null,Object? showNepaliword = null,Object? currentPlayingAudioId = freezed,Object? dragStatus = null,Object? draggedItemId = freezed,Object? targetOutlineId = freezed,Object? currentTargetItemId = freezed,}) {
  return _then(_DragToMatchState(
itemPositions: null == itemPositions ? _self._itemPositions : itemPositions // ignore: cast_nullable_to_non_nullable
as List<ItemPosition>,outlinePositions: null == outlinePositions ? _self._outlinePositions : outlinePositions // ignore: cast_nullable_to_non_nullable
as List<ItemPosition>,matchedItemIds: null == matchedItemIds ? _self._matchedItemIds : matchedItemIds // ignore: cast_nullable_to_non_nullable
as List<String>,currentHintIndex: null == currentHintIndex ? _self.currentHintIndex : currentHintIndex // ignore: cast_nullable_to_non_nullable
as int,isPlayingHint: null == isPlayingHint ? _self.isPlayingHint : isPlayingHint // ignore: cast_nullable_to_non_nullable
as bool,isPlayingAudio: null == isPlayingAudio ? _self.isPlayingAudio : isPlayingAudio // ignore: cast_nullable_to_non_nullable
as bool,showNepaliword: null == showNepaliword ? _self.showNepaliword : showNepaliword // ignore: cast_nullable_to_non_nullable
as bool,currentPlayingAudioId: freezed == currentPlayingAudioId ? _self.currentPlayingAudioId : currentPlayingAudioId // ignore: cast_nullable_to_non_nullable
as String?,dragStatus: null == dragStatus ? _self.dragStatus : dragStatus // ignore: cast_nullable_to_non_nullable
as DragStatus,draggedItemId: freezed == draggedItemId ? _self.draggedItemId : draggedItemId // ignore: cast_nullable_to_non_nullable
as String?,targetOutlineId: freezed == targetOutlineId ? _self.targetOutlineId : targetOutlineId // ignore: cast_nullable_to_non_nullable
as String?,currentTargetItemId: freezed == currentTargetItemId ? _self.currentTargetItemId : currentTargetItemId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ItemPosition {

 String get id; String get itemId; String get nameNp; double get x; double get y; bool get isMatched;
/// Create a copy of ItemPosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemPositionCopyWith<ItemPosition> get copyWith => _$ItemPositionCopyWithImpl<ItemPosition>(this as ItemPosition, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemPosition&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.isMatched, isMatched) || other.isMatched == isMatched));
}


@override
int get hashCode => Object.hash(runtimeType,id,itemId,nameNp,x,y,isMatched);

@override
String toString() {
  return 'ItemPosition(id: $id, itemId: $itemId, nameNp: $nameNp, x: $x, y: $y, isMatched: $isMatched)';
}


}

/// @nodoc
abstract mixin class $ItemPositionCopyWith<$Res>  {
  factory $ItemPositionCopyWith(ItemPosition value, $Res Function(ItemPosition) _then) = _$ItemPositionCopyWithImpl;
@useResult
$Res call({
 String id, String itemId, String nameNp, double x, double y, bool isMatched
});




}
/// @nodoc
class _$ItemPositionCopyWithImpl<$Res>
    implements $ItemPositionCopyWith<$Res> {
  _$ItemPositionCopyWithImpl(this._self, this._then);

  final ItemPosition _self;
  final $Res Function(ItemPosition) _then;

/// Create a copy of ItemPosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? nameNp = null,Object? x = null,Object? y = null,Object? isMatched = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,isMatched: null == isMatched ? _self.isMatched : isMatched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemPosition].
extension ItemPositionPatterns on ItemPosition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemPosition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemPosition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemPosition value)  $default,){
final _that = this;
switch (_that) {
case _ItemPosition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemPosition value)?  $default,){
final _that = this;
switch (_that) {
case _ItemPosition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String itemId,  String nameNp,  double x,  double y,  bool isMatched)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemPosition() when $default != null:
return $default(_that.id,_that.itemId,_that.nameNp,_that.x,_that.y,_that.isMatched);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String itemId,  String nameNp,  double x,  double y,  bool isMatched)  $default,) {final _that = this;
switch (_that) {
case _ItemPosition():
return $default(_that.id,_that.itemId,_that.nameNp,_that.x,_that.y,_that.isMatched);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String itemId,  String nameNp,  double x,  double y,  bool isMatched)?  $default,) {final _that = this;
switch (_that) {
case _ItemPosition() when $default != null:
return $default(_that.id,_that.itemId,_that.nameNp,_that.x,_that.y,_that.isMatched);case _:
  return null;

}
}

}

/// @nodoc


class _ItemPosition implements ItemPosition {
  const _ItemPosition({required this.id, required this.itemId, required this.nameNp, required this.x, required this.y, required this.isMatched});
  

@override final  String id;
@override final  String itemId;
@override final  String nameNp;
@override final  double x;
@override final  double y;
@override final  bool isMatched;

/// Create a copy of ItemPosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemPositionCopyWith<_ItemPosition> get copyWith => __$ItemPositionCopyWithImpl<_ItemPosition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemPosition&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.isMatched, isMatched) || other.isMatched == isMatched));
}


@override
int get hashCode => Object.hash(runtimeType,id,itemId,nameNp,x,y,isMatched);

@override
String toString() {
  return 'ItemPosition(id: $id, itemId: $itemId, nameNp: $nameNp, x: $x, y: $y, isMatched: $isMatched)';
}


}

/// @nodoc
abstract mixin class _$ItemPositionCopyWith<$Res> implements $ItemPositionCopyWith<$Res> {
  factory _$ItemPositionCopyWith(_ItemPosition value, $Res Function(_ItemPosition) _then) = __$ItemPositionCopyWithImpl;
@override @useResult
$Res call({
 String id, String itemId, String nameNp, double x, double y, bool isMatched
});




}
/// @nodoc
class __$ItemPositionCopyWithImpl<$Res>
    implements _$ItemPositionCopyWith<$Res> {
  __$ItemPositionCopyWithImpl(this._self, this._then);

  final _ItemPosition _self;
  final $Res Function(_ItemPosition) _then;

/// Create a copy of ItemPosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? nameNp = null,Object? x = null,Object? y = null,Object? isMatched = null,}) {
  return _then(_ItemPosition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,isMatched: null == isMatched ? _self.isMatched : isMatched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$DragToMatchEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DragToMatchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DragToMatchEvent()';
}


}

/// @nodoc
class $DragToMatchEventCopyWith<$Res>  {
$DragToMatchEventCopyWith(DragToMatchEvent _, $Res Function(DragToMatchEvent) __);
}


/// Adds pattern-matching-related methods to [DragToMatchEvent].
extension DragToMatchEventPatterns on DragToMatchEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initialize value)?  initialize,TResult Function( _StartHintSequence value)?  startHintSequence,TResult Function( _PlayNextHint value)?  playNextHint,TResult Function( _StartDrag value)?  startDrag,TResult Function( _UpdateDragPosition value)?  updateDragPosition,TResult Function( _EndDrag value)?  endDrag,TResult Function( _PlayItemAudio value)?  playItemAudio,TResult Function( _AudioPlaybackComplete value)?  audioPlaybackComplete,TResult Function( _ResetGame value)?  resetGame,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize(_that);case _StartHintSequence() when startHintSequence != null:
return startHintSequence(_that);case _PlayNextHint() when playNextHint != null:
return playNextHint(_that);case _StartDrag() when startDrag != null:
return startDrag(_that);case _UpdateDragPosition() when updateDragPosition != null:
return updateDragPosition(_that);case _EndDrag() when endDrag != null:
return endDrag(_that);case _PlayItemAudio() when playItemAudio != null:
return playItemAudio(_that);case _AudioPlaybackComplete() when audioPlaybackComplete != null:
return audioPlaybackComplete(_that);case _ResetGame() when resetGame != null:
return resetGame(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initialize value)  initialize,required TResult Function( _StartHintSequence value)  startHintSequence,required TResult Function( _PlayNextHint value)  playNextHint,required TResult Function( _StartDrag value)  startDrag,required TResult Function( _UpdateDragPosition value)  updateDragPosition,required TResult Function( _EndDrag value)  endDrag,required TResult Function( _PlayItemAudio value)  playItemAudio,required TResult Function( _AudioPlaybackComplete value)  audioPlaybackComplete,required TResult Function( _ResetGame value)  resetGame,}){
final _that = this;
switch (_that) {
case _Initialize():
return initialize(_that);case _StartHintSequence():
return startHintSequence(_that);case _PlayNextHint():
return playNextHint(_that);case _StartDrag():
return startDrag(_that);case _UpdateDragPosition():
return updateDragPosition(_that);case _EndDrag():
return endDrag(_that);case _PlayItemAudio():
return playItemAudio(_that);case _AudioPlaybackComplete():
return audioPlaybackComplete(_that);case _ResetGame():
return resetGame(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initialize value)?  initialize,TResult? Function( _StartHintSequence value)?  startHintSequence,TResult? Function( _PlayNextHint value)?  playNextHint,TResult? Function( _StartDrag value)?  startDrag,TResult? Function( _UpdateDragPosition value)?  updateDragPosition,TResult? Function( _EndDrag value)?  endDrag,TResult? Function( _PlayItemAudio value)?  playItemAudio,TResult? Function( _AudioPlaybackComplete value)?  audioPlaybackComplete,TResult? Function( _ResetGame value)?  resetGame,}){
final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize(_that);case _StartHintSequence() when startHintSequence != null:
return startHintSequence(_that);case _PlayNextHint() when playNextHint != null:
return playNextHint(_that);case _StartDrag() when startDrag != null:
return startDrag(_that);case _UpdateDragPosition() when updateDragPosition != null:
return updateDragPosition(_that);case _EndDrag() when endDrag != null:
return endDrag(_that);case _PlayItemAudio() when playItemAudio != null:
return playItemAudio(_that);case _AudioPlaybackComplete() when audioPlaybackComplete != null:
return audioPlaybackComplete(_that);case _ResetGame() when resetGame != null:
return resetGame(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<Item> items)?  initialize,TResult Function()?  startHintSequence,TResult Function()?  playNextHint,TResult Function( String itemId)?  startDrag,TResult Function( String itemId,  double x,  double y)?  updateDragPosition,TResult Function( String itemId,  String? targetOutlineId)?  endDrag,TResult Function( String itemId)?  playItemAudio,TResult Function()?  audioPlaybackComplete,TResult Function()?  resetGame,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize(_that.items);case _StartHintSequence() when startHintSequence != null:
return startHintSequence();case _PlayNextHint() when playNextHint != null:
return playNextHint();case _StartDrag() when startDrag != null:
return startDrag(_that.itemId);case _UpdateDragPosition() when updateDragPosition != null:
return updateDragPosition(_that.itemId,_that.x,_that.y);case _EndDrag() when endDrag != null:
return endDrag(_that.itemId,_that.targetOutlineId);case _PlayItemAudio() when playItemAudio != null:
return playItemAudio(_that.itemId);case _AudioPlaybackComplete() when audioPlaybackComplete != null:
return audioPlaybackComplete();case _ResetGame() when resetGame != null:
return resetGame();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<Item> items)  initialize,required TResult Function()  startHintSequence,required TResult Function()  playNextHint,required TResult Function( String itemId)  startDrag,required TResult Function( String itemId,  double x,  double y)  updateDragPosition,required TResult Function( String itemId,  String? targetOutlineId)  endDrag,required TResult Function( String itemId)  playItemAudio,required TResult Function()  audioPlaybackComplete,required TResult Function()  resetGame,}) {final _that = this;
switch (_that) {
case _Initialize():
return initialize(_that.items);case _StartHintSequence():
return startHintSequence();case _PlayNextHint():
return playNextHint();case _StartDrag():
return startDrag(_that.itemId);case _UpdateDragPosition():
return updateDragPosition(_that.itemId,_that.x,_that.y);case _EndDrag():
return endDrag(_that.itemId,_that.targetOutlineId);case _PlayItemAudio():
return playItemAudio(_that.itemId);case _AudioPlaybackComplete():
return audioPlaybackComplete();case _ResetGame():
return resetGame();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<Item> items)?  initialize,TResult? Function()?  startHintSequence,TResult? Function()?  playNextHint,TResult? Function( String itemId)?  startDrag,TResult? Function( String itemId,  double x,  double y)?  updateDragPosition,TResult? Function( String itemId,  String? targetOutlineId)?  endDrag,TResult? Function( String itemId)?  playItemAudio,TResult? Function()?  audioPlaybackComplete,TResult? Function()?  resetGame,}) {final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize(_that.items);case _StartHintSequence() when startHintSequence != null:
return startHintSequence();case _PlayNextHint() when playNextHint != null:
return playNextHint();case _StartDrag() when startDrag != null:
return startDrag(_that.itemId);case _UpdateDragPosition() when updateDragPosition != null:
return updateDragPosition(_that.itemId,_that.x,_that.y);case _EndDrag() when endDrag != null:
return endDrag(_that.itemId,_that.targetOutlineId);case _PlayItemAudio() when playItemAudio != null:
return playItemAudio(_that.itemId);case _AudioPlaybackComplete() when audioPlaybackComplete != null:
return audioPlaybackComplete();case _ResetGame() when resetGame != null:
return resetGame();case _:
  return null;

}
}

}

/// @nodoc


class _Initialize implements DragToMatchEvent {
  const _Initialize({required final  List<Item> items}): _items = items;
  

 final  List<Item> _items;
 List<Item> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of DragToMatchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitializeCopyWith<_Initialize> get copyWith => __$InitializeCopyWithImpl<_Initialize>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initialize&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'DragToMatchEvent.initialize(items: $items)';
}


}

/// @nodoc
abstract mixin class _$InitializeCopyWith<$Res> implements $DragToMatchEventCopyWith<$Res> {
  factory _$InitializeCopyWith(_Initialize value, $Res Function(_Initialize) _then) = __$InitializeCopyWithImpl;
@useResult
$Res call({
 List<Item> items
});




}
/// @nodoc
class __$InitializeCopyWithImpl<$Res>
    implements _$InitializeCopyWith<$Res> {
  __$InitializeCopyWithImpl(this._self, this._then);

  final _Initialize _self;
  final $Res Function(_Initialize) _then;

/// Create a copy of DragToMatchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_Initialize(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc


class _StartHintSequence implements DragToMatchEvent {
  const _StartHintSequence();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartHintSequence);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DragToMatchEvent.startHintSequence()';
}


}




/// @nodoc


class _PlayNextHint implements DragToMatchEvent {
  const _PlayNextHint();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayNextHint);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DragToMatchEvent.playNextHint()';
}


}




/// @nodoc


class _StartDrag implements DragToMatchEvent {
  const _StartDrag({required this.itemId});
  

 final  String itemId;

/// Create a copy of DragToMatchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartDragCopyWith<_StartDrag> get copyWith => __$StartDragCopyWithImpl<_StartDrag>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartDrag&&(identical(other.itemId, itemId) || other.itemId == itemId));
}


@override
int get hashCode => Object.hash(runtimeType,itemId);

@override
String toString() {
  return 'DragToMatchEvent.startDrag(itemId: $itemId)';
}


}

/// @nodoc
abstract mixin class _$StartDragCopyWith<$Res> implements $DragToMatchEventCopyWith<$Res> {
  factory _$StartDragCopyWith(_StartDrag value, $Res Function(_StartDrag) _then) = __$StartDragCopyWithImpl;
@useResult
$Res call({
 String itemId
});




}
/// @nodoc
class __$StartDragCopyWithImpl<$Res>
    implements _$StartDragCopyWith<$Res> {
  __$StartDragCopyWithImpl(this._self, this._then);

  final _StartDrag _self;
  final $Res Function(_StartDrag) _then;

/// Create a copy of DragToMatchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,}) {
  return _then(_StartDrag(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UpdateDragPosition implements DragToMatchEvent {
  const _UpdateDragPosition({required this.itemId, required this.x, required this.y});
  

 final  String itemId;
 final  double x;
 final  double y;

/// Create a copy of DragToMatchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateDragPositionCopyWith<_UpdateDragPosition> get copyWith => __$UpdateDragPositionCopyWithImpl<_UpdateDragPosition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateDragPosition&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,x,y);

@override
String toString() {
  return 'DragToMatchEvent.updateDragPosition(itemId: $itemId, x: $x, y: $y)';
}


}

/// @nodoc
abstract mixin class _$UpdateDragPositionCopyWith<$Res> implements $DragToMatchEventCopyWith<$Res> {
  factory _$UpdateDragPositionCopyWith(_UpdateDragPosition value, $Res Function(_UpdateDragPosition) _then) = __$UpdateDragPositionCopyWithImpl;
@useResult
$Res call({
 String itemId, double x, double y
});




}
/// @nodoc
class __$UpdateDragPositionCopyWithImpl<$Res>
    implements _$UpdateDragPositionCopyWith<$Res> {
  __$UpdateDragPositionCopyWithImpl(this._self, this._then);

  final _UpdateDragPosition _self;
  final $Res Function(_UpdateDragPosition) _then;

/// Create a copy of DragToMatchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? x = null,Object? y = null,}) {
  return _then(_UpdateDragPosition(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _EndDrag implements DragToMatchEvent {
  const _EndDrag({required this.itemId, this.targetOutlineId});
  

 final  String itemId;
 final  String? targetOutlineId;

/// Create a copy of DragToMatchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndDragCopyWith<_EndDrag> get copyWith => __$EndDragCopyWithImpl<_EndDrag>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EndDrag&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.targetOutlineId, targetOutlineId) || other.targetOutlineId == targetOutlineId));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,targetOutlineId);

@override
String toString() {
  return 'DragToMatchEvent.endDrag(itemId: $itemId, targetOutlineId: $targetOutlineId)';
}


}

/// @nodoc
abstract mixin class _$EndDragCopyWith<$Res> implements $DragToMatchEventCopyWith<$Res> {
  factory _$EndDragCopyWith(_EndDrag value, $Res Function(_EndDrag) _then) = __$EndDragCopyWithImpl;
@useResult
$Res call({
 String itemId, String? targetOutlineId
});




}
/// @nodoc
class __$EndDragCopyWithImpl<$Res>
    implements _$EndDragCopyWith<$Res> {
  __$EndDragCopyWithImpl(this._self, this._then);

  final _EndDrag _self;
  final $Res Function(_EndDrag) _then;

/// Create a copy of DragToMatchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? targetOutlineId = freezed,}) {
  return _then(_EndDrag(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,targetOutlineId: freezed == targetOutlineId ? _self.targetOutlineId : targetOutlineId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _PlayItemAudio implements DragToMatchEvent {
  const _PlayItemAudio({required this.itemId});
  

 final  String itemId;

/// Create a copy of DragToMatchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayItemAudioCopyWith<_PlayItemAudio> get copyWith => __$PlayItemAudioCopyWithImpl<_PlayItemAudio>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayItemAudio&&(identical(other.itemId, itemId) || other.itemId == itemId));
}


@override
int get hashCode => Object.hash(runtimeType,itemId);

@override
String toString() {
  return 'DragToMatchEvent.playItemAudio(itemId: $itemId)';
}


}

/// @nodoc
abstract mixin class _$PlayItemAudioCopyWith<$Res> implements $DragToMatchEventCopyWith<$Res> {
  factory _$PlayItemAudioCopyWith(_PlayItemAudio value, $Res Function(_PlayItemAudio) _then) = __$PlayItemAudioCopyWithImpl;
@useResult
$Res call({
 String itemId
});




}
/// @nodoc
class __$PlayItemAudioCopyWithImpl<$Res>
    implements _$PlayItemAudioCopyWith<$Res> {
  __$PlayItemAudioCopyWithImpl(this._self, this._then);

  final _PlayItemAudio _self;
  final $Res Function(_PlayItemAudio) _then;

/// Create a copy of DragToMatchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemId = null,}) {
  return _then(_PlayItemAudio(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AudioPlaybackComplete implements DragToMatchEvent {
  const _AudioPlaybackComplete();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioPlaybackComplete);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DragToMatchEvent.audioPlaybackComplete()';
}


}




/// @nodoc


class _ResetGame implements DragToMatchEvent {
  const _ResetGame();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetGame);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DragToMatchEvent.resetGame()';
}


}




// dart format on
