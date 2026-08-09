// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tap_to_pop_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TapToPopEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToPopEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TapToPopEvent()';
}


}

/// @nodoc
class $TapToPopEventCopyWith<$Res>  {
$TapToPopEventCopyWith(TapToPopEvent _, $Res Function(TapToPopEvent) __);
}


/// Adds pattern-matching-related methods to [TapToPopEvent].
extension TapToPopEventPatterns on TapToPopEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _TapItem value)?  tapItem,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TapItem() when tapItem != null:
return tapItem(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _TapItem value)  tapItem,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _TapItem():
return tapItem(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _TapItem value)?  tapItem,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _TapItem() when tapItem != null:
return tapItem(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TapToPopLessonContent content)?  started,TResult Function( Item item)?  tapItem,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _TapItem() when tapItem != null:
return tapItem(_that.item);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TapToPopLessonContent content)  started,required TResult Function( Item item)  tapItem,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _TapItem():
return tapItem(_that.item);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TapToPopLessonContent content)?  started,TResult? Function( Item item)?  tapItem,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _TapItem() when tapItem != null:
return tapItem(_that.item);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements TapToPopEvent {
  const _Started(this.content);
  

 final  TapToPopLessonContent content;

/// Create a copy of TapToPopEvent
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
  return 'TapToPopEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $TapToPopEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 TapToPopLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of TapToPopEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToPopLessonContent,
  ));
}


}

/// @nodoc


class _TapItem implements TapToPopEvent {
  const _TapItem(this.item);
  

 final  Item item;

/// Create a copy of TapToPopEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TapItemCopyWith<_TapItem> get copyWith => __$TapItemCopyWithImpl<_TapItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TapItem&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'TapToPopEvent.tapItem(item: $item)';
}


}

/// @nodoc
abstract mixin class _$TapItemCopyWith<$Res> implements $TapToPopEventCopyWith<$Res> {
  factory _$TapItemCopyWith(_TapItem value, $Res Function(_TapItem) _then) = __$TapItemCopyWithImpl;
@useResult
$Res call({
 Item item
});


$ItemCopyWith<$Res> get item;

}
/// @nodoc
class __$TapItemCopyWithImpl<$Res>
    implements _$TapItemCopyWith<$Res> {
  __$TapItemCopyWithImpl(this._self, this._then);

  final _TapItem _self;
  final $Res Function(_TapItem) _then;

/// Create a copy of TapToPopEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(_TapItem(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,
  ));
}

/// Create a copy of TapToPopEvent
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
mixin _$TapToPopState {

 TapToPopLessonContent? get content; List<Item>? get correctItems; List<Item>? get selectedItems; bool get completed;
/// Create a copy of TapToPopState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TapToPopStateCopyWith<TapToPopState> get copyWith => _$TapToPopStateCopyWithImpl<TapToPopState>(this as TapToPopState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToPopState&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other.correctItems, correctItems)&&const DeepCollectionEquality().equals(other.selectedItems, selectedItems)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(correctItems),const DeepCollectionEquality().hash(selectedItems),completed);

@override
String toString() {
  return 'TapToPopState(content: $content, correctItems: $correctItems, selectedItems: $selectedItems, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $TapToPopStateCopyWith<$Res>  {
  factory $TapToPopStateCopyWith(TapToPopState value, $Res Function(TapToPopState) _then) = _$TapToPopStateCopyWithImpl;
@useResult
$Res call({
 TapToPopLessonContent? content, List<Item>? correctItems, List<Item>? selectedItems, bool completed
});




}
/// @nodoc
class _$TapToPopStateCopyWithImpl<$Res>
    implements $TapToPopStateCopyWith<$Res> {
  _$TapToPopStateCopyWithImpl(this._self, this._then);

  final TapToPopState _self;
  final $Res Function(TapToPopState) _then;

/// Create a copy of TapToPopState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? correctItems = freezed,Object? selectedItems = freezed,Object? completed = null,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToPopLessonContent?,correctItems: freezed == correctItems ? _self.correctItems : correctItems // ignore: cast_nullable_to_non_nullable
as List<Item>?,selectedItems: freezed == selectedItems ? _self.selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as List<Item>?,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TapToPopState].
extension TapToPopStatePatterns on TapToPopState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Initial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Initial value)  $default,){
final _that = this;
switch (_that) {
case _Initial():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Initial value)?  $default,){
final _that = this;
switch (_that) {
case _Initial() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TapToPopLessonContent? content,  List<Item>? correctItems,  List<Item>? selectedItems,  bool completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when $default != null:
return $default(_that.content,_that.correctItems,_that.selectedItems,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TapToPopLessonContent? content,  List<Item>? correctItems,  List<Item>? selectedItems,  bool completed)  $default,) {final _that = this;
switch (_that) {
case _Initial():
return $default(_that.content,_that.correctItems,_that.selectedItems,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TapToPopLessonContent? content,  List<Item>? correctItems,  List<Item>? selectedItems,  bool completed)?  $default,) {final _that = this;
switch (_that) {
case _Initial() when $default != null:
return $default(_that.content,_that.correctItems,_that.selectedItems,_that.completed);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements TapToPopState {
  const _Initial({this.content, final  List<Item>? correctItems, final  List<Item>? selectedItems, this.completed = false}): _correctItems = correctItems,_selectedItems = selectedItems;
  

@override final  TapToPopLessonContent? content;
 final  List<Item>? _correctItems;
@override List<Item>? get correctItems {
  final value = _correctItems;
  if (value == null) return null;
  if (_correctItems is EqualUnmodifiableListView) return _correctItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Item>? _selectedItems;
@override List<Item>? get selectedItems {
  final value = _selectedItems;
  if (value == null) return null;
  if (_selectedItems is EqualUnmodifiableListView) return _selectedItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool completed;

/// Create a copy of TapToPopState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other._correctItems, _correctItems)&&const DeepCollectionEquality().equals(other._selectedItems, _selectedItems)&&(identical(other.completed, completed) || other.completed == completed));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(_correctItems),const DeepCollectionEquality().hash(_selectedItems),completed);

@override
String toString() {
  return 'TapToPopState(content: $content, correctItems: $correctItems, selectedItems: $selectedItems, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $TapToPopStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 TapToPopLessonContent? content, List<Item>? correctItems, List<Item>? selectedItems, bool completed
});




}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of TapToPopState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? correctItems = freezed,Object? selectedItems = freezed,Object? completed = null,}) {
  return _then(_Initial(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToPopLessonContent?,correctItems: freezed == correctItems ? _self._correctItems : correctItems // ignore: cast_nullable_to_non_nullable
as List<Item>?,selectedItems: freezed == selectedItems ? _self._selectedItems : selectedItems // ignore: cast_nullable_to_non_nullable
as List<Item>?,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
