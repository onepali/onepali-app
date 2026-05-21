import 'package:cloud_firestore/cloud_firestore.dart';

import '../../src.dart';

class PasscodeModel {
  final String hash;
  final String salt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int attempts;
  final DateTime? lockedUntil;
  final PasscodeMode mode;

  const PasscodeModel({
    required this.hash,
    required this.salt,
    required this.createdAt,
    required this.updatedAt,
    this.attempts = 0,
    this.lockedUntil,
    this.mode = PasscodeMode.digits4,
  });

  factory PasscodeModel.fromMap(Map<String, dynamic> map) {
    return PasscodeModel(
      hash: map['hash'] ?? '',
      salt: map['salt'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      attempts: map['attempts'] ?? 0,
      lockedUntil: (map['lockedUntil'] as Timestamp?)?.toDate(),
      mode: PasscodeMode.values.firstWhere(
        (e) => e.name == map['mode'],
        orElse: () => PasscodeMode.digits4,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hash': hash,
      'salt': salt,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'attempts': attempts,
      'lockedUntil': lockedUntil != null
          ? Timestamp.fromDate(lockedUntil!)
          : null,
      'mode': mode.name,
    };
  }

  PasscodeModel copyWith({
    String? hash,
    String? salt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? attempts,
    DateTime? lockedUntil,
    PasscodeMode? mode,
    bool clearLockedUntil = false,
  }) {
    return PasscodeModel(
      hash: hash ?? this.hash,
      salt: salt ?? this.salt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attempts: attempts ?? this.attempts,
      lockedUntil: clearLockedUntil ? null : (lockedUntil ?? this.lockedUntil),
      mode: mode ?? this.mode,
    );
  }

  bool get isLocked {
    if (lockedUntil == null) return false;
    return DateTime.now().isBefore(lockedUntil!);
  }

  Duration? get lockTimeRemaining {
    if (!isLocked) return null;
    return lockedUntil!.difference(DateTime.now());
  }

  @override
  String toString() {
    return 'PasscodeModel(hash: [hidden], salt: [hidden], createdAt: $createdAt, '
        'updatedAt: $updatedAt, attempts: $attempts, lockedUntil: $lockedUntil, mode: $mode)';
  }
}
