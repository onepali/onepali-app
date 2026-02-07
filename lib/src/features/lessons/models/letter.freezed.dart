// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Letter {

 String get letter; String get name; num get width; num get height; String get viewBox; List<LetterStroke> get strokes;
/// Create a copy of Letter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LetterCopyWith<Letter> get copyWith => _$LetterCopyWithImpl<Letter>(this as Letter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Letter&&(identical(other.letter, letter) || other.letter == letter)&&(identical(other.name, name) || other.name == name)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.viewBox, viewBox) || other.viewBox == viewBox)&&const DeepCollectionEquality().equals(other.strokes, strokes));
}


@override
int get hashCode => Object.hash(runtimeType,letter,name,width,height,viewBox,const DeepCollectionEquality().hash(strokes));

@override
String toString() {
  return 'Letter(letter: $letter, name: $name, width: $width, height: $height, viewBox: $viewBox, strokes: $strokes)';
}


}

/// @nodoc
abstract mixin class $LetterCopyWith<$Res>  {
  factory $LetterCopyWith(Letter value, $Res Function(Letter) _then) = _$LetterCopyWithImpl;
@useResult
$Res call({
 String letter, String name, num width, num height, String viewBox, List<LetterStroke> strokes
});




}
/// @nodoc
class _$LetterCopyWithImpl<$Res>
    implements $LetterCopyWith<$Res> {
  _$LetterCopyWithImpl(this._self, this._then);

  final Letter _self;
  final $Res Function(Letter) _then;

/// Create a copy of Letter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? letter = null,Object? name = null,Object? width = null,Object? height = null,Object? viewBox = null,Object? strokes = null,}) {
  return _then(_self.copyWith(
letter: null == letter ? _self.letter : letter // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as num,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as num,viewBox: null == viewBox ? _self.viewBox : viewBox // ignore: cast_nullable_to_non_nullable
as String,strokes: null == strokes ? _self.strokes : strokes // ignore: cast_nullable_to_non_nullable
as List<LetterStroke>,
  ));
}

}


/// Adds pattern-matching-related methods to [Letter].
extension LetterPatterns on Letter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Letter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Letter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Letter value)  $default,){
final _that = this;
switch (_that) {
case _Letter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Letter value)?  $default,){
final _that = this;
switch (_that) {
case _Letter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String letter,  String name,  num width,  num height,  String viewBox,  List<LetterStroke> strokes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Letter() when $default != null:
return $default(_that.letter,_that.name,_that.width,_that.height,_that.viewBox,_that.strokes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String letter,  String name,  num width,  num height,  String viewBox,  List<LetterStroke> strokes)  $default,) {final _that = this;
switch (_that) {
case _Letter():
return $default(_that.letter,_that.name,_that.width,_that.height,_that.viewBox,_that.strokes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String letter,  String name,  num width,  num height,  String viewBox,  List<LetterStroke> strokes)?  $default,) {final _that = this;
switch (_that) {
case _Letter() when $default != null:
return $default(_that.letter,_that.name,_that.width,_that.height,_that.viewBox,_that.strokes);case _:
  return null;

}
}

}

/// @nodoc


class _Letter extends Letter {
  const _Letter({required this.letter, required this.name, required this.width, required this.height, required this.viewBox, required final  List<LetterStroke> strokes}): _strokes = strokes,super._();
  

@override final  String letter;
@override final  String name;
@override final  num width;
@override final  num height;
@override final  String viewBox;
 final  List<LetterStroke> _strokes;
@override List<LetterStroke> get strokes {
  if (_strokes is EqualUnmodifiableListView) return _strokes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strokes);
}


/// Create a copy of Letter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LetterCopyWith<_Letter> get copyWith => __$LetterCopyWithImpl<_Letter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Letter&&(identical(other.letter, letter) || other.letter == letter)&&(identical(other.name, name) || other.name == name)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.viewBox, viewBox) || other.viewBox == viewBox)&&const DeepCollectionEquality().equals(other._strokes, _strokes));
}


@override
int get hashCode => Object.hash(runtimeType,letter,name,width,height,viewBox,const DeepCollectionEquality().hash(_strokes));

@override
String toString() {
  return 'Letter(letter: $letter, name: $name, width: $width, height: $height, viewBox: $viewBox, strokes: $strokes)';
}


}

/// @nodoc
abstract mixin class _$LetterCopyWith<$Res> implements $LetterCopyWith<$Res> {
  factory _$LetterCopyWith(_Letter value, $Res Function(_Letter) _then) = __$LetterCopyWithImpl;
@override @useResult
$Res call({
 String letter, String name, num width, num height, String viewBox, List<LetterStroke> strokes
});




}
/// @nodoc
class __$LetterCopyWithImpl<$Res>
    implements _$LetterCopyWith<$Res> {
  __$LetterCopyWithImpl(this._self, this._then);

  final _Letter _self;
  final $Res Function(_Letter) _then;

/// Create a copy of Letter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? letter = null,Object? name = null,Object? width = null,Object? height = null,Object? viewBox = null,Object? strokes = null,}) {
  return _then(_Letter(
letter: null == letter ? _self.letter : letter // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as num,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as num,viewBox: null == viewBox ? _self.viewBox : viewBox // ignore: cast_nullable_to_non_nullable
as String,strokes: null == strokes ? _self._strokes : strokes // ignore: cast_nullable_to_non_nullable
as List<LetterStroke>,
  ));
}


}

/// @nodoc
mixin _$LetterStroke {

 String get name; String get path; String get instruction; int? get order; String? get color;
/// Create a copy of LetterStroke
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LetterStrokeCopyWith<LetterStroke> get copyWith => _$LetterStrokeCopyWithImpl<LetterStroke>(this as LetterStroke, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LetterStroke&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.order, order) || other.order == order)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,name,path,instruction,order,color);

@override
String toString() {
  return 'LetterStroke(name: $name, path: $path, instruction: $instruction, order: $order, color: $color)';
}


}

/// @nodoc
abstract mixin class $LetterStrokeCopyWith<$Res>  {
  factory $LetterStrokeCopyWith(LetterStroke value, $Res Function(LetterStroke) _then) = _$LetterStrokeCopyWithImpl;
@useResult
$Res call({
 String name, String path, String instruction, int? order, String? color
});




}
/// @nodoc
class _$LetterStrokeCopyWithImpl<$Res>
    implements $LetterStrokeCopyWith<$Res> {
  _$LetterStrokeCopyWithImpl(this._self, this._then);

  final LetterStroke _self;
  final $Res Function(LetterStroke) _then;

/// Create a copy of LetterStroke
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? path = null,Object? instruction = null,Object? order = freezed,Object? color = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LetterStroke].
extension LetterStrokePatterns on LetterStroke {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LetterStroke value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LetterStroke() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LetterStroke value)  $default,){
final _that = this;
switch (_that) {
case _LetterStroke():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LetterStroke value)?  $default,){
final _that = this;
switch (_that) {
case _LetterStroke() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String path,  String instruction,  int? order,  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LetterStroke() when $default != null:
return $default(_that.name,_that.path,_that.instruction,_that.order,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String path,  String instruction,  int? order,  String? color)  $default,) {final _that = this;
switch (_that) {
case _LetterStroke():
return $default(_that.name,_that.path,_that.instruction,_that.order,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String path,  String instruction,  int? order,  String? color)?  $default,) {final _that = this;
switch (_that) {
case _LetterStroke() when $default != null:
return $default(_that.name,_that.path,_that.instruction,_that.order,_that.color);case _:
  return null;

}
}

}

/// @nodoc


class _LetterStroke implements LetterStroke {
  const _LetterStroke({required this.name, required this.path, required this.instruction, this.order, this.color});
  

@override final  String name;
@override final  String path;
@override final  String instruction;
@override final  int? order;
@override final  String? color;

/// Create a copy of LetterStroke
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LetterStrokeCopyWith<_LetterStroke> get copyWith => __$LetterStrokeCopyWithImpl<_LetterStroke>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LetterStroke&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.order, order) || other.order == order)&&(identical(other.color, color) || other.color == color));
}


@override
int get hashCode => Object.hash(runtimeType,name,path,instruction,order,color);

@override
String toString() {
  return 'LetterStroke(name: $name, path: $path, instruction: $instruction, order: $order, color: $color)';
}


}

/// @nodoc
abstract mixin class _$LetterStrokeCopyWith<$Res> implements $LetterStrokeCopyWith<$Res> {
  factory _$LetterStrokeCopyWith(_LetterStroke value, $Res Function(_LetterStroke) _then) = __$LetterStrokeCopyWithImpl;
@override @useResult
$Res call({
 String name, String path, String instruction, int? order, String? color
});




}
/// @nodoc
class __$LetterStrokeCopyWithImpl<$Res>
    implements _$LetterStrokeCopyWith<$Res> {
  __$LetterStrokeCopyWithImpl(this._self, this._then);

  final _LetterStroke _self;
  final $Res Function(_LetterStroke) _then;

/// Create a copy of LetterStroke
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? path = null,Object? instruction = null,Object? order = freezed,Object? color = freezed,}) {
  return _then(_LetterStroke(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
