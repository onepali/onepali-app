class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final int yearOfBirth;
  final String heardAbout;
  final String learningReason;
  final String authProvider;
  final String createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.yearOfBirth,
    required this.heardAbout,
    required this.learningReason,
    required this.authProvider,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'fullName': fullName,
    'email': email,
    'yearOfBirth': yearOfBirth,
    'heardAbout': heardAbout,
    'learningReason': learningReason,
    'authProvider': authProvider,
    'createdAt': createdAt,
  };

  factory UserModel.fromJson(Map<String, dynamic> map) => UserModel(
    uid: map['uid'],
    fullName: map['fullName'],
    email: map['email'],
    yearOfBirth: map['yearOfBirth'],
    heardAbout: map['heardAbout'],
    learningReason: map['learningReason'],
    authProvider: map['authProvider'],
    createdAt: map['createdAt'],
  );
}
