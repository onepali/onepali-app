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

  Future<void> playAudio(List<Lesson> lessons) async {
    if (_isPlaying) return;

    _isPlaying = true;
    notifyListeners();

    await _audioPlayer1.play(AssetSource(lessons[_currentIndex].audio));
    await _audioPlayer1.onPlayerComplete.first;

    await _audioPlayer2.play(AssetSource(lessons[_currentIndex].wordAudio));
    await _audioPlayer2.onPlayerComplete.first;

    _onPlaybackComplete(lessons);
  }

  void _onPlaybackComplete(List<Lesson> lessons) {
    _isPlaying = false;
    notifyListeners();
    navigateToNext(lessons);
  }

  void navigateToNext(List<Lesson> lessons) {
    if (_currentIndex < lessons.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void navigateToPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void resetIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer1.dispose();
    _audioPlayer2.dispose();
    super.dispose();
  }
}
