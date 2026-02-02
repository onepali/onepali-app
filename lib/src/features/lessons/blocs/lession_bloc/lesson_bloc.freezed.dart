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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _NextContent value)?  nextContent,TResult Function( _PreviousContent value)?  previousContent,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _NextContent() when nextContent != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _NextContent value)  nextContent,required TResult Function( _PreviousContent value)  previousContent,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _NextContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _NextContent value)?  nextContent,TResult? Function( _PreviousContent value)?  previousContent,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _NextContent() when nextContent != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String lessonId)?  started,TResult Function()?  nextContent,TResult Function()?  previousContent,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.lessonId);case _NextContent() when nextContent != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String lessonId)  started,required TResult Function()  nextContent,required TResult Function()  previousContent,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.lessonId);case _NextContent():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String lessonId)?  started,TResult? Function()?  nextContent,TResult? Function()?  previousContent,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.lessonId);case _NextContent() when nextContent != null:
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

 LessonStatus get status; String? get lessonId; LessonDetail? get lessonDetails; int get currentIndex; LessonContent? get currentContent;
/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonStateCopyWith<LessonState> get copyWith => _$LessonStateCopyWithImpl<LessonState>(this as LessonState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonState&&(identical(other.status, status) || other.status == status)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonDetails, lessonDetails) || other.lessonDetails == lessonDetails)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.currentContent, currentContent) || other.currentContent == currentContent));
}


@override
int get hashCode => Object.hash(runtimeType,status,lessonId,lessonDetails,currentIndex,currentContent);

@override
String toString() {
  return 'LessonState(status: $status, lessonId: $lessonId, lessonDetails: $lessonDetails, currentIndex: $currentIndex, currentContent: $currentContent)';
}


}

/// @nodoc
abstract mixin class $LessonStateCopyWith<$Res>  {
  factory $LessonStateCopyWith(LessonState value, $Res Function(LessonState) _then) = _$LessonStateCopyWithImpl;
@useResult
$Res call({
 LessonStatus status, String? lessonId, LessonDetail? lessonDetails, int currentIndex, LessonContent? currentContent
});


$LessonContentCopyWith<$Res>? get currentContent;

}
/// @nodoc
class _$LessonStateCopyWithImpl<$Res>
    implements $LessonStateCopyWith<$Res> {
  _$LessonStateCopyWithImpl(this._self, this._then);

  final LessonState _self;
  final $Res Function(LessonState) _then;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? lessonId = freezed,Object? lessonDetails = freezed,Object? currentIndex = null,Object? currentContent = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LessonStatus,lessonId: freezed == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String?,lessonDetails: freezed == lessonDetails ? _self.lessonDetails : lessonDetails // ignore: cast_nullable_to_non_nullable
as LessonDetail?,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,currentContent: freezed == currentContent ? _self.currentContent : currentContent // ignore: cast_nullable_to_non_nullable
as LessonContent?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LessonStatus status,  String? lessonId,  LessonDetail? lessonDetails,  int currentIndex,  LessonContent? currentContent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonState() when $default != null:
return $default(_that.status,_that.lessonId,_that.lessonDetails,_that.currentIndex,_that.currentContent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LessonStatus status,  String? lessonId,  LessonDetail? lessonDetails,  int currentIndex,  LessonContent? currentContent)  $default,) {final _that = this;
switch (_that) {
case _LessonState():
return $default(_that.status,_that.lessonId,_that.lessonDetails,_that.currentIndex,_that.currentContent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LessonStatus status,  String? lessonId,  LessonDetail? lessonDetails,  int currentIndex,  LessonContent? currentContent)?  $default,) {final _that = this;
switch (_that) {
case _LessonState() when $default != null:
return $default(_that.status,_that.lessonId,_that.lessonDetails,_that.currentIndex,_that.currentContent);case _:
  return null;

}
}

}

/// @nodoc


class _LessonState implements LessonState {
  const _LessonState({this.status = LessonStatus.initial, this.lessonId, this.lessonDetails, this.currentIndex = 0, this.currentContent});
  

@override@JsonKey() final  LessonStatus status;
@override final  String? lessonId;
@override final  LessonDetail? lessonDetails;
@override@JsonKey() final  int currentIndex;
@override final  LessonContent? currentContent;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonStateCopyWith<_LessonState> get copyWith => __$LessonStateCopyWithImpl<_LessonState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonState&&(identical(other.status, status) || other.status == status)&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.lessonDetails, lessonDetails) || other.lessonDetails == lessonDetails)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.currentContent, currentContent) || other.currentContent == currentContent));
}


@override
int get hashCode => Object.hash(runtimeType,status,lessonId,lessonDetails,currentIndex,currentContent);

@override
String toString() {
  return 'LessonState(status: $status, lessonId: $lessonId, lessonDetails: $lessonDetails, currentIndex: $currentIndex, currentContent: $currentContent)';
}


}

/// @nodoc
abstract mixin class _$LessonStateCopyWith<$Res> implements $LessonStateCopyWith<$Res> {
  factory _$LessonStateCopyWith(_LessonState value, $Res Function(_LessonState) _then) = __$LessonStateCopyWithImpl;
@override @useResult
$Res call({
 LessonStatus status, String? lessonId, LessonDetail? lessonDetails, int currentIndex, LessonContent? currentContent
});


@override $LessonContentCopyWith<$Res>? get currentContent;

}
/// @nodoc
class __$LessonStateCopyWithImpl<$Res>
    implements _$LessonStateCopyWith<$Res> {
  __$LessonStateCopyWithImpl(this._self, this._then);

  final _LessonState _self;
  final $Res Function(_LessonState) _then;

/// Create a copy of LessonState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? lessonId = freezed,Object? lessonDetails = freezed,Object? currentIndex = null,Object? currentContent = freezed,}) {
  return _then(_LessonState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LessonStatus,lessonId: freezed == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String?,lessonDetails: freezed == lessonDetails ? _self.lessonDetails : lessonDetails // ignore: cast_nullable_to_non_nullable
as LessonDetail?,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,currentContent: freezed == currentContent ? _self.currentContent : currentContent // ignore: cast_nullable_to_non_nullable
as LessonContent?,
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
}
}

// dart format on
