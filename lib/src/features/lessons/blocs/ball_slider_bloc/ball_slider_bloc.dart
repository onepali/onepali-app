import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'ball_slider_event.dart';
part 'ball_slider_state.dart';
part 'ball_slider_bloc.freezed.dart';

enum SliderDirection { leftToRight, rightToLeft, leftToRightHeading }

class BallSliderBloc extends Bloc<BallSliderEvent, BallSliderState> {
  final double ballSize;
  final double completionThreshold;

  /// Left to right or right to left
  final SliderDirection direction;

  /// Minimum release velocity (px/s) to trigger a fling to the end.
  static const double _flingThresholdPx = 300.0;

  /// Friction deceleration applied each tick (normalized units/s²).
  static const double _friction = 1.8;

  /// How often the physics loop ticks (60 fps)
  static const _tickInterval = Duration(milliseconds: 16);

  // Internal physics state
  double _usableWidth = 1.0;
  double _velocity = 0.0; // normalized units per second
  Timer? _physicsTimer;

  BallSliderBloc({
    this.ballSize = 60.0,
    this.completionThreshold = 0.98,
    this.direction = SliderDirection.rightToLeft,
  }) : super(const BallSliderState()) {
    on<_Started>(_onStarted);
    on<_BallDragged>(_onBallDragged);
    on<_BallDragEnded>(_onBallDragEnded);
    on<_BallTapped>(_onBallTapped);
    on<_BallReset>(_onBallReset);
    on<_PhysicsTick>(_onPhysicsTick);
  }
  void _onStarted(_Started event, Emitter<BallSliderState> emit) {
    emit(state.copyWith(content: event.content));
  }

  double _toForwardDelta(double rawNormalisedDelta) =>
      direction == SliderDirection.rightToLeft
      ? -rawNormalisedDelta
      : rawNormalisedDelta;
  double _toForwardVelocity(double rawPxPerSec) =>
      direction == SliderDirection.rightToLeft
      ? -(rawPxPerSec / _usableWidth)
      : rawPxPerSec / _usableWidth;

  double _deltaToRadians(double normalizedDelta) {
    return (normalizedDelta * _usableWidth) / (ballSize / 2);
  }

  //  Drag update
  void _onBallDragged(_BallDragged event, Emitter<BallSliderState> emit) {
    _stopPhysics();
    _usableWidth = event.usableWidth;
    final forwardDelta = _toForwardDelta(event.delta);
    final newValue = (state.value + forwardDelta).clamp(0.0, 1.0);
    final newRotation = state.rotationAngle + _deltaToRadians(forwardDelta);
    emit(_compute(newValue, newRotation, isAnimating: false));
  }

  //  Finger lifted — decide fling or snap-back
  void _onBallDragEnded(_BallDragEnded event, Emitter<BallSliderState> emit) {
    _usableWidth = event.usableWidth;
    final forwardVelocity = _toForwardVelocity(event.velocityPx);
    if (forwardVelocity >= _flingThresholdPx / _usableWidth) {
      _velocity = forwardVelocity;
      _startPhysicsLoop();
      emit(state.copyWith(isAnimating: true));
    } else if (forwardVelocity <= -(_flingThresholdPx / _usableWidth)) {
      _velocity = forwardVelocity;
      _startPhysicsLoop();
      emit(state.copyWith(isAnimating: true));
    } else {
      // if(state.value<0.5){
      //   _startSnapBack();
      // }
      emit(state.copyWith(isAnimating: true));
    }
  }

  //  Physics tick (called ~60fps while animating)
  void _onPhysicsTick(_PhysicsTick event, Emitter<BallSliderState> emit) {
    final dt = _tickInterval.inMilliseconds / 1000.0;

    if (_velocity > 0) {
      _velocity = (_velocity - _friction * dt).clamp(0.0, double.infinity);
    } else if (_velocity < 0) {
      _velocity = (_velocity + _friction * dt).clamp(
        double.negativeInfinity,
        0.0,
      );
    }

    final newValue = (state.value + _velocity * dt).clamp(0.0, 1.0);
    final newRotation = state.rotationAngle + _deltaToRadians(_velocity * dt);

    final reached = newValue >= completionThreshold || newValue <= 0.0;
    if (_velocity.abs() < 0.01 || reached) {
      final snapped = newValue >= 0.5 ? 1.0 : 0.0;
      _stopPhysics();
      emit(
        _compute(snapped, _nearestQuarterTurn(newRotation), isAnimating: false),
      );
    } else {
      emit(_compute(newValue, newRotation, isAnimating: true));
    }
  }

  //  Tap
  void _onBallTapped(_BallTapped event, Emitter<BallSliderState> emit) {
    return;
  }

  //  Reset
  void _onBallReset(_BallReset event, Emitter<BallSliderState> emit) {
    _stopPhysics();
    _velocity = 0;
    emit(const BallSliderState());
  }

  //  Helpers
  void _startPhysicsLoop() {
    _stopPhysics();
    _physicsTimer = Timer.periodic(_tickInterval, (_) => add(_PhysicsTick()));
  }

  void _stopPhysics() {
    _physicsTimer?.cancel();
    _physicsTimer = null;
  }

  BallSliderState _compute(
    double raw,
    double rotation, {
    required bool isAnimating,
  }) {
    final clamped = raw.clamp(0.0, 1.0);
    return BallSliderState(
      value: clamped,
      rotationAngle: rotation,
      isComplete: clamped >= completionThreshold,
      isAnimating: isAnimating,
    );
  }

  double _nearestQuarterTurn(double radians) {
    const quarter = math.pi / 2;
    return (radians / quarter).round() * quarter;
  }

  @override
  Future<void> close() {
    _stopPhysics();
    return super.close();
  }
}
