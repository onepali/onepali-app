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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _HunchaButtonPressed value)?  hunchaButtonPressed,TResult Function( _OnDragAccept value)?  onDragAccept,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _HunchaButtonPressed() when hunchaButtonPressed != null:
return hunchaButtonPressed(_that);case _OnDragAccept() when onDragAccept != null:
return onDragAccept(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _HunchaButtonPressed value)  hunchaButtonPressed,required TResult Function( _OnDragAccept value)  onDragAccept,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _HunchaButtonPressed():
return hunchaButtonPressed(_that);case _OnDragAccept():
return onDragAccept(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _HunchaButtonPressed value)?  hunchaButtonPressed,TResult? Function( _OnDragAccept value)?  onDragAccept,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _HunchaButtonPressed() when hunchaButtonPressed != null:
return hunchaButtonPressed(_that);case _OnDragAccept() when onDragAccept != null:
return onDragAccept(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TeaMakingLessonContent content)?  started,TResult Function()?  hunchaButtonPressed,TResult Function( int index)?  onDragAccept,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _HunchaButtonPressed() when hunchaButtonPressed != null:
return hunchaButtonPressed();case _OnDragAccept() when onDragAccept != null:
return onDragAccept(_that.index);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TeaMakingLessonContent content)  started,required TResult Function()  hunchaButtonPressed,required TResult Function( int index)  onDragAccept,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _HunchaButtonPressed():
return hunchaButtonPressed();case _OnDragAccept():
return onDragAccept(_that.index);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TeaMakingLessonContent content)?  started,TResult? Function()?  hunchaButtonPressed,TResult? Function( int index)?  onDragAccept,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _HunchaButtonPressed() when hunchaButtonPressed != null:
return hunchaButtonPressed();case _OnDragAccept() when onDragAccept != null:
return onDragAccept(_that.index);case _:
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


class _OnDragAccept implements TutorialEvent {
  const _OnDragAccept(this.index);
  

 final  int index;

/// Create a copy of TutorialEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnDragAcceptCopyWith<_OnDragAccept> get copyWith => __$OnDragAcceptCopyWithImpl<_OnDragAccept>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnDragAccept&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'TutorialEvent.onDragAccept(index: $index)';
}


}

/// @nodoc
abstract mixin class _$OnDragAcceptCopyWith<$Res> implements $TutorialEventCopyWith<$Res> {
  factory _$OnDragAcceptCopyWith(_OnDragAccept value, $Res Function(_OnDragAccept) _then) = __$OnDragAcceptCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class __$OnDragAcceptCopyWithImpl<$Res>
    implements _$OnDragAcceptCopyWith<$Res> {
  __$OnDragAcceptCopyWithImpl(this._self, this._then);

  final _OnDragAccept _self;
  final $Res Function(_OnDragAccept) _then;

/// Create a copy of TutorialEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(_OnDragAccept(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TutorialState {

 bool get showLoading; int get index; int get draggedIndex; List<String> get ingredients; bool get showLeopardWithTea; bool get showHunchButton; bool get showDragIndicator; String? get draggedItemPath; String? get droppedItem; String? get stoveImage; String? get dragIndicator; String? get hunchaButton; String? get checkIcon; String? get leopardTakingTeaTb; String? get leopardTakingTeaMb; bool get teaReady; bool get completionFeedbackReady;
/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TutorialStateCopyWith<TutorialState> get copyWith => _$TutorialStateCopyWithImpl<TutorialState>(this as TutorialState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TutorialState&&(identical(other.showLoading, showLoading) || other.showLoading == showLoading)&&(identical(other.index, index) || other.index == index)&&(identical(other.draggedIndex, draggedIndex) || other.draggedIndex == draggedIndex)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&(identical(other.showLeopardWithTea, showLeopardWithTea) || other.showLeopardWithTea == showLeopardWithTea)&&(identical(other.showHunchButton, showHunchButton) || other.showHunchButton == showHunchButton)&&(identical(other.showDragIndicator, showDragIndicator) || other.showDragIndicator == showDragIndicator)&&(identical(other.draggedItemPath, draggedItemPath) || other.draggedItemPath == draggedItemPath)&&(identical(other.droppedItem, droppedItem) || other.droppedItem == droppedItem)&&(identical(other.stoveImage, stoveImage) || other.stoveImage == stoveImage)&&(identical(other.dragIndicator, dragIndicator) || other.dragIndicator == dragIndicator)&&(identical(other.hunchaButton, hunchaButton) || other.hunchaButton == hunchaButton)&&(identical(other.checkIcon, checkIcon) || other.checkIcon == checkIcon)&&(identical(other.leopardTakingTeaTb, leopardTakingTeaTb) || other.leopardTakingTeaTb == leopardTakingTeaTb)&&(identical(other.leopardTakingTeaMb, leopardTakingTeaMb) || other.leopardTakingTeaMb == leopardTakingTeaMb)&&(identical(other.teaReady, teaReady) || other.teaReady == teaReady)&&(identical(other.completionFeedbackReady, completionFeedbackReady) || other.completionFeedbackReady == completionFeedbackReady));
}


@override
int get hashCode => Object.hash(runtimeType,showLoading,index,draggedIndex,const DeepCollectionEquality().hash(ingredients),showLeopardWithTea,showHunchButton,showDragIndicator,draggedItemPath,droppedItem,stoveImage,dragIndicator,hunchaButton,checkIcon,leopardTakingTeaTb,leopardTakingTeaMb,teaReady,completionFeedbackReady);

@override
String toString() {
  return 'TutorialState(showLoading: $showLoading, index: $index, draggedIndex: $draggedIndex, ingredients: $ingredients, showLeopardWithTea: $showLeopardWithTea, showHunchButton: $showHunchButton, showDragIndicator: $showDragIndicator, draggedItemPath: $draggedItemPath, droppedItem: $droppedItem, stoveImage: $stoveImage, dragIndicator: $dragIndicator, hunchaButton: $hunchaButton, checkIcon: $checkIcon, leopardTakingTeaTb: $leopardTakingTeaTb, leopardTakingTeaMb: $leopardTakingTeaMb, teaReady: $teaReady, completionFeedbackReady: $completionFeedbackReady)';
}


}

/// @nodoc
abstract mixin class $TutorialStateCopyWith<$Res>  {
  factory $TutorialStateCopyWith(TutorialState value, $Res Function(TutorialState) _then) = _$TutorialStateCopyWithImpl;
@useResult
$Res call({
 bool showLoading, int index, int draggedIndex, List<String> ingredients, bool showLeopardWithTea, bool showHunchButton, bool showDragIndicator, String? draggedItemPath, String? droppedItem, String? stoveImage, String? dragIndicator, String? hunchaButton, String? checkIcon, String? leopardTakingTeaTb, String? leopardTakingTeaMb, bool teaReady, bool completionFeedbackReady
});




}
/// @nodoc
class _$TutorialStateCopyWithImpl<$Res>
    implements $TutorialStateCopyWith<$Res> {
  _$TutorialStateCopyWithImpl(this._self, this._then);

  final TutorialState _self;
  final $Res Function(TutorialState) _then;

/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showLoading = null,Object? index = null,Object? draggedIndex = null,Object? ingredients = null,Object? showLeopardWithTea = null,Object? showHunchButton = null,Object? showDragIndicator = null,Object? draggedItemPath = freezed,Object? droppedItem = freezed,Object? stoveImage = freezed,Object? dragIndicator = freezed,Object? hunchaButton = freezed,Object? checkIcon = freezed,Object? leopardTakingTeaTb = freezed,Object? leopardTakingTeaMb = freezed,Object? teaReady = null,Object? completionFeedbackReady = null,}) {
  return _then(_self.copyWith(
showLoading: null == showLoading ? _self.showLoading : showLoading // ignore: cast_nullable_to_non_nullable
as bool,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,draggedIndex: null == draggedIndex ? _self.draggedIndex : draggedIndex // ignore: cast_nullable_to_non_nullable
as int,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<String>,showLeopardWithTea: null == showLeopardWithTea ? _self.showLeopardWithTea : showLeopardWithTea // ignore: cast_nullable_to_non_nullable
as bool,showHunchButton: null == showHunchButton ? _self.showHunchButton : showHunchButton // ignore: cast_nullable_to_non_nullable
as bool,showDragIndicator: null == showDragIndicator ? _self.showDragIndicator : showDragIndicator // ignore: cast_nullable_to_non_nullable
as bool,draggedItemPath: freezed == draggedItemPath ? _self.draggedItemPath : draggedItemPath // ignore: cast_nullable_to_non_nullable
as String?,droppedItem: freezed == droppedItem ? _self.droppedItem : droppedItem // ignore: cast_nullable_to_non_nullable
as String?,stoveImage: freezed == stoveImage ? _self.stoveImage : stoveImage // ignore: cast_nullable_to_non_nullable
as String?,dragIndicator: freezed == dragIndicator ? _self.dragIndicator : dragIndicator // ignore: cast_nullable_to_non_nullable
as String?,hunchaButton: freezed == hunchaButton ? _self.hunchaButton : hunchaButton // ignore: cast_nullable_to_non_nullable
as String?,checkIcon: freezed == checkIcon ? _self.checkIcon : checkIcon // ignore: cast_nullable_to_non_nullable
as String?,leopardTakingTeaTb: freezed == leopardTakingTeaTb ? _self.leopardTakingTeaTb : leopardTakingTeaTb // ignore: cast_nullable_to_non_nullable
as String?,leopardTakingTeaMb: freezed == leopardTakingTeaMb ? _self.leopardTakingTeaMb : leopardTakingTeaMb // ignore: cast_nullable_to_non_nullable
as String?,teaReady: null == teaReady ? _self.teaReady : teaReady // ignore: cast_nullable_to_non_nullable
as bool,completionFeedbackReady: null == completionFeedbackReady ? _self.completionFeedbackReady : completionFeedbackReady // ignore: cast_nullable_to_non_nullable
as bool,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool showLoading,  int index,  int draggedIndex,  List<String> ingredients,  bool showLeopardWithTea,  bool showHunchButton,  bool showDragIndicator,  String? draggedItemPath,  String? droppedItem,  String? stoveImage,  String? dragIndicator,  String? hunchaButton,  String? checkIcon,  String? leopardTakingTeaTb,  String? leopardTakingTeaMb,  bool teaReady,  bool completionFeedbackReady)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TutorialState() when $default != null:
return $default(_that.showLoading,_that.index,_that.draggedIndex,_that.ingredients,_that.showLeopardWithTea,_that.showHunchButton,_that.showDragIndicator,_that.draggedItemPath,_that.droppedItem,_that.stoveImage,_that.dragIndicator,_that.hunchaButton,_that.checkIcon,_that.leopardTakingTeaTb,_that.leopardTakingTeaMb,_that.teaReady,_that.completionFeedbackReady);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool showLoading,  int index,  int draggedIndex,  List<String> ingredients,  bool showLeopardWithTea,  bool showHunchButton,  bool showDragIndicator,  String? draggedItemPath,  String? droppedItem,  String? stoveImage,  String? dragIndicator,  String? hunchaButton,  String? checkIcon,  String? leopardTakingTeaTb,  String? leopardTakingTeaMb,  bool teaReady,  bool completionFeedbackReady)  $default,) {final _that = this;
switch (_that) {
case _TutorialState():
return $default(_that.showLoading,_that.index,_that.draggedIndex,_that.ingredients,_that.showLeopardWithTea,_that.showHunchButton,_that.showDragIndicator,_that.draggedItemPath,_that.droppedItem,_that.stoveImage,_that.dragIndicator,_that.hunchaButton,_that.checkIcon,_that.leopardTakingTeaTb,_that.leopardTakingTeaMb,_that.teaReady,_that.completionFeedbackReady);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool showLoading,  int index,  int draggedIndex,  List<String> ingredients,  bool showLeopardWithTea,  bool showHunchButton,  bool showDragIndicator,  String? draggedItemPath,  String? droppedItem,  String? stoveImage,  String? dragIndicator,  String? hunchaButton,  String? checkIcon,  String? leopardTakingTeaTb,  String? leopardTakingTeaMb,  bool teaReady,  bool completionFeedbackReady)?  $default,) {final _that = this;
switch (_that) {
case _TutorialState() when $default != null:
return $default(_that.showLoading,_that.index,_that.draggedIndex,_that.ingredients,_that.showLeopardWithTea,_that.showHunchButton,_that.showDragIndicator,_that.draggedItemPath,_that.droppedItem,_that.stoveImage,_that.dragIndicator,_that.hunchaButton,_that.checkIcon,_that.leopardTakingTeaTb,_that.leopardTakingTeaMb,_that.teaReady,_that.completionFeedbackReady);case _:
  return null;

}
}

}

/// @nodoc


class _TutorialState implements TutorialState {
  const _TutorialState({this.showLoading = false, this.index = -1, this.draggedIndex = 0, final  List<String> ingredients = const [], this.showLeopardWithTea = false, this.showHunchButton = false, this.showDragIndicator = false, this.draggedItemPath, this.droppedItem, this.stoveImage, this.dragIndicator, this.hunchaButton, this.checkIcon, this.leopardTakingTeaTb, this.leopardTakingTeaMb, this.teaReady = false, this.completionFeedbackReady = false}): _ingredients = ingredients;
  

@override@JsonKey() final  bool showLoading;
@override@JsonKey() final  int index;
@override@JsonKey() final  int draggedIndex;
 final  List<String> _ingredients;
@override@JsonKey() List<String> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

@override@JsonKey() final  bool showLeopardWithTea;
@override@JsonKey() final  bool showHunchButton;
@override@JsonKey() final  bool showDragIndicator;
@override final  String? draggedItemPath;
@override final  String? droppedItem;
@override final  String? stoveImage;
@override final  String? dragIndicator;
@override final  String? hunchaButton;
@override final  String? checkIcon;
@override final  String? leopardTakingTeaTb;
@override final  String? leopardTakingTeaMb;
@override@JsonKey() final  bool teaReady;
@override@JsonKey() final  bool completionFeedbackReady;

/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TutorialStateCopyWith<_TutorialState> get copyWith => __$TutorialStateCopyWithImpl<_TutorialState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TutorialState&&(identical(other.showLoading, showLoading) || other.showLoading == showLoading)&&(identical(other.index, index) || other.index == index)&&(identical(other.draggedIndex, draggedIndex) || other.draggedIndex == draggedIndex)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&(identical(other.showLeopardWithTea, showLeopardWithTea) || other.showLeopardWithTea == showLeopardWithTea)&&(identical(other.showHunchButton, showHunchButton) || other.showHunchButton == showHunchButton)&&(identical(other.showDragIndicator, showDragIndicator) || other.showDragIndicator == showDragIndicator)&&(identical(other.draggedItemPath, draggedItemPath) || other.draggedItemPath == draggedItemPath)&&(identical(other.droppedItem, droppedItem) || other.droppedItem == droppedItem)&&(identical(other.stoveImage, stoveImage) || other.stoveImage == stoveImage)&&(identical(other.dragIndicator, dragIndicator) || other.dragIndicator == dragIndicator)&&(identical(other.hunchaButton, hunchaButton) || other.hunchaButton == hunchaButton)&&(identical(other.checkIcon, checkIcon) || other.checkIcon == checkIcon)&&(identical(other.leopardTakingTeaTb, leopardTakingTeaTb) || other.leopardTakingTeaTb == leopardTakingTeaTb)&&(identical(other.leopardTakingTeaMb, leopardTakingTeaMb) || other.leopardTakingTeaMb == leopardTakingTeaMb)&&(identical(other.teaReady, teaReady) || other.teaReady == teaReady)&&(identical(other.completionFeedbackReady, completionFeedbackReady) || other.completionFeedbackReady == completionFeedbackReady));
}


@override
int get hashCode => Object.hash(runtimeType,showLoading,index,draggedIndex,const DeepCollectionEquality().hash(_ingredients),showLeopardWithTea,showHunchButton,showDragIndicator,draggedItemPath,droppedItem,stoveImage,dragIndicator,hunchaButton,checkIcon,leopardTakingTeaTb,leopardTakingTeaMb,teaReady,completionFeedbackReady);

@override
String toString() {
  return 'TutorialState(showLoading: $showLoading, index: $index, draggedIndex: $draggedIndex, ingredients: $ingredients, showLeopardWithTea: $showLeopardWithTea, showHunchButton: $showHunchButton, showDragIndicator: $showDragIndicator, draggedItemPath: $draggedItemPath, droppedItem: $droppedItem, stoveImage: $stoveImage, dragIndicator: $dragIndicator, hunchaButton: $hunchaButton, checkIcon: $checkIcon, leopardTakingTeaTb: $leopardTakingTeaTb, leopardTakingTeaMb: $leopardTakingTeaMb, teaReady: $teaReady, completionFeedbackReady: $completionFeedbackReady)';
}


}

/// @nodoc
abstract mixin class _$TutorialStateCopyWith<$Res> implements $TutorialStateCopyWith<$Res> {
  factory _$TutorialStateCopyWith(_TutorialState value, $Res Function(_TutorialState) _then) = __$TutorialStateCopyWithImpl;
@override @useResult
$Res call({
 bool showLoading, int index, int draggedIndex, List<String> ingredients, bool showLeopardWithTea, bool showHunchButton, bool showDragIndicator, String? draggedItemPath, String? droppedItem, String? stoveImage, String? dragIndicator, String? hunchaButton, String? checkIcon, String? leopardTakingTeaTb, String? leopardTakingTeaMb, bool teaReady, bool completionFeedbackReady
});




}
/// @nodoc
class __$TutorialStateCopyWithImpl<$Res>
    implements _$TutorialStateCopyWith<$Res> {
  __$TutorialStateCopyWithImpl(this._self, this._then);

  final _TutorialState _self;
  final $Res Function(_TutorialState) _then;

/// Create a copy of TutorialState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showLoading = null,Object? index = null,Object? draggedIndex = null,Object? ingredients = null,Object? showLeopardWithTea = null,Object? showHunchButton = null,Object? showDragIndicator = null,Object? draggedItemPath = freezed,Object? droppedItem = freezed,Object? stoveImage = freezed,Object? dragIndicator = freezed,Object? hunchaButton = freezed,Object? checkIcon = freezed,Object? leopardTakingTeaTb = freezed,Object? leopardTakingTeaMb = freezed,Object? teaReady = null,Object? completionFeedbackReady = null,}) {
  return _then(_TutorialState(
showLoading: null == showLoading ? _self.showLoading : showLoading // ignore: cast_nullable_to_non_nullable
as bool,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,draggedIndex: null == draggedIndex ? _self.draggedIndex : draggedIndex // ignore: cast_nullable_to_non_nullable
as int,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<String>,showLeopardWithTea: null == showLeopardWithTea ? _self.showLeopardWithTea : showLeopardWithTea // ignore: cast_nullable_to_non_nullable
as bool,showHunchButton: null == showHunchButton ? _self.showHunchButton : showHunchButton // ignore: cast_nullable_to_non_nullable
as bool,showDragIndicator: null == showDragIndicator ? _self.showDragIndicator : showDragIndicator // ignore: cast_nullable_to_non_nullable
as bool,draggedItemPath: freezed == draggedItemPath ? _self.draggedItemPath : draggedItemPath // ignore: cast_nullable_to_non_nullable
as String?,droppedItem: freezed == droppedItem ? _self.droppedItem : droppedItem // ignore: cast_nullable_to_non_nullable
as String?,stoveImage: freezed == stoveImage ? _self.stoveImage : stoveImage // ignore: cast_nullable_to_non_nullable
as String?,dragIndicator: freezed == dragIndicator ? _self.dragIndicator : dragIndicator // ignore: cast_nullable_to_non_nullable
as String?,hunchaButton: freezed == hunchaButton ? _self.hunchaButton : hunchaButton // ignore: cast_nullable_to_non_nullable
as String?,checkIcon: freezed == checkIcon ? _self.checkIcon : checkIcon // ignore: cast_nullable_to_non_nullable
as String?,leopardTakingTeaTb: freezed == leopardTakingTeaTb ? _self.leopardTakingTeaTb : leopardTakingTeaTb // ignore: cast_nullable_to_non_nullable
as String?,leopardTakingTeaMb: freezed == leopardTakingTeaMb ? _self.leopardTakingTeaMb : leopardTakingTeaMb // ignore: cast_nullable_to_non_nullable
as String?,teaReady: null == teaReady ? _self.teaReady : teaReady // ignore: cast_nullable_to_non_nullable
as bool,completionFeedbackReady: null == completionFeedbackReady ? _self.completionFeedbackReady : completionFeedbackReady // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
