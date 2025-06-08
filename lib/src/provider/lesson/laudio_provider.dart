import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../src.dart';

class LessonAudioProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer1 = AudioPlayer();
  final AudioPlayer _audioPlayer2 = AudioPlayer();
  bool _isPlaying = false;
  int _currentIndex = 0;

  bool get isPlaying => _isPlaying;
  int get currentIndex => _currentIndex;

  // Future<void> playAudio(List<Lesson> lessons) async {
  //   if (_isPlaying) return;

  //   _isPlaying = true;
  //   notifyListeners();

  //   // await _audioPlayer1.play(AssetSource(lessons[_currentIndex].audio));
  //   // await _audioPlayer1.onPlayerComplete.first;

  //   // await _audioPlayer2.play(AssetSource(lessons[_currentIndex].wordAudio));
  //   await _audioPlayer2.onPlayerComplete.first;

  //   _onPlaybackComplete(lessons);
  // }

  // void _onPlaybackComplete(List<Lesson> lessons) {
  //   _isPlaying = false;
  //   notifyListeners();
  //   navigateToNext(lessons);
  // }

  // void navigateToNext(List<Lesson> lessons) {
  //   if (_currentIndex < lessons.length - 1) {
  //     _currentIndex++;
  //     notifyListeners();
  //   }
  // }

  // void navigateToPrevious() {
  //   if (_currentIndex > 0) {
  //     _currentIndex--;
  //     notifyListeners();
  //   }
  // }

  // void resetIndex(int index) {
  //   _currentIndex = index;
  //   notifyListeners();
  // }

  // void updateCurrentIndex(int index) {
  //   _currentIndex = index;
  //   notifyListeners();
  // }

  Future<void> playContentAudio(
    List<LessonContent> contents, {
    AudioSourceType audioSourceType = AudioSourceType.asset,
  }) async {
    if (_isPlaying) return;
    _isPlaying = true;
    notifyListeners();
    final audioPath = contents[_currentIndex].audio;
    logger.i('Playing audio: $audioPath');
    if (audioPath.isNotEmpty) {
      final audioWidget = CustomAudioWidget(
        audioPath: audioPath,
        audioSourceType: audioSourceType,
      );
      // Preload next audio if available
      if (_currentIndex < contents.length - 1) {
        final nextAudioPath = contents[_currentIndex + 1].audio;
        logger.i('Preloading next audio: $nextAudioPath');
        if (nextAudioPath.isNotEmpty) {
          // Preload by creating and releasing the player (network only)
          if (audioSourceType == AudioSourceType.network) {
            final preloader = AudioPlayer();
            try {
              await preloader.setSource(UrlSource(nextAudioPath));
              logger.i('Preloaded next audio successfully');
            } catch (e) {
              logger.i('Failed to preload next audio: $e');
            }
            await preloader.release();
          }
        }
      }
      await audioWidget.play();
    }
    _isPlaying = false;
    notifyListeners();
  }

  void navigateToNextContent(List<LessonContent> contents) {
    if (_currentIndex < contents.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void navigateToPreviousContent() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _audioPlayer1.dispose();
    _audioPlayer2.dispose();
    super.dispose();
  }
}
