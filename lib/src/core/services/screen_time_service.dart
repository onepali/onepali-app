import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../navigator_key.dart';
import '../../src.dart';

class ScreenTimeService extends ChangeNotifier {
  static ScreenTimeService? _instance;
  static ScreenTimeService get instance => _instance ??= ScreenTimeService._();

  ScreenTimeService._();

  Timer? _trackingTimer;
  DateTime? _sessionStartTime;
  String? _currentChildId;
  ScreenTimeModel? _currentScreenTime;
  bool _isTracking = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Start tracking screen time for a child
  Future<void> startTracking(String childId) async {
    logger.i(' ScreenTimeService: Starting tracking for child $childId');

    final shouldTrack = await shouldEnableTrackingForChild(childId);
    if (!shouldTrack) {
      logger.i(
        ' ScreenTimeService: Screen time tracking disabled for child $childId',
      );
      return;
    }

    if (_isTracking && _currentChildId == childId) {
      logger.d('ScreenTimeService: Already tracking this child, skipping');
      return;
    }

    // If switching children, handle the switch properly
    if (_currentChildId != null && _currentChildId != childId) {
      await switchToChild(childId);
    } else {
      _currentChildId = childId;
      await _loadScreenTimeData();
    }

    // Start tracking
    _sessionStartTime = DateTime.now();
    _isTracking = true;

    logger.d('ScreenTimeService: Session start time: $_sessionStartTime');

    // Check if we need to reset for a new day
    if (_currentScreenTime?.shouldReset() ?? false) {
      logger.i('ScreenTimeService: Resetting screen time for new day');
      await _resetScreenTimeForNewDay();
    }

    // Log current screen time status
    if (_currentScreenTime != null) {
      logger.i(' Current screen time status:');
      logger.i(
        '   - Total allowed: ${_currentScreenTime!.totalAllowed} minutes',
      );
      logger.i('   - Total used: ${_currentScreenTime!.totalUsed} minutes');
      logger.i('   - Remaining: ${_currentScreenTime!.remainingTime} minutes');
      logger.i('   - Last updated: ${_currentScreenTime!.lastUpdated}');
    }

    // Start the tracking timer
    _trackingTimer = Timer.periodic(
      Duration(seconds: AppConstants.screenTimeCheckIntervalSeconds),
      _onTimerTick,
    );

    logger.i(
      ' ScreenTimeService: Successfully started tracking for child $childId',
    );
    notifyListeners();
  }

  /// Stop tracking screen time
  Future<void> stopTracking() async {
    if (!_isTracking) {
      logger.d('ScreenTimeService: Not tracking, nothing to stop');
      return;
    }

    logger.i(' ScreenTimeService: Stopping tracking');

    _trackingTimer?.cancel();

    if (_sessionStartTime != null && _currentChildId != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);
      final sessionMinutes = sessionDuration.inMinutes.toDouble();
      logger.i(
        ' Session completed: ${sessionMinutes.toStringAsFixed(1)} minutes',
      );
      await _updateScreenTime(sessionMinutes);
    }

    _isTracking = false;
    _sessionStartTime = null;
    // Don't clear _currentChildId and _currentScreenTime to preserve accumulated time

    logger.i(' ScreenTimeService: Successfully stopped tracking');
    notifyListeners();
  }

  /// Timer tick handler to check screen time and update
  void _onTimerTick(Timer timer) async {
    if (!_isTracking || _sessionStartTime == null || _currentChildId == null) {
      return;
    }

    final currentSessionDuration = DateTime.now().difference(
      _sessionStartTime!,
    );
    final sessionMinutes = currentSessionDuration.inMinutes.toDouble();

    logger.d(
      ' Timer tick: Total session ${sessionMinutes.toStringAsFixed(1)} minutes',
    );

    // Update the current screen time with accumulated session duration
    if (_currentScreenTime != null) {
      final previousUsed = _currentScreenTime!.totalUsed;

      // Calculate the total time used: base time + current session
      final totalUsed =
          (previousUsed + sessionMinutes)
              .clamp(0.0, double.infinity)
              .toDouble();

      final updatedScreenTime = _currentScreenTime!.copyWith(
        totalUsed: totalUsed,
        lastUpdated: DateTime.now(),
      );

      logger.d(' Screen time update:');
      logger.d('   - Base used: ${previousUsed.toStringAsFixed(1)} minutes');
      logger.d(
        '   - Current session: ${sessionMinutes.toStringAsFixed(1)} minutes',
      );
      logger.d(
        '   - Total used: ${updatedScreenTime.totalUsed.toStringAsFixed(1)} minutes',
      );
      logger.d(
        '   - Remaining: ${updatedScreenTime.remainingTime.toStringAsFixed(1)} minutes',
      );

      // Check if limit exceeded
      if (!_currentScreenTime!.isLimitExceeded &&
          updatedScreenTime.isLimitExceeded) {
        logger.w(' Screen time limit exceeded!');
        await _showScreenTimeLimitDialog();
        return; // Stop processing after showing dialog
      }

      _currentScreenTime = updatedScreenTime;

      // Save to Firestore periodically (every few ticks to avoid too many writes)
      if (sessionMinutes > 0 && sessionMinutes.toInt() % 1 == 0) {
        // Save every minute
        logger.d(' Periodic save: Saving accumulated screen time');
        await _saveScreenTimeData();

        // Reset session start time after saving to avoid double counting
        _sessionStartTime = DateTime.now();

        // Update the base time to include the session we just saved
        _currentScreenTime = _currentScreenTime!.copyWith(
          totalUsed: updatedScreenTime.totalUsed,
        );
      }
    }

    notifyListeners();
  }

  /// Load screen time data from Firestore
  Future<void> _loadScreenTimeData() async {
    if (_currentChildId == null) return;

    logger.d(' Loading screen time data for child $_currentChildId');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        logger.e('User not authenticated, cannot load screen time data');
        return;
      }

      final doc =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('children')
              .doc(_currentChildId!)
              .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['screenTimeTracking'] != null) {
          _currentScreenTime = ScreenTimeModel.fromJson(
            data['screenTimeTracking'],
          );
          logger.i(' Loaded existing screen time data:');
          logger.i(
            '   - Total allowed: ${_currentScreenTime!.totalAllowed} minutes',
          );
          logger.i('   - Total used: ${_currentScreenTime!.totalUsed} minutes');
          logger.i('   - Last updated: ${_currentScreenTime!.lastUpdated}');
        } else {
          // Create default screen time tracking from legacy screenTime field
          final screenTime = (data?['screen_time'] ?? 30).toDouble();
          logger.i(
            'Creating new screen time tracking with $screenTime minutes limit',
          );
          _currentScreenTime = ScreenTimeModel(
            totalAllowed: screenTime,
            totalUsed: 0.0,
            lastUpdated: DateTime.now(),
          );
          await _saveScreenTimeData();
        }
      } else {
        logger.w('Child document does not exist');
      }
    } catch (e) {
      logger.e('Error loading screen time data: $e');
    }
  }

  /// Save screen time data to Firestore
  Future<void> _saveScreenTimeData() async {
    if (_currentChildId == null || _currentScreenTime == null) return;

    logger.d(' Saving screen time data to Firestore');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        logger.e('User not authenticated, cannot save screen time data');
        return;
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('children')
          .doc(_currentChildId!)
          .update({'screenTimeTracking': _currentScreenTime!.toJson()});

      logger.i(' Successfully saved screen time data:');
      logger.i(
        '   - Total used: ${_currentScreenTime!.totalUsed.toStringAsFixed(1)} minutes',
      );
      logger.i(
        '   - Remaining: ${_currentScreenTime!.remainingTime.toStringAsFixed(1)} minutes',
      );
    } catch (e) {
      logger.e('Error saving screen time data: $e');
    }
  }

  /// Update screen time with session duration
  Future<void> _updateScreenTime(double sessionMinutes) async {
    if (_currentScreenTime == null) return;

    logger.d(
      'Updating screen time with ${sessionMinutes.toStringAsFixed(1)} minutes',
    );

    final previousUsed = _currentScreenTime!.totalUsed;
    _currentScreenTime = _currentScreenTime!.copyWith(
      totalUsed:
          (previousUsed + sessionMinutes)
              .clamp(0.0, double.infinity)
              .toDouble(),
      lastUpdated: DateTime.now(),
    );

    logger.i(' Screen time updated:');
    logger.i('   - Previous: ${previousUsed.toStringAsFixed(1)} minutes');
    logger.i('   - Added: ${sessionMinutes.toStringAsFixed(1)} minutes');
    logger.i(
      '   - New total: ${_currentScreenTime!.totalUsed.toStringAsFixed(1)} minutes',
    );
    logger.i(
      '   - Remaining: ${_currentScreenTime!.remainingTime.toStringAsFixed(1)} minutes',
    );

    await _saveScreenTimeData();
  }

  /// Reset screen time for a new day
  Future<void> _resetScreenTimeForNewDay() async {
    if (_currentScreenTime == null) return;

    logger.i(' Resetting screen time for new day');
    logger.i(
      '   - Previous used: ${_currentScreenTime!.totalUsed.toStringAsFixed(1)} minutes',
    );

    _currentScreenTime = _currentScreenTime!.resetForNewDay();
    await _saveScreenTimeData();

    logger.i(' Screen time reset completed');
    logger.i(
      '   - New total used: ${_currentScreenTime!.totalUsed.toStringAsFixed(1)} minutes',
    );
    logger.i(
      '   - Available: ${_currentScreenTime!.remainingTime.toStringAsFixed(1)} minutes',
    );
  }

  /// Show screen time limit exceeded dialog
  Future<void> _showScreenTimeLimitDialog() async {
    logger.w('SCREEN TIME LIMIT EXCEEDED - Showing dialog');

    final context = navigatorKey.currentContext;
    if (context == null) {
      logger.e('Cannot show dialog - no context available');
      return;
    }

    logger.i('Displaying screen time limit dialog');

    await DialogManager.showCustomDialog(
      context: context,
      title: 'Time\'s Up!',
      content: 'Come back tomorrow',
      image: Assets.timeUpSvg,
      isSvg: true,
      onConfirm: () {
        logger.i(' User requested to extend time - navigating to parent PIN');

        Navigator.of(context).pop();

        Misc.onLayoutRendered(() {
          try {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AppRoutes.parentPinScreen,
              (route) => false,
              arguments: {
                'fromScreenTimeLimit': true,
                'childId': _currentChildId,
              },
            );
            logger.i('Navigation to parent PIN screen completed');
          } catch (e) {
            logger.e('Navigation error: $e');
            try {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.parentPinScreen,
                (route) => false,
                arguments: {
                  'fromScreenTimeLimit': true,
                  'childId': _currentChildId,
                },
              );
            } catch (e2) {
              logger.e('Fallback navigation failed: $e2');
            }
          }
        });
      },
      confirmButtonText: 'Extend Time',
      barrierDismissible: false,
      hasSingleButton: true,
    );
  }

  /// Check if screen time limit is already exceeded and show dialog if needed
  Future<bool> checkAndHandleExceededLimit(String childId) async {
    logger.i('🔍 Checking screen time limit for child $childId');

    // Load the child's screen time data
    final previousChildId = _currentChildId;
    _currentChildId = childId;
    await _loadScreenTimeData();

    if (_currentScreenTime == null) {
      logger.w(' No screen time data found for child $childId');
      _currentChildId = previousChildId; // Restore previous child ID
      return false;
    }

    // Reset whenever a new day is detected
    if (_currentScreenTime!.shouldReset()) {
      logger.i('Resetting screen time for new day (new day detected)');
      await _resetScreenTimeForNewDay();
    }

    // Check if limit is already exceeded
    if (_currentScreenTime!.isLimitExceeded) {
      logger.w('Screen time limit already exceeded!');
      logger.i(
        ' Current usage: ${_currentScreenTime!.totalUsed.toStringAsFixed(1)} minutes',
      );
      logger.i(
        ' Allowed: ${_currentScreenTime!.totalAllowed.toStringAsFixed(1)} minutes',
      );

      await _showScreenTimeLimitDialog();
      _currentChildId = previousChildId; // Restore previous child ID
      return true; // Limit exceeded
    }

    logger.i(' Screen time limit check passed');
    logger.i(
      ' Used: ${_currentScreenTime!.totalUsed.toStringAsFixed(1)}/${_currentScreenTime!.totalAllowed.toStringAsFixed(1)} minutes',
    );
    logger.i(
      ' Remaining: ${_currentScreenTime!.remainingTime.toStringAsFixed(1)} minutes',
    );

    return false; // Limit not exceeded
  }

  /// Get current screen time status
  ScreenTimeModel? get currentScreenTime => _currentScreenTime;

  /// Check if tracking is active
  bool get isTracking => _isTracking;

  /// Get current child ID being tracked
  String? get currentChildId => _currentChildId;

  /// Get remaining time in minutes
  double get remainingTime => _currentScreenTime?.remainingTime ?? 0.0;

  /// Check if limit is exceeded
  bool get isLimitExceeded => _currentScreenTime?.isLimitExceeded ?? false;

  /// Check if the screen time limit is already exceeded
  /// Returns true if limit exceeded, false otherwise
  Future<bool> checkScreenTimeLimitExceeded(String childId) async {
    return await checkAndHandleExceededLimit(childId);
  }

  /// Check if screen time tracking should be enabled for a child
  /// This method fetches the child data from Firestore to check hasScreenTime flag
  Future<bool> shouldEnableTrackingForChild(String childId) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      if (user == null) {
        logger.w('No authenticated user found');
        return false;
      }

      final doc =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('children')
              .doc(childId)
              .get();

      if (!doc.exists) {
        logger.w('Child document not found for ID: $childId');
        return false;
      }

      final data = doc.data()!;
      final hasScreenTime = data['has_screen_time'] ?? false;
      final screenTime = (data['screen_time'] ?? 0).toDouble();

      logger.d(
        'Child $childId - hasScreenTime: $hasScreenTime, screenTime: $screenTime',
      );

      return hasScreenTime && screenTime > 0;
    } catch (e) {
      logger.e(
        'Error checking if tracking should be enabled for child $childId: $e',
      );
      return false;
    }
  }

  /// Manually reset screen time (for testing or admin purposes)
  Future<void> resetScreenTime() async {
    if (_currentScreenTime != null) {
      _currentScreenTime = _currentScreenTime!.resetForNewDay();
      await _saveScreenTimeData();
      notifyListeners();
    }
  }

  /// Update screen time limit
  Future<void> updateScreenTimeLimit(double newLimit) async {
    if (_currentScreenTime != null) {
      _currentScreenTime = _currentScreenTime!.copyWith(totalAllowed: newLimit);
      await _saveScreenTimeData();
      notifyListeners();
    }
  }

  /// Switch to tracking a different child
  Future<void> switchToChild(String childId) async {
    if (_currentChildId == childId) {
      logger.d('Already tracking child $childId, no switch needed');
      return;
    }

    logger.i('Switching tracking from child $_currentChildId to $childId');

    // Save current session data if tracking
    if (_isTracking && _sessionStartTime != null && _currentChildId != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);
      final sessionMinutes = sessionDuration.inMinutes.toDouble();

      if (sessionMinutes > 0 && _currentScreenTime != null) {
        logger.d(' Saving session data for previous child $_currentChildId');
        await _updateScreenTime(sessionMinutes);
      }
    }

    // Switch to new child
    _currentChildId = childId;
    _currentScreenTime = null; // Clear previous child's data

    // Load new child's data
    await _loadScreenTimeData();

    // Do NOT reset screen time for new day here; only at midnight in checkAndHandleExceededLimit
    if (_isTracking) {
      _sessionStartTime =
          DateTime.now(); // Reset session start time for new child
      logger.i(' Successfully switched to tracking child $childId');
    }

    notifyListeners();
  }

  /// Extend current screen time limit
  Future<void> extendTime(double additionalMinutes) async {
    if (_currentScreenTime == null) {
      logger.w(
        'ScreenTimeService: Cannot extend time - no current screen time data',
      );
      return;
    }

    logger.i('ScreenTimeService: Extending time by $additionalMinutes minutes');

    // Update the current screen time limit
    final newLimit = _currentScreenTime!.totalAllowed + additionalMinutes;
    _currentScreenTime = _currentScreenTime!.copyWith(totalAllowed: newLimit);

    // Save the updated data
    await _saveScreenTimeData();

    logger.i(
      'ScreenTimeService: Time extended successfully. New limit: ${_currentScreenTime!.totalAllowed.toStringAsFixed(1)} minutes',
    );
    logger.i(
      'ScreenTimeService: Remaining time: ${_currentScreenTime!.remainingTime.toStringAsFixed(1)} minutes',
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _trackingTimer?.cancel();
    super.dispose();
  }
}
