import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class StoryProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final StoryRepo _repo = StoryRepo();
  final List<StoryModel> _stories = [];
  List<StoryModel> get stories => _stories;

  int _currentContentIndex = 0;
  int get currentContentIndex => _currentContentIndex;

  StoryModel? _currentStory;
  StoryModel? get currentStory => _currentStory;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Future<void> fetchStories() async {
    _status = DataFetchStatus.loading;
    notifyListeners();
    try {
      final result = await _repo.fetchStories();
      _stories.clear();
      _stories.addAll(result);
      logger.d(
        'Fetched \\${_stories.length} stories ------ data: \\${_stories[0].toJson()}',
      );
      _status = DataFetchStatus.success;
      notifyListeners();
    } catch (e) {
      _status = DataFetchStatus.error;
      notifyListeners();
    }
  }

  void setCurrentStory(StoryModel story) {
    _currentStory = story;
    _currentContentIndex = 0;
    notifyListeners();
  }

  void nextContent() {
    if (_currentStory == null) return;
    if (_currentContentIndex < _currentStory!.content.length) {
      _currentContentIndex++;
      notifyListeners();
    }
  }

  void previousContent() {
    if (_currentStory == null) return;
    if (_currentContentIndex > 0) {
      _currentContentIndex--;
      notifyListeners();
    }
  }

  void resetContentIndex() {
    _currentContentIndex = 0;
    notifyListeners();
  }

  Future<void> playAudio(
    String url, {
    AudioSourceType audioSourceType = AudioSourceType.asset,
  }) async {
    if (_isPlaying || url.isEmpty) return;
    _isPlaying = true;
    notifyListeners();
    try {
      final audioWidget = CustomAudioWidget(
        audioPath: url,
        audioSourceType: audioSourceType,
      );
      await audioWidget.play();
      await audioWidget.dispose();
    } catch (e) {
      logger.e('Audio play error: \\${e.toString()}');
    }
    _isPlaying = false;
    notifyListeners();
  }
}
