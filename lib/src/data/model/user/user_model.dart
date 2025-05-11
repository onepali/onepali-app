import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String name;
  final String email;
  final int age;
  final String profilePicture;
  final String level;
  final Progress progress;
  final Rewards rewards;

  UserModel({
    required this.name,
    required this.email,
    required this.age,
    required this.profilePicture,
    required this.level,
    required this.progress,
    required this.rewards,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    age: json["age"] ?? 0,
    profilePicture: json["profile_picture"] ?? "",
    level: json["level"] ?? "",
    progress: Progress.fromJson(json["progress"] ?? {}),
    rewards: Rewards.fromJson(json["rewards"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "age": age,
    "profile_picture": profilePicture,
    "level": level,
    "progress": progress.toJson(),
    "rewards": rewards.toJson(),
  };
}

class Progress {
  final PreSchool preSchool;

  Progress({required this.preSchool});

  factory Progress.fromJson(Map<String, dynamic> json) =>
      Progress(preSchool: PreSchool.fromJson(json["Pre-School"] ?? {}));

  Map<String, dynamic> toJson() => {"Pre-School": preSchool.toJson()};
}

class PreSchool {
  final String numbers;
  final String alphabets;
  final String swornBarna;

  PreSchool({
    required this.numbers,
    required this.alphabets,
    required this.swornBarna,
  });

  factory PreSchool.fromJson(Map<String, dynamic> json) => PreSchool(
    numbers: json["Numbers"] ?? "",
    alphabets: json["Alphabets"] ?? "",
    swornBarna: json["Sworn Barna"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "Numbers": numbers,
    "Alphabets": alphabets,
    "Sworn Barna": swornBarna,
  };
}

class Rewards {
  final int stars;
  final List<String> badges;

  Rewards({required this.stars, required this.badges});

  factory Rewards.fromJson(Map<String, dynamic> json) => Rewards(
    stars: json["stars"] ?? 0,
    badges: List<String>.from((json["badges"] ?? []).map((x) => x ?? "")),
  );

  Map<String, dynamic> toJson() => {
    "stars": stars,
    "badges": List<dynamic>.from(badges.map((x) => x)),
  };
}
