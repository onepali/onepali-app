// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balloon_fill_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BalloonFillEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BalloonFillEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BalloonFillEvent()';
}


}

/// @nodoc
class $BalloonFillEventCopyWith<$Res>  {
$BalloonFillEventCopyWith(BalloonFillEvent _, $Res Function(BalloonFillEvent) __);
}


/// Adds pattern-matching-related methods to [BalloonFillEvent].
extension BalloonFillEventPatterns on BalloonFillEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _AudioCompleted value)?  audioCompleted,TResult Function( _BalloonTapped value)?  balloonTapped,TResult Function( _FillAnimationCompleted value)?  fillAnimationCompleted,TResult Function( _LabelHidden value)?  labelHidden,TResult Function( _Reset value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that);case _BalloonTapped() when balloonTapped != null:
return balloonTapped(_that);case _FillAnimationCompleted() when fillAnimationCompleted != null:
return fillAnimationCompleted(_that);case _LabelHidden() when labelHidden != null:
return labelHidden(_that);case _Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _AudioCompleted value)  audioCompleted,required TResult Function( _BalloonTapped value)  balloonTapped,required TResult Function( _FillAnimationCompleted value)  fillAnimationCompleted,required TResult Function( _LabelHidden value)  labelHidden,required TResult Function( _Reset value)  reset,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _AudioCompleted():
return audioCompleted(_that);case _BalloonTapped():
return balloonTapped(_that);case _FillAnimationCompleted():
return fillAnimationCompleted(_that);case _LabelHidden():
return labelHidden(_that);case _Reset():
return reset(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _AudioCompleted value)?  audioCompleted,TResult? Function( _BalloonTapped value)?  balloonTapped,TResult? Function( _FillAnimationCompleted value)?  fillAnimationCompleted,TResult? Function( _LabelHidden value)?  labelHidden,TResult? Function( _Reset value)?  reset,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that);case _BalloonTapped() when balloonTapped != null:
return balloonTapped(_that);case _FillAnimationCompleted() when fillAnimationCompleted != null:
return fillAnimationCompleted(_that);case _LabelHidden() when labelHidden != null:
return labelHidden(_that);case _Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BalloonFillLessonContent content)?  started,TResult Function()?  audioCompleted,TResult Function( int index)?  balloonTapped,TResult Function()?  fillAnimationCompleted,TResult Function()?  labelHidden,TResult Function()?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _AudioCompleted() when audioCompleted != null:
return audioCompleted();case _BalloonTapped() when balloonTapped != null:
return balloonTapped(_that.index);case _FillAnimationCompleted() when fillAnimationCompleted != null:
return fillAnimationCompleted();case _LabelHidden() when labelHidden != null:
return labelHidden();case _Reset() when reset != null:
return reset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BalloonFillLessonContent content)  started,required TResult Function()  audioCompleted,required TResult Function( int index)  balloonTapped,required TResult Function()  fillAnimationCompleted,required TResult Function()  labelHidden,required TResult Function()  reset,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _AudioCompleted():
return audioCompleted();case _BalloonTapped():
return balloonTapped(_that.index);case _FillAnimationCompleted():
return fillAnimationCompleted();case _LabelHidden():
return labelHidden();case _Reset():
return reset();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BalloonFillLessonContent content)?  started,TResult? Function()?  audioCompleted,TResult? Function( int index)?  balloonTapped,TResult? Function()?  fillAnimationCompleted,TResult? Function()?  labelHidden,TResult? Function()?  reset,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _AudioCompleted() when audioCompleted != null:
return audioCompleted();case _BalloonTapped() when balloonTapped != null:
return balloonTapped(_that.index);case _FillAnimationCompleted() when fillAnimationCompleted != null:
return fillAnimationCompleted();case _LabelHidden() when labelHidden != null:
return labelHidden();case _Reset() when reset != null:
return reset();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements BalloonFillEvent {
  const _Started(this.content);
  

 final  BalloonFillLessonContent content;

/// Create a copy of BalloonFillEvent
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
  return 'BalloonFillEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $BalloonFillEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 BalloonFillLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of BalloonFillEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as BalloonFillLessonContent,
  ));
}


}

/// @nodoc


class _AudioCompleted implements BalloonFillEvent {
  const _AudioCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BalloonFillEvent.audioCompleted()';
}


}




/// @nodoc


class _BalloonTapped implements BalloonFillEvent {
  const _BalloonTapped(this.index);
  

 final  int index;

/// Create a copy of BalloonFillEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BalloonTappedCopyWith<_BalloonTapped> get copyWith => __$BalloonTappedCopyWithImpl<_BalloonTapped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BalloonTapped&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'BalloonFillEvent.balloonTapped(index: $index)';
}


}

/// @nodoc
abstract mixin class _$BalloonTappedCopyWith<$Res> implements $BalloonFillEventCopyWith<$Res> {
  factory _$BalloonTappedCopyWith(_BalloonTapped value, $Res Function(_BalloonTapped) _then) = __$BalloonTappedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class __$BalloonTappedCopyWithImpl<$Res>
    implements _$BalloonTappedCopyWith<$Res> {
  __$BalloonTappedCopyWithImpl(this._self, this._then);

  final _BalloonTapped _self;
  final $Res Function(_BalloonTapped) _then;

/// Create a copy of BalloonFillEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(_BalloonTapped(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _FillAnimationCompleted implements BalloonFillEvent {
  const _FillAnimationCompleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FillAnimationCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BalloonFillEvent.fillAnimationCompleted()';
}


}




/// @nodoc


class _LabelHidden implements BalloonFillEvent {
  const _LabelHidden();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabelHidden);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BalloonFillEvent.labelHidden()';
}


}




/// @nodoc


class _Reset implements BalloonFillEvent {
  const _Reset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BalloonFillEvent.reset()';
}


}




/// @nodoc
mixin _$BalloonFillState {

 BalloonFillLessonContent? get content; BalloonFillStatus get status; Set<int> get filledIndexes; int? get fillingIndex;// which balloon is currently animating
 String? get colorLabelNp;
/// Create a copy of BalloonFillState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BalloonFillStateCopyWith<BalloonFillState> get copyWith => _$BalloonFillStateCopyWithImpl<BalloonFillState>(this as BalloonFillState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BalloonFillState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.filledIndexes, filledIndexes)&&(identical(other.fillingIndex, fillingIndex) || other.fillingIndex == fillingIndex)&&(identical(other.colorLabelNp, colorLabelNp) || other.colorLabelNp == colorLabelNp));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),status,const DeepCollectionEquality().hash(filledIndexes),fillingIndex,colorLabelNp);

@override
String toString() {
  return 'BalloonFillState(content: $content, status: $status, filledIndexes: $filledIndexes, fillingIndex: $fillingIndex, colorLabelNp: $colorLabelNp)';
}


}

/// @nodoc
abstract mixin class $BalloonFillStateCopyWith<$Res>  {
  factory $BalloonFillStateCopyWith(BalloonFillState value, $Res Function(BalloonFillState) _then) = _$BalloonFillStateCopyWithImpl;
@useResult
$Res call({
 BalloonFillLessonContent? content, BalloonFillStatus status, Set<int> filledIndexes, int? fillingIndex, String? colorLabelNp
});




}
/// @nodoc
class _$BalloonFillStateCopyWithImpl<$Res>
    implements $BalloonFillStateCopyWith<$Res> {
  _$BalloonFillStateCopyWithImpl(this._self, this._then);

  final BalloonFillState _self;
  final $Res Function(BalloonFillState) _then;

/// Create a copy of BalloonFillState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? status = null,Object? filledIndexes = null,Object? fillingIndex = freezed,Object? colorLabelNp = freezed,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as BalloonFillLessonContent?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BalloonFillStatus,filledIndexes: null == filledIndexes ? _self.filledIndexes : filledIndexes // ignore: cast_nullable_to_non_nullable
as Set<int>,fillingIndex: freezed == fillingIndex ? _self.fillingIndex : fillingIndex // ignore: cast_nullable_to_non_nullable
as int?,colorLabelNp: freezed == colorLabelNp ? _self.colorLabelNp : colorLabelNp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BalloonFillState].
extension BalloonFillStatePatterns on BalloonFillState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BalloonFillState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BalloonFillState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BalloonFillState value)  $default,){
final _that = this;
switch (_that) {
case _BalloonFillState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BalloonFillState value)?  $default,){
final _that = this;
switch (_that) {
case _BalloonFillState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BalloonFillLessonContent? content,  BalloonFillStatus status,  Set<int> filledIndexes,  int? fillingIndex,  String? colorLabelNp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BalloonFillState() when $default != null:
return $default(_that.content,_that.status,_that.filledIndexes,_that.fillingIndex,_that.colorLabelNp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BalloonFillLessonContent? content,  BalloonFillStatus status,  Set<int> filledIndexes,  int? fillingIndex,  String? colorLabelNp)  $default,) {final _that = this;
switch (_that) {
case _BalloonFillState():
return $default(_that.content,_that.status,_that.filledIndexes,_that.fillingIndex,_that.colorLabelNp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BalloonFillLessonContent? content,  BalloonFillStatus status,  Set<int> filledIndexes,  int? fillingIndex,  String? colorLabelNp)?  $default,) {final _that = this;
switch (_that) {
case _BalloonFillState() when $default != null:
return $default(_that.content,_that.status,_that.filledIndexes,_that.fillingIndex,_that.colorLabelNp);case _:
  return null;

}
}

}

/// @nodoc


class _BalloonFillState extends BalloonFillState {
  const _BalloonFillState({this.content, this.status = BalloonFillStatus.initial, final  Set<int> filledIndexes = const {}, this.fillingIndex, this.colorLabelNp}): _filledIndexes = filledIndexes,super._();
  

@override final  BalloonFillLessonContent? content;
@override@JsonKey() final  BalloonFillStatus status;
 final  Set<int> _filledIndexes;
@override@JsonKey() Set<int> get filledIndexes {
  if (_filledIndexes is EqualUnmodifiableSetView) return _filledIndexes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_filledIndexes);
}

@override final  int? fillingIndex;
// which balloon is currently animating
@override final  String? colorLabelNp;

/// Create a copy of BalloonFillState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BalloonFillStateCopyWith<_BalloonFillState> get copyWith => __$BalloonFillStateCopyWithImpl<_BalloonFillState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BalloonFillState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._filledIndexes, _filledIndexes)&&(identical(other.fillingIndex, fillingIndex) || other.fillingIndex == fillingIndex)&&(identical(other.colorLabelNp, colorLabelNp) || other.colorLabelNp == colorLabelNp));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),status,const DeepCollectionEquality().hash(_filledIndexes),fillingIndex,colorLabelNp);

@override
String toString() {
  return 'BalloonFillState(content: $content, status: $status, filledIndexes: $filledIndexes, fillingIndex: $fillingIndex, colorLabelNp: $colorLabelNp)';
}


}

/// @nodoc
abstract mixin class _$BalloonFillStateCopyWith<$Res> implements $BalloonFillStateCopyWith<$Res> {
  factory _$BalloonFillStateCopyWith(_BalloonFillState value, $Res Function(_BalloonFillState) _then) = __$BalloonFillStateCopyWithImpl;
@override @useResult
$Res call({
 BalloonFillLessonContent? content, BalloonFillStatus status, Set<int> filledIndexes, int? fillingIndex, String? colorLabelNp
});




}
/// @nodoc
class __$BalloonFillStateCopyWithImpl<$Res>
    implements _$BalloonFillStateCopyWith<$Res> {
  __$BalloonFillStateCopyWithImpl(this._self, this._then);

  final _BalloonFillState _self;
  final $Res Function(_BalloonFillState) _then;

/// Create a copy of BalloonFillState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? status = null,Object? filledIndexes = null,Object? fillingIndex = freezed,Object? colorLabelNp = freezed,}) {
  return _then(_BalloonFillState(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as BalloonFillLessonContent?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BalloonFillStatus,filledIndexes: null == filledIndexes ? _self._filledIndexes : filledIndexes // ignore: cast_nullable_to_non_nullable
as Set<int>,fillingIndex: freezed == fillingIndex ? _self.fillingIndex : fillingIndex // ignore: cast_nullable_to_non_nullable
as int?,colorLabelNp: freezed == colorLabelNp ? _self.colorLabelNp : colorLabelNp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
