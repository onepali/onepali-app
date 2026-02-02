// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lesson {

 String get id; String get name; String get image;
/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCopyWith<Lesson> get copyWith => _$LessonCopyWithImpl<Lesson>(this as Lesson, _$identity);

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image);

@override
String toString() {
  return 'Lesson(id: $id, name: $name, image: $image)';
}


}

/// @nodoc
abstract mixin class $LessonCopyWith<$Res>  {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) _then) = _$LessonCopyWithImpl;
@useResult
$Res call({
 String id, String name, String image
});




}
/// @nodoc
class _$LessonCopyWithImpl<$Res>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._self, this._then);

  final Lesson _self;
  final $Res Function(Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? image = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Lesson].
extension LessonPatterns on Lesson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lesson value)  $default,){
final _that = this;
switch (_that) {
case _Lesson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lesson value)?  $default,){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.name,_that.image);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String image)  $default,) {final _that = this;
switch (_that) {
case _Lesson():
return $default(_that.id,_that.name,_that.image);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String image)?  $default,) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.name,_that.image);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lesson implements Lesson {
  const _Lesson({required this.id, required this.name, required this.image});
  factory _Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

@override final  String id;
@override final  String name;
@override final  String image;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonCopyWith<_Lesson> get copyWith => __$LessonCopyWithImpl<_Lesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image);

@override
String toString() {
  return 'Lesson(id: $id, name: $name, image: $image)';
}


}

/// @nodoc
abstract mixin class _$LessonCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$LessonCopyWith(_Lesson value, $Res Function(_Lesson) _then) = __$LessonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String image
});




}
/// @nodoc
class __$LessonCopyWithImpl<$Res>
    implements _$LessonCopyWith<$Res> {
  __$LessonCopyWithImpl(this._self, this._then);

  final _Lesson _self;
  final $Res Function(_Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? image = null,}) {
  return _then(_Lesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

LessonContent _$LessonContentFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'intro':
          return IntroLessonContent.fromJson(
            json
          );
                case 'info':
          return InfoLessonContent.fromJson(
            json
          );
                case 'choose_correct':
          return ChooseCorrectLessonContent.fromJson(
            json
          );
                case 'tap_to_reveal':
          return TapToRevealLessonContent.fromJson(
            json
          );
                case 'drag_to_match':
          return DragToMatchLessonContent.fromJson(
            json
          );
                case 'unknown':
          return UnknownLessonContent.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'LessonContent',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$LessonContent {

 String get id; int get index; String get type;
/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonContentCopyWith<LessonContent> get copyWith => _$LessonContentCopyWithImpl<LessonContent>(this as LessonContent, _$identity);

  /// Serializes this LessonContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type);

@override
String toString() {
  return 'LessonContent(id: $id, index: $index, type: $type)';
}


}

/// @nodoc
abstract mixin class $LessonContentCopyWith<$Res>  {
  factory $LessonContentCopyWith(LessonContent value, $Res Function(LessonContent) _then) = _$LessonContentCopyWithImpl;
@useResult
$Res call({
 String id, int index, String type
});




}
/// @nodoc
class _$LessonContentCopyWithImpl<$Res>
    implements $LessonContentCopyWith<$Res> {
  _$LessonContentCopyWithImpl(this._self, this._then);

  final LessonContent _self;
  final $Res Function(LessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? index = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonContent].
extension LessonContentPatterns on LessonContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( IntroLessonContent value)?  intro,TResult Function( InfoLessonContent value)?  info,TResult Function( ChooseCorrectLessonContent value)?  chooseCorrect,TResult Function( TapToRevealLessonContent value)?  tapToReveal,TResult Function( DragToMatchLessonContent value)?  dragToMatch,TResult Function( UnknownLessonContent value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case IntroLessonContent() when intro != null:
return intro(_that);case InfoLessonContent() when info != null:
return info(_that);case ChooseCorrectLessonContent() when chooseCorrect != null:
return chooseCorrect(_that);case TapToRevealLessonContent() when tapToReveal != null:
return tapToReveal(_that);case DragToMatchLessonContent() when dragToMatch != null:
return dragToMatch(_that);case UnknownLessonContent() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( IntroLessonContent value)  intro,required TResult Function( InfoLessonContent value)  info,required TResult Function( ChooseCorrectLessonContent value)  chooseCorrect,required TResult Function( TapToRevealLessonContent value)  tapToReveal,required TResult Function( DragToMatchLessonContent value)  dragToMatch,required TResult Function( UnknownLessonContent value)  unknown,}){
final _that = this;
switch (_that) {
case IntroLessonContent():
return intro(_that);case InfoLessonContent():
return info(_that);case ChooseCorrectLessonContent():
return chooseCorrect(_that);case TapToRevealLessonContent():
return tapToReveal(_that);case DragToMatchLessonContent():
return dragToMatch(_that);case UnknownLessonContent():
return unknown(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( IntroLessonContent value)?  intro,TResult? Function( InfoLessonContent value)?  info,TResult? Function( ChooseCorrectLessonContent value)?  chooseCorrect,TResult? Function( TapToRevealLessonContent value)?  tapToReveal,TResult? Function( DragToMatchLessonContent value)?  dragToMatch,TResult? Function( UnknownLessonContent value)?  unknown,}){
final _that = this;
switch (_that) {
case IntroLessonContent() when intro != null:
return intro(_that);case InfoLessonContent() when info != null:
return info(_that);case ChooseCorrectLessonContent() when chooseCorrect != null:
return chooseCorrect(_that);case TapToRevealLessonContent() when tapToReveal != null:
return tapToReveal(_that);case DragToMatchLessonContent() when dragToMatch != null:
return dragToMatch(_that);case UnknownLessonContent() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  int index,  String type,  String? bgColor,  String? image,  String? audio)?  intro,TResult Function( String id,  int index,  String type,  String nameEn,  String nameNp,  String audioWord,  String? audioBg,  String image,  String? video,  String? bgImageColor)?  info,TResult Function( String id,  int index,  String type,  List<Item> items)?  chooseCorrect,TResult Function( String id,  int index,  String? bgImage,  String type,  List<Item> items)?  tapToReveal,TResult Function( String id,  int index,  String type,  List<Item> items)?  dragToMatch,TResult Function( String id,  int index,  String type)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case IntroLessonContent() when intro != null:
return intro(_that.id,_that.index,_that.type,_that.bgColor,_that.image,_that.audio);case InfoLessonContent() when info != null:
return info(_that.id,_that.index,_that.type,_that.nameEn,_that.nameNp,_that.audioWord,_that.audioBg,_that.image,_that.video,_that.bgImageColor);case ChooseCorrectLessonContent() when chooseCorrect != null:
return chooseCorrect(_that.id,_that.index,_that.type,_that.items);case TapToRevealLessonContent() when tapToReveal != null:
return tapToReveal(_that.id,_that.index,_that.bgImage,_that.type,_that.items);case DragToMatchLessonContent() when dragToMatch != null:
return dragToMatch(_that.id,_that.index,_that.type,_that.items);case UnknownLessonContent() when unknown != null:
return unknown(_that.id,_that.index,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  int index,  String type,  String? bgColor,  String? image,  String? audio)  intro,required TResult Function( String id,  int index,  String type,  String nameEn,  String nameNp,  String audioWord,  String? audioBg,  String image,  String? video,  String? bgImageColor)  info,required TResult Function( String id,  int index,  String type,  List<Item> items)  chooseCorrect,required TResult Function( String id,  int index,  String? bgImage,  String type,  List<Item> items)  tapToReveal,required TResult Function( String id,  int index,  String type,  List<Item> items)  dragToMatch,required TResult Function( String id,  int index,  String type)  unknown,}) {final _that = this;
switch (_that) {
case IntroLessonContent():
return intro(_that.id,_that.index,_that.type,_that.bgColor,_that.image,_that.audio);case InfoLessonContent():
return info(_that.id,_that.index,_that.type,_that.nameEn,_that.nameNp,_that.audioWord,_that.audioBg,_that.image,_that.video,_that.bgImageColor);case ChooseCorrectLessonContent():
return chooseCorrect(_that.id,_that.index,_that.type,_that.items);case TapToRevealLessonContent():
return tapToReveal(_that.id,_that.index,_that.bgImage,_that.type,_that.items);case DragToMatchLessonContent():
return dragToMatch(_that.id,_that.index,_that.type,_that.items);case UnknownLessonContent():
return unknown(_that.id,_that.index,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  int index,  String type,  String? bgColor,  String? image,  String? audio)?  intro,TResult? Function( String id,  int index,  String type,  String nameEn,  String nameNp,  String audioWord,  String? audioBg,  String image,  String? video,  String? bgImageColor)?  info,TResult? Function( String id,  int index,  String type,  List<Item> items)?  chooseCorrect,TResult? Function( String id,  int index,  String? bgImage,  String type,  List<Item> items)?  tapToReveal,TResult? Function( String id,  int index,  String type,  List<Item> items)?  dragToMatch,TResult? Function( String id,  int index,  String type)?  unknown,}) {final _that = this;
switch (_that) {
case IntroLessonContent() when intro != null:
return intro(_that.id,_that.index,_that.type,_that.bgColor,_that.image,_that.audio);case InfoLessonContent() when info != null:
return info(_that.id,_that.index,_that.type,_that.nameEn,_that.nameNp,_that.audioWord,_that.audioBg,_that.image,_that.video,_that.bgImageColor);case ChooseCorrectLessonContent() when chooseCorrect != null:
return chooseCorrect(_that.id,_that.index,_that.type,_that.items);case TapToRevealLessonContent() when tapToReveal != null:
return tapToReveal(_that.id,_that.index,_that.bgImage,_that.type,_that.items);case DragToMatchLessonContent() when dragToMatch != null:
return dragToMatch(_that.id,_that.index,_that.type,_that.items);case UnknownLessonContent() when unknown != null:
return unknown(_that.id,_that.index,_that.type);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class IntroLessonContent implements LessonContent {
  const IntroLessonContent({required this.id, required this.index, this.type = 'intro', this.bgColor, this.image, this.audio});
  factory IntroLessonContent.fromJson(Map<String, dynamic> json) => _$IntroLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  String? bgColor;
 final  String? image;
 final  String? audio;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntroLessonContentCopyWith<IntroLessonContent> get copyWith => _$IntroLessonContentCopyWithImpl<IntroLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntroLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntroLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.image, image) || other.image == image)&&(identical(other.audio, audio) || other.audio == audio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type,bgColor,image,audio);

@override
String toString() {
  return 'LessonContent.intro(id: $id, index: $index, type: $type, bgColor: $bgColor, image: $image, audio: $audio)';
}


}

/// @nodoc
abstract mixin class $IntroLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $IntroLessonContentCopyWith(IntroLessonContent value, $Res Function(IntroLessonContent) _then) = _$IntroLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, String? bgColor, String? image, String? audio
});




}
/// @nodoc
class _$IntroLessonContentCopyWithImpl<$Res>
    implements $IntroLessonContentCopyWith<$Res> {
  _$IntroLessonContentCopyWithImpl(this._self, this._then);

  final IntroLessonContent _self;
  final $Res Function(IntroLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? bgColor = freezed,Object? image = freezed,Object? audio = freezed,}) {
  return _then(IntroLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,audio: freezed == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class InfoLessonContent implements LessonContent {
  const InfoLessonContent({required this.id, required this.index, this.type = 'info', required this.nameEn, required this.nameNp, required this.audioWord, this.audioBg, required this.image, this.video, this.bgImageColor});
  factory InfoLessonContent.fromJson(Map<String, dynamic> json) => _$InfoLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  String nameEn;
 final  String nameNp;
 final  String audioWord;
 final  String? audioBg;
 final  String image;
 final  String? video;
 final  String? bgImageColor;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfoLessonContentCopyWith<InfoLessonContent> get copyWith => _$InfoLessonContentCopyWithImpl<InfoLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InfoLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InfoLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.audioWord, audioWord) || other.audioWord == audioWord)&&(identical(other.audioBg, audioBg) || other.audioBg == audioBg)&&(identical(other.image, image) || other.image == image)&&(identical(other.video, video) || other.video == video)&&(identical(other.bgImageColor, bgImageColor) || other.bgImageColor == bgImageColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type,nameEn,nameNp,audioWord,audioBg,image,video,bgImageColor);

@override
String toString() {
  return 'LessonContent.info(id: $id, index: $index, type: $type, nameEn: $nameEn, nameNp: $nameNp, audioWord: $audioWord, audioBg: $audioBg, image: $image, video: $video, bgImageColor: $bgImageColor)';
}


}

/// @nodoc
abstract mixin class $InfoLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $InfoLessonContentCopyWith(InfoLessonContent value, $Res Function(InfoLessonContent) _then) = _$InfoLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, String nameEn, String nameNp, String audioWord, String? audioBg, String image, String? video, String? bgImageColor
});




}
/// @nodoc
class _$InfoLessonContentCopyWithImpl<$Res>
    implements $InfoLessonContentCopyWith<$Res> {
  _$InfoLessonContentCopyWithImpl(this._self, this._then);

  final InfoLessonContent _self;
  final $Res Function(InfoLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? nameEn = null,Object? nameNp = null,Object? audioWord = null,Object? audioBg = freezed,Object? image = null,Object? video = freezed,Object? bgImageColor = freezed,}) {
  return _then(InfoLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,audioWord: null == audioWord ? _self.audioWord : audioWord // ignore: cast_nullable_to_non_nullable
as String,audioBg: freezed == audioBg ? _self.audioBg : audioBg // ignore: cast_nullable_to_non_nullable
as String?,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as String?,bgImageColor: freezed == bgImageColor ? _self.bgImageColor : bgImageColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ChooseCorrectLessonContent implements LessonContent {
  const ChooseCorrectLessonContent({required this.id, required this.index, this.type = 'choose_correct', final  List<Item> items = const []}): _items = items;
  factory ChooseCorrectLessonContent.fromJson(Map<String, dynamic> json) => _$ChooseCorrectLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  List<Item> _items;
@JsonKey() List<Item> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChooseCorrectLessonContentCopyWith<ChooseCorrectLessonContent> get copyWith => _$ChooseCorrectLessonContentCopyWithImpl<ChooseCorrectLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChooseCorrectLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChooseCorrectLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'LessonContent.chooseCorrect(id: $id, index: $index, type: $type, items: $items)';
}


}

/// @nodoc
abstract mixin class $ChooseCorrectLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $ChooseCorrectLessonContentCopyWith(ChooseCorrectLessonContent value, $Res Function(ChooseCorrectLessonContent) _then) = _$ChooseCorrectLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, List<Item> items
});




}
/// @nodoc
class _$ChooseCorrectLessonContentCopyWithImpl<$Res>
    implements $ChooseCorrectLessonContentCopyWith<$Res> {
  _$ChooseCorrectLessonContentCopyWithImpl(this._self, this._then);

  final ChooseCorrectLessonContent _self;
  final $Res Function(ChooseCorrectLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? items = null,}) {
  return _then(ChooseCorrectLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TapToRevealLessonContent implements LessonContent {
  const TapToRevealLessonContent({required this.id, required this.index, this.bgImage, this.type = 'tap_to_reveal', final  List<Item> items = const []}): _items = items;
  factory TapToRevealLessonContent.fromJson(Map<String, dynamic> json) => _$TapToRevealLessonContentFromJson(json);

@override final  String id;
@override final  int index;
 final  String? bgImage;
@override@JsonKey() final  String type;
 final  List<Item> _items;
@JsonKey() List<Item> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TapToRevealLessonContentCopyWith<TapToRevealLessonContent> get copyWith => _$TapToRevealLessonContentCopyWithImpl<TapToRevealLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TapToRevealLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToRevealLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,bgImage,type,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'LessonContent.tapToReveal(id: $id, index: $index, bgImage: $bgImage, type: $type, items: $items)';
}


}

/// @nodoc
abstract mixin class $TapToRevealLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $TapToRevealLessonContentCopyWith(TapToRevealLessonContent value, $Res Function(TapToRevealLessonContent) _then) = _$TapToRevealLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String? bgImage, String type, List<Item> items
});




}
/// @nodoc
class _$TapToRevealLessonContentCopyWithImpl<$Res>
    implements $TapToRevealLessonContentCopyWith<$Res> {
  _$TapToRevealLessonContentCopyWithImpl(this._self, this._then);

  final TapToRevealLessonContent _self;
  final $Res Function(TapToRevealLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? bgImage = freezed,Object? type = null,Object? items = null,}) {
  return _then(TapToRevealLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class DragToMatchLessonContent implements LessonContent {
  const DragToMatchLessonContent({required this.id, required this.index, this.type = 'drag_to_match', final  List<Item> items = const []}): _items = items;
  factory DragToMatchLessonContent.fromJson(Map<String, dynamic> json) => _$DragToMatchLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  List<Item> _items;
@JsonKey() List<Item> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DragToMatchLessonContentCopyWith<DragToMatchLessonContent> get copyWith => _$DragToMatchLessonContentCopyWithImpl<DragToMatchLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DragToMatchLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DragToMatchLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'LessonContent.dragToMatch(id: $id, index: $index, type: $type, items: $items)';
}


}

/// @nodoc
abstract mixin class $DragToMatchLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $DragToMatchLessonContentCopyWith(DragToMatchLessonContent value, $Res Function(DragToMatchLessonContent) _then) = _$DragToMatchLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, List<Item> items
});




}
/// @nodoc
class _$DragToMatchLessonContentCopyWithImpl<$Res>
    implements $DragToMatchLessonContentCopyWith<$Res> {
  _$DragToMatchLessonContentCopyWithImpl(this._self, this._then);

  final DragToMatchLessonContent _self;
  final $Res Function(DragToMatchLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? items = null,}) {
  return _then(DragToMatchLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UnknownLessonContent implements LessonContent {
  const UnknownLessonContent({this.id = '', this.index = -1, this.type = 'unknown'});
  factory UnknownLessonContent.fromJson(Map<String, dynamic> json) => _$UnknownLessonContentFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  int index;
@override@JsonKey() final  String type;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownLessonContentCopyWith<UnknownLessonContent> get copyWith => _$UnknownLessonContentCopyWithImpl<UnknownLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnknownLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type);

@override
String toString() {
  return 'LessonContent.unknown(id: $id, index: $index, type: $type)';
}


}

/// @nodoc
abstract mixin class $UnknownLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $UnknownLessonContentCopyWith(UnknownLessonContent value, $Res Function(UnknownLessonContent) _then) = _$UnknownLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type
});




}
/// @nodoc
class _$UnknownLessonContentCopyWithImpl<$Res>
    implements $UnknownLessonContentCopyWith<$Res> {
  _$UnknownLessonContentCopyWithImpl(this._self, this._then);

  final UnknownLessonContent _self;
  final $Res Function(UnknownLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,}) {
  return _then(UnknownLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Item {

 String get nameEn; String get nameNp; String get image; String? get imageOutline; String? get question;// eg where is the cat
 String get audioItem;// Cat pronunciation
 String? get audioBg;// eg cat sound meww, dog sound barking
 num? get dxRatio; num? get dyRatio;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageOutline, imageOutline) || other.imageOutline == imageOutline)&&(identical(other.question, question) || other.question == question)&&(identical(other.audioItem, audioItem) || other.audioItem == audioItem)&&(identical(other.audioBg, audioBg) || other.audioBg == audioBg)&&(identical(other.dxRatio, dxRatio) || other.dxRatio == dxRatio)&&(identical(other.dyRatio, dyRatio) || other.dyRatio == dyRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nameEn,nameNp,image,imageOutline,question,audioItem,audioBg,dxRatio,dyRatio);

@override
String toString() {
  return 'Item(nameEn: $nameEn, nameNp: $nameNp, image: $image, imageOutline: $imageOutline, question: $question, audioItem: $audioItem, audioBg: $audioBg, dxRatio: $dxRatio, dyRatio: $dyRatio)';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 String nameEn, String nameNp, String image, String? imageOutline, String? question, String audioItem, String? audioBg, num? dxRatio, num? dyRatio
});




}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nameEn = null,Object? nameNp = null,Object? image = null,Object? imageOutline = freezed,Object? question = freezed,Object? audioItem = null,Object? audioBg = freezed,Object? dxRatio = freezed,Object? dyRatio = freezed,}) {
  return _then(_self.copyWith(
nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,imageOutline: freezed == imageOutline ? _self.imageOutline : imageOutline // ignore: cast_nullable_to_non_nullable
as String?,question: freezed == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String?,audioItem: null == audioItem ? _self.audioItem : audioItem // ignore: cast_nullable_to_non_nullable
as String,audioBg: freezed == audioBg ? _self.audioBg : audioBg // ignore: cast_nullable_to_non_nullable
as String?,dxRatio: freezed == dxRatio ? _self.dxRatio : dxRatio // ignore: cast_nullable_to_non_nullable
as num?,dyRatio: freezed == dyRatio ? _self.dyRatio : dyRatio // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [Item].
extension ItemPatterns on Item {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Item value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Item value)  $default,){
final _that = this;
switch (_that) {
case _Item():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Item value)?  $default,){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nameEn,  String nameNp,  String image,  String? imageOutline,  String? question,  String audioItem,  String? audioBg,  num? dxRatio,  num? dyRatio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.nameEn,_that.nameNp,_that.image,_that.imageOutline,_that.question,_that.audioItem,_that.audioBg,_that.dxRatio,_that.dyRatio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nameEn,  String nameNp,  String image,  String? imageOutline,  String? question,  String audioItem,  String? audioBg,  num? dxRatio,  num? dyRatio)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.nameEn,_that.nameNp,_that.image,_that.imageOutline,_that.question,_that.audioItem,_that.audioBg,_that.dxRatio,_that.dyRatio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nameEn,  String nameNp,  String image,  String? imageOutline,  String? question,  String audioItem,  String? audioBg,  num? dxRatio,  num? dyRatio)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.nameEn,_that.nameNp,_that.image,_that.imageOutline,_that.question,_that.audioItem,_that.audioBg,_that.dxRatio,_that.dyRatio);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Item implements Item {
  const _Item({required this.nameEn, required this.nameNp, required this.image, this.imageOutline, this.question, required this.audioItem, this.audioBg, this.dxRatio, this.dyRatio});
  factory _Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

@override final  String nameEn;
@override final  String nameNp;
@override final  String image;
@override final  String? imageOutline;
@override final  String? question;
// eg where is the cat
@override final  String audioItem;
// Cat pronunciation
@override final  String? audioBg;
// eg cat sound meww, dog sound barking
@override final  num? dxRatio;
@override final  num? dyRatio;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageOutline, imageOutline) || other.imageOutline == imageOutline)&&(identical(other.question, question) || other.question == question)&&(identical(other.audioItem, audioItem) || other.audioItem == audioItem)&&(identical(other.audioBg, audioBg) || other.audioBg == audioBg)&&(identical(other.dxRatio, dxRatio) || other.dxRatio == dxRatio)&&(identical(other.dyRatio, dyRatio) || other.dyRatio == dyRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nameEn,nameNp,image,imageOutline,question,audioItem,audioBg,dxRatio,dyRatio);

@override
String toString() {
  return 'Item(nameEn: $nameEn, nameNp: $nameNp, image: $image, imageOutline: $imageOutline, question: $question, audioItem: $audioItem, audioBg: $audioBg, dxRatio: $dxRatio, dyRatio: $dyRatio)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 String nameEn, String nameNp, String image, String? imageOutline, String? question, String audioItem, String? audioBg, num? dxRatio, num? dyRatio
});




}
/// @nodoc
class __$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(this._self, this._then);

  final _Item _self;
  final $Res Function(_Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nameEn = null,Object? nameNp = null,Object? image = null,Object? imageOutline = freezed,Object? question = freezed,Object? audioItem = null,Object? audioBg = freezed,Object? dxRatio = freezed,Object? dyRatio = freezed,}) {
  return _then(_Item(
nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,imageOutline: freezed == imageOutline ? _self.imageOutline : imageOutline // ignore: cast_nullable_to_non_nullable
as String?,question: freezed == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String?,audioItem: null == audioItem ? _self.audioItem : audioItem // ignore: cast_nullable_to_non_nullable
as String,audioBg: freezed == audioBg ? _self.audioBg : audioBg // ignore: cast_nullable_to_non_nullable
as String?,dxRatio: freezed == dxRatio ? _self.dxRatio : dxRatio // ignore: cast_nullable_to_non_nullable
as num?,dyRatio: freezed == dyRatio ? _self.dyRatio : dyRatio // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
