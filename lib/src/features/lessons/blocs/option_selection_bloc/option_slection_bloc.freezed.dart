// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option_slection_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OptionSlectionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptionSlectionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OptionSlectionEvent()';
}


}

/// @nodoc
class $OptionSlectionEventCopyWith<$Res>  {
$OptionSlectionEventCopyWith(OptionSlectionEvent _, $Res Function(OptionSlectionEvent) __);
}


/// Adds pattern-matching-related methods to [OptionSlectionEvent].
extension OptionSlectionEventPatterns on OptionSlectionEvent {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( OptionSelectionLessonContent content)?  started,TResult Function()?  audioCompleted,TResult Function( Option option)?  optionTapped,required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( OptionSelectionLessonContent content)  started,required TResult Function()  audioCompleted,required TResult Function( Option option)  optionTapped,}) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( OptionSelectionLessonContent content)?  started,TResult? Function()?  audioCompleted,TResult? Function( Option option)?  optionTapped,}) {final _that = this;
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


class _Started implements OptionSlectionEvent {
  const _Started(this.content);


 final  OptionSelectionLessonContent content;

/// Create a copy of OptionSlectionEvent
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
  return 'OptionSlectionEvent.started(content: $content)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $OptionSlectionEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 OptionSelectionLessonContent content
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of OptionSlectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? content = freezed,}) {
  return _then(_Started(
freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as OptionSelectionLessonContent,
  ));
}


}

/// @nodoc


class _AudioCompleted implements OptionSlectionEvent {
  const _AudioCompleted();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioCompleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OptionSlectionEvent.audioCompleted()';
}


}




/// @nodoc


class _OptionTapped implements OptionSlectionEvent {
  const _OptionTapped(this.option);


 final  Option option;

/// Create a copy of OptionSlectionEvent
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
  return 'OptionSlectionEvent.optionTapped(option: $option)';
}


}

/// @nodoc
abstract mixin class _$OptionTappedCopyWith<$Res> implements $OptionSlectionEventCopyWith<$Res> {
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

/// Create a copy of OptionSlectionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? option = null,}) {
  return _then(_OptionTapped(
null == option ? _self.option : option // ignore: cast_nullable_to_non_nullable
as Option,
  ));
}

/// Create a copy of OptionSlectionEvent
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
mixin _$OptionSlectionState {

 OptionSelectionLessonContent? get content; OptionSelectionStatus get status;
/// Create a copy of OptionSlectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionSlectionStateCopyWith<OptionSlectionState> get copyWith => _$OptionSlectionStateCopyWithImpl<OptionSlectionState>(this as OptionSlectionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptionSlectionState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),status);

@override
String toString() {
  return 'OptionSlectionState(content: $content, status: $status)';
}


}

/// @nodoc
abstract mixin class $OptionSlectionStateCopyWith<$Res>  {
  factory $OptionSlectionStateCopyWith(OptionSlectionState value, $Res Function(OptionSlectionState) _then) = _$OptionSlectionStateCopyWithImpl;
@useResult
$Res call({
 OptionSelectionLessonContent? content, OptionSelectionStatus status
});




}
/// @nodoc
class _$OptionSlectionStateCopyWithImpl<$Res>
    implements $OptionSlectionStateCopyWith<$Res> {
  _$OptionSlectionStateCopyWithImpl(this._self, this._then);

  final OptionSlectionState _self;
  final $Res Function(OptionSlectionState) _then;

/// Create a copy of OptionSlectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as OptionSelectionLessonContent?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OptionSelectionStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [OptionSlectionState].
extension OptionSlectionStatePatterns on OptionSlectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OptionSlectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OptionSlectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OptionSlectionState value)  $default,){
final _that = this;
switch (_that) {
case _OptionSlectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OptionSlectionState value)?  $default,){
final _that = this;
switch (_that) {
case _OptionSlectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OptionSelectionLessonContent? content,  OptionSelectionStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OptionSlectionState() when $default != null:
return $default(_that.content,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OptionSelectionLessonContent? content,  OptionSelectionStatus status)  $default,) {final _that = this;
switch (_that) {
case _OptionSlectionState():
return $default(_that.content,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OptionSelectionLessonContent? content,  OptionSelectionStatus status)?  $default,) {final _that = this;
switch (_that) {
case _OptionSlectionState() when $default != null:
return $default(_that.content,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _OptionSlectionState implements OptionSlectionState {
  const _OptionSlectionState({this.content, this.status = OptionSelectionStatus.initial});


@override final  OptionSelectionLessonContent? content;
@override@JsonKey() final  OptionSelectionStatus status;

/// Create a copy of OptionSlectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptionSlectionStateCopyWith<_OptionSlectionState> get copyWith => __$OptionSlectionStateCopyWithImpl<_OptionSlectionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptionSlectionState&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(content),status);

@override
String toString() {
  return 'OptionSlectionState(content: $content, status: $status)';
}


}

/// @nodoc
abstract mixin class _$OptionSlectionStateCopyWith<$Res> implements $OptionSlectionStateCopyWith<$Res> {
  factory _$OptionSlectionStateCopyWith(_OptionSlectionState value, $Res Function(_OptionSlectionState) _then) = __$OptionSlectionStateCopyWithImpl;
@override @useResult
$Res call({
 OptionSelectionLessonContent? content, OptionSelectionStatus status
});




}
/// @nodoc
class __$OptionSlectionStateCopyWithImpl<$Res>
    implements _$OptionSlectionStateCopyWith<$Res> {
  __$OptionSlectionStateCopyWithImpl(this._self, this._then);

  final _OptionSlectionState _self;
  final $Res Function(_OptionSlectionState) _then;

/// Create a copy of OptionSlectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? status = null,}) {
  return _then(_OptionSlectionState(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as OptionSelectionLessonContent?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OptionSelectionStatus,
  ));
}


}

// dart format on
