// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoryModel {

@JsonKey(name: 'level_id') String get levelId; String get nameEn; String get nameNp; String get thumbnail; String get lottie;@JsonKey(fromJson: _stringListFromJson) List<String> get audio; String get tooltip; String get description; List<Content> get content;@JsonKey(name: 'bg_color') String? get bgColor;
/// Create a copy of StoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryModelCopyWith<StoryModel> get copyWith => _$StoryModelCopyWithImpl<StoryModel>(this as StoryModel, _$identity);

  /// Serializes this StoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryModel&&(identical(other.levelId, levelId) || other.levelId == levelId)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.lottie, lottie) || other.lottie == lottie)&&const DeepCollectionEquality().equals(other.audio, audio)&&(identical(other.tooltip, tooltip) || other.tooltip == tooltip)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,levelId,nameEn,nameNp,thumbnail,lottie,const DeepCollectionEquality().hash(audio),tooltip,description,const DeepCollectionEquality().hash(content),bgColor);

@override
String toString() {
  return 'StoryModel(levelId: $levelId, nameEn: $nameEn, nameNp: $nameNp, thumbnail: $thumbnail, lottie: $lottie, audio: $audio, tooltip: $tooltip, description: $description, content: $content, bgColor: $bgColor)';
}


}

/// @nodoc
abstract mixin class $StoryModelCopyWith<$Res>  {
  factory $StoryModelCopyWith(StoryModel value, $Res Function(StoryModel) _then) = _$StoryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'level_id') String levelId, String nameEn, String nameNp, String thumbnail, String lottie,@JsonKey(fromJson: _stringListFromJson) List<String> audio, String tooltip, String description, List<Content> content,@JsonKey(name: 'bg_color') String? bgColor
});




}
/// @nodoc
class _$StoryModelCopyWithImpl<$Res>
    implements $StoryModelCopyWith<$Res> {
  _$StoryModelCopyWithImpl(this._self, this._then);

  final StoryModel _self;
  final $Res Function(StoryModel) _then;

/// Create a copy of StoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? levelId = null,Object? nameEn = null,Object? nameNp = null,Object? thumbnail = null,Object? lottie = null,Object? audio = null,Object? tooltip = null,Object? description = null,Object? content = null,Object? bgColor = freezed,}) {
  return _then(_self.copyWith(
levelId: null == levelId ? _self.levelId : levelId // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,lottie: null == lottie ? _self.lottie : lottie // ignore: cast_nullable_to_non_nullable
as String,audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as List<String>,tooltip: null == tooltip ? _self.tooltip : tooltip // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<Content>,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryModel].
extension StoryModelPatterns on StoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryModel value)  $default,){
final _that = this;
switch (_that) {
case _StoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _StoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'level_id')  String levelId,  String nameEn,  String nameNp,  String thumbnail,  String lottie, @JsonKey(fromJson: _stringListFromJson)  List<String> audio,  String tooltip,  String description,  List<Content> content, @JsonKey(name: 'bg_color')  String? bgColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryModel() when $default != null:
return $default(_that.levelId,_that.nameEn,_that.nameNp,_that.thumbnail,_that.lottie,_that.audio,_that.tooltip,_that.description,_that.content,_that.bgColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'level_id')  String levelId,  String nameEn,  String nameNp,  String thumbnail,  String lottie, @JsonKey(fromJson: _stringListFromJson)  List<String> audio,  String tooltip,  String description,  List<Content> content, @JsonKey(name: 'bg_color')  String? bgColor)  $default,) {final _that = this;
switch (_that) {
case _StoryModel():
return $default(_that.levelId,_that.nameEn,_that.nameNp,_that.thumbnail,_that.lottie,_that.audio,_that.tooltip,_that.description,_that.content,_that.bgColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'level_id')  String levelId,  String nameEn,  String nameNp,  String thumbnail,  String lottie, @JsonKey(fromJson: _stringListFromJson)  List<String> audio,  String tooltip,  String description,  List<Content> content, @JsonKey(name: 'bg_color')  String? bgColor)?  $default,) {final _that = this;
switch (_that) {
case _StoryModel() when $default != null:
return $default(_that.levelId,_that.nameEn,_that.nameNp,_that.thumbnail,_that.lottie,_that.audio,_that.tooltip,_that.description,_that.content,_that.bgColor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _StoryModel implements StoryModel {
  const _StoryModel({@JsonKey(name: 'level_id') this.levelId = '', this.nameEn = '', this.nameNp = '', this.thumbnail = '', this.lottie = '', @JsonKey(fromJson: _stringListFromJson) final  List<String> audio = const <String>[], this.tooltip = '', this.description = '', final  List<Content> content = const <Content>[], @JsonKey(name: 'bg_color') this.bgColor}): _audio = audio,_content = content;
  factory _StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);

@override@JsonKey(name: 'level_id') final  String levelId;
@override@JsonKey() final  String nameEn;
@override@JsonKey() final  String nameNp;
@override@JsonKey() final  String thumbnail;
@override@JsonKey() final  String lottie;
 final  List<String> _audio;
@override@JsonKey(fromJson: _stringListFromJson) List<String> get audio {
  if (_audio is EqualUnmodifiableListView) return _audio;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_audio);
}

@override@JsonKey() final  String tooltip;
@override@JsonKey() final  String description;
 final  List<Content> _content;
@override@JsonKey() List<Content> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override@JsonKey(name: 'bg_color') final  String? bgColor;

/// Create a copy of StoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryModelCopyWith<_StoryModel> get copyWith => __$StoryModelCopyWithImpl<_StoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryModel&&(identical(other.levelId, levelId) || other.levelId == levelId)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameNp, nameNp) || other.nameNp == nameNp)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.lottie, lottie) || other.lottie == lottie)&&const DeepCollectionEquality().equals(other._audio, _audio)&&(identical(other.tooltip, tooltip) || other.tooltip == tooltip)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._content, _content)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,levelId,nameEn,nameNp,thumbnail,lottie,const DeepCollectionEquality().hash(_audio),tooltip,description,const DeepCollectionEquality().hash(_content),bgColor);

@override
String toString() {
  return 'StoryModel(levelId: $levelId, nameEn: $nameEn, nameNp: $nameNp, thumbnail: $thumbnail, lottie: $lottie, audio: $audio, tooltip: $tooltip, description: $description, content: $content, bgColor: $bgColor)';
}


}

/// @nodoc
abstract mixin class _$StoryModelCopyWith<$Res> implements $StoryModelCopyWith<$Res> {
  factory _$StoryModelCopyWith(_StoryModel value, $Res Function(_StoryModel) _then) = __$StoryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'level_id') String levelId, String nameEn, String nameNp, String thumbnail, String lottie,@JsonKey(fromJson: _stringListFromJson) List<String> audio, String tooltip, String description, List<Content> content,@JsonKey(name: 'bg_color') String? bgColor
});




}
/// @nodoc
class __$StoryModelCopyWithImpl<$Res>
    implements _$StoryModelCopyWith<$Res> {
  __$StoryModelCopyWithImpl(this._self, this._then);

  final _StoryModel _self;
  final $Res Function(_StoryModel) _then;

/// Create a copy of StoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? levelId = null,Object? nameEn = null,Object? nameNp = null,Object? thumbnail = null,Object? lottie = null,Object? audio = null,Object? tooltip = null,Object? description = null,Object? content = null,Object? bgColor = freezed,}) {
  return _then(_StoryModel(
levelId: null == levelId ? _self.levelId : levelId // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,nameNp: null == nameNp ? _self.nameNp : nameNp // ignore: cast_nullable_to_non_nullable
as String,thumbnail: null == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String,lottie: null == lottie ? _self.lottie : lottie // ignore: cast_nullable_to_non_nullable
as String,audio: null == audio ? _self._audio : audio // ignore: cast_nullable_to_non_nullable
as List<String>,tooltip: null == tooltip ? _self.tooltip : tooltip // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<Content>,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Content {

 String get image;@JsonKey(name: 'image_tb') String? get imageTb;// for tablet
@JsonKey(name: 'image_success') String? get imageSuccess;@JsonKey(name: 'image_success_tb') String? get imageSuccessTb;@JsonKey(fromJson: _stringListFromJson) List<String> get audio; String get lottie; String get type; List<Conversation> get conversation;@JsonKey(name: 'character', fromJson: _stringListFromJson) List<String> get characters; String get confetti;
/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentCopyWith<Content> get copyWith => _$ContentCopyWithImpl<Content>(this as Content, _$identity);

  /// Serializes this Content to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Content&&(identical(other.image, image) || other.image == image)&&(identical(other.imageTb, imageTb) || other.imageTb == imageTb)&&(identical(other.imageSuccess, imageSuccess) || other.imageSuccess == imageSuccess)&&(identical(other.imageSuccessTb, imageSuccessTb) || other.imageSuccessTb == imageSuccessTb)&&const DeepCollectionEquality().equals(other.audio, audio)&&(identical(other.lottie, lottie) || other.lottie == lottie)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.conversation, conversation)&&const DeepCollectionEquality().equals(other.characters, characters)&&(identical(other.confetti, confetti) || other.confetti == confetti));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,image,imageTb,imageSuccess,imageSuccessTb,const DeepCollectionEquality().hash(audio),lottie,type,const DeepCollectionEquality().hash(conversation),const DeepCollectionEquality().hash(characters),confetti);

@override
String toString() {
  return 'Content(image: $image, imageTb: $imageTb, imageSuccess: $imageSuccess, imageSuccessTb: $imageSuccessTb, audio: $audio, lottie: $lottie, type: $type, conversation: $conversation, characters: $characters, confetti: $confetti)';
}


}

/// @nodoc
abstract mixin class $ContentCopyWith<$Res>  {
  factory $ContentCopyWith(Content value, $Res Function(Content) _then) = _$ContentCopyWithImpl;
@useResult
$Res call({
 String image,@JsonKey(name: 'image_tb') String? imageTb,@JsonKey(name: 'image_success') String? imageSuccess,@JsonKey(name: 'image_success_tb') String? imageSuccessTb,@JsonKey(fromJson: _stringListFromJson) List<String> audio, String lottie, String type, List<Conversation> conversation,@JsonKey(name: 'character', fromJson: _stringListFromJson) List<String> characters, String confetti
});




}
/// @nodoc
class _$ContentCopyWithImpl<$Res>
    implements $ContentCopyWith<$Res> {
  _$ContentCopyWithImpl(this._self, this._then);

  final Content _self;
  final $Res Function(Content) _then;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? image = null,Object? imageTb = freezed,Object? imageSuccess = freezed,Object? imageSuccessTb = freezed,Object? audio = null,Object? lottie = null,Object? type = null,Object? conversation = null,Object? characters = null,Object? confetti = null,}) {
  return _then(_self.copyWith(
image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,imageTb: freezed == imageTb ? _self.imageTb : imageTb // ignore: cast_nullable_to_non_nullable
as String?,imageSuccess: freezed == imageSuccess ? _self.imageSuccess : imageSuccess // ignore: cast_nullable_to_non_nullable
as String?,imageSuccessTb: freezed == imageSuccessTb ? _self.imageSuccessTb : imageSuccessTb // ignore: cast_nullable_to_non_nullable
as String?,audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as List<String>,lottie: null == lottie ? _self.lottie : lottie // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,conversation: null == conversation ? _self.conversation : conversation // ignore: cast_nullable_to_non_nullable
as List<Conversation>,characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as List<String>,confetti: null == confetti ? _self.confetti : confetti // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Content].
extension ContentPatterns on Content {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Content value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Content() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Content value)  $default,){
final _that = this;
switch (_that) {
case _Content():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Content value)?  $default,){
final _that = this;
switch (_that) {
case _Content() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String image, @JsonKey(name: 'image_tb')  String? imageTb, @JsonKey(name: 'image_success')  String? imageSuccess, @JsonKey(name: 'image_success_tb')  String? imageSuccessTb, @JsonKey(fromJson: _stringListFromJson)  List<String> audio,  String lottie,  String type,  List<Conversation> conversation, @JsonKey(name: 'character', fromJson: _stringListFromJson)  List<String> characters,  String confetti)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Content() when $default != null:
return $default(_that.image,_that.imageTb,_that.imageSuccess,_that.imageSuccessTb,_that.audio,_that.lottie,_that.type,_that.conversation,_that.characters,_that.confetti);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String image, @JsonKey(name: 'image_tb')  String? imageTb, @JsonKey(name: 'image_success')  String? imageSuccess, @JsonKey(name: 'image_success_tb')  String? imageSuccessTb, @JsonKey(fromJson: _stringListFromJson)  List<String> audio,  String lottie,  String type,  List<Conversation> conversation, @JsonKey(name: 'character', fromJson: _stringListFromJson)  List<String> characters,  String confetti)  $default,) {final _that = this;
switch (_that) {
case _Content():
return $default(_that.image,_that.imageTb,_that.imageSuccess,_that.imageSuccessTb,_that.audio,_that.lottie,_that.type,_that.conversation,_that.characters,_that.confetti);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String image, @JsonKey(name: 'image_tb')  String? imageTb, @JsonKey(name: 'image_success')  String? imageSuccess, @JsonKey(name: 'image_success_tb')  String? imageSuccessTb, @JsonKey(fromJson: _stringListFromJson)  List<String> audio,  String lottie,  String type,  List<Conversation> conversation, @JsonKey(name: 'character', fromJson: _stringListFromJson)  List<String> characters,  String confetti)?  $default,) {final _that = this;
switch (_that) {
case _Content() when $default != null:
return $default(_that.image,_that.imageTb,_that.imageSuccess,_that.imageSuccessTb,_that.audio,_that.lottie,_that.type,_that.conversation,_that.characters,_that.confetti);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Content implements Content {
  const _Content({this.image = '', @JsonKey(name: 'image_tb') this.imageTb, @JsonKey(name: 'image_success') this.imageSuccess, @JsonKey(name: 'image_success_tb') this.imageSuccessTb, @JsonKey(fromJson: _stringListFromJson) final  List<String> audio = const <String>[], this.lottie = '', this.type = '', final  List<Conversation> conversation = const <Conversation>[], @JsonKey(name: 'character', fromJson: _stringListFromJson) final  List<String> characters = const <String>[], this.confetti = ''}): _audio = audio,_conversation = conversation,_characters = characters;
  factory _Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);

@override@JsonKey() final  String image;
@override@JsonKey(name: 'image_tb') final  String? imageTb;
// for tablet
@override@JsonKey(name: 'image_success') final  String? imageSuccess;
@override@JsonKey(name: 'image_success_tb') final  String? imageSuccessTb;
 final  List<String> _audio;
@override@JsonKey(fromJson: _stringListFromJson) List<String> get audio {
  if (_audio is EqualUnmodifiableListView) return _audio;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_audio);
}

@override@JsonKey() final  String lottie;
@override@JsonKey() final  String type;
 final  List<Conversation> _conversation;
@override@JsonKey() List<Conversation> get conversation {
  if (_conversation is EqualUnmodifiableListView) return _conversation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conversation);
}

 final  List<String> _characters;
@override@JsonKey(name: 'character', fromJson: _stringListFromJson) List<String> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}

@override@JsonKey() final  String confetti;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentCopyWith<_Content> get copyWith => __$ContentCopyWithImpl<_Content>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Content&&(identical(other.image, image) || other.image == image)&&(identical(other.imageTb, imageTb) || other.imageTb == imageTb)&&(identical(other.imageSuccess, imageSuccess) || other.imageSuccess == imageSuccess)&&(identical(other.imageSuccessTb, imageSuccessTb) || other.imageSuccessTb == imageSuccessTb)&&const DeepCollectionEquality().equals(other._audio, _audio)&&(identical(other.lottie, lottie) || other.lottie == lottie)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._conversation, _conversation)&&const DeepCollectionEquality().equals(other._characters, _characters)&&(identical(other.confetti, confetti) || other.confetti == confetti));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,image,imageTb,imageSuccess,imageSuccessTb,const DeepCollectionEquality().hash(_audio),lottie,type,const DeepCollectionEquality().hash(_conversation),const DeepCollectionEquality().hash(_characters),confetti);

@override
String toString() {
  return 'Content(image: $image, imageTb: $imageTb, imageSuccess: $imageSuccess, imageSuccessTb: $imageSuccessTb, audio: $audio, lottie: $lottie, type: $type, conversation: $conversation, characters: $characters, confetti: $confetti)';
}


}

/// @nodoc
abstract mixin class _$ContentCopyWith<$Res> implements $ContentCopyWith<$Res> {
  factory _$ContentCopyWith(_Content value, $Res Function(_Content) _then) = __$ContentCopyWithImpl;
@override @useResult
$Res call({
 String image,@JsonKey(name: 'image_tb') String? imageTb,@JsonKey(name: 'image_success') String? imageSuccess,@JsonKey(name: 'image_success_tb') String? imageSuccessTb,@JsonKey(fromJson: _stringListFromJson) List<String> audio, String lottie, String type, List<Conversation> conversation,@JsonKey(name: 'character', fromJson: _stringListFromJson) List<String> characters, String confetti
});




}
/// @nodoc
class __$ContentCopyWithImpl<$Res>
    implements _$ContentCopyWith<$Res> {
  __$ContentCopyWithImpl(this._self, this._then);

  final _Content _self;
  final $Res Function(_Content) _then;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? image = null,Object? imageTb = freezed,Object? imageSuccess = freezed,Object? imageSuccessTb = freezed,Object? audio = null,Object? lottie = null,Object? type = null,Object? conversation = null,Object? characters = null,Object? confetti = null,}) {
  return _then(_Content(
image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,imageTb: freezed == imageTb ? _self.imageTb : imageTb // ignore: cast_nullable_to_non_nullable
as String?,imageSuccess: freezed == imageSuccess ? _self.imageSuccess : imageSuccess // ignore: cast_nullable_to_non_nullable
as String?,imageSuccessTb: freezed == imageSuccessTb ? _self.imageSuccessTb : imageSuccessTb // ignore: cast_nullable_to_non_nullable
as String?,audio: null == audio ? _self._audio : audio // ignore: cast_nullable_to_non_nullable
as List<String>,lottie: null == lottie ? _self.lottie : lottie // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,conversation: null == conversation ? _self._conversation : conversation // ignore: cast_nullable_to_non_nullable
as List<Conversation>,characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<String>,confetti: null == confetti ? _self.confetti : confetti // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Conversation {

@JsonKey(fromJson: _idFromJson) String get id; String get messageEn; String get messageNp; String get icon; bool get correct;// Audio question
 String? get question; String? get audioItem;
/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationCopyWith<Conversation> get copyWith => _$ConversationCopyWithImpl<Conversation>(this as Conversation, _$identity);

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.messageEn, messageEn) || other.messageEn == messageEn)&&(identical(other.messageNp, messageNp) || other.messageNp == messageNp)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.question, question) || other.question == question)&&(identical(other.audioItem, audioItem) || other.audioItem == audioItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageEn,messageNp,icon,correct,question,audioItem);

@override
String toString() {
  return 'Conversation(id: $id, messageEn: $messageEn, messageNp: $messageNp, icon: $icon, correct: $correct, question: $question, audioItem: $audioItem)';
}


}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res>  {
  factory $ConversationCopyWith(Conversation value, $Res Function(Conversation) _then) = _$ConversationCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id, String messageEn, String messageNp, String icon, bool correct, String? question, String? audioItem
});




}
/// @nodoc
class _$ConversationCopyWithImpl<$Res>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? messageEn = null,Object? messageNp = null,Object? icon = null,Object? correct = null,Object? question = freezed,Object? audioItem = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageEn: null == messageEn ? _self.messageEn : messageEn // ignore: cast_nullable_to_non_nullable
as String,messageNp: null == messageNp ? _self.messageNp : messageNp // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,question: freezed == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String?,audioItem: freezed == audioItem ? _self.audioItem : audioItem // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Conversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Conversation value)  $default,){
final _that = this;
switch (_that) {
case _Conversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Conversation value)?  $default,){
final _that = this;
switch (_that) {
case _Conversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id,  String messageEn,  String messageNp,  String icon,  bool correct,  String? question,  String? audioItem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.messageEn,_that.messageNp,_that.icon,_that.correct,_that.question,_that.audioItem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String id,  String messageEn,  String messageNp,  String icon,  bool correct,  String? question,  String? audioItem)  $default,) {final _that = this;
switch (_that) {
case _Conversation():
return $default(_that.id,_that.messageEn,_that.messageNp,_that.icon,_that.correct,_that.question,_that.audioItem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String id,  String messageEn,  String messageNp,  String icon,  bool correct,  String? question,  String? audioItem)?  $default,) {final _that = this;
switch (_that) {
case _Conversation() when $default != null:
return $default(_that.id,_that.messageEn,_that.messageNp,_that.icon,_that.correct,_that.question,_that.audioItem);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Conversation implements Conversation {
  const _Conversation({@JsonKey(fromJson: _idFromJson) this.id = '', this.messageEn = '', this.messageNp = '', this.icon = '', this.correct = false, this.question, this.audioItem});
  factory _Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String id;
@override@JsonKey() final  String messageEn;
@override@JsonKey() final  String messageNp;
@override@JsonKey() final  String icon;
@override@JsonKey() final  bool correct;
// Audio question
@override final  String? question;
@override final  String? audioItem;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationCopyWith<_Conversation> get copyWith => __$ConversationCopyWithImpl<_Conversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Conversation&&(identical(other.id, id) || other.id == id)&&(identical(other.messageEn, messageEn) || other.messageEn == messageEn)&&(identical(other.messageNp, messageNp) || other.messageNp == messageNp)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.question, question) || other.question == question)&&(identical(other.audioItem, audioItem) || other.audioItem == audioItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,messageEn,messageNp,icon,correct,question,audioItem);

@override
String toString() {
  return 'Conversation(id: $id, messageEn: $messageEn, messageNp: $messageNp, icon: $icon, correct: $correct, question: $question, audioItem: $audioItem)';
}


}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res> implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(_Conversation value, $Res Function(_Conversation) _then) = __$ConversationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String id, String messageEn, String messageNp, String icon, bool correct, String? question, String? audioItem
});




}
/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

/// Create a copy of Conversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? messageEn = null,Object? messageNp = null,Object? icon = null,Object? correct = null,Object? question = freezed,Object? audioItem = freezed,}) {
  return _then(_Conversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,messageEn: null == messageEn ? _self.messageEn : messageEn // ignore: cast_nullable_to_non_nullable
as String,messageNp: null == messageNp ? _self.messageNp : messageNp // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,question: freezed == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String?,audioItem: freezed == audioItem ? _self.audioItem : audioItem // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
