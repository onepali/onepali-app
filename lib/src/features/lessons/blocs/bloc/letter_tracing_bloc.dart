import 'dart:developer';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/models/nepali_letter.dart';
import 'package:onepali/src/features/lessons/services/nepali_letter_service.dart';
import 'package:path_drawing/path_drawing.dart';

part 'letter_tracing_event.dart';
part 'letter_tracing_state.dart';
part 'letter_tracing_bloc.freezed.dart';

class LetterTracingBloc extends Bloc<LetterTracingEvent, LetterTracingState> {
  LetterTracingBloc() : super(_LetterTracingState()) {
    on<_Started>(_onStarted);
    on<_OnPanStart>(_onPanStart);
    on<_OnPanUpdate>(_onPanUpdate);
    on<_OnPanEnd>(_onPanEnd);
    on<_Reset>(_onReset);
  }

  void _onStarted(_Started event, Emitter<LetterTracingState> emit) async {
    final content = event.content;
    final char = content.nameNp;
    final letters = await LetterService.loadLetters();
    final letter = letters.firstWhere((letter) => letter.letter == char);
    final size = letter.getSize();
    final letterPaths = letter.strokes
        .map((stroke) => parseSvgPathData(stroke.path))
        .toList();
    final pathsPoints = letterPaths
        .map((path) => getPointsFromPath(path))
        .toList();
    final strokeWidth = letter.strokes.isNotEmpty
        ? letter.strokes.first.strokeWidth ?? 20.0
        : 20.0;
    emit(
      state.copyWith(
        strokeWidth: strokeWidth.toDouble(),
        letter: letter,
        letterSize: size,
        numberOfStrokes: letter.strokes.length,
        pathsPoints: pathsPoints,
        letterPaths: letterPaths,
      ),
    );
  }

  void _onPanStart(_OnPanStart event, Emitter<LetterTracingState> emit) {
    if (state.currentStrokeIndex >= state.numberOfStrokes) return;
    final userStrokePoints = List<Offset>.from(state.userStrokes);
    userStrokePoints.add(event.position);
    emit(state.copyWith(userStrokes: userStrokePoints));
  }

  void _onPanUpdate(_OnPanUpdate event, Emitter<LetterTracingState> emit) {
    if (state.currentStrokeIndex >= state.numberOfStrokes) return;
    final userStrokes = List<Offset>.from(state.userStrokes);
    userStrokes.add(event.position);
    emit(state.copyWith(userStrokes: userStrokes));
  }

  void _onPanEnd(_OnPanEnd event, Emitter<LetterTracingState> emit) {
    if (state.currentStrokeIndex >= state.numberOfStrokes) return;
    final pathPoints = List<Offset>.from(
      state.pathsPoints[state.currentStrokeIndex],
    );
    final userStrokePoints = List<Offset>.from(state.userStrokes);
    userStrokePoints.add(event.position);

    // calcualte if the userStrokePoints are +_60% of the pathPoints
    final ratio = userStrokePoints.length / pathPoints.length;
    if (ratio >= 0.6 && ratio <= 1.4) {
      log(
        "CurrentStorkeIndex: ${state.currentStrokeIndex}  Stroke Points: ${pathPoints.length} User Points: ${userStrokePoints.length}",
      );
      // Calculate 650% of the path points should be same
      final isPathValid = isStrokeValid(
        pathPoints: pathPoints,
        userStrokePoints: userStrokePoints,
      );
      log("isPathValid: $isPathValid");
      final completedPaths = List<Path>.from(state.completedPaths);
      completedPaths.add(state.letterPaths[state.currentStrokeIndex]);
      final nextIndex = state.currentStrokeIndex + 1;
      emit(
        state.copyWith(
          currentStrokeIndex: nextIndex,
          userStrokes: [],
          completedPaths: completedPaths,
        ),
      );
    } else {
      log(
        "Wrong tracing CurrentStorkeIndex: ${state.currentStrokeIndex}  Stroke Points: ${pathPoints.length} User Points: ${userStrokePoints.length}",
      );
      emit(state.copyWith(userStrokes: []));
    }
  }

  void _onReset(_Reset event, Emitter<LetterTracingState> emit) {
    // final letter = state.letter!;
    // emit(_LetterTracingState());
    // add(_Started(letter));
  }

  List<Offset> getPointsFromPath(Path path) {
    final metrics = path.computeMetrics();
    List<Offset> points = [];

    for (final metric in metrics) {
      for (double t = 0; t < metric.length; t += 2) {
        final tangent = metric.getTangentForOffset(t);
        if (tangent != null) {
          points.add(tangent.position);
        }
      }
    }
    return points;
  }

  bool isStrokeValid({
    required List<Offset> pathPoints,
    required List<Offset> userStrokePoints,
    double threshold = 14.0,
    double requiredMatchRatio = 0.65,
  }) {
    if (pathPoints.isEmpty || userStrokePoints.isEmpty) return false;

    int matchedPoints = 0;

    for (final userPoint in userStrokePoints) {
      double minDistance = double.infinity;

      for (final pathPoint in pathPoints) {
        final distance = (userPoint - pathPoint).distance;
        if (distance < minDistance) {
          minDistance = distance;
        }
      }

      if (minDistance <= threshold) {
        matchedPoints++;
      }
    }

    final matchRatio = matchedPoints / userStrokePoints.length;
    return matchRatio >= requiredMatchRatio;
  }
}
