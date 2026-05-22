// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tutorial_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TutorialEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorialEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialEvent()';
}


}

/// @nodoc
class $TutorialEventCopyWith<$Res>  {
$TutorialEventCopyWith(TutorialEvent _, $Res Function(TutorialEvent) __);
}


/// Adds pattern-matching-related methods to [TutorialEvent].
extension TutorialEventPatterns on TutorialEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _InstructionAudioCompleted value)?  instructionAudioCompleted,TResult Function( _HunchaButtonPressed value)?  hunchaButtonPressed,TResult Function( _HunchaAudioCompleted value)?  hunchaAudioCompleted,TResult Function( _GuideAudioCompleted value)?  guideAudioCompleted,TResult Function( _ItemDropped value)?  itemDropped,TResult Function( _ItemAudioCompleted value)?  itemAudioCompleted,TResult Function( _ProcessInstructionOnlyStep value)?  processInstructionOnlyStep,TResult Function( _Ideal value)?  ideal,TResult Function( _Completed value)?  completed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _InstructionAudioCompleted() when instructionAudioCompleted != null:
return instructionAudioCompleted(_that);case _HunchaButtonPressed() when hunchaButtonPressed != null:
return hunchaButtonPressed(_that);case _HunchaAudioCompleted() when hunchaAudioCompleted != null:
return hunchaAudioCompleted(_that);case _GuideAudioCompleted() when guideAudioCompleted != null:
return guideAudioCompleted(_that);case _ItemDropped() when itemDropped != null:
return itemDropped(_that);case _ItemAudioCompleted() when itemAudioCompleted != null:
return itemAudioCompleted(_that);case _ProcessInstructionOnlyStep() when processInstructionOnlyStep != null:
return processInstructionOnlyStep(_that);case _Ideal() when ideal != null:
return ideal(_that);case _Completed() when completed != null:
return completed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _InstructionAudioCompleted value)  instructionAudioCompleted,required TResult Function( _HunchaButtonPressed value)  hunchaButtonPressed,required TResult Function( _HunchaAudioCompleted value)  hunchaAudioCompleted,required TResult Function( _GuideAudioCompleted value)  guideAudioCompleted,required TResult Function( _ItemDropped value)  itemDropped,required TResult Function( _ItemAudioCompleted value)  itemAudioCompleted,required TResult Function( _ProcessInstructionOnlyStep value)  processInstructionOnlyStep,required TResult Function( _Ideal value)  ideal,required TResult Function( _Completed value)  completed,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _InstructionAudioCompleted():
return instructionAudioCompleted(_that);case _HunchaButtonPressed():
return hunchaButtonPressed(_that);case _HunchaAudioCompleted():
return hunchaAudioCompleted(_that);case _GuideAudioCompleted():
return guideAudioCompleted(_that);case _ItemDropped():
return itemDropped(_that);case _ItemAudioCompleted():
return itemAudioCompleted(_that);case _ProcessInstructionOnlyStep():
return processInstructionOnlyStep(_that);case _Ideal():
return ideal(_that);case _Completed():
return completed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _InstructionAudioCompleted value)?  instructionAudioCompleted,TResult? Function( _HunchaButtonPressed value)?  hunchaButtonPressed,TResult? Function( _HunchaAudioCompleted value)?  hunchaAudioCompleted,TResult? Function( _GuideAudioCompleted value)?  guideAudioCompleted,TResult? Function( _ItemDropped value)?  itemDropped,TResult? Function( _ItemAudioCompleted value)?  itemAudioCompleted,TResult? Function( _ProcessInstructionOnlyStep value)?  processInstructionOnlyStep,TResult? Function( _Ideal value)?  ideal,TResult? Function( _Completed value)?  completed,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _InstructionAudioCompleted() when instructionAudioCompleted != null:
return instructionAudioCompleted(_that);case _HunchaButtonPressed() when hunchaButtonPressed != null:
return hunchaButtonPressed(_that);case _HunchaAudioCompleted() when hunchaAudioCompleted != null:
return hunchaAudioCompleted(_that);case _GuideAudioCompleted() when guideAudioCompleted != null:
return guideAudioCompleted(_that);case _ItemDropped() when itemDropped != null:
return itemDropped(_that);case _ItemAudioCompleted() when itemAudioCompleted != null:
return itemAudioCompleted(_that);case _ProcessInstructionOnlyStep() when processInstructionOnlyStep != null:
return processInstructionOnlyStep(_that);case _Ideal() when ideal != null:
return ideal(_that);case _Completed() when completed != null:
return completed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TeaMakingLessonContent content)?  started,TResult Function()?  instructionAudioCompleted,TResult Function()?  hunchaButtonPressed,TResult Function()?  hunchaAudioCompleted,TResult Function()?  guideAudioCompleted,TResult Function( Item item)?  itemDropped,TResult Function()?  itemAudioCompleted,TResult Function()?  processInstructionOnlyStep,TResult Function( Item item)?  ideal,TResult Function()?  completed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _InstructionAudioCompleted() when instructionAudioCompleted != null:
return instructionAudioCompleted();case _HunchaButtonPressed() when hunchaButtonPressed != null:
return hunchaButtonPressed();case _HunchaAudioCompleted() when hunchaAudioCompleted != null:
return hunchaAudioCompleted();case _GuideAudioCompleted() when guideAudioCompleted != null:
return guideAudioCompleted();case _ItemDropped() when itemDropped != null:
return itemDropped(_that.item);case _ItemAudioCompleted() when itemAudioCompleted != null:
return itemAudioCompleted();case _ProcessInstructionOnlyStep() when processInstructionOnlyStep != null:
return processInstructionOnlyStep();case _Ideal() when ideal != null:
return ideal(_that.item);case _Completed() when completed != null:
return completed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TeaMakingLessonContent content)  started,required TResult Function()  instructionAudioCompleted,required TResult Function()  hunchaButtonPressed,required TResult Function()  hunchaAudioCompleted,required TResult Function()  guideAudioCompleted,required TResult Function( Item item)  itemDropped,required TResult Function()  itemAudioCompleted,required TResult Function()  processInstructionOnlyStep,required TResult Function( Item item)  ideal,required TResult Function()  completed,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _InstructionAudioCompleted():
return instructionAudioCompleted();case _HunchaButtonPressed():
return hunchaButtonPressed();case _HunchaAudioCompleted():
return hunchaAudioCompleted();case _GuideAudioCompleted():
return guideAudioCompleted();case _ItemDropped():
return itemDropped(_that.item);case _ItemAudioCompleted():
return itemAudioCompleted();case _ProcessInstructionOnlyStep():
return processInstructionOnlyStep();case _Ideal():
return ideal(_that.item);case _Completed():
return completed();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TeaMakingLessonContent content)?  started,TResult? Function()?  instructionAudioCompleted,TResult? Function()?  hunchaButtonPressed,TResult? Function()?  hunchaAudioCompleted,TResult? Function()?  guideAudioCompleted,TResult? Function( Item item)?  itemDropped,TResult? Function()?  itemAudioCompleted,TResult? Function()?  processInstructionOnlyStep,TResult? Function( Item item)?  ideal,TResult? Function()?  completed,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _InstructionAudioCompleted() when instructionAudioCompleted != null:
return instructionAudioCompleted();case _HunchaButtonPressed() when hunchaButtonPressed != null:
return hunchaButtonPressed();case _HunchaAudioCompleted() when hunchaAudioCompleted != null:
return hunchaAudioCompleted();case _GuideAudioCompleted() when guideAudioCompleted != null:
return guideAudioCompleted();case _ItemDropped() when itemDropped != null:
return itemDropped(_that.item);case _ItemAudioCompleted() when itemAudioCompleted != null:
return itemAudioCompleted();case _ProcessInstructionOnlyStep() when processInstructionOnlyStep != null:
return processInstructionOnlyStep();case _Ideal() when ideal != null:
return ideal(_that.item);case _Completed() when completed != null:
return completed();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements TutorialEvent {
  const _Started(this.content);
  

 final  TeaMakingLessonContent content;

/// Create a copy of TutorialEvent
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
  return 'TutorialEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $TutorialEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 TeaMakingLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of TutorialEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TeaMakingLessonContent,
  ));
}


}

/// @nodoc


class _InstructionAudioCompleted implements TutorialEvent {
  const _InstructionAudioCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstructionAudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialEvent.instructionAudioCompleted()';
}


}




/// @nodoc


class _HunchaButtonPressed implements TutorialEvent {
  const _HunchaButtonPressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HunchaButtonPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialEvent.hunchaButtonPressed()';
}


}




/// @nodoc


class _HunchaAudioCompleted implements TutorialEvent {
  const _HunchaAudioCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HunchaAudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialEvent.hunchaAudioCompleted()';
}


}




/// @nodoc


class _GuideAudioCompleted implements TutorialEvent {
  const _GuideAudioCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuideAudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialEvent.guideAudioCompleted()';
}


}




/// @nodoc


class _ItemDropped implements TutorialEvent {
  const _ItemDropped(this.item);
  

 final  Item item;

/// Create a copy of TutorialEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemDroppedCopyWith<_ItemDropped> get copyWith => __$ItemDroppedCopyWithImpl<_ItemDropped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemDropped&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'TutorialEvent.itemDropped(item: $item)';
}


}

/// @nodoc
abstract mixin class _$ItemDroppedCopyWith<$Res> implements $TutorialEventCopyWith<$Res> {
  factory _$ItemDroppedCopyWith(_ItemDropped value, $Res Function(_ItemDropped) _then) = __$ItemDroppedCopyWithImpl;
@useResult
$Res call({
 Item item
});


$ItemCopyWith<$Res> get item;

}
/// @nodoc
class __$ItemDroppedCopyWithImpl<$Res>
    implements _$ItemDroppedCopyWith<$Res> {
  __$ItemDroppedCopyWithImpl(this._self, this._then);

  final _ItemDropped _self;
  final $Res Function(_ItemDropped) _then;

/// Create a copy of TutorialEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(_ItemDropped(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,
  ));
}

/// Create a copy of TutorialEvent
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


class _ItemAudioCompleted implements TutorialEvent {
  const _ItemAudioCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemAudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialEvent.itemAudioCompleted()';
}


}




/// @nodoc


class _ProcessInstructionOnlyStep implements TutorialEvent {
  const _ProcessInstructionOnlyStep();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProcessInstructionOnlyStep);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialEvent.processInstructionOnlyStep()';
}


}




/// @nodoc


class _Ideal implements TutorialEvent {
  const _Ideal(this.item);
  

 final  Item item;

/// Create a copy of TutorialEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IdealCopyWith<_Ideal> get copyWith => __$IdealCopyWithImpl<_Ideal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ideal&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'TutorialEvent.ideal(item: $item)';
}


}

/// @nodoc
abstract mixin class _$IdealCopyWith<$Res> implements $TutorialEventCopyWith<$Res> {
  factory _$IdealCopyWith(_Ideal value, $Res Function(_Ideal) _then) = __$IdealCopyWithImpl;
@useResult
$Res call({
 Item item
});


$ItemCopyWith<$Res> get item;

}
/// @nodoc
class __$IdealCopyWithImpl<$Res>
    implements _$IdealCopyWith<$Res> {
  __$IdealCopyWithImpl(this._self, this._then);

  final _Ideal _self;
  final $Res Function(_Ideal) _then;

/// Create a copy of TutorialEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(_Ideal(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,
  ));
}

/// Create a copy of TutorialEvent
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


class _Completed implements TutorialEvent {
  const _Completed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Completed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TutorialEvent.completed()';
}


}




/// @nodoc
mixin _$TutorialState {

 TutorialStatus get status; TeaMakingLessonContent? get content; Item? get lastDroppedItem; Item? get currentItem; int get currentIndex; Set<int> get completedIngredientIndices;// @Default(false) bool showLoading,
// @Default(-1) int index,
// @Default(0) int draggedIndex,
// @Default([]) List<String> ingredients,
// @Default(false) bool showBearWithTea,
 bool get showHunchButton;
/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TutorialStateCopyWith<TutorialState> get copyWith => _$TutorialStateCopyWithImpl<TutorialState>(this as TutorialState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorialState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.lastDroppedItem, lastDroppedItem) || other.lastDroppedItem == lastDroppedItem)&&(identical(other.currentItem, currentItem) || other.currentItem == currentItem)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other.completedIngredientIndices, completedIngredientIndices)&&(identical(other.showHunchButton, showHunchButton) || other.showHunchButton == showHunchButton));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(content),lastDroppedItem,currentItem,currentIndex,const DeepCollectionEquality().hash(completedIngredientIndices),showHunchButton);

@override
String toString() {
  return 'TutorialState(status: $status, content: $content, lastDroppedItem: $lastDroppedItem, currentItem: $currentItem, currentIndex: $currentIndex, completedIngredientIndices: $completedIngredientIndices, showHunchButton: $showHunchButton)';
}


}

/// @nodoc
abstract mixin class $TutorialStateCopyWith<$Res>  {
  factory $TutorialStateCopyWith(TutorialState value, $Res Function(TutorialState) _then) = _$TutorialStateCopyWithImpl;
@useResult
$Res call({
 TutorialStatus status, TeaMakingLessonContent? content, Item? lastDroppedItem, Item? currentItem, int currentIndex, Set<int> completedIngredientIndices, bool showHunchButton
});


$ItemCopyWith<$Res>? get lastDroppedItem;$ItemCopyWith<$Res>? get currentItem;

}
/// @nodoc
class _$TutorialStateCopyWithImpl<$Res>
    implements $TutorialStateCopyWith<$Res> {
  _$TutorialStateCopyWithImpl(this._self, this._then);

  final TutorialState _self;
  final $Res Function(TutorialState) _then;

/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? content = freezed,Object? lastDroppedItem = freezed,Object? currentItem = freezed,Object? currentIndex = null,Object? completedIngredientIndices = null,Object? showHunchButton = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TutorialStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TeaMakingLessonContent?,lastDroppedItem: freezed == lastDroppedItem ? _self.lastDroppedItem : lastDroppedItem // ignore: cast_nullable_to_non_nullable
as Item?,currentItem: freezed == currentItem ? _self.currentItem : currentItem // ignore: cast_nullable_to_non_nullable
as Item?,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,completedIngredientIndices: null == completedIngredientIndices ? _self.completedIngredientIndices : completedIngredientIndices // ignore: cast_nullable_to_non_nullable
as Set<int>,showHunchButton: null == showHunchButton ? _self.showHunchButton : showHunchButton // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get lastDroppedItem {
    if (_self.lastDroppedItem == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.lastDroppedItem!, (value) {
    return _then(_self.copyWith(lastDroppedItem: value));
  });
}/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get currentItem {
    if (_self.currentItem == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.currentItem!, (value) {
    return _then(_self.copyWith(currentItem: value));
  });
}
}


/// Adds pattern-matching-related methods to [TutorialState].
extension TutorialStatePatterns on TutorialState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TutorialState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TutorialState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TutorialState value)  $default,){
final _that = this;
switch (_that) {
case _TutorialState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TutorialState value)?  $default,){
final _that = this;
switch (_that) {
case _TutorialState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TutorialStatus status,  TeaMakingLessonContent? content,  Item? lastDroppedItem,  Item? currentItem,  int currentIndex,  Set<int> completedIngredientIndices,  bool showHunchButton)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TutorialState() when $default != null:
return $default(_that.status,_that.content,_that.lastDroppedItem,_that.currentItem,_that.currentIndex,_that.completedIngredientIndices,_that.showHunchButton);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TutorialStatus status,  TeaMakingLessonContent? content,  Item? lastDroppedItem,  Item? currentItem,  int currentIndex,  Set<int> completedIngredientIndices,  bool showHunchButton)  $default,) {final _that = this;
switch (_that) {
case _TutorialState():
return $default(_that.status,_that.content,_that.lastDroppedItem,_that.currentItem,_that.currentIndex,_that.completedIngredientIndices,_that.showHunchButton);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TutorialStatus status,  TeaMakingLessonContent? content,  Item? lastDroppedItem,  Item? currentItem,  int currentIndex,  Set<int> completedIngredientIndices,  bool showHunchButton)?  $default,) {final _that = this;
switch (_that) {
case _TutorialState() when $default != null:
return $default(_that.status,_that.content,_that.lastDroppedItem,_that.currentItem,_that.currentIndex,_that.completedIngredientIndices,_that.showHunchButton);case _:
  return null;

}
}

}

/// @nodoc


class _TutorialState extends TutorialState {
  const _TutorialState({this.status = TutorialStatus.initial, this.content, this.lastDroppedItem, this.currentItem, this.currentIndex = 0, final  Set<int> completedIngredientIndices = const <int>{}, this.showHunchButton = false}): _completedIngredientIndices = completedIngredientIndices,super._();
  

@override@JsonKey() final  TutorialStatus status;
@override final  TeaMakingLessonContent? content;
@override final  Item? lastDroppedItem;
@override final  Item? currentItem;
@override@JsonKey() final  int currentIndex;
 final  Set<int> _completedIngredientIndices;
@override@JsonKey() Set<int> get completedIngredientIndices {
  if (_completedIngredientIndices is EqualUnmodifiableSetView) return _completedIngredientIndices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_completedIngredientIndices);
}

// @Default(false) bool showLoading,
// @Default(-1) int index,
// @Default(0) int draggedIndex,
// @Default([]) List<String> ingredients,
// @Default(false) bool showBearWithTea,
@override@JsonKey() final  bool showHunchButton;

/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TutorialStateCopyWith<_TutorialState> get copyWith => __$TutorialStateCopyWithImpl<_TutorialState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TutorialState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.lastDroppedItem, lastDroppedItem) || other.lastDroppedItem == lastDroppedItem)&&(identical(other.currentItem, currentItem) || other.currentItem == currentItem)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other._completedIngredientIndices, _completedIngredientIndices)&&(identical(other.showHunchButton, showHunchButton) || other.showHunchButton == showHunchButton));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(content),lastDroppedItem,currentItem,currentIndex,const DeepCollectionEquality().hash(_completedIngredientIndices),showHunchButton);

@override
String toString() {
  return 'TutorialState(status: $status, content: $content, lastDroppedItem: $lastDroppedItem, currentItem: $currentItem, currentIndex: $currentIndex, completedIngredientIndices: $completedIngredientIndices, showHunchButton: $showHunchButton)';
}


}

/// @nodoc
abstract mixin class _$TutorialStateCopyWith<$Res> implements $TutorialStateCopyWith<$Res> {
  factory _$TutorialStateCopyWith(_TutorialState value, $Res Function(_TutorialState) _then) = __$TutorialStateCopyWithImpl;
@override @useResult
$Res call({
 TutorialStatus status, TeaMakingLessonContent? content, Item? lastDroppedItem, Item? currentItem, int currentIndex, Set<int> completedIngredientIndices, bool showHunchButton
});


@override $ItemCopyWith<$Res>? get lastDroppedItem;@override $ItemCopyWith<$Res>? get currentItem;

}
/// @nodoc
class __$TutorialStateCopyWithImpl<$Res>
    implements _$TutorialStateCopyWith<$Res> {
  __$TutorialStateCopyWithImpl(this._self, this._then);

  final _TutorialState _self;
  final $Res Function(_TutorialState) _then;

/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? content = freezed,Object? lastDroppedItem = freezed,Object? currentItem = freezed,Object? currentIndex = null,Object? completedIngredientIndices = null,Object? showHunchButton = null,}) {
  return _then(_TutorialState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TutorialStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TeaMakingLessonContent?,lastDroppedItem: freezed == lastDroppedItem ? _self.lastDroppedItem : lastDroppedItem // ignore: cast_nullable_to_non_nullable
as Item?,currentItem: freezed == currentItem ? _self.currentItem : currentItem // ignore: cast_nullable_to_non_nullable
as Item?,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,completedIngredientIndices: null == completedIngredientIndices ? _self._completedIngredientIndices : completedIngredientIndices // ignore: cast_nullable_to_non_nullable
as Set<int>,showHunchButton: null == showHunchButton ? _self.showHunchButton : showHunchButton // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get lastDroppedItem {
    if (_self.lastDroppedItem == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.lastDroppedItem!, (value) {
    return _then(_self.copyWith(lastDroppedItem: value));
  });
}/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get currentItem {
    if (_self.currentItem == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.currentItem!, (value) {
    return _then(_self.copyWith(currentItem: value));
  });
}
}

// dart format on
