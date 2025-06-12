import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

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
      String sourcePath = audioPath;
      AudioSourceType sourceType = audioSourceType;
      if (audioSourceType == AudioSourceType.network) {
        // Try to get from cache
        final file = await DefaultCacheManager().getSingleFile(audioPath);
        if (file.existsSync()) {
          sourcePath = file.path;
          sourceType = AudioSourceType.asset; // Play as local file
          logger.i('Playing from cache: $sourcePath');
        } else {
          logger.i('Audio not cached, will stream from network: $audioPath');
        }
      }
      final audioWidget = CustomAudioWidget(
        audioPath: sourcePath,
        audioSourceType: sourceType,
      );
      // Preload next audio if available
      if (_currentIndex < contents.length - 1) {
        final nextAudioPath = contents[_currentIndex + 1].audio;
        logger.i('Preloading next audio: $nextAudioPath');
        if (nextAudioPath.isNotEmpty) {
          // Preload/caching for next audio
          if (audioSourceType == AudioSourceType.network) {
            await DefaultCacheManager().downloadFile(nextAudioPath);
            logger.i('Preloaded and cached next audio');
          }
        }
      }
      await audioWidget.play();
    }
    _isPlaying = false;
    notifyListeners();
  }

  void navigateToNextContent(
    List<LessonContent> contents,
    BuildContext context,
    Lesson lesson,
  ) async {
    if (_currentIndex < contents.length - 1) {
      _currentIndex++;
      notifyListeners();
      // Save progress after moving to next
      final prefs = SharedPreferencesService();
      final childId = await prefs.getStringPref(AppConstants.childIdKey) ?? '';
      if (childId.isNotEmpty) {
        if (!context.mounted) return;
        final recommendedLessonProvider =
            context.read<RecommendedLessonProvider>();
        await recommendedLessonProvider.saveOrUpdateLessonProgress(
          childId: childId,
          lessonId: lesson.id.toString(),
          progress: _currentIndex + 1,
          title: contents[_currentIndex].nameNp,
          image: contents[_currentIndex].image,
        );
      }
    }
  }

  void navigateToPreviousContent(
    List<LessonContent> contents,
    BuildContext context,
    Lesson lesson,
  ) async {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
      // Save progress after moving to previous
      final prefs = SharedPreferencesService();
      final childId = await prefs.getStringPref(AppConstants.childIdKey) ?? '';
      if (!context.mounted) return;
      if (childId.isNotEmpty) {
        final recommendedLessonProvider =
            context.read<RecommendedLessonProvider>();
        await recommendedLessonProvider.saveOrUpdateLessonProgress(
          childId: childId,
          lessonId: lesson.id.toString(),
          progress: _currentIndex + 1,
          title: contents[_currentIndex].nameNp,
          image: contents[_currentIndex].image,
        );
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer1.dispose();
    _audioPlayer2.dispose();
    super.dispose();
  }
}
