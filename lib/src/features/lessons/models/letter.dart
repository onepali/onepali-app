import 'package:freezed_annotation/freezed_annotation.dart';

part 'letter.freezed.dart';

@freezed
abstract class Letter with _$Letter {
  const Letter._();
  const factory Letter({
    required String letter,
    required String name,
    required num width,
    required num height,
    required String viewBox,
    required List<LetterStroke> strokes,
  }) = _Letter;
}

@freezed
abstract class LetterStroke with _$LetterStroke {
  const factory LetterStroke({
    required String name,
    required String path,
    required String instruction,
    int? order,
    String? color,
  }) = _LetterStroke;
}
