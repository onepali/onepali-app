import 'dart:convert';

List<SystemModel> systemModelFromJson(String str) => List<SystemModel>.from(
  json.decode(str).map((x) => SystemModel.fromJson(x)),
);

String systemModelToJson(List<SystemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SystemModel {
  final String id;
  final String info;
  final String? title;
  final String? answer;

  SystemModel({required this.id, required this.info, this.title, this.answer});

  factory SystemModel.fromJson(Map<String, dynamic> json) => SystemModel(
    id: json["id"] ?? '',
    info: json["info"] ?? '',
    title: json["title"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "info": info,
    if (title != null) "title": title,
    if (answer != null) "answer": answer,
  };
}

class AboutModel {
  final String info;
  final String? title;
  final String? tip;

  AboutModel({required this.info, this.title, this.tip});

  factory AboutModel.fromJson(Map<String, dynamic> json) => AboutModel(
    info: json["info"] ?? '',
    title: json["title"],
    tip: json["tip"],
  );

  Map<String, dynamic> toJson() => {
    "info": info,
    if (title != null) "title": title,
    if (tip != null) "tip": tip,
  };
}

class ContactModel {
  final String info;
  final String? title;

  ContactModel({required this.info, this.title});

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      ContactModel(info: json["info"] ?? '', title: json["title"]);

  Map<String, dynamic> toJson() => {
    "info": info,
    if (title != null) "title": title,
  };
}

class FaqModel {
  final String title;
  final String answer;

  FaqModel({required this.title, required this.answer});

  factory FaqModel.fromJson(Map<String, dynamic> json) =>
      FaqModel(title: json["title"] ?? '', answer: json["answer"] ?? '');

  Map<String, dynamic> toJson() => {"title": title, "answer": answer};
}
