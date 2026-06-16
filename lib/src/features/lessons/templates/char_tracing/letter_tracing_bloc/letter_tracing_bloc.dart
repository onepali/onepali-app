import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/models/nepali_letter.dart';
import 'package:onepali/src/features/lessons/services/nepali_letter_service.dart';
import 'package:path_drawing/path_drawing.dart';

part 'letter_tracing_event.dart';
part 'letter_tracing_state.dart';
part 'letter_tracing_bloc.freezed.dart';

class LetterTracingBloc extends Bloc<LetterTracingEvent, LetterTracingState> {
  final AudioPlayerService audioPlayerService = AudioPlayerServiceImpl();
  LetterTracingBloc() : super(_LetterTracingState()) {
    on<_Started>(_onStarted);
    on<_OnPanStart>(_onPanStart);
    on<_OnPanUpdate>(_onPanUpdate);
    on<_OnPanEnd>(_onPanEnd);
    on<_Reset>(_onReset);
  }

  void _onStarted(_Started event, Emitter<LetterTracingState> emit) async {
    Path? outlinePath;
    final isMobile = event.isMobile;
    final content = event.content;
    final char = content.nameNp;
    final letters = await LetterService.loadLetters();
    final letter = letters.firstWhere((letter) => letter.letter == char);
    final size = letter.getSize(event.isMobile);
    final strokes = isMobile ? letter.strokes.mb : letter.strokes.tb;
    final letterPaths = strokes
        .map((stroke) => parseSvgPathData(stroke.path))
        .toList();
    final pathsPoints = letterPaths
        .map((path) => getPointsFromPath(path))
        .toList();
    if (letter.outlinePathTb != null && !isMobile) {
      outlinePath = parseSvgPathData(letter.outlinePathTb!);
    } else if (letter.outlinePathMb != null && isMobile) {
      outlinePath = parseSvgPathData(letter.outlinePathMb!);
    }
    final strokeWidth = strokes.isNotEmpty
        ? strokes.first.strokeWidth ?? 20.0
        : 20.0;

    // Calculate bounding boxes for each stroke
    final boundingBoxes = letterPaths.map((path) => path.getBounds()).toList();

    emit(
      state.copyWith(
        strokeWidth: strokeWidth.toDouble(),
        letter: letter,
        letterSize: size,
        numberOfStrokes: strokes.length,
        outlinePath: outlinePath,
        pathsPoints: pathsPoints,
        letterPaths: letterPaths,
        strokeBoundingBoxes: boundingBoxes,
        showPointer: true, // Show pointer for first stroke
        pointerPosition: pathsPoints.isNotEmpty ? pathsPoints[0].first : null,
      ),
    );
  }

  void _onPanStart(_OnPanStart event, Emitter<LetterTracingState> emit) {
    if (state.currentStrokeIndex >= state.numberOfStrokes) return;

    final position = event.position;
    final currentPathPoints = state.pathsPoints[state.currentStrokeIndex];

    // Check if starting near the beginning of the stroke
    final startPoint = currentPathPoints.first;
    final distanceFromStart = (position - startPoint).distance;

    // Validate start position
    if (distanceFromStart > state.strokeWidth * 2) {
      emit(state.copyWith(isTracingOutsideBounds: true, showStartHint: true));
      return;
    }

    final userStrokePoints = <Offset>[position];
    emit(
      state.copyWith(
        userStrokes: userStrokePoints,
        isTracingOutsideBounds: false,
        showStartHint: false,
        showPointer: false, // Hide pointer when tracing starts
      ),
    );
  }

  void _onPanUpdate(_OnPanUpdate event, Emitter<LetterTracingState> emit) {
    if (state.currentStrokeIndex >= state.numberOfStrokes) return;
    if (state.isTracingOutsideBounds) return; // Don't update if already invalid

    final position = event.position;
    final currentPathPoints = state.pathsPoints[state.currentStrokeIndex];
    final boundingBox = state.strokeBoundingBoxes[state.currentStrokeIndex];

    // Check if the position is within acceptable bounds
    final isWithinBounds = _isPointNearPath(
      position,
      currentPathPoints,
      state.strokeWidth * 2.5, // Tolerance for deviation
    );

    // Expanded bounding box check
    final expandedBounds = boundingBox.inflate(state.strokeWidth * 2);
    final isInExpandedBounds = expandedBounds.contains(position);

    if (!isWithinBounds || !isInExpandedBounds) {
      // User is tracing outside bounds
      emit(
        state.copyWith(
          isTracingOutsideBounds: true,
          feedbackMessage: 'Stay on the path!',
        ),
      );
      return;
    }

    final userStrokes = List<Offset>.from(state.userStrokes);
    userStrokes.add(position);

    // Calculate progress
    final progress = _calculateStrokeProgress(userStrokes, currentPathPoints);

    emit(
      state.copyWith(
        userStrokes: userStrokes,
        currentStrokeProgress: progress,
        isTracingOutsideBounds: false,
        feedbackMessage: null,
      ),
    );
  }

  void _onPanEnd(_OnPanEnd event, Emitter<LetterTracingState> emit) {
    if (state.currentStrokeIndex >= state.numberOfStrokes) return;

    // If tracing was outside bounds, reset
    if (state.isTracingOutsideBounds) {
      emit(
        state.copyWith(
          userStrokes: [],
          isTracingOutsideBounds: false,
          feedbackMessage: 'Try again!',
          showPointer: true,
          pointerPosition: state.pathsPoints[state.currentStrokeIndex].first,
        ),
      );
      return;
    }

    final pathPoints = List<Offset>.from(
      state.pathsPoints[state.currentStrokeIndex],
    );
    final userStrokePoints = List<Offset>.from(state.userStrokes);
    userStrokePoints.add(event.position);

    // Improved validation
    final validation = _validateStroke(
      pathPoints: pathPoints,
      userStrokePoints: userStrokePoints,
      strokeWidth: state.strokeWidth,
    );

    if (validation.isValid) {
      log(
        "✓ Stroke ${state.currentStrokeIndex + 1} completed! Coverage: ${(validation.coverage * 100).toStringAsFixed(1)}%, Accuracy: ${(validation.accuracy * 100).toStringAsFixed(1)}%",
      );

      final completedPaths = List<Path>.from(state.completedPaths);
      completedPaths.add(state.letterPaths[state.currentStrokeIndex]);
      final nextIndex = state.currentStrokeIndex + 1;

      // Check if all strokes are completed
      final isLetterComplete = nextIndex >= state.numberOfStrokes;
      int newRepetations = state.repetations;
      if (isLetterComplete) {
        audioPlayerService.playAsset('audio/sfx/star_blast.mp3');
        newRepetations = state.repetations + 1;
        if (newRepetations >= 3) {
          // Reset to first stroke after 3 repetations
          emit(
            state.copyWith(
              repetations: newRepetations,
              currentStrokeIndex: nextIndex,
              userStrokes: [],
              completedPaths: completedPaths,
              currentStrokeProgress: 0.0,
              feedbackMessage: 'Great job! 👍',
              showPointer: false,
              pointerPosition: null,
              isLetterComplete: true,
            ),
          );
          return;
        } else {
          emit(
            state.copyWith(
              repetations: newRepetations,
              currentStrokeIndex: 0,
              userStrokes: [],
              completedPaths: [],
              currentStrokeProgress: 0.0,
              feedbackMessage: "Great job! Let's do it again.",
              showPointer: true,
              pointerPosition: state.pathsPoints[0].first,
              isLetterComplete: false,
            ),
          );
          return;
        }
      }

      emit(
        state.copyWith(
          currentStrokeIndex: nextIndex,
          userStrokes: [],
          completedPaths: completedPaths,
          currentStrokeProgress: 0.0,
          feedbackMessage: isLetterComplete ? 'Perfect! ⭐' : 'Great job! 👍',
          showPointer: !isLetterComplete,
          pointerPosition:
              !isLetterComplete && nextIndex < state.pathsPoints.length
              ? state.pathsPoints[nextIndex].first
              : null,
          isLetterComplete: isLetterComplete,
        ),
      );
    } else {
      log(
        "✗ Stroke ${state.currentStrokeIndex + 1} failed. Coverage: ${(validation.coverage * 100).toStringAsFixed(1)}%, Accuracy: ${(validation.accuracy * 100).toStringAsFixed(1)}%",
      );

      emit(
        state.copyWith(
          userStrokes: [],
          currentStrokeProgress: 0.0,
          feedbackMessage: 'Try again! Follow the path.',
          showPointer: true,
          pointerPosition: state.pathsPoints[state.currentStrokeIndex].first,
        ),
      );
    }
  }

  void _onReset(_Reset event, Emitter<LetterTracingState> emit) {
    emit(
      state.copyWith(
        currentStrokeIndex: 0,
        userStrokes: [],
        completedPaths: [],
        currentStrokeProgress: 0.0,
        isTracingOutsideBounds: false,
        feedbackMessage: null,
        showPointer: true,
        pointerPosition: state.pathsPoints.isNotEmpty
            ? state.pathsPoints[0].first
            : null,
        isLetterComplete: false,
      ),
    );
  }

  // Helper method to check if a point is near the path
  bool _isPointNearPath(
    Offset point,
    List<Offset> pathPoints,
    double threshold,
  ) {
    for (final pathPoint in pathPoints) {
      if ((point - pathPoint).distance <= threshold) {
        return true;
      }
    }
    return false;
  }

  // Calculate stroke progress (0.0 to 1.0)
  double _calculateStrokeProgress(
    List<Offset> userPoints,
    List<Offset> pathPoints,
  ) {
    if (userPoints.isEmpty || pathPoints.isEmpty) return 0.0;

    // Find the furthest point along the path that the user has traced
    int maxMatchedIndex = 0;

    for (int i = 0; i < pathPoints.length; i++) {
      final pathPoint = pathPoints[i];
      for (final userPoint in userPoints) {
        if ((userPoint - pathPoint).distance <= 25.0) {
          if (i > maxMatchedIndex) {
            maxMatchedIndex = i;
          }
        }
      }
    }

    return maxMatchedIndex / pathPoints.length;
  }

  // Improved stroke validation
  StrokeValidation _validateStroke({
    required List<Offset> pathPoints,
    required List<Offset> userStrokePoints,
    required double strokeWidth,
    double accuracyThreshold = 15.0,
    double requiredCoverage = 0.65,
    double requiredAccuracy = 0.60,
  }) {
    if (pathPoints.isEmpty || userStrokePoints.isEmpty) {
      return StrokeValidation(isValid: false, coverage: 0.0, accuracy: 0.0);
    }

    // Check coverage: how much of the path was traced
    int coveredPoints = 0;
    for (final pathPoint in pathPoints) {
      bool isCovered = false;
      for (final userPoint in userStrokePoints) {
        if ((userPoint - pathPoint).distance <= accuracyThreshold) {
          isCovered = true;
          break;
        }
      }
      if (isCovered) coveredPoints++;
    }
    final coverage = coveredPoints / pathPoints.length;

    // Check accuracy: how many user points are on the path
    int accuratePoints = 0;
    for (final userPoint in userStrokePoints) {
      double minDistance = double.infinity;
      for (final pathPoint in pathPoints) {
        final distance = (userPoint - pathPoint).distance;
        if (distance < minDistance) {
          minDistance = distance;
        }
      }
      if (minDistance <= accuracyThreshold) {
        accuratePoints++;
      }
    }
    final accuracy = accuratePoints / userStrokePoints.length;

    final isValid =
        coverage >= requiredCoverage && accuracy >= requiredAccuracy;

    return StrokeValidation(
      isValid: isValid,
      coverage: coverage,
      accuracy: accuracy,
    );
  }

  List<Offset> getPointsFromPath(Path path) {
    final metrics = path.computeMetrics();
    List<Offset> points = [];

    for (final metric in metrics) {
      // Reduce step size for more accurate path representation
      for (double t = 0; t < metric.length; t += 1.5) {
        final tangent = metric.getTangentForOffset(t);
        if (tangent != null) {
          points.add(tangent.position);
        }
      }
    }
    return points;
  }

  @override
  Future<void> close() {
    audioPlayerService.dispose();
    return super.close();
  }
}

// Validation result class
class StrokeValidation {
  final bool isValid;
  final double coverage; // 0.0 to 1.0
  final double accuracy; // 0.0 to 1.0

  StrokeValidation({
    required this.isValid,
    required this.coverage,
    required this.accuracy,
  });
}
