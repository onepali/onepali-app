// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tap_to_fill_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TapToFillEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToFillEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TapToFillEvent()';
}


}

/// @nodoc
class $TapToFillEventCopyWith<$Res>  {
$TapToFillEventCopyWith(TapToFillEvent _, $Res Function(TapToFillEvent) __);
}


/// Adds pattern-matching-related methods to [TapToFillEvent].
extension TapToFillEventPatterns on TapToFillEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _AudioCompleted value)?  audioCompleted,TResult Function( _OptionTapped value)?  optionTapped,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that);case _OptionTapped() when optionTapped != null:
return optionTapped(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _AudioCompleted value)  audioCompleted,required TResult Function( _OptionTapped value)  optionTapped,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _AudioCompleted():
return audioCompleted(_that);case _OptionTapped():
return optionTapped(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _AudioCompleted value)?  audioCompleted,TResult? Function( _OptionTapped value)?  optionTapped,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AudioCompleted() when audioCompleted != null:
return audioCompleted(_that);case _OptionTapped() when optionTapped != null:
return optionTapped(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TapToFillLessonContent content)?  started,TResult Function()?  audioCompleted,TResult Function( Option option)?  optionTapped,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _AudioCompleted() when audioCompleted != null:
return audioCompleted();case _OptionTapped() when optionTapped != null:
return optionTapped(_that.option);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TapToFillLessonContent content)  started,required TResult Function()  audioCompleted,required TResult Function( Option option)  optionTapped,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.content);case _AudioCompleted():
return audioCompleted();case _OptionTapped():
return optionTapped(_that.option);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TapToFillLessonContent content)?  started,TResult? Function()?  audioCompleted,TResult? Function( Option option)?  optionTapped,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.content);case _AudioCompleted() when audioCompleted != null:
return audioCompleted();case _OptionTapped() when optionTapped != null:
return optionTapped(_that.option);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements TapToFillEvent {
  const _Started(this.content);


 final  TapToFillLessonContent content;

/// Create a copy of TapToFillEvent
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
  return 'TapToFillEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $TapToFillEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 TapToFillLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of TapToFillEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToFillLessonContent,
  ));
}


}

/// @nodoc


class _AudioCompleted implements TapToFillEvent {
  const _AudioCompleted();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TapToFillEvent.audioCompleted()';
}


}




/// @nodoc


class _OptionTapped implements TapToFillEvent {
  const _OptionTapped(this.option);


 final  Option option;

/// Create a copy of TapToFillEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptionTappedCopyWith<_OptionTapped> get copyWith => __$OptionTappedCopyWithImpl<_OptionTapped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptionTapped&&(identical(other.option, option) || other.option == option));
}


@override
int get hashCode => Object.hash(runtimeType,option);

@override
String toString() {
  return 'TapToFillEvent.optionTapped(option: $option)';
}


}

/// @nodoc
abstract mixin class _$OptionTappedCopyWith<$Res> implements $TapToFillEventCopyWith<$Res> {
  factory _$OptionTappedCopyWith(_OptionTapped value, $Res Function(_OptionTapped) _then) = __$OptionTappedCopyWithImpl;
@useResult
$Res call({
 Option option
});


$OptionCopyWith<$Res> get option;

}
/// @nodoc
class __$OptionTappedCopyWithImpl<$Res>
    implements _$OptionTappedCopyWith<$Res> {
  __$OptionTappedCopyWithImpl(this._self, this._then);

  final _OptionTapped _self;
  final $Res Function(_OptionTapped) _then;

/// Create a copy of TapToFillEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? option = null,}) {
  return _then(_OptionTapped(
null == option ? _self.option : option // ignore: cast_nullable_to_non_nullable
as Option,
  ));
}

/// Create a copy of TapToFillEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OptionCopyWith<$Res> get option {

  return $OptionCopyWith<$Res>(_self.option, (value) {
    return _then(_self.copyWith(option: value));
  });
}
}

/// @nodoc
mixin _$TapToFillState {

 TapToFillStatus get status; TapToFillLessonContent? get content;
/// Create a copy of TapToFillState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TapToFillStateCopyWith<TapToFillState> get copyWith => _$TapToFillStateCopyWithImpl<TapToFillState>(this as TapToFillState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToFillState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.content, content));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(content));

@override
String toString() {
  return 'TapToFillState(status: $status, content: $content)';
}


}

/// @nodoc
abstract mixin class $TapToFillStateCopyWith<$Res>  {
  factory $TapToFillStateCopyWith(TapToFillState value, $Res Function(TapToFillState) _then) = _$TapToFillStateCopyWithImpl;
@useResult
$Res call({
 TapToFillStatus status, TapToFillLessonContent? content
});




}
/// @nodoc
class _$TapToFillStateCopyWithImpl<$Res>
    implements $TapToFillStateCopyWith<$Res> {
  _$TapToFillStateCopyWithImpl(this._self, this._then);

  final TapToFillState _self;
  final $Res Function(TapToFillState) _then;

/// Create a copy of TapToFillState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? content = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TapToFillStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToFillLessonContent?,
  ));
}

}


/// Adds pattern-matching-related methods to [TapToFillState].
extension TapToFillStatePatterns on TapToFillState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TapToFillState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TapToFillState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TapToFillState value)  $default,){
final _that = this;
switch (_that) {
case _TapToFillState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TapToFillState value)?  $default,){
final _that = this;
switch (_that) {
case _TapToFillState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TapToFillStatus status,  TapToFillLessonContent? content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TapToFillState() when $default != null:
return $default(_that.status,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TapToFillStatus status,  TapToFillLessonContent? content)  $default,) {final _that = this;
switch (_that) {
case _TapToFillState():
return $default(_that.status,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TapToFillStatus status,  TapToFillLessonContent? content)?  $default,) {final _that = this;
switch (_that) {
case _TapToFillState() when $default != null:
return $default(_that.status,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _TapToFillState implements TapToFillState {
  const _TapToFillState({this.status = TapToFillStatus.initial, this.content});


@override@JsonKey() final  TapToFillStatus status;
@override final  TapToFillLessonContent? content;

/// Create a copy of TapToFillState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TapToFillStateCopyWith<_TapToFillState> get copyWith => __$TapToFillStateCopyWithImpl<_TapToFillState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TapToFillState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.content, content));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(content));

@override
String toString() {
  return 'TapToFillState(status: $status, content: $content)';
}


}

/// @nodoc
abstract mixin class _$TapToFillStateCopyWith<$Res> implements $TapToFillStateCopyWith<$Res> {
  factory _$TapToFillStateCopyWith(_TapToFillState value, $Res Function(_TapToFillState) _then) = __$TapToFillStateCopyWithImpl;
@override @useResult
$Res call({
 TapToFillStatus status, TapToFillLessonContent? content
});




}
/// @nodoc
class __$TapToFillStateCopyWithImpl<$Res>
    implements _$TapToFillStateCopyWith<$Res> {
  __$TapToFillStateCopyWithImpl(this._self, this._then);

  final _TapToFillState _self;
  final $Res Function(_TapToFillState) _then;

/// Create a copy of TapToFillState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? content = freezed,}) {
  return _then(_TapToFillState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TapToFillStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as TapToFillLessonContent?,
  ));
}


}

// dart format on
