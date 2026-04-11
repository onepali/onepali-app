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

 String get id; String get name; String? get image;@JsonKey(name: 'bg_image') String? get bgImage; bool get active;
/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCopyWith<Lesson> get copyWith => _$LessonCopyWithImpl<Lesson>(this as Lesson, _$identity);

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image,bgImage,active);

@override
String toString() {
  return 'Lesson(id: $id, name: $name, image: $image, bgImage: $bgImage, active: $active)';
}


}

/// @nodoc
abstract mixin class $LessonCopyWith<$Res>  {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) _then) = _$LessonCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? image,@JsonKey(name: 'bg_image') String? bgImage, bool active
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? image = freezed,Object? bgImage = freezed,Object? active = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? image, @JsonKey(name: 'bg_image')  String? bgImage,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.bgImage,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? image, @JsonKey(name: 'bg_image')  String? bgImage,  bool active)  $default,) {final _that = this;
switch (_that) {
case _Lesson():
return $default(_that.id,_that.name,_that.image,_that.bgImage,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? image, @JsonKey(name: 'bg_image')  String? bgImage,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.bgImage,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lesson implements Lesson {
  const _Lesson({required this.id, required this.name, this.image, @JsonKey(name: 'bg_image') this.bgImage, this.active = false});
  factory _Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? image;
@override@JsonKey(name: 'bg_image') final  String? bgImage;
@override@JsonKey() final  bool active;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image,bgImage,active);

@override
String toString() {
  return 'Lesson(id: $id, name: $name, image: $image, bgImage: $bgImage, active: $active)';
}


}

/// @nodoc
abstract mixin class _$LessonCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$LessonCopyWith(_Lesson value, $Res Function(_Lesson) _then) = __$LessonCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? image,@JsonKey(name: 'bg_image') String? bgImage, bool active
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? image = freezed,Object? bgImage = freezed,Object? active = null,}) {
  return _then(_Lesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
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
                case 'tap_to_pop':
          return TapToPopLessonContent.fromJson(
            json
          );
                case 'listen_and_repeat':
          return ListenAndRepeatLessonContent.fromJson(
            json
          );
                case 'char_tracing':
          return CharTracingLessonContent.fromJson(
            json
          );
                case 'tea_making':
          return TeaMakingLessonContent.fromJson(
            json
          );
                case 'ball_slide':
          return BallSlideLessonContent.fromJson(
            json
          );
                case 'slide_up_to_match':
          return SlideUpToMatchLessonContent.fromJson(
            json
          );
                case 'flip_card':
          return FlipCardLessonContent.fromJson(
            json
          );
                case 'balloon_fill':
          return BalloonFillLessonContent.fromJson(
            json
          );
                case 'gun_fill':
          return GunFillLessonContent.fromJson(
            json
          );
                case 'holi_animate':
          return HoliAnimateLessonContent.fromJson(
            json
          );
                case 'tap_to_change':
          return TapToChangeLessonContent.fromJson(
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( IntroLessonContent value)?  intro,TResult Function( InfoLessonContent value)?  info,TResult Function( ChooseCorrectLessonContent value)?  chooseCorrect,TResult Function( TapToRevealLessonContent value)?  tapToReveal,TResult Function( DragToMatchLessonContent value)?  dragToMatch,TResult Function( TapToPopLessonContent value)?  tapToPop,TResult Function( ListenAndRepeatLessonContent value)?  listenAndRepeat,TResult Function( CharTracingLessonContent value)?  charTracing,TResult Function( TeaMakingLessonContent value)?  teaMaking,TResult Function( BallSlideLessonContent value)?  ballSlide,TResult Function( SlideUpToMatchLessonContent value)?  slideUpToMatch,TResult Function( FlipCardLessonContent value)?  flipCard,TResult Function( BalloonFillLessonContent value)?  balloonFill,TResult Function( GunFillLessonContent value)?  gunFill,TResult Function( HoliAnimateLessonContent value)?  holiAnimate,TResult Function( TapToChangeLessonContent value)?  tapToChange,TResult Function( UnknownLessonContent value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case IntroLessonContent() when intro != null:
return intro(_that);case InfoLessonContent() when info != null:
return info(_that);case ChooseCorrectLessonContent() when chooseCorrect != null:
return chooseCorrect(_that);case TapToRevealLessonContent() when tapToReveal != null:
return tapToReveal(_that);case DragToMatchLessonContent() when dragToMatch != null:
return dragToMatch(_that);case TapToPopLessonContent() when tapToPop != null:
return tapToPop(_that);case ListenAndRepeatLessonContent() when listenAndRepeat != null:
return listenAndRepeat(_that);case CharTracingLessonContent() when charTracing != null:
return charTracing(_that);case TeaMakingLessonContent() when teaMaking != null:
return teaMaking(_that);case BallSlideLessonContent() when ballSlide != null:
return ballSlide(_that);case SlideUpToMatchLessonContent() when slideUpToMatch != null:
return slideUpToMatch(_that);case FlipCardLessonContent() when flipCard != null:
return flipCard(_that);case BalloonFillLessonContent() when balloonFill != null:
return balloonFill(_that);case GunFillLessonContent() when gunFill != null:
return gunFill(_that);case HoliAnimateLessonContent() when holiAnimate != null:
return holiAnimate(_that);case TapToChangeLessonContent() when tapToChange != null:
return tapToChange(_that);case UnknownLessonContent() when unknown != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( IntroLessonContent value)  intro,required TResult Function( InfoLessonContent value)  info,required TResult Function( ChooseCorrectLessonContent value)  chooseCorrect,required TResult Function( TapToRevealLessonContent value)  tapToReveal,required TResult Function( DragToMatchLessonContent value)  dragToMatch,required TResult Function( TapToPopLessonContent value)  tapToPop,required TResult Function( ListenAndRepeatLessonContent value)  listenAndRepeat,required TResult Function( CharTracingLessonContent value)  charTracing,required TResult Function( TeaMakingLessonContent value)  teaMaking,required TResult Function( BallSlideLessonContent value)  ballSlide,required TResult Function( SlideUpToMatchLessonContent value)  slideUpToMatch,required TResult Function( FlipCardLessonContent value)  flipCard,required TResult Function( BalloonFillLessonContent value)  balloonFill,required TResult Function( GunFillLessonContent value)  gunFill,required TResult Function( HoliAnimateLessonContent value)  holiAnimate,required TResult Function( TapToChangeLessonContent value)  tapToChange,required TResult Function( UnknownLessonContent value)  unknown,}){
final _that = this;
switch (_that) {
case IntroLessonContent():
return intro(_that);case InfoLessonContent():
return info(_that);case ChooseCorrectLessonContent():
return chooseCorrect(_that);case TapToRevealLessonContent():
return tapToReveal(_that);case DragToMatchLessonContent():
return dragToMatch(_that);case TapToPopLessonContent():
return tapToPop(_that);case ListenAndRepeatLessonContent():
return listenAndRepeat(_that);case CharTracingLessonContent():
return charTracing(_that);case TeaMakingLessonContent():
return teaMaking(_that);case BallSlideLessonContent():
return ballSlide(_that);case SlideUpToMatchLessonContent():
return slideUpToMatch(_that);case FlipCardLessonContent():
return flipCard(_that);case BalloonFillLessonContent():
return balloonFill(_that);case GunFillLessonContent():
return gunFill(_that);case HoliAnimateLessonContent():
return holiAnimate(_that);case TapToChangeLessonContent():
return tapToChange(_that);case UnknownLessonContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( IntroLessonContent value)?  intro,TResult? Function( InfoLessonContent value)?  info,TResult? Function( ChooseCorrectLessonContent value)?  chooseCorrect,TResult? Function( TapToRevealLessonContent value)?  tapToReveal,TResult? Function( DragToMatchLessonContent value)?  dragToMatch,TResult? Function( TapToPopLessonContent value)?  tapToPop,TResult? Function( ListenAndRepeatLessonContent value)?  listenAndRepeat,TResult? Function( CharTracingLessonContent value)?  charTracing,TResult? Function( TeaMakingLessonContent value)?  teaMaking,TResult? Function( BallSlideLessonContent value)?  ballSlide,TResult? Function( SlideUpToMatchLessonContent value)?  slideUpToMatch,TResult? Function( FlipCardLessonContent value)?  flipCard,TResult? Function( BalloonFillLessonContent value)?  balloonFill,TResult? Function( GunFillLessonContent value)?  gunFill,TResult? Function( HoliAnimateLessonContent value)?  holiAnimate,TResult? Function( TapToChangeLessonContent value)?  tapToChange,TResult? Function( UnknownLessonContent value)?  unknown,}){
final _that = this;
switch (_that) {
case IntroLessonContent() when intro != null:
return intro(_that);case InfoLessonContent() when info != null:
return info(_that);case ChooseCorrectLessonContent() when chooseCorrect != null:
return chooseCorrect(_that);case TapToRevealLessonContent() when tapToReveal != null:
return tapToReveal(_that);case DragToMatchLessonContent() when dragToMatch != null:
return dragToMatch(_that);case TapToPopLessonContent() when tapToPop != null:
return tapToPop(_that);case ListenAndRepeatLessonContent() when listenAndRepeat != null:
return listenAndRepeat(_that);case CharTracingLessonContent() when charTracing != null:
return charTracing(_that);case TeaMakingLessonContent() when teaMaking != null:
return teaMaking(_that);case BallSlideLessonContent() when ballSlide != null:
return ballSlide(_that);case SlideUpToMatchLessonContent() when slideUpToMatch != null:
return slideUpToMatch(_that);case FlipCardLessonContent() when flipCard != null:
return flipCard(_that);case BalloonFillLessonContent() when balloonFill != null:
return balloonFill(_that);case GunFillLessonContent() when gunFill != null:
return gunFill(_that);case HoliAnimateLessonContent() when holiAnimate != null:
return holiAnimate(_that);case TapToChangeLessonContent() when tapToChange != null:
return tapToChange(_that);case UnknownLessonContent() when unknown != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  int index,  String type,  String? bgColor,  String? image,  String? audio,  String? bgImageMobile,  String? bgImageTablet)?  intro,TResult Function( String id,  int index,  String type,  String nameEn,  String nameNp,  String audioWord,  String? audioBg,  String image,  bool isImageSvg,  String? video,  String? bgImageColor)?  info,TResult Function( String id,  int index,  String type,  List<Item> items)?  chooseCorrect,TResult Function( String id,  int index,  String? bgImage,  String type,  List<Item> items)?  tapToReveal,TResult Function( String id,  int index,  String type,  List<Item> items)?  dragToMatch,TResult Function( String id,  int index,  String? bgImage,  String? successImage,  String? bgColor,  String? audioWord,  String? instructionAudio,  String type,  List<Item> items)?  tapToPop,TResult Function( String id,  int index,  String type,  String nameEn,  String nameNp,  String? bgImage,  String? bgColor,  String audioWord,  String? audioBg,  String? image,  String? charImage,  bool isImageSvg)?  listenAndRepeat,TResult Function( String nameEn,  String nameNp,  String id,  int index,  String? bgImage,  String? bgColor,  String? audioBg,  String? audioItem,  String type)?  charTracing,TResult Function( String id,  int index,  String type,  String audioInstruction,  String teapotVapour,  String stoveImage,  String abaPaniUmalaSound,  String teaReadySound,  String bearTakingTea,  List<Item> ingredients)?  teaMaking,TResult Function( String id,  int index,  String type,  String? bgImageMobile,  String? bgImageTablet,  String? player1,  String? player2,  String? ballImage,  String? sliderColor,  bool rotateBall,  String? ballImageEnd,  String direction,  List<String> conversation,  num angle,  num sliderLengthMb,  num sliderLengthTb,  int pDyMb,  int pDyTb,  String? goalLeftImageMb,  String? goalLeftImageTb,  String? goalRightImageMb,  String? goalRightImageTb)?  ballSlide,TResult Function( String id,  int index,  String type,  String? bgImage,  List<Item> items)?  slideUpToMatch,TResult Function( String id,  int index,  String type,  String? bgImage,  List<Item> items)?  flipCard,TResult Function( String id,  int index,  String? audio,  String type,  String? bgImage,  String? bgImageTb,  List<Item> items)?  balloonFill,TResult Function( String id,  int index,  String? audio,  String type,  String? bgImage,  String? bgImageTb,  List<Item> items)?  gunFill,TResult Function( String id,  int index,  String? audio,  String type,  String? bgImage,  String? bgImageTb,  String image,  List<Item> items)?  holiAnimate,TResult Function( String id,  int index,  String? audio,  String type,  String bgImage,  String afterBgImage,  String bgImageTb,  String afterBgImageTb,  String? tapGesture,  String? splashImage,  List<Item> items)?  tapToChange,TResult Function( String id,  int index,  String type)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case IntroLessonContent() when intro != null:
return intro(_that.id,_that.index,_that.type,_that.bgColor,_that.image,_that.audio,_that.bgImageMobile,_that.bgImageTablet);case InfoLessonContent() when info != null:
return info(_that.id,_that.index,_that.type,_that.nameEn,_that.nameNp,_that.audioWord,_that.audioBg,_that.image,_that.isImageSvg,_that.video,_that.bgImageColor);case ChooseCorrectLessonContent() when chooseCorrect != null:
return chooseCorrect(_that.id,_that.index,_that.type,_that.items);case TapToRevealLessonContent() when tapToReveal != null:
return tapToReveal(_that.id,_that.index,_that.bgImage,_that.type,_that.items);case DragToMatchLessonContent() when dragToMatch != null:
return dragToMatch(_that.id,_that.index,_that.type,_that.items);case TapToPopLessonContent() when tapToPop != null:
return tapToPop(_that.id,_that.index,_that.bgImage,_that.successImage,_that.bgColor,_that.audioWord,_that.instructionAudio,_that.type,_that.items);case ListenAndRepeatLessonContent() when listenAndRepeat != null:
return listenAndRepeat(_that.id,_that.index,_that.type,_that.nameEn,_that.nameNp,_that.bgImage,_that.bgColor,_that.audioWord,_that.audioBg,_that.image,_that.charImage,_that.isImageSvg);case CharTracingLessonContent() when charTracing != null:
return charTracing(_that.nameEn,_that.nameNp,_that.id,_that.index,_that.bgImage,_that.bgColor,_that.audioBg,_that.audioItem,_that.type);case TeaMakingLessonContent() when teaMaking != null:
return teaMaking(_that.id,_that.index,_that.type,_that.audioInstruction,_that.teapotVapour,_that.stoveImage,_that.abaPaniUmalaSound,_that.teaReadySound,_that.bearTakingTea,_that.ingredients);case BallSlideLessonContent() when ballSlide != null:
return ballSlide(_that.id,_that.index,_that.type,_that.bgImageMobile,_that.bgImageTablet,_that.player1,_that.player2,_that.ballImage,_that.sliderColor,_that.rotateBall,_that.ballImageEnd,_that.direction,_that.conversation,_that.angle,_that.sliderLengthMb,_that.sliderLengthTb,_that.pDyMb,_that.pDyTb,_that.goalLeftImageMb,_that.goalLeftImageTb,_that.goalRightImageMb,_that.goalRightImageTb);case SlideUpToMatchLessonContent() when slideUpToMatch != null:
return slideUpToMatch(_that.id,_that.index,_that.type,_that.bgImage,_that.items);case FlipCardLessonContent() when flipCard != null:
return flipCard(_that.id,_that.index,_that.type,_that.bgImage,_that.items);case BalloonFillLessonContent() when balloonFill != null:
return balloonFill(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.bgImageTb,_that.items);case GunFillLessonContent() when gunFill != null:
return gunFill(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.bgImageTb,_that.items);case HoliAnimateLessonContent() when holiAnimate != null:
return holiAnimate(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.bgImageTb,_that.image,_that.items);case TapToChangeLessonContent() when tapToChange != null:
return tapToChange(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.afterBgImage,_that.bgImageTb,_that.afterBgImageTb,_that.tapGesture,_that.splashImage,_that.items);case UnknownLessonContent() when unknown != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  int index,  String type,  String? bgColor,  String? image,  String? audio,  String? bgImageMobile,  String? bgImageTablet)  intro,required TResult Function( String id,  int index,  String type,  String nameEn,  String nameNp,  String audioWord,  String? audioBg,  String image,  bool isImageSvg,  String? video,  String? bgImageColor)  info,required TResult Function( String id,  int index,  String type,  List<Item> items)  chooseCorrect,required TResult Function( String id,  int index,  String? bgImage,  String type,  List<Item> items)  tapToReveal,required TResult Function( String id,  int index,  String type,  List<Item> items)  dragToMatch,required TResult Function( String id,  int index,  String? bgImage,  String? successImage,  String? bgColor,  String? audioWord,  String? instructionAudio,  String type,  List<Item> items)  tapToPop,required TResult Function( String id,  int index,  String type,  String nameEn,  String nameNp,  String? bgImage,  String? bgColor,  String audioWord,  String? audioBg,  String? image,  String? charImage,  bool isImageSvg)  listenAndRepeat,required TResult Function( String nameEn,  String nameNp,  String id,  int index,  String? bgImage,  String? bgColor,  String? audioBg,  String? audioItem,  String type)  charTracing,required TResult Function( String id,  int index,  String type,  String audioInstruction,  String teapotVapour,  String stoveImage,  String abaPaniUmalaSound,  String teaReadySound,  String bearTakingTea,  List<Item> ingredients)  teaMaking,required TResult Function( String id,  int index,  String type,  String? bgImageMobile,  String? bgImageTablet,  String? player1,  String? player2,  String? ballImage,  String? sliderColor,  bool rotateBall,  String? ballImageEnd,  String direction,  List<String> conversation,  num angle,  num sliderLengthMb,  num sliderLengthTb,  int pDyMb,  int pDyTb,  String? goalLeftImageMb,  String? goalLeftImageTb,  String? goalRightImageMb,  String? goalRightImageTb)  ballSlide,required TResult Function( String id,  int index,  String type,  String? bgImage,  List<Item> items)  slideUpToMatch,required TResult Function( String id,  int index,  String type,  String? bgImage,  List<Item> items)  flipCard,required TResult Function( String id,  int index,  String? audio,  String type,  String? bgImage,  String? bgImageTb,  List<Item> items)  balloonFill,required TResult Function( String id,  int index,  String? audio,  String type,  String? bgImage,  String? bgImageTb,  List<Item> items)  gunFill,required TResult Function( String id,  int index,  String? audio,  String type,  String? bgImage,  String? bgImageTb,  String image,  List<Item> items)  holiAnimate,required TResult Function( String id,  int index,  String? audio,  String type,  String bgImage,  String afterBgImage,  String bgImageTb,  String afterBgImageTb,  String? tapGesture,  String? splashImage,  List<Item> items)  tapToChange,required TResult Function( String id,  int index,  String type)  unknown,}) {final _that = this;
switch (_that) {
case IntroLessonContent():
return intro(_that.id,_that.index,_that.type,_that.bgColor,_that.image,_that.audio,_that.bgImageMobile,_that.bgImageTablet);case InfoLessonContent():
return info(_that.id,_that.index,_that.type,_that.nameEn,_that.nameNp,_that.audioWord,_that.audioBg,_that.image,_that.isImageSvg,_that.video,_that.bgImageColor);case ChooseCorrectLessonContent():
return chooseCorrect(_that.id,_that.index,_that.type,_that.items);case TapToRevealLessonContent():
return tapToReveal(_that.id,_that.index,_that.bgImage,_that.type,_that.items);case DragToMatchLessonContent():
return dragToMatch(_that.id,_that.index,_that.type,_that.items);case TapToPopLessonContent():
return tapToPop(_that.id,_that.index,_that.bgImage,_that.successImage,_that.bgColor,_that.audioWord,_that.instructionAudio,_that.type,_that.items);case ListenAndRepeatLessonContent():
return listenAndRepeat(_that.id,_that.index,_that.type,_that.nameEn,_that.nameNp,_that.bgImage,_that.bgColor,_that.audioWord,_that.audioBg,_that.image,_that.charImage,_that.isImageSvg);case CharTracingLessonContent():
return charTracing(_that.nameEn,_that.nameNp,_that.id,_that.index,_that.bgImage,_that.bgColor,_that.audioBg,_that.audioItem,_that.type);case TeaMakingLessonContent():
return teaMaking(_that.id,_that.index,_that.type,_that.audioInstruction,_that.teapotVapour,_that.stoveImage,_that.abaPaniUmalaSound,_that.teaReadySound,_that.bearTakingTea,_that.ingredients);case BallSlideLessonContent():
return ballSlide(_that.id,_that.index,_that.type,_that.bgImageMobile,_that.bgImageTablet,_that.player1,_that.player2,_that.ballImage,_that.sliderColor,_that.rotateBall,_that.ballImageEnd,_that.direction,_that.conversation,_that.angle,_that.sliderLengthMb,_that.sliderLengthTb,_that.pDyMb,_that.pDyTb,_that.goalLeftImageMb,_that.goalLeftImageTb,_that.goalRightImageMb,_that.goalRightImageTb);case SlideUpToMatchLessonContent():
return slideUpToMatch(_that.id,_that.index,_that.type,_that.bgImage,_that.items);case FlipCardLessonContent():
return flipCard(_that.id,_that.index,_that.type,_that.bgImage,_that.items);case BalloonFillLessonContent():
return balloonFill(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.bgImageTb,_that.items);case GunFillLessonContent():
return gunFill(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.bgImageTb,_that.items);case HoliAnimateLessonContent():
return holiAnimate(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.bgImageTb,_that.image,_that.items);case TapToChangeLessonContent():
return tapToChange(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.afterBgImage,_that.bgImageTb,_that.afterBgImageTb,_that.tapGesture,_that.splashImage,_that.items);case UnknownLessonContent():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  int index,  String type,  String? bgColor,  String? image,  String? audio,  String? bgImageMobile,  String? bgImageTablet)?  intro,TResult? Function( String id,  int index,  String type,  String nameEn,  String nameNp,  String audioWord,  String? audioBg,  String image,  bool isImageSvg,  String? video,  String? bgImageColor)?  info,TResult? Function( String id,  int index,  String type,  List<Item> items)?  chooseCorrect,TResult? Function( String id,  int index,  String? bgImage,  String type,  List<Item> items)?  tapToReveal,TResult? Function( String id,  int index,  String type,  List<Item> items)?  dragToMatch,TResult? Function( String id,  int index,  String? bgImage,  String? successImage,  String? bgColor,  String? audioWord,  String? instructionAudio,  String type,  List<Item> items)?  tapToPop,TResult? Function( String id,  int index,  String type,  String nameEn,  String nameNp,  String? bgImage,  String? bgColor,  String audioWord,  String? audioBg,  String? image,  String? charImage,  bool isImageSvg)?  listenAndRepeat,TResult? Function( String nameEn,  String nameNp,  String id,  int index,  String? bgImage,  String? bgColor,  String? audioBg,  String? audioItem,  String type)?  charTracing,TResult? Function( String id,  int index,  String type,  String audioInstruction,  String teapotVapour,  String stoveImage,  String abaPaniUmalaSound,  String teaReadySound,  String bearTakingTea,  List<Item> ingredients)?  teaMaking,TResult? Function( String id,  int index,  String type,  String? bgImageMobile,  String? bgImageTablet,  String? player1,  String? player2,  String? ballImage,  String? sliderColor,  bool rotateBall,  String? ballImageEnd,  String direction,  List<String> conversation,  num angle,  num sliderLengthMb,  num sliderLengthTb,  int pDyMb,  int pDyTb,  String? goalLeftImageMb,  String? goalLeftImageTb,  String? goalRightImageMb,  String? goalRightImageTb)?  ballSlide,TResult? Function( String id,  int index,  String type,  String? bgImage,  List<Item> items)?  slideUpToMatch,TResult? Function( String id,  int index,  String type,  String? bgImage,  List<Item> items)?  flipCard,TResult? Function( String id,  int index,  String? audio,  String type,  String? bgImage,  String? bgImageTb,  List<Item> items)?  balloonFill,TResult? Function( String id,  int index,  String? audio,  String type,  String? bgImage,  String? bgImageTb,  List<Item> items)?  gunFill,TResult? Function( String id,  int index,  String? audio,  String type,  String? bgImage,  String? bgImageTb,  String image,  List<Item> items)?  holiAnimate,TResult? Function( String id,  int index,  String? audio,  String type,  String bgImage,  String afterBgImage,  String bgImageTb,  String afterBgImageTb,  String? tapGesture,  String? splashImage,  List<Item> items)?  tapToChange,TResult? Function( String id,  int index,  String type)?  unknown,}) {final _that = this;
switch (_that) {
case IntroLessonContent() when intro != null:
return intro(_that.id,_that.index,_that.type,_that.bgColor,_that.image,_that.audio,_that.bgImageMobile,_that.bgImageTablet);case InfoLessonContent() when info != null:
return info(_that.id,_that.index,_that.type,_that.nameEn,_that.nameNp,_that.audioWord,_that.audioBg,_that.image,_that.isImageSvg,_that.video,_that.bgImageColor);case ChooseCorrectLessonContent() when chooseCorrect != null:
return chooseCorrect(_that.id,_that.index,_that.type,_that.items);case TapToRevealLessonContent() when tapToReveal != null:
return tapToReveal(_that.id,_that.index,_that.bgImage,_that.type,_that.items);case DragToMatchLessonContent() when dragToMatch != null:
return dragToMatch(_that.id,_that.index,_that.type,_that.items);case TapToPopLessonContent() when tapToPop != null:
return tapToPop(_that.id,_that.index,_that.bgImage,_that.successImage,_that.bgColor,_that.audioWord,_that.instructionAudio,_that.type,_that.items);case ListenAndRepeatLessonContent() when listenAndRepeat != null:
return listenAndRepeat(_that.id,_that.index,_that.type,_that.nameEn,_that.nameNp,_that.bgImage,_that.bgColor,_that.audioWord,_that.audioBg,_that.image,_that.charImage,_that.isImageSvg);case CharTracingLessonContent() when charTracing != null:
return charTracing(_that.nameEn,_that.nameNp,_that.id,_that.index,_that.bgImage,_that.bgColor,_that.audioBg,_that.audioItem,_that.type);case TeaMakingLessonContent() when teaMaking != null:
return teaMaking(_that.id,_that.index,_that.type,_that.audioInstruction,_that.teapotVapour,_that.stoveImage,_that.abaPaniUmalaSound,_that.teaReadySound,_that.bearTakingTea,_that.ingredients);case BallSlideLessonContent() when ballSlide != null:
return ballSlide(_that.id,_that.index,_that.type,_that.bgImageMobile,_that.bgImageTablet,_that.player1,_that.player2,_that.ballImage,_that.sliderColor,_that.rotateBall,_that.ballImageEnd,_that.direction,_that.conversation,_that.angle,_that.sliderLengthMb,_that.sliderLengthTb,_that.pDyMb,_that.pDyTb,_that.goalLeftImageMb,_that.goalLeftImageTb,_that.goalRightImageMb,_that.goalRightImageTb);case SlideUpToMatchLessonContent() when slideUpToMatch != null:
return slideUpToMatch(_that.id,_that.index,_that.type,_that.bgImage,_that.items);case FlipCardLessonContent() when flipCard != null:
return flipCard(_that.id,_that.index,_that.type,_that.bgImage,_that.items);case BalloonFillLessonContent() when balloonFill != null:
return balloonFill(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.bgImageTb,_that.items);case GunFillLessonContent() when gunFill != null:
return gunFill(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.bgImageTb,_that.items);case HoliAnimateLessonContent() when holiAnimate != null:
return holiAnimate(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.bgImageTb,_that.image,_that.items);case TapToChangeLessonContent() when tapToChange != null:
return tapToChange(_that.id,_that.index,_that.audio,_that.type,_that.bgImage,_that.afterBgImage,_that.bgImageTb,_that.afterBgImageTb,_that.tapGesture,_that.splashImage,_that.items);case UnknownLessonContent() when unknown != null:
return unknown(_that.id,_that.index,_that.type);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class IntroLessonContent implements LessonContent {
  const IntroLessonContent({required this.id, required this.index, this.type = 'intro', this.bgColor, this.image, this.audio, this.bgImageMobile, this.bgImageTablet});
  factory IntroLessonContent.fromJson(Map<String, dynamic> json) => _$IntroLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  String? bgColor;
 final  String? image;
// svg
 final  String? audio;
 final  String? bgImageMobile;
 final  String? bgImageTablet;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntroLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.image, image) || other.image == image)&&(identical(other.audio, audio) || other.audio == audio)&&(identical(other.bgImageMobile, bgImageMobile) || other.bgImageMobile == bgImageMobile)&&(identical(other.bgImageTablet, bgImageTablet) || other.bgImageTablet == bgImageTablet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type,bgColor,image,audio,bgImageMobile,bgImageTablet);

@override
String toString() {
  return 'LessonContent.intro(id: $id, index: $index, type: $type, bgColor: $bgColor, image: $image, audio: $audio, bgImageMobile: $bgImageMobile, bgImageTablet: $bgImageTablet)';
}


}

/// @nodoc
abstract mixin class $IntroLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $IntroLessonContentCopyWith(IntroLessonContent value, $Res Function(IntroLessonContent) _then) = _$IntroLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, String? bgColor, String? image, String? audio, String? bgImageMobile, String? bgImageTablet
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? bgColor = freezed,Object? image = freezed,Object? audio = freezed,Object? bgImageMobile = freezed,Object? bgImageTablet = freezed,}) {
  return _then(IntroLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,audio: freezed == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as String?,bgImageMobile: freezed == bgImageMobile ? _self.bgImageMobile : bgImageMobile // ignore: cast_nullable_to_non_nullable
as String?,bgImageTablet: freezed == bgImageTablet ? _self.bgImageTablet : bgImageTablet // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class InfoLessonContent implements LessonContent {
  const InfoLessonContent({required this.id, required this.index, this.type = 'info', required this.nameEn, required this.nameNp, required this.audioWord, this.audioBg, required this.image, this.isImageSvg = false, this.video, this.bgImageColor});
  factory InfoLessonContent.fromJson(Map<String, dynamic> json) => _$InfoLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  String nameEn;
 final  String nameNp;
 final  String audioWord;
 final  String? audioBg;
 final  String image;
@JsonKey() final  bool isImageSvg;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InfoLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.audioWord, audioWord) || other.audioWord == audioWord)&&(identical(other.audioBg, audioBg) || other.audioBg == audioBg)&&(identical(other.image, image) || other.image == image)&&(identical(other.isImageSvg, isImageSvg) || other.isImageSvg == isImageSvg)&&(identical(other.video, video) || other.video == video)&&(identical(other.bgImageColor, bgImageColor) || other.bgImageColor == bgImageColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type,nameEn,nameNp,audioWord,audioBg,image,isImageSvg,video,bgImageColor);

@override
String toString() {
  return 'LessonContent.info(id: $id, index: $index, type: $type, nameEn: $nameEn, nameNp: $nameNp, audioWord: $audioWord, audioBg: $audioBg, image: $image, isImageSvg: $isImageSvg, video: $video, bgImageColor: $bgImageColor)';
}


}

/// @nodoc
abstract mixin class $InfoLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $InfoLessonContentCopyWith(InfoLessonContent value, $Res Function(InfoLessonContent) _then) = _$InfoLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, String nameEn, String nameNp, String audioWord, String? audioBg, String image, bool isImageSvg, String? video, String? bgImageColor
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? nameEn = null,Object? nameNp = null,Object? audioWord = null,Object? audioBg = freezed,Object? image = null,Object? isImageSvg = null,Object? video = freezed,Object? bgImageColor = freezed,}) {
  return _then(InfoLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,audioWord: null == audioWord ? _self.audioWord : audioWord // ignore: cast_nullable_to_non_nullable
as String,audioBg: freezed == audioBg ? _self.audioBg : audioBg // ignore: cast_nullable_to_non_nullable
as String?,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,isImageSvg: null == isImageSvg ? _self.isImageSvg : isImageSvg // ignore: cast_nullable_to_non_nullable
as bool,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
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

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TapToPopLessonContent implements LessonContent {
  const TapToPopLessonContent({required this.id, required this.index, this.bgImage, this.successImage, this.bgColor, this.audioWord, this.instructionAudio, this.type = 'tap_to_pop', final  List<Item> items = const []}): _items = items;
  factory TapToPopLessonContent.fromJson(Map<String, dynamic> json) => _$TapToPopLessonContentFromJson(json);

@override final  String id;
@override final  int index;
 final  String? bgImage;
 final  String? successImage;
 final  String? bgColor;
 final  String? audioWord;
 final  String? instructionAudio;
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
$TapToPopLessonContentCopyWith<TapToPopLessonContent> get copyWith => _$TapToPopLessonContentCopyWithImpl<TapToPopLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TapToPopLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToPopLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.successImage, successImage) || other.successImage == successImage)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.audioWord, audioWord) || other.audioWord == audioWord)&&(identical(other.instructionAudio, instructionAudio) || other.instructionAudio == instructionAudio)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,bgImage,successImage,bgColor,audioWord,instructionAudio,type,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'LessonContent.tapToPop(id: $id, index: $index, bgImage: $bgImage, successImage: $successImage, bgColor: $bgColor, audioWord: $audioWord, instructionAudio: $instructionAudio, type: $type, items: $items)';
}


}

/// @nodoc
abstract mixin class $TapToPopLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $TapToPopLessonContentCopyWith(TapToPopLessonContent value, $Res Function(TapToPopLessonContent) _then) = _$TapToPopLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String? bgImage, String? successImage, String? bgColor, String? audioWord, String? instructionAudio, String type, List<Item> items
});




}
/// @nodoc
class _$TapToPopLessonContentCopyWithImpl<$Res>
    implements $TapToPopLessonContentCopyWith<$Res> {
  _$TapToPopLessonContentCopyWithImpl(this._self, this._then);

  final TapToPopLessonContent _self;
  final $Res Function(TapToPopLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? bgImage = freezed,Object? successImage = freezed,Object? bgColor = freezed,Object? audioWord = freezed,Object? instructionAudio = freezed,Object? type = null,Object? items = null,}) {
  return _then(TapToPopLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,successImage: freezed == successImage ? _self.successImage : successImage // ignore: cast_nullable_to_non_nullable
as String?,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as String?,audioWord: freezed == audioWord ? _self.audioWord : audioWord // ignore: cast_nullable_to_non_nullable
as String?,instructionAudio: freezed == instructionAudio ? _self.instructionAudio : instructionAudio // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ListenAndRepeatLessonContent implements LessonContent {
  const ListenAndRepeatLessonContent({required this.id, required this.index, this.type = 'listen_and_repeat', required this.nameEn, required this.nameNp, this.bgImage, this.bgColor, required this.audioWord, this.audioBg, this.image, this.charImage, this.isImageSvg = false});
  factory ListenAndRepeatLessonContent.fromJson(Map<String, dynamic> json) => _$ListenAndRepeatLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  String nameEn;
 final  String nameNp;
 final  String? bgImage;
 final  String? bgColor;
 final  String audioWord;
 final  String? audioBg;
 final  String? image;
// This is image of the word, eg a man doing namaste
 final  String? charImage;
// This is the character image, eg 'न'
@JsonKey() final  bool isImageSvg;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListenAndRepeatLessonContentCopyWith<ListenAndRepeatLessonContent> get copyWith => _$ListenAndRepeatLessonContentCopyWithImpl<ListenAndRepeatLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListenAndRepeatLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListenAndRepeatLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.audioWord, audioWord) || other.audioWord == audioWord)&&(identical(other.audioBg, audioBg) || other.audioBg == audioBg)&&(identical(other.image, image) || other.image == image)&&(identical(other.charImage, charImage) || other.charImage == charImage)&&(identical(other.isImageSvg, isImageSvg) || other.isImageSvg == isImageSvg));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type,nameEn,nameNp,bgImage,bgColor,audioWord,audioBg,image,charImage,isImageSvg);

@override
String toString() {
  return 'LessonContent.listenAndRepeat(id: $id, index: $index, type: $type, nameEn: $nameEn, nameNp: $nameNp, bgImage: $bgImage, bgColor: $bgColor, audioWord: $audioWord, audioBg: $audioBg, image: $image, charImage: $charImage, isImageSvg: $isImageSvg)';
}


}

/// @nodoc
abstract mixin class $ListenAndRepeatLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $ListenAndRepeatLessonContentCopyWith(ListenAndRepeatLessonContent value, $Res Function(ListenAndRepeatLessonContent) _then) = _$ListenAndRepeatLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, String nameEn, String nameNp, String? bgImage, String? bgColor, String audioWord, String? audioBg, String? image, String? charImage, bool isImageSvg
});




}
/// @nodoc
class _$ListenAndRepeatLessonContentCopyWithImpl<$Res>
    implements $ListenAndRepeatLessonContentCopyWith<$Res> {
  _$ListenAndRepeatLessonContentCopyWithImpl(this._self, this._then);

  final ListenAndRepeatLessonContent _self;
  final $Res Function(ListenAndRepeatLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? nameEn = null,Object? nameNp = null,Object? bgImage = freezed,Object? bgColor = freezed,Object? audioWord = null,Object? audioBg = freezed,Object? image = freezed,Object? charImage = freezed,Object? isImageSvg = null,}) {
  return _then(ListenAndRepeatLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as String?,audioWord: null == audioWord ? _self.audioWord : audioWord // ignore: cast_nullable_to_non_nullable
as String,audioBg: freezed == audioBg ? _self.audioBg : audioBg // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,charImage: freezed == charImage ? _self.charImage : charImage // ignore: cast_nullable_to_non_nullable
as String?,isImageSvg: null == isImageSvg ? _self.isImageSvg : isImageSvg // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharTracingLessonContent implements LessonContent {
  const CharTracingLessonContent({this.nameEn = '', this.nameNp = '', required this.id, required this.index, this.bgImage, this.bgColor, this.audioBg, this.audioItem, this.type = 'char_tracing'});
  factory CharTracingLessonContent.fromJson(Map<String, dynamic> json) => _$CharTracingLessonContentFromJson(json);

@JsonKey() final  String nameEn;
@JsonKey() final  String nameNp;
@override final  String id;
@override final  int index;
 final  String? bgImage;
 final  String? bgColor;
 final  String? audioBg;
 final  String? audioItem;
@override@JsonKey() final  String type;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharTracingLessonContentCopyWith<CharTracingLessonContent> get copyWith => _$CharTracingLessonContentCopyWithImpl<CharTracingLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharTracingLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharTracingLessonContent&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.audioBg, audioBg) || other.audioBg == audioBg)&&(identical(other.audioItem, audioItem) || other.audioItem == audioItem)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nameEn,nameNp,id,index,bgImage,bgColor,audioBg,audioItem,type);

@override
String toString() {
  return 'LessonContent.charTracing(nameEn: $nameEn, nameNp: $nameNp, id: $id, index: $index, bgImage: $bgImage, bgColor: $bgColor, audioBg: $audioBg, audioItem: $audioItem, type: $type)';
}


}

/// @nodoc
abstract mixin class $CharTracingLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $CharTracingLessonContentCopyWith(CharTracingLessonContent value, $Res Function(CharTracingLessonContent) _then) = _$CharTracingLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String nameEn, String nameNp, String id, int index, String? bgImage, String? bgColor, String? audioBg, String? audioItem, String type
});




}
/// @nodoc
class _$CharTracingLessonContentCopyWithImpl<$Res>
    implements $CharTracingLessonContentCopyWith<$Res> {
  _$CharTracingLessonContentCopyWithImpl(this._self, this._then);

  final CharTracingLessonContent _self;
  final $Res Function(CharTracingLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nameEn = null,Object? nameNp = null,Object? id = null,Object? index = null,Object? bgImage = freezed,Object? bgColor = freezed,Object? audioBg = freezed,Object? audioItem = freezed,Object? type = null,}) {
  return _then(CharTracingLessonContent(
nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as String?,audioBg: freezed == audioBg ? _self.audioBg : audioBg // ignore: cast_nullable_to_non_nullable
as String?,audioItem: freezed == audioItem ? _self.audioItem : audioItem // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TeaMakingLessonContent implements LessonContent {
  const TeaMakingLessonContent({required this.id, required this.index, this.type = 'tea_making', required this.audioInstruction, required this.teapotVapour, required this.stoveImage, required this.abaPaniUmalaSound, required this.teaReadySound, required this.bearTakingTea, final  List<Item> ingredients = const []}): _ingredients = ingredients;
  factory TeaMakingLessonContent.fromJson(Map<String, dynamic> json) => _$TeaMakingLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  String audioInstruction;
 final  String teapotVapour;
 final  String stoveImage;
 final  String abaPaniUmalaSound;
 final  String teaReadySound;
 final  String bearTakingTea;
 final  List<Item> _ingredients;
@JsonKey() List<Item> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}


/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeaMakingLessonContentCopyWith<TeaMakingLessonContent> get copyWith => _$TeaMakingLessonContentCopyWithImpl<TeaMakingLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeaMakingLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeaMakingLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.audioInstruction, audioInstruction) || other.audioInstruction == audioInstruction)&&(identical(other.teapotVapour, teapotVapour) || other.teapotVapour == teapotVapour)&&(identical(other.stoveImage, stoveImage) || other.stoveImage == stoveImage)&&(identical(other.abaPaniUmalaSound, abaPaniUmalaSound) || other.abaPaniUmalaSound == abaPaniUmalaSound)&&(identical(other.teaReadySound, teaReadySound) || other.teaReadySound == teaReadySound)&&(identical(other.bearTakingTea, bearTakingTea) || other.bearTakingTea == bearTakingTea)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type,audioInstruction,teapotVapour,stoveImage,abaPaniUmalaSound,teaReadySound,bearTakingTea,const DeepCollectionEquality().hash(_ingredients));

@override
String toString() {
  return 'LessonContent.teaMaking(id: $id, index: $index, type: $type, audioInstruction: $audioInstruction, teapotVapour: $teapotVapour, stoveImage: $stoveImage, abaPaniUmalaSound: $abaPaniUmalaSound, teaReadySound: $teaReadySound, bearTakingTea: $bearTakingTea, ingredients: $ingredients)';
}


}

/// @nodoc
abstract mixin class $TeaMakingLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $TeaMakingLessonContentCopyWith(TeaMakingLessonContent value, $Res Function(TeaMakingLessonContent) _then) = _$TeaMakingLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, String audioInstruction, String teapotVapour, String stoveImage, String abaPaniUmalaSound, String teaReadySound, String bearTakingTea, List<Item> ingredients
});




}
/// @nodoc
class _$TeaMakingLessonContentCopyWithImpl<$Res>
    implements $TeaMakingLessonContentCopyWith<$Res> {
  _$TeaMakingLessonContentCopyWithImpl(this._self, this._then);

  final TeaMakingLessonContent _self;
  final $Res Function(TeaMakingLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? audioInstruction = null,Object? teapotVapour = null,Object? stoveImage = null,Object? abaPaniUmalaSound = null,Object? teaReadySound = null,Object? bearTakingTea = null,Object? ingredients = null,}) {
  return _then(TeaMakingLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,audioInstruction: null == audioInstruction ? _self.audioInstruction : audioInstruction // ignore: cast_nullable_to_non_nullable
as String,teapotVapour: null == teapotVapour ? _self.teapotVapour : teapotVapour // ignore: cast_nullable_to_non_nullable
as String,stoveImage: null == stoveImage ? _self.stoveImage : stoveImage // ignore: cast_nullable_to_non_nullable
as String,abaPaniUmalaSound: null == abaPaniUmalaSound ? _self.abaPaniUmalaSound : abaPaniUmalaSound // ignore: cast_nullable_to_non_nullable
as String,teaReadySound: null == teaReadySound ? _self.teaReadySound : teaReadySound // ignore: cast_nullable_to_non_nullable
as String,bearTakingTea: null == bearTakingTea ? _self.bearTakingTea : bearTakingTea // ignore: cast_nullable_to_non_nullable
as String,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class BallSlideLessonContent implements LessonContent {
  const BallSlideLessonContent({required this.id, required this.index, this.type = 'ball_slide', this.bgImageMobile, this.bgImageTablet, this.player1, this.player2, this.ballImage, this.sliderColor, this.rotateBall = true, this.ballImageEnd, this.direction = 'ltr', final  List<String> conversation = const [], this.angle = 0, this.sliderLengthMb = 1, this.sliderLengthTb = 1, this.pDyMb = 0, this.pDyTb = 0, this.goalLeftImageMb, this.goalLeftImageTb, this.goalRightImageMb, this.goalRightImageTb}): _conversation = conversation;
  factory BallSlideLessonContent.fromJson(Map<String, dynamic> json) => _$BallSlideLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  String? bgImageMobile;
// png
 final  String? bgImageTablet;
// png
 final  String? player1;
//png
 final  String? player2;
//png
 final  String? ballImage;
//png
 final  String? sliderColor;
// Hex color
@JsonKey() final  bool rotateBall;
/// This image[PNG] replaces the ball image when the ball reaches the end
 final  String? ballImageEnd;
@JsonKey() final  String direction;
// ltr, rtl, ltr_heading, rtl_heading, none(only play conversation audios)
 final  List<String> _conversation;
// ltr, rtl, ltr_heading, rtl_heading, none(only play conversation audios)
@JsonKey() List<String> get conversation {
  if (_conversation is EqualUnmodifiableListView) return _conversation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conversation);
}

// List of audio urls
@JsonKey() final  num angle;
@JsonKey() final  num sliderLengthMb;
@JsonKey() final  num sliderLengthTb;
@JsonKey() final  int pDyMb;
@JsonKey() final  int pDyTb;
 final  String? goalLeftImageMb;
//png
 final  String? goalLeftImageTb;
//png
 final  String? goalRightImageMb;
//png
 final  String? goalRightImageTb;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BallSlideLessonContentCopyWith<BallSlideLessonContent> get copyWith => _$BallSlideLessonContentCopyWithImpl<BallSlideLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BallSlideLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BallSlideLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.bgImageMobile, bgImageMobile) || other.bgImageMobile == bgImageMobile)&&(identical(other.bgImageTablet, bgImageTablet) || other.bgImageTablet == bgImageTablet)&&(identical(other.player1, player1) || other.player1 == player1)&&(identical(other.player2, player2) || other.player2 == player2)&&(identical(other.ballImage, ballImage) || other.ballImage == ballImage)&&(identical(other.sliderColor, sliderColor) || other.sliderColor == sliderColor)&&(identical(other.rotateBall, rotateBall) || other.rotateBall == rotateBall)&&(identical(other.ballImageEnd, ballImageEnd) || other.ballImageEnd == ballImageEnd)&&(identical(other.direction, direction) || other.direction == direction)&&const DeepCollectionEquality().equals(other._conversation, _conversation)&&(identical(other.angle, angle) || other.angle == angle)&&(identical(other.sliderLengthMb, sliderLengthMb) || other.sliderLengthMb == sliderLengthMb)&&(identical(other.sliderLengthTb, sliderLengthTb) || other.sliderLengthTb == sliderLengthTb)&&(identical(other.pDyMb, pDyMb) || other.pDyMb == pDyMb)&&(identical(other.pDyTb, pDyTb) || other.pDyTb == pDyTb)&&(identical(other.goalLeftImageMb, goalLeftImageMb) || other.goalLeftImageMb == goalLeftImageMb)&&(identical(other.goalLeftImageTb, goalLeftImageTb) || other.goalLeftImageTb == goalLeftImageTb)&&(identical(other.goalRightImageMb, goalRightImageMb) || other.goalRightImageMb == goalRightImageMb)&&(identical(other.goalRightImageTb, goalRightImageTb) || other.goalRightImageTb == goalRightImageTb));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,index,type,bgImageMobile,bgImageTablet,player1,player2,ballImage,sliderColor,rotateBall,ballImageEnd,direction,const DeepCollectionEquality().hash(_conversation),angle,sliderLengthMb,sliderLengthTb,pDyMb,pDyTb,goalLeftImageMb,goalLeftImageTb,goalRightImageMb,goalRightImageTb]);

@override
String toString() {
  return 'LessonContent.ballSlide(id: $id, index: $index, type: $type, bgImageMobile: $bgImageMobile, bgImageTablet: $bgImageTablet, player1: $player1, player2: $player2, ballImage: $ballImage, sliderColor: $sliderColor, rotateBall: $rotateBall, ballImageEnd: $ballImageEnd, direction: $direction, conversation: $conversation, angle: $angle, sliderLengthMb: $sliderLengthMb, sliderLengthTb: $sliderLengthTb, pDyMb: $pDyMb, pDyTb: $pDyTb, goalLeftImageMb: $goalLeftImageMb, goalLeftImageTb: $goalLeftImageTb, goalRightImageMb: $goalRightImageMb, goalRightImageTb: $goalRightImageTb)';
}


}

/// @nodoc
abstract mixin class $BallSlideLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $BallSlideLessonContentCopyWith(BallSlideLessonContent value, $Res Function(BallSlideLessonContent) _then) = _$BallSlideLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, String? bgImageMobile, String? bgImageTablet, String? player1, String? player2, String? ballImage, String? sliderColor, bool rotateBall, String? ballImageEnd, String direction, List<String> conversation, num angle, num sliderLengthMb, num sliderLengthTb, int pDyMb, int pDyTb, String? goalLeftImageMb, String? goalLeftImageTb, String? goalRightImageMb, String? goalRightImageTb
});




}
/// @nodoc
class _$BallSlideLessonContentCopyWithImpl<$Res>
    implements $BallSlideLessonContentCopyWith<$Res> {
  _$BallSlideLessonContentCopyWithImpl(this._self, this._then);

  final BallSlideLessonContent _self;
  final $Res Function(BallSlideLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? bgImageMobile = freezed,Object? bgImageTablet = freezed,Object? player1 = freezed,Object? player2 = freezed,Object? ballImage = freezed,Object? sliderColor = freezed,Object? rotateBall = null,Object? ballImageEnd = freezed,Object? direction = null,Object? conversation = null,Object? angle = null,Object? sliderLengthMb = null,Object? sliderLengthTb = null,Object? pDyMb = null,Object? pDyTb = null,Object? goalLeftImageMb = freezed,Object? goalLeftImageTb = freezed,Object? goalRightImageMb = freezed,Object? goalRightImageTb = freezed,}) {
  return _then(BallSlideLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,bgImageMobile: freezed == bgImageMobile ? _self.bgImageMobile : bgImageMobile // ignore: cast_nullable_to_non_nullable
as String?,bgImageTablet: freezed == bgImageTablet ? _self.bgImageTablet : bgImageTablet // ignore: cast_nullable_to_non_nullable
as String?,player1: freezed == player1 ? _self.player1 : player1 // ignore: cast_nullable_to_non_nullable
as String?,player2: freezed == player2 ? _self.player2 : player2 // ignore: cast_nullable_to_non_nullable
as String?,ballImage: freezed == ballImage ? _self.ballImage : ballImage // ignore: cast_nullable_to_non_nullable
as String?,sliderColor: freezed == sliderColor ? _self.sliderColor : sliderColor // ignore: cast_nullable_to_non_nullable
as String?,rotateBall: null == rotateBall ? _self.rotateBall : rotateBall // ignore: cast_nullable_to_non_nullable
as bool,ballImageEnd: freezed == ballImageEnd ? _self.ballImageEnd : ballImageEnd // ignore: cast_nullable_to_non_nullable
as String?,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as String,conversation: null == conversation ? _self._conversation : conversation // ignore: cast_nullable_to_non_nullable
as List<String>,angle: null == angle ? _self.angle : angle // ignore: cast_nullable_to_non_nullable
as num,sliderLengthMb: null == sliderLengthMb ? _self.sliderLengthMb : sliderLengthMb // ignore: cast_nullable_to_non_nullable
as num,sliderLengthTb: null == sliderLengthTb ? _self.sliderLengthTb : sliderLengthTb // ignore: cast_nullable_to_non_nullable
as num,pDyMb: null == pDyMb ? _self.pDyMb : pDyMb // ignore: cast_nullable_to_non_nullable
as int,pDyTb: null == pDyTb ? _self.pDyTb : pDyTb // ignore: cast_nullable_to_non_nullable
as int,goalLeftImageMb: freezed == goalLeftImageMb ? _self.goalLeftImageMb : goalLeftImageMb // ignore: cast_nullable_to_non_nullable
as String?,goalLeftImageTb: freezed == goalLeftImageTb ? _self.goalLeftImageTb : goalLeftImageTb // ignore: cast_nullable_to_non_nullable
as String?,goalRightImageMb: freezed == goalRightImageMb ? _self.goalRightImageMb : goalRightImageMb // ignore: cast_nullable_to_non_nullable
as String?,goalRightImageTb: freezed == goalRightImageTb ? _self.goalRightImageTb : goalRightImageTb // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class SlideUpToMatchLessonContent implements LessonContent {
  const SlideUpToMatchLessonContent({required this.id, required this.index, this.type = 'slide_up_to_match', this.bgImage, final  List<Item> items = const []}): _items = items;
  factory SlideUpToMatchLessonContent.fromJson(Map<String, dynamic> json) => _$SlideUpToMatchLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  String? bgImage;
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
$SlideUpToMatchLessonContentCopyWith<SlideUpToMatchLessonContent> get copyWith => _$SlideUpToMatchLessonContentCopyWithImpl<SlideUpToMatchLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlideUpToMatchLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlideUpToMatchLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type,bgImage,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'LessonContent.slideUpToMatch(id: $id, index: $index, type: $type, bgImage: $bgImage, items: $items)';
}


}

/// @nodoc
abstract mixin class $SlideUpToMatchLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $SlideUpToMatchLessonContentCopyWith(SlideUpToMatchLessonContent value, $Res Function(SlideUpToMatchLessonContent) _then) = _$SlideUpToMatchLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, String? bgImage, List<Item> items
});




}
/// @nodoc
class _$SlideUpToMatchLessonContentCopyWithImpl<$Res>
    implements $SlideUpToMatchLessonContentCopyWith<$Res> {
  _$SlideUpToMatchLessonContentCopyWithImpl(this._self, this._then);

  final SlideUpToMatchLessonContent _self;
  final $Res Function(SlideUpToMatchLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? bgImage = freezed,Object? items = null,}) {
  return _then(SlideUpToMatchLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class FlipCardLessonContent implements LessonContent {
  const FlipCardLessonContent({required this.id, required this.index, this.type = 'flip_card', this.bgImage, final  List<Item> items = const []}): _items = items;
  factory FlipCardLessonContent.fromJson(Map<String, dynamic> json) => _$FlipCardLessonContentFromJson(json);

@override final  String id;
@override final  int index;
@override@JsonKey() final  String type;
 final  String? bgImage;
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
$FlipCardLessonContentCopyWith<FlipCardLessonContent> get copyWith => _$FlipCardLessonContentCopyWithImpl<FlipCardLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlipCardLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlipCardLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.type, type) || other.type == type)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,type,bgImage,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'LessonContent.flipCard(id: $id, index: $index, type: $type, bgImage: $bgImage, items: $items)';
}


}

/// @nodoc
abstract mixin class $FlipCardLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $FlipCardLessonContentCopyWith(FlipCardLessonContent value, $Res Function(FlipCardLessonContent) _then) = _$FlipCardLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String type, String? bgImage, List<Item> items
});




}
/// @nodoc
class _$FlipCardLessonContentCopyWithImpl<$Res>
    implements $FlipCardLessonContentCopyWith<$Res> {
  _$FlipCardLessonContentCopyWithImpl(this._self, this._then);

  final FlipCardLessonContent _self;
  final $Res Function(FlipCardLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? type = null,Object? bgImage = freezed,Object? items = null,}) {
  return _then(FlipCardLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class BalloonFillLessonContent implements LessonContent {
  const BalloonFillLessonContent({required this.id, required this.index, this.audio, this.type = 'balloon_fill', this.bgImage, this.bgImageTb, final  List<Item> items = const []}): _items = items;
  factory BalloonFillLessonContent.fromJson(Map<String, dynamic> json) => _$BalloonFillLessonContentFromJson(json);

@override final  String id;
@override final  int index;
 final  String? audio;
@override@JsonKey() final  String type;
 final  String? bgImage;
 final  String? bgImageTb;
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
$BalloonFillLessonContentCopyWith<BalloonFillLessonContent> get copyWith => _$BalloonFillLessonContentCopyWithImpl<BalloonFillLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BalloonFillLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BalloonFillLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.audio, audio) || other.audio == audio)&&(identical(other.type, type) || other.type == type)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.bgImageTb, bgImageTb) || other.bgImageTb == bgImageTb)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,audio,type,bgImage,bgImageTb,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'LessonContent.balloonFill(id: $id, index: $index, audio: $audio, type: $type, bgImage: $bgImage, bgImageTb: $bgImageTb, items: $items)';
}


}

/// @nodoc
abstract mixin class $BalloonFillLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $BalloonFillLessonContentCopyWith(BalloonFillLessonContent value, $Res Function(BalloonFillLessonContent) _then) = _$BalloonFillLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String? audio, String type, String? bgImage, String? bgImageTb, List<Item> items
});




}
/// @nodoc
class _$BalloonFillLessonContentCopyWithImpl<$Res>
    implements $BalloonFillLessonContentCopyWith<$Res> {
  _$BalloonFillLessonContentCopyWithImpl(this._self, this._then);

  final BalloonFillLessonContent _self;
  final $Res Function(BalloonFillLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? audio = freezed,Object? type = null,Object? bgImage = freezed,Object? bgImageTb = freezed,Object? items = null,}) {
  return _then(BalloonFillLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,audio: freezed == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,bgImageTb: freezed == bgImageTb ? _self.bgImageTb : bgImageTb // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GunFillLessonContent implements LessonContent {
  const GunFillLessonContent({required this.id, required this.index, this.audio, this.type = 'gun_fill', this.bgImage, this.bgImageTb, final  List<Item> items = const []}): _items = items;
  factory GunFillLessonContent.fromJson(Map<String, dynamic> json) => _$GunFillLessonContentFromJson(json);

@override final  String id;
@override final  int index;
 final  String? audio;
@override@JsonKey() final  String type;
 final  String? bgImage;
// Svg Image
 final  String? bgImageTb;
// Svg Image
 final  List<Item> _items;
// Svg Image
@JsonKey() List<Item> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GunFillLessonContentCopyWith<GunFillLessonContent> get copyWith => _$GunFillLessonContentCopyWithImpl<GunFillLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GunFillLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GunFillLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.audio, audio) || other.audio == audio)&&(identical(other.type, type) || other.type == type)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.bgImageTb, bgImageTb) || other.bgImageTb == bgImageTb)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,audio,type,bgImage,bgImageTb,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'LessonContent.gunFill(id: $id, index: $index, audio: $audio, type: $type, bgImage: $bgImage, bgImageTb: $bgImageTb, items: $items)';
}


}

/// @nodoc
abstract mixin class $GunFillLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $GunFillLessonContentCopyWith(GunFillLessonContent value, $Res Function(GunFillLessonContent) _then) = _$GunFillLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String? audio, String type, String? bgImage, String? bgImageTb, List<Item> items
});




}
/// @nodoc
class _$GunFillLessonContentCopyWithImpl<$Res>
    implements $GunFillLessonContentCopyWith<$Res> {
  _$GunFillLessonContentCopyWithImpl(this._self, this._then);

  final GunFillLessonContent _self;
  final $Res Function(GunFillLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? audio = freezed,Object? type = null,Object? bgImage = freezed,Object? bgImageTb = freezed,Object? items = null,}) {
  return _then(GunFillLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,audio: freezed == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,bgImageTb: freezed == bgImageTb ? _self.bgImageTb : bgImageTb // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class HoliAnimateLessonContent implements LessonContent {
  const HoliAnimateLessonContent({required this.id, required this.index, this.audio, this.type = 'holi_animate', this.bgImage, this.bgImageTb, required this.image, final  List<Item> items = const []}): _items = items;
  factory HoliAnimateLessonContent.fromJson(Map<String, dynamic> json) => _$HoliAnimateLessonContentFromJson(json);

@override final  String id;
@override final  int index;
 final  String? audio;
@override@JsonKey() final  String type;
 final  String? bgImage;
// png Image
 final  String? bgImageTb;
// png Image
 final  String image;
// Image to animate
 final  List<Item> _items;
// Image to animate
@JsonKey() List<Item> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HoliAnimateLessonContentCopyWith<HoliAnimateLessonContent> get copyWith => _$HoliAnimateLessonContentCopyWithImpl<HoliAnimateLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HoliAnimateLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HoliAnimateLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.audio, audio) || other.audio == audio)&&(identical(other.type, type) || other.type == type)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.bgImageTb, bgImageTb) || other.bgImageTb == bgImageTb)&&(identical(other.image, image) || other.image == image)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,audio,type,bgImage,bgImageTb,image,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'LessonContent.holiAnimate(id: $id, index: $index, audio: $audio, type: $type, bgImage: $bgImage, bgImageTb: $bgImageTb, image: $image, items: $items)';
}


}

/// @nodoc
abstract mixin class $HoliAnimateLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $HoliAnimateLessonContentCopyWith(HoliAnimateLessonContent value, $Res Function(HoliAnimateLessonContent) _then) = _$HoliAnimateLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String? audio, String type, String? bgImage, String? bgImageTb, String image, List<Item> items
});




}
/// @nodoc
class _$HoliAnimateLessonContentCopyWithImpl<$Res>
    implements $HoliAnimateLessonContentCopyWith<$Res> {
  _$HoliAnimateLessonContentCopyWithImpl(this._self, this._then);

  final HoliAnimateLessonContent _self;
  final $Res Function(HoliAnimateLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? audio = freezed,Object? type = null,Object? bgImage = freezed,Object? bgImageTb = freezed,Object? image = null,Object? items = null,}) {
  return _then(HoliAnimateLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,audio: freezed == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,bgImage: freezed == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String?,bgImageTb: freezed == bgImageTb ? _self.bgImageTb : bgImageTb // ignore: cast_nullable_to_non_nullable
as String?,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TapToChangeLessonContent implements LessonContent {
  const TapToChangeLessonContent({required this.id, required this.index, this.audio, this.type = 'tap_to_change', required this.bgImage, required this.afterBgImage, required this.bgImageTb, required this.afterBgImageTb, this.tapGesture, this.splashImage, final  List<Item> items = const []}): _items = items;
  factory TapToChangeLessonContent.fromJson(Map<String, dynamic> json) => _$TapToChangeLessonContentFromJson(json);

@override final  String id;
@override final  int index;
 final  String? audio;
@override@JsonKey() final  String type;
 final  String bgImage;
// png Image
 final  String afterBgImage;
 final  String bgImageTb;
// png Image
 final  String afterBgImageTb;
 final  String? tapGesture;
// Png image
 final  String? splashImage;
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
$TapToChangeLessonContentCopyWith<TapToChangeLessonContent> get copyWith => _$TapToChangeLessonContentCopyWithImpl<TapToChangeLessonContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TapToChangeLessonContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TapToChangeLessonContent&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.audio, audio) || other.audio == audio)&&(identical(other.type, type) || other.type == type)&&(identical(other.bgImage, bgImage) || other.bgImage == bgImage)&&(identical(other.afterBgImage, afterBgImage) || other.afterBgImage == afterBgImage)&&(identical(other.bgImageTb, bgImageTb) || other.bgImageTb == bgImageTb)&&(identical(other.afterBgImageTb, afterBgImageTb) || other.afterBgImageTb == afterBgImageTb)&&(identical(other.tapGesture, tapGesture) || other.tapGesture == tapGesture)&&(identical(other.splashImage, splashImage) || other.splashImage == splashImage)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,index,audio,type,bgImage,afterBgImage,bgImageTb,afterBgImageTb,tapGesture,splashImage,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'LessonContent.tapToChange(id: $id, index: $index, audio: $audio, type: $type, bgImage: $bgImage, afterBgImage: $afterBgImage, bgImageTb: $bgImageTb, afterBgImageTb: $afterBgImageTb, tapGesture: $tapGesture, splashImage: $splashImage, items: $items)';
}


}

/// @nodoc
abstract mixin class $TapToChangeLessonContentCopyWith<$Res> implements $LessonContentCopyWith<$Res> {
  factory $TapToChangeLessonContentCopyWith(TapToChangeLessonContent value, $Res Function(TapToChangeLessonContent) _then) = _$TapToChangeLessonContentCopyWithImpl;
@override @useResult
$Res call({
 String id, int index, String? audio, String type, String bgImage, String afterBgImage, String bgImageTb, String afterBgImageTb, String? tapGesture, String? splashImage, List<Item> items
});




}
/// @nodoc
class _$TapToChangeLessonContentCopyWithImpl<$Res>
    implements $TapToChangeLessonContentCopyWith<$Res> {
  _$TapToChangeLessonContentCopyWithImpl(this._self, this._then);

  final TapToChangeLessonContent _self;
  final $Res Function(TapToChangeLessonContent) _then;

/// Create a copy of LessonContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? index = null,Object? audio = freezed,Object? type = null,Object? bgImage = null,Object? afterBgImage = null,Object? bgImageTb = null,Object? afterBgImageTb = null,Object? tapGesture = freezed,Object? splashImage = freezed,Object? items = null,}) {
  return _then(TapToChangeLessonContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,audio: freezed == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,bgImage: null == bgImage ? _self.bgImage : bgImage // ignore: cast_nullable_to_non_nullable
as String,afterBgImage: null == afterBgImage ? _self.afterBgImage : afterBgImage // ignore: cast_nullable_to_non_nullable
as String,bgImageTb: null == bgImageTb ? _self.bgImageTb : bgImageTb // ignore: cast_nullable_to_non_nullable
as String,afterBgImageTb: null == afterBgImageTb ? _self.afterBgImageTb : afterBgImageTb // ignore: cast_nullable_to_non_nullable
as String,tapGesture: freezed == tapGesture ? _self.tapGesture : tapGesture // ignore: cast_nullable_to_non_nullable
as String?,splashImage: freezed == splashImage ? _self.splashImage : splashImage // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
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

 int? get order; String get nameEn; String get nameNp; String get image; bool get isImageSvg; String? get bgColor; String? get imageOutline; bool get isImageOutlineSvg; String? get outlineBgColor; String? get question;// eg where is the cat
 String? get audioItem;// Cat pronunciation
 String? get audioBg;// eg cat sound meww, dog sound barking
 num? get dxRatio; num? get dyRatio; num? get dxRatioMobile; num? get dyRatioMobile; bool get isCorrect;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.order, order) || other.order == order)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.image, image) || other.image == image)&&(identical(other.isImageSvg, isImageSvg) || other.isImageSvg == isImageSvg)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.imageOutline, imageOutline) || other.imageOutline == imageOutline)&&(identical(other.isImageOutlineSvg, isImageOutlineSvg) || other.isImageOutlineSvg == isImageOutlineSvg)&&(identical(other.outlineBgColor, outlineBgColor) || other.outlineBgColor == outlineBgColor)&&(identical(other.question, question) || other.question == question)&&(identical(other.audioItem, audioItem) || other.audioItem == audioItem)&&(identical(other.audioBg, audioBg) || other.audioBg == audioBg)&&(identical(other.dxRatio, dxRatio) || other.dxRatio == dxRatio)&&(identical(other.dyRatio, dyRatio) || other.dyRatio == dyRatio)&&(identical(other.dxRatioMobile, dxRatioMobile) || other.dxRatioMobile == dxRatioMobile)&&(identical(other.dyRatioMobile, dyRatioMobile) || other.dyRatioMobile == dyRatioMobile)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,nameEn,nameNp,image,isImageSvg,bgColor,imageOutline,isImageOutlineSvg,outlineBgColor,question,audioItem,audioBg,dxRatio,dyRatio,dxRatioMobile,dyRatioMobile,isCorrect);

@override
String toString() {
  return 'Item(order: $order, nameEn: $nameEn, nameNp: $nameNp, image: $image, isImageSvg: $isImageSvg, bgColor: $bgColor, imageOutline: $imageOutline, isImageOutlineSvg: $isImageOutlineSvg, outlineBgColor: $outlineBgColor, question: $question, audioItem: $audioItem, audioBg: $audioBg, dxRatio: $dxRatio, dyRatio: $dyRatio, dxRatioMobile: $dxRatioMobile, dyRatioMobile: $dyRatioMobile, isCorrect: $isCorrect)';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 int? order, String nameEn, String nameNp, String image, bool isImageSvg, String? bgColor, String? imageOutline, bool isImageOutlineSvg, String? outlineBgColor, String? question, String? audioItem, String? audioBg, num? dxRatio, num? dyRatio, num? dxRatioMobile, num? dyRatioMobile, bool isCorrect
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
@pragma('vm:prefer-inline') @override $Res call({Object? order = freezed,Object? nameEn = null,Object? nameNp = null,Object? image = null,Object? isImageSvg = null,Object? bgColor = freezed,Object? imageOutline = freezed,Object? isImageOutlineSvg = null,Object? outlineBgColor = freezed,Object? question = freezed,Object? audioItem = freezed,Object? audioBg = freezed,Object? dxRatio = freezed,Object? dyRatio = freezed,Object? dxRatioMobile = freezed,Object? dyRatioMobile = freezed,Object? isCorrect = null,}) {
  return _then(_self.copyWith(
order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,isImageSvg: null == isImageSvg ? _self.isImageSvg : isImageSvg // ignore: cast_nullable_to_non_nullable
as bool,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as String?,imageOutline: freezed == imageOutline ? _self.imageOutline : imageOutline // ignore: cast_nullable_to_non_nullable
as String?,isImageOutlineSvg: null == isImageOutlineSvg ? _self.isImageOutlineSvg : isImageOutlineSvg // ignore: cast_nullable_to_non_nullable
as bool,outlineBgColor: freezed == outlineBgColor ? _self.outlineBgColor : outlineBgColor // ignore: cast_nullable_to_non_nullable
as String?,question: freezed == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String?,audioItem: freezed == audioItem ? _self.audioItem : audioItem // ignore: cast_nullable_to_non_nullable
as String?,audioBg: freezed == audioBg ? _self.audioBg : audioBg // ignore: cast_nullable_to_non_nullable
as String?,dxRatio: freezed == dxRatio ? _self.dxRatio : dxRatio // ignore: cast_nullable_to_non_nullable
as num?,dyRatio: freezed == dyRatio ? _self.dyRatio : dyRatio // ignore: cast_nullable_to_non_nullable
as num?,dxRatioMobile: freezed == dxRatioMobile ? _self.dxRatioMobile : dxRatioMobile // ignore: cast_nullable_to_non_nullable
as num?,dyRatioMobile: freezed == dyRatioMobile ? _self.dyRatioMobile : dyRatioMobile // ignore: cast_nullable_to_non_nullable
as num?,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? order,  String nameEn,  String nameNp,  String image,  bool isImageSvg,  String? bgColor,  String? imageOutline,  bool isImageOutlineSvg,  String? outlineBgColor,  String? question,  String? audioItem,  String? audioBg,  num? dxRatio,  num? dyRatio,  num? dxRatioMobile,  num? dyRatioMobile,  bool isCorrect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.order,_that.nameEn,_that.nameNp,_that.image,_that.isImageSvg,_that.bgColor,_that.imageOutline,_that.isImageOutlineSvg,_that.outlineBgColor,_that.question,_that.audioItem,_that.audioBg,_that.dxRatio,_that.dyRatio,_that.dxRatioMobile,_that.dyRatioMobile,_that.isCorrect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? order,  String nameEn,  String nameNp,  String image,  bool isImageSvg,  String? bgColor,  String? imageOutline,  bool isImageOutlineSvg,  String? outlineBgColor,  String? question,  String? audioItem,  String? audioBg,  num? dxRatio,  num? dyRatio,  num? dxRatioMobile,  num? dyRatioMobile,  bool isCorrect)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.order,_that.nameEn,_that.nameNp,_that.image,_that.isImageSvg,_that.bgColor,_that.imageOutline,_that.isImageOutlineSvg,_that.outlineBgColor,_that.question,_that.audioItem,_that.audioBg,_that.dxRatio,_that.dyRatio,_that.dxRatioMobile,_that.dyRatioMobile,_that.isCorrect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? order,  String nameEn,  String nameNp,  String image,  bool isImageSvg,  String? bgColor,  String? imageOutline,  bool isImageOutlineSvg,  String? outlineBgColor,  String? question,  String? audioItem,  String? audioBg,  num? dxRatio,  num? dyRatio,  num? dxRatioMobile,  num? dyRatioMobile,  bool isCorrect)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.order,_that.nameEn,_that.nameNp,_that.image,_that.isImageSvg,_that.bgColor,_that.imageOutline,_that.isImageOutlineSvg,_that.outlineBgColor,_that.question,_that.audioItem,_that.audioBg,_that.dxRatio,_that.dyRatio,_that.dxRatioMobile,_that.dyRatioMobile,_that.isCorrect);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Item implements Item {
  const _Item({this.order, required this.nameEn, required this.nameNp, required this.image, this.isImageSvg = false, this.bgColor, this.imageOutline, this.isImageOutlineSvg = false, this.outlineBgColor, this.question, this.audioItem, this.audioBg, this.dxRatio, this.dyRatio, this.dxRatioMobile, this.dyRatioMobile, this.isCorrect = false});
  factory _Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

@override final  int? order;
@override final  String nameEn;
@override final  String nameNp;
@override final  String image;
@override@JsonKey() final  bool isImageSvg;
@override final  String? bgColor;
@override final  String? imageOutline;
@override@JsonKey() final  bool isImageOutlineSvg;
@override final  String? outlineBgColor;
@override final  String? question;
// eg where is the cat
@override final  String? audioItem;
// Cat pronunciation
@override final  String? audioBg;
// eg cat sound meww, dog sound barking
@override final  num? dxRatio;
@override final  num? dyRatio;
@override final  num? dxRatioMobile;
@override final  num? dyRatioMobile;
@override@JsonKey() final  bool isCorrect;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.order, order) || other.order == order)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.image, image) || other.image == image)&&(identical(other.isImageSvg, isImageSvg) || other.isImageSvg == isImageSvg)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.imageOutline, imageOutline) || other.imageOutline == imageOutline)&&(identical(other.isImageOutlineSvg, isImageOutlineSvg) || other.isImageOutlineSvg == isImageOutlineSvg)&&(identical(other.outlineBgColor, outlineBgColor) || other.outlineBgColor == outlineBgColor)&&(identical(other.question, question) || other.question == question)&&(identical(other.audioItem, audioItem) || other.audioItem == audioItem)&&(identical(other.audioBg, audioBg) || other.audioBg == audioBg)&&(identical(other.dxRatio, dxRatio) || other.dxRatio == dxRatio)&&(identical(other.dyRatio, dyRatio) || other.dyRatio == dyRatio)&&(identical(other.dxRatioMobile, dxRatioMobile) || other.dxRatioMobile == dxRatioMobile)&&(identical(other.dyRatioMobile, dyRatioMobile) || other.dyRatioMobile == dyRatioMobile)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,order,nameEn,nameNp,image,isImageSvg,bgColor,imageOutline,isImageOutlineSvg,outlineBgColor,question,audioItem,audioBg,dxRatio,dyRatio,dxRatioMobile,dyRatioMobile,isCorrect);

@override
String toString() {
  return 'Item(order: $order, nameEn: $nameEn, nameNp: $nameNp, image: $image, isImageSvg: $isImageSvg, bgColor: $bgColor, imageOutline: $imageOutline, isImageOutlineSvg: $isImageOutlineSvg, outlineBgColor: $outlineBgColor, question: $question, audioItem: $audioItem, audioBg: $audioBg, dxRatio: $dxRatio, dyRatio: $dyRatio, dxRatioMobile: $dxRatioMobile, dyRatioMobile: $dyRatioMobile, isCorrect: $isCorrect)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 int? order, String nameEn, String nameNp, String image, bool isImageSvg, String? bgColor, String? imageOutline, bool isImageOutlineSvg, String? outlineBgColor, String? question, String? audioItem, String? audioBg, num? dxRatio, num? dyRatio, num? dxRatioMobile, num? dyRatioMobile, bool isCorrect
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
@override @pragma('vm:prefer-inline') $Res call({Object? order = freezed,Object? nameEn = null,Object? nameNp = null,Object? image = null,Object? isImageSvg = null,Object? bgColor = freezed,Object? imageOutline = freezed,Object? isImageOutlineSvg = null,Object? outlineBgColor = freezed,Object? question = freezed,Object? audioItem = freezed,Object? audioBg = freezed,Object? dxRatio = freezed,Object? dyRatio = freezed,Object? dxRatioMobile = freezed,Object? dyRatioMobile = freezed,Object? isCorrect = null,}) {
  return _then(_Item(
order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,isImageSvg: null == isImageSvg ? _self.isImageSvg : isImageSvg // ignore: cast_nullable_to_non_nullable
as bool,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as String?,imageOutline: freezed == imageOutline ? _self.imageOutline : imageOutline // ignore: cast_nullable_to_non_nullable
as String?,isImageOutlineSvg: null == isImageOutlineSvg ? _self.isImageOutlineSvg : isImageOutlineSvg // ignore: cast_nullable_to_non_nullable
as bool,outlineBgColor: freezed == outlineBgColor ? _self.outlineBgColor : outlineBgColor // ignore: cast_nullable_to_non_nullable
as String?,question: freezed == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String?,audioItem: freezed == audioItem ? _self.audioItem : audioItem // ignore: cast_nullable_to_non_nullable
as String?,audioBg: freezed == audioBg ? _self.audioBg : audioBg // ignore: cast_nullable_to_non_nullable
as String?,dxRatio: freezed == dxRatio ? _self.dxRatio : dxRatio // ignore: cast_nullable_to_non_nullable
as num?,dyRatio: freezed == dyRatio ? _self.dyRatio : dyRatio // ignore: cast_nullable_to_non_nullable
as num?,dxRatioMobile: freezed == dxRatioMobile ? _self.dxRatioMobile : dxRatioMobile // ignore: cast_nullable_to_non_nullable
as num?,dyRatioMobile: freezed == dyRatioMobile ? _self.dyRatioMobile : dyRatioMobile // ignore: cast_nullable_to_non_nullable
as num?,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
