// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gun_fill_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GunFillEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GunFillEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GunFillEvent()';
}


}

/// @nodoc
class $GunFillEventCopyWith<$Res>  {
$GunFillEventCopyWith(GunFillEvent _, $Res Function(GunFillEvent) __);
}


/// Adds pattern-matching-related methods to [GunFillEvent].
extension GunFillEventPatterns on GunFillEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _InstructionComplete value)?  instructionComplete,TResult Function( _ColorFilled value)?  colorFilled,TResult Function( _StarBlustCompleted value)?  starBlustCompleted,TResult Function( _AudioComplete value)?  audioComplete,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _InstructionComplete() when instructionComplete != null:
return instructionComplete(_that);case _ColorFilled() when colorFilled != null:
return colorFilled(_that);case _StarBlustCompleted() when starBlustCompleted != null:
return starBlustCompleted(_that);case _AudioComplete() when audioComplete != null:
return audioComplete(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _InstructionComplete value)  instructionComplete,required TResult Function( _ColorFilled value)  colorFilled,required TResult Function( _StarBlustCompleted value)  starBlustCompleted,required TResult Function( _AudioComplete value)  audioComplete,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _InstructionComplete():
return instructionComplete(_that);case _ColorFilled():
return colorFilled(_that);case _StarBlustCompleted():
return starBlustCompleted(_that);case _AudioComplete():
return audioComplete(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _InstructionComplete value)?  instructionComplete,TResult? Function( _ColorFilled value)?  colorFilled,TResult? Function( _StarBlustCompleted value)?  starBlustCompleted,TResult? Function( _AudioComplete value)?  audioComplete,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _InstructionComplete() when instructionComplete != null:
return instructionComplete(_that);case _ColorFilled() when colorFilled != null:
return colorFilled(_that);case _StarBlustCompleted() when starBlustCompleted != null:
return starBlustCompleted(_that);case _AudioComplete() when audioComplete != null:
return audioComplete(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( GunFillLessonContent content,  bool isMobile)?  started,TResult Function()?  instructionComplete,TResult Function( String partId)?  colorFilled,TResult Function( GunPart part)?  starBlustCompleted,TResult Function()?  audioComplete,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content,_that.isMobile);case _InstructionComplete() when instructionComplete != null:
return instructionComplete();case _ColorFilled() when colorFilled != null:
return colorFilled(_that.partId);case _StarBlustCompleted() when starBlustCompleted != null:
return starBlustCompleted(_that.part);case _AudioComplete() when audioComplete != null:
return audioComplete();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( GunFillLessonContent content,  bool isMobile)  started,required TResult Function()  instructionComplete,required TResult Function( String partId)  colorFilled,required TResult Function( GunPart part)  starBlustCompleted,required TResult Function()  audioComplete,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content,_that.isMobile);case _InstructionComplete():
return instructionComplete();case _ColorFilled():
return colorFilled(_that.partId);case _StarBlustCompleted():
return starBlustCompleted(_that.part);case _AudioComplete():
return audioComplete();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( GunFillLessonContent content,  bool isMobile)?  started,TResult? Function()?  instructionComplete,TResult? Function( String partId)?  colorFilled,TResult? Function( GunPart part)?  starBlustCompleted,TResult? Function()?  audioComplete,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content,_that.isMobile);case _InstructionComplete() when instructionComplete != null:
return instructionComplete();case _ColorFilled() when colorFilled != null:
return colorFilled(_that.partId);case _StarBlustCompleted() when starBlustCompleted != null:
return starBlustCompleted(_that.part);case _AudioComplete() when audioComplete != null:
return audioComplete();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements GunFillEvent {
  const _Started(this.content, this.isMobile);
  

 final  GunFillLessonContent content;
 final  bool isMobile;

/// Create a copy of GunFillEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.isMobile, isMobile) || other.isMobile == isMobile));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),isMobile);

@override
String toString() {
  return 'GunFillEvent.started(content: $content, isMobile: $isMobile)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $GunFillEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 GunFillLessonContent content, bool isMobile
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of GunFillEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? isMobile = null,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as GunFillLessonContent,null == isMobile ? _self.isMobile : isMobile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _InstructionComplete implements GunFillEvent {
  const _InstructionComplete();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstructionComplete);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GunFillEvent.instructionComplete()';
}


}




/// @nodoc


class _ColorFilled implements GunFillEvent {
  const _ColorFilled(this.partId);
  

 final  String partId;

/// Create a copy of GunFillEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColorFilledCopyWith<_ColorFilled> get copyWith => __$ColorFilledCopyWithImpl<_ColorFilled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColorFilled&&(identical(other.partId, partId) || other.partId == partId));
}


@override
int get hashCode => Object.hash(runtimeType,partId);

@override
String toString() {
  return 'GunFillEvent.colorFilled(partId: $partId)';
}


}

/// @nodoc
abstract mixin class _$ColorFilledCopyWith<$Res> implements $GunFillEventCopyWith<$Res> {
  factory _$ColorFilledCopyWith(_ColorFilled value, $Res Function(_ColorFilled) _then) = __$ColorFilledCopyWithImpl;
@useResult
$Res call({
 String partId
});




}
/// @nodoc
class __$ColorFilledCopyWithImpl<$Res>
    implements _$ColorFilledCopyWith<$Res> {
  __$ColorFilledCopyWithImpl(this._self, this._then);

  final _ColorFilled _self;
  final $Res Function(_ColorFilled) _then;

/// Create a copy of GunFillEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? partId = null,}) {
  return _then(_ColorFilled(
null == partId ? _self.partId : partId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _StarBlustCompleted implements GunFillEvent {
  const _StarBlustCompleted(this.part);
  

 final  GunPart part;

/// Create a copy of GunFillEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StarBlustCompletedCopyWith<_StarBlustCompleted> get copyWith => __$StarBlustCompletedCopyWithImpl<_StarBlustCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StarBlustCompleted&&(identical(other.part, part) || other.part == part));
}


@override
int get hashCode => Object.hash(runtimeType,part);

@override
String toString() {
  return 'GunFillEvent.starBlustCompleted(part: $part)';
}


}

/// @nodoc
abstract mixin class _$StarBlustCompletedCopyWith<$Res> implements $GunFillEventCopyWith<$Res> {
  factory _$StarBlustCompletedCopyWith(_StarBlustCompleted value, $Res Function(_StarBlustCompleted) _then) = __$StarBlustCompletedCopyWithImpl;
@useResult
$Res call({
 GunPart part
});


$GunPartCopyWith<$Res> get part;

}
/// @nodoc
class __$StarBlustCompletedCopyWithImpl<$Res>
    implements _$StarBlustCompletedCopyWith<$Res> {
  __$StarBlustCompletedCopyWithImpl(this._self, this._then);

  final _StarBlustCompleted _self;
  final $Res Function(_StarBlustCompleted) _then;

/// Create a copy of GunFillEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? part = null,}) {
  return _then(_StarBlustCompleted(
null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as GunPart,
  ));
}

/// Create a copy of GunFillEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GunPartCopyWith<$Res> get part {
  
  return $GunPartCopyWith<$Res>(_self.part, (value) {
    return _then(_self.copyWith(part: value));
  });
}
}

/// @nodoc


class _AudioComplete implements GunFillEvent {
  const _AudioComplete();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioComplete);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GunFillEvent.audioComplete()';
}


}




/// @nodoc
mixin _$GunFillState {

 GunFillStatus get status; GunFillLessonContent? get content; List<GunPart> get gunParts; List<GunLabel> get labelPaths; bool get isCompleted;
/// Create a copy of GunFillState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GunFillStateCopyWith<GunFillState> get copyWith => _$GunFillStateCopyWithImpl<GunFillState>(this as GunFillState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GunFillState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other.gunParts, gunParts)&&const DeepCollectionEquality().equals(other.labelPaths, labelPaths)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(gunParts),const DeepCollectionEquality().hash(labelPaths),isCompleted);

@override
String toString() {
  return 'GunFillState(status: $status, content: $content, gunParts: $gunParts, labelPaths: $labelPaths, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $GunFillStateCopyWith<$Res>  {
  factory $GunFillStateCopyWith(GunFillState value, $Res Function(GunFillState) _then) = _$GunFillStateCopyWithImpl;
@useResult
$Res call({
 GunFillStatus status, GunFillLessonContent? content, List<GunPart> gunParts, List<GunLabel> labelPaths, bool isCompleted
});




}
/// @nodoc
class _$GunFillStateCopyWithImpl<$Res>
    implements $GunFillStateCopyWith<$Res> {
  _$GunFillStateCopyWithImpl(this._self, this._then);

  final GunFillState _self;
  final $Res Function(GunFillState) _then;

/// Create a copy of GunFillState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? content = freezed,Object? gunParts = null,Object? labelPaths = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GunFillStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as GunFillLessonContent?,gunParts: null == gunParts ? _self.gunParts : gunParts // ignore: cast_nullable_to_non_nullable
as List<GunPart>,labelPaths: null == labelPaths ? _self.labelPaths : labelPaths // ignore: cast_nullable_to_non_nullable
as List<GunLabel>,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GunFillState].
extension GunFillStatePatterns on GunFillState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GunFillState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GunFillState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GunFillState value)  $default,){
final _that = this;
switch (_that) {
case _GunFillState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GunFillState value)?  $default,){
final _that = this;
switch (_that) {
case _GunFillState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GunFillStatus status,  GunFillLessonContent? content,  List<GunPart> gunParts,  List<GunLabel> labelPaths,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GunFillState() when $default != null:
return $default(_that.status,_that.content,_that.gunParts,_that.labelPaths,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GunFillStatus status,  GunFillLessonContent? content,  List<GunPart> gunParts,  List<GunLabel> labelPaths,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _GunFillState():
return $default(_that.status,_that.content,_that.gunParts,_that.labelPaths,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GunFillStatus status,  GunFillLessonContent? content,  List<GunPart> gunParts,  List<GunLabel> labelPaths,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _GunFillState() when $default != null:
return $default(_that.status,_that.content,_that.gunParts,_that.labelPaths,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _GunFillState implements GunFillState {
  const _GunFillState({this.status = GunFillStatus.initial, this.content, final  List<GunPart> gunParts = const [], final  List<GunLabel> labelPaths = const [], this.isCompleted = false}): _gunParts = gunParts,_labelPaths = labelPaths;
  

@override@JsonKey() final  GunFillStatus status;
@override final  GunFillLessonContent? content;
 final  List<GunPart> _gunParts;
@override@JsonKey() List<GunPart> get gunParts {
  if (_gunParts is EqualUnmodifiableListView) return _gunParts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gunParts);
}

 final  List<GunLabel> _labelPaths;
@override@JsonKey() List<GunLabel> get labelPaths {
  if (_labelPaths is EqualUnmodifiableListView) return _labelPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_labelPaths);
}

@override@JsonKey() final  bool isCompleted;

/// Create a copy of GunFillState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GunFillStateCopyWith<_GunFillState> get copyWith => __$GunFillStateCopyWithImpl<_GunFillState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GunFillState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.content, content)&&const DeepCollectionEquality().equals(other._gunParts, _gunParts)&&const DeepCollectionEquality().equals(other._labelPaths, _labelPaths)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(content),const DeepCollectionEquality().hash(_gunParts),const DeepCollectionEquality().hash(_labelPaths),isCompleted);

@override
String toString() {
  return 'GunFillState(status: $status, content: $content, gunParts: $gunParts, labelPaths: $labelPaths, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$GunFillStateCopyWith<$Res> implements $GunFillStateCopyWith<$Res> {
  factory _$GunFillStateCopyWith(_GunFillState value, $Res Function(_GunFillState) _then) = __$GunFillStateCopyWithImpl;
@override @useResult
$Res call({
 GunFillStatus status, GunFillLessonContent? content, List<GunPart> gunParts, List<GunLabel> labelPaths, bool isCompleted
});




}
/// @nodoc
class __$GunFillStateCopyWithImpl<$Res>
    implements _$GunFillStateCopyWith<$Res> {
  __$GunFillStateCopyWithImpl(this._self, this._then);

  final _GunFillState _self;
  final $Res Function(_GunFillState) _then;

/// Create a copy of GunFillState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? content = freezed,Object? gunParts = null,Object? labelPaths = null,Object? isCompleted = null,}) {
  return _then(_GunFillState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GunFillStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as GunFillLessonContent?,gunParts: null == gunParts ? _self._gunParts : gunParts // ignore: cast_nullable_to_non_nullable
as List<GunPart>,labelPaths: null == labelPaths ? _self._labelPaths : labelPaths // ignore: cast_nullable_to_non_nullable
as List<GunLabel>,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$GunPart {

/// Id of the part, also used as the color code, for example #ff0000.
 String get id;/// Path of the part in svg image
 String get path;/// Fill color of the part in svg image.
 String? get color;/// Tracks whether the part has been filled.
 bool get isFilled; Item? get item;
/// Create a copy of GunPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GunPartCopyWith<GunPart> get copyWith => _$GunPartCopyWithImpl<GunPart>(this as GunPart, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GunPart&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.color, color) || other.color == color)&&(identical(other.isFilled, isFilled) || other.isFilled == isFilled)&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,id,path,color,isFilled,item);

@override
String toString() {
  return 'GunPart(id: $id, path: $path, color: $color, isFilled: $isFilled, item: $item)';
}


}

/// @nodoc
abstract mixin class $GunPartCopyWith<$Res>  {
  factory $GunPartCopyWith(GunPart value, $Res Function(GunPart) _then) = _$GunPartCopyWithImpl;
@useResult
$Res call({
 String id, String path, String? color, bool isFilled, Item? item
});


$ItemCopyWith<$Res>? get item;

}
/// @nodoc
class _$GunPartCopyWithImpl<$Res>
    implements $GunPartCopyWith<$Res> {
  _$GunPartCopyWithImpl(this._self, this._then);

  final GunPart _self;
  final $Res Function(GunPart) _then;

/// Create a copy of GunPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = null,Object? color = freezed,Object? isFilled = null,Object? item = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isFilled: null == isFilled ? _self.isFilled : isFilled // ignore: cast_nullable_to_non_nullable
as bool,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item?,
  ));
}
/// Create a copy of GunPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// Adds pattern-matching-related methods to [GunPart].
extension GunPartPatterns on GunPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GunPart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GunPart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GunPart value)  $default,){
final _that = this;
switch (_that) {
case _GunPart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GunPart value)?  $default,){
final _that = this;
switch (_that) {
case _GunPart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String path,  String? color,  bool isFilled,  Item? item)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GunPart() when $default != null:
return $default(_that.id,_that.path,_that.color,_that.isFilled,_that.item);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String path,  String? color,  bool isFilled,  Item? item)  $default,) {final _that = this;
switch (_that) {
case _GunPart():
return $default(_that.id,_that.path,_that.color,_that.isFilled,_that.item);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String path,  String? color,  bool isFilled,  Item? item)?  $default,) {final _that = this;
switch (_that) {
case _GunPart() when $default != null:
return $default(_that.id,_that.path,_that.color,_that.isFilled,_that.item);case _:
  return null;

}
}

}

/// @nodoc


class _GunPart implements GunPart {
  const _GunPart({required this.id, required this.path, this.color, this.isFilled = false, this.item});
  

/// Id of the part, also used as the color code, for example #ff0000.
@override final  String id;
/// Path of the part in svg image
@override final  String path;
/// Fill color of the part in svg image.
@override final  String? color;
/// Tracks whether the part has been filled.
@override@JsonKey() final  bool isFilled;
@override final  Item? item;

/// Create a copy of GunPart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GunPartCopyWith<_GunPart> get copyWith => __$GunPartCopyWithImpl<_GunPart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GunPart&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.color, color) || other.color == color)&&(identical(other.isFilled, isFilled) || other.isFilled == isFilled)&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,id,path,color,isFilled,item);

@override
String toString() {
  return 'GunPart(id: $id, path: $path, color: $color, isFilled: $isFilled, item: $item)';
}


}

/// @nodoc
abstract mixin class _$GunPartCopyWith<$Res> implements $GunPartCopyWith<$Res> {
  factory _$GunPartCopyWith(_GunPart value, $Res Function(_GunPart) _then) = __$GunPartCopyWithImpl;
@override @useResult
$Res call({
 String id, String path, String? color, bool isFilled, Item? item
});


@override $ItemCopyWith<$Res>? get item;

}
/// @nodoc
class __$GunPartCopyWithImpl<$Res>
    implements _$GunPartCopyWith<$Res> {
  __$GunPartCopyWithImpl(this._self, this._then);

  final _GunPart _self;
  final $Res Function(_GunPart) _then;

/// Create a copy of GunPart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = null,Object? color = freezed,Object? isFilled = null,Object? item = freezed,}) {
  return _then(_GunPart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,isFilled: null == isFilled ? _self.isFilled : isFilled // ignore: cast_nullable_to_non_nullable
as bool,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item?,
  ));
}

/// Create a copy of GunPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $ItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc
mixin _$GunLabel {

/// Path of the label in svg image
 String get path;/// Fill color of the label in svg image.
 String? get color;/// Gun part id/color code that this label accepts when dropped on.
 String? get gunPartId;
/// Create a copy of GunLabel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GunLabelCopyWith<GunLabel> get copyWith => _$GunLabelCopyWithImpl<GunLabel>(this as GunLabel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GunLabel&&(identical(other.path, path) || other.path == path)&&(identical(other.color, color) || other.color == color)&&(identical(other.gunPartId, gunPartId) || other.gunPartId == gunPartId));
}


@override
int get hashCode => Object.hash(runtimeType,path,color,gunPartId);

@override
String toString() {
  return 'GunLabel(path: $path, color: $color, gunPartId: $gunPartId)';
}


}

/// @nodoc
abstract mixin class $GunLabelCopyWith<$Res>  {
  factory $GunLabelCopyWith(GunLabel value, $Res Function(GunLabel) _then) = _$GunLabelCopyWithImpl;
@useResult
$Res call({
 String path, String? color, String? gunPartId
});




}
/// @nodoc
class _$GunLabelCopyWithImpl<$Res>
    implements $GunLabelCopyWith<$Res> {
  _$GunLabelCopyWithImpl(this._self, this._then);

  final GunLabel _self;
  final $Res Function(GunLabel) _then;

/// Create a copy of GunLabel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? color = freezed,Object? gunPartId = freezed,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,gunPartId: freezed == gunPartId ? _self.gunPartId : gunPartId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GunLabel].
extension GunLabelPatterns on GunLabel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GunLabel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GunLabel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GunLabel value)  $default,){
final _that = this;
switch (_that) {
case _GunLabel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GunLabel value)?  $default,){
final _that = this;
switch (_that) {
case _GunLabel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String? color,  String? gunPartId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GunLabel() when $default != null:
return $default(_that.path,_that.color,_that.gunPartId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String? color,  String? gunPartId)  $default,) {final _that = this;
switch (_that) {
case _GunLabel():
return $default(_that.path,_that.color,_that.gunPartId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String? color,  String? gunPartId)?  $default,) {final _that = this;
switch (_that) {
case _GunLabel() when $default != null:
return $default(_that.path,_that.color,_that.gunPartId);case _:
  return null;

}
}

}

/// @nodoc


class _GunLabel implements GunLabel {
  const _GunLabel({required this.path, this.color, this.gunPartId});
  

/// Path of the label in svg image
@override final  String path;
/// Fill color of the label in svg image.
@override final  String? color;
/// Gun part id/color code that this label accepts when dropped on.
@override final  String? gunPartId;

/// Create a copy of GunLabel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GunLabelCopyWith<_GunLabel> get copyWith => __$GunLabelCopyWithImpl<_GunLabel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GunLabel&&(identical(other.path, path) || other.path == path)&&(identical(other.color, color) || other.color == color)&&(identical(other.gunPartId, gunPartId) || other.gunPartId == gunPartId));
}


@override
int get hashCode => Object.hash(runtimeType,path,color,gunPartId);

@override
String toString() {
  return 'GunLabel(path: $path, color: $color, gunPartId: $gunPartId)';
}


}

/// @nodoc
abstract mixin class _$GunLabelCopyWith<$Res> implements $GunLabelCopyWith<$Res> {
  factory _$GunLabelCopyWith(_GunLabel value, $Res Function(_GunLabel) _then) = __$GunLabelCopyWithImpl;
@override @useResult
$Res call({
 String path, String? color, String? gunPartId
});




}
/// @nodoc
class __$GunLabelCopyWithImpl<$Res>
    implements _$GunLabelCopyWith<$Res> {
  __$GunLabelCopyWithImpl(this._self, this._then);

  final _GunLabel _self;
  final $Res Function(_GunLabel) _then;

/// Create a copy of GunLabel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? color = freezed,Object? gunPartId = freezed,}) {
  return _then(_GunLabel(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,gunPartId: freezed == gunPartId ? _self.gunPartId : gunPartId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
