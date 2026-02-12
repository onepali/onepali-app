import 'dart:convert';

List<StoryModel> storyModelFromJson(String str) =>
    List<StoryModel>.from(json.decode(str).map((x) => StoryModel.fromJson(x)));

String storyModelToJson(List<StoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoryModel {
  final String nameEn;
  final String nameNp;
  final String thumbnail;
  final String lottie;
  final List<String> audio;
  final String tooltip;
  final String description;
  final List<Content> content;

  StoryModel({
    required this.nameEn,
    required this.nameNp,
    required this.thumbnail,
    required this.lottie,
    required this.audio,
    required this.tooltip,
    required this.description,
    required this.content,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
    nameEn: json["nameEn"] ?? "",
    nameNp: json["nameNp"] ?? "",
    thumbnail: json["thumbnail"] ?? "",
    lottie: json["lottie"] ?? "",
    audio: json["audio"] == null
        ? []
        : List<String>.from(json["audio"].map((x) => x.toString())),
    tooltip: json["tooltip"] ?? "",
    description: json["description"] ?? "",
    content: json["content"] == null
        ? []
        : List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "nameEn": nameEn,
    "nameNp": nameNp,
    "thumbnail": thumbnail,
    "lottie": lottie,
    "audio": List<dynamic>.from(audio.map((x) => x.toString())),
    "tooltip": tooltip,
    "description": description,
    "content": List<dynamic>.from(content.map((x) => x.toJson())),
  };
}

class Content {
  final String image;
  final String? imageTb; // for tablet
  final String? imageSuccess;
  final List<String> audio;
  final String lottie;
  final String type;
  final List<Conversation> conversation;
  final List<String>? characters;
  final String confetti;

  Content({
    required this.image,
    this.imageTb,
    this.imageSuccess,
    required this.audio,
    required this.lottie,
    required this.type,
    required this.conversation,
    this.characters = const [],
    required this.confetti,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    image: json["image"] ?? "",
    imageTb: json["image_tb"],
    imageSuccess: json["image_success"],
    audio: json["audio"] == null
        ? []
        : List<String>.from(json["audio"].map((x) => x.toString())),
    lottie: json["lottie"] ?? "",
    type: json["type"] ?? "",
    conversation: json["conversation"] == null
        ? []
        : List<Conversation>.from(
            json["conversation"].map((x) => Conversation.fromJson(x)),
          ),
    characters: json["character"] == null
        ? []
        : List<String>.from(json["character"].map((x) => x.toString())),
    confetti: json["confetti"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "image_tb": imageTb,
    "image_success": imageSuccess,
    "audio": List<dynamic>.from(audio.map((x) => x.toString())),
    "lottie": lottie,
    "type": type,
    "character": List<dynamic>.from(characters!.map((x) => x.toString())),
    "conversation": List<dynamic>.from(conversation.map((x) => x.toJson())),
    "confetti": confetti,
  };
}

class Conversation {
  final String id;
  final String messageEn;
  final String messageNp;
  final String icon;
  final bool? correct;

  Conversation({
    required this.id,
    required this.messageEn,
    required this.messageNp,
    required this.icon,
    this.correct = false,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    id: json["id"]?.toString() ?? "",
    messageEn: json["messageEn"] ?? "",
    messageNp: json["messageNp"] ?? "",
    icon: json["icon"] ?? "",
    correct: json["correct"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "messageEn": messageEn,
    "messageNp": messageNp,
    "icon": icon,
    "correct": correct,
  };
}
