import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

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

  AudioPlayer? _audioPlayerInstance;

  Future<void> fetchStories() async {
    _status = DataFetchStatus.loading;
    notifyListeners();
    try {
      final result = await _repo.fetchStories();
      _stories.clear();
      _stories.addAll(result);
      // // Print the first story's data
      // if (_stories.isNotEmpty) {
      //   logger.d('First story: ${jsonEncode(_stories[0].toJson())}');
      // }
      // // Write all stories to a formatted JSON file (mobile/desktop only)
      // final storiesJson = _stories.map((e) => e.toJson()).toList();
      // final formattedJson = const JsonEncoder.withIndent(
      //   '  ',
      // ).convert(storiesJson);
      // final file = File('stories_dump.json');
      // await file.writeAsString(formattedJson);
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

  void nextContent(BuildContext context) async {
    if (_currentStory == null) return;
    if (_currentContentIndex < _currentStory!.content.length) {
      _currentContentIndex++;
      notifyListeners();
      final authState = Provider.of<AuthState>(context, listen: false);
      final childId = authState.currentChildId ?? '';
      if (childId.isNotEmpty) {
        final recommendedStoryProvider = Provider.of<RecommendedStoryProvider>(
          context,
          listen: false,
        );
        logger.d(
          '[StoryProvider] Updating recommended story progress for childId: $childId, storyId: ${_currentStory!.nameEn}, progress: $_currentContentIndex',
        );
        await recommendedStoryProvider.saveOrUpdateStoryProgress(
          childId: childId,
          storyId: _currentStory!.nameEn,
          progress: _currentContentIndex,
          title: _currentStory!.nameEn,
          image: _currentStory!.thumbnail,
        );

        // If this is the last content, mark story as completed for parent metrics
        if (_currentContentIndex == _currentStory!.content.length) {
          if (!context.mounted) return;
          await MetricsTrackingHelper.trackStoryCompletion(
            context: context,
            storyId: _currentStory!.nameEn,
            storyTitle:
                _currentStory!.nameNp.isNotEmpty
                    ? _currentStory!.nameNp
                    : _currentStory!.nameEn,
          );
        }
      } else {
        logger.d(
          '[StoryProvider] No childId found, not updating recommended story progress.',
        );
      }
      // Play audio for the new content after navigation
      if (_currentContentIndex > 0 &&
          _currentContentIndex <= _currentStory!.content.length) {
        final content = _currentStory!.content[_currentContentIndex - 1];
        await _playAudioCached(content.audio);
      }
    }
  }

  void previousContent() async {
    if (_currentStory == null) return;
    if (_currentContentIndex > 0) {
      _currentContentIndex--;
      notifyListeners();
      // Play audio for the new content after navigation
      if (_currentContentIndex > 0 &&
          _currentContentIndex <= _currentStory!.content.length) {
        final content = _currentStory!.content[_currentContentIndex - 1];
        await _playAudioCached(content.audio);
      }
    }
  }

  Future<void> _playAudioCached(dynamic url) async {
    if (url == null) return;
    if (url is String) {
      if (url.isEmpty) return;
      String sourcePath = url;
      AudioSourceType sourceType = AudioSourceType.network;
      try {
        final file = await DefaultCacheManager().getSingleFile(url);
        if (file.existsSync()) {
          sourcePath = file.path;
          sourceType = AudioSourceType.asset;
        }
      } catch (_) {}
      await playAudio(sourcePath, audioSourceType: sourceType);
    } else if (url is List) {
      for (final u in url) {
        if (u is String && u.isNotEmpty) {
          String sourcePath = u;
          AudioSourceType sourceType = AudioSourceType.network;
          try {
            final file = await DefaultCacheManager().getSingleFile(u);
            if (file.existsSync()) {
              sourcePath = file.path;
              sourceType = AudioSourceType.asset;
            }
          } catch (_) {}
          await playAudio(sourcePath, audioSourceType: sourceType);
        }
      }
    }
  }

  Future<void> stopAudio() async {
    if (_audioPlayerInstance != null) {
      await _audioPlayerInstance!.stop();
      await _audioPlayerInstance!.dispose();
      _audioPlayerInstance = null;
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> playAudio(
    dynamic url, {
    AudioSourceType audioSourceType = AudioSourceType.network,
  }) async {
    logger.d(
      '[StoryProvider] playAudio called with url: $url, isPlaying: $_isPlaying',
    );
    // Stop any currently playing audio before starting new
    await stopAudio();
    if (url == null ||
        (url is String && url.isEmpty) ||
        (url is List && url.isEmpty)) {
      logger.d('[StoryProvider] playAudio: Not playing (url empty/null)');
      return;
    }
    _isPlaying = true;
    notifyListeners();
    try {
      if (url is List) {
        for (final u in url) {
          if (u is String && u.isNotEmpty) {
            logger.d('[StoryProvider] Playing audio from list: $u');
            final audioWidget = CustomAudioWidget(
              audioPath: u,
              audioSourceType: audioSourceType,
            );
            _audioPlayerInstance = audioWidget.audioPlayer;
            await audioWidget.play();
            await audioWidget.audioPlayer.onPlayerComplete.first;
          }
        }
      } else if (url is String && url.isNotEmpty) {
        logger.d('[StoryProvider] Playing audio from string: $url');
        final audioWidget = CustomAudioWidget(
          audioPath: url,
          audioSourceType: audioSourceType,
        );
        _audioPlayerInstance = audioWidget.audioPlayer;
        await audioWidget.play();
        await audioWidget.audioPlayer.onPlayerComplete.first;
      }
    } catch (e) {
      logger.e('Audio play error: $e');
    }
    _isPlaying = false;
    notifyListeners();
    logger.d('[StoryProvider] playAudio finished, isPlaying: $_isPlaying');
  }

  Future<void> fetchRecommendedStoriesForActiveChild(
    BuildContext context,
  ) async {
    if (!context.mounted) return;
    final recommendedStoryProvider = Provider.of<RecommendedStoryProvider>(
      context,
      listen: false,
    );
    await recommendedStoryProvider.fetchRecommendedStories();
  }

  // Track story completion and update parent metrics
  Future<void> trackStoryCompletion({
    required String parentUid,
    required String childUid,
    required String storyId,
    required String storyTitle,
    required BuildContext context,
  }) async {
    try {
      // Get the metrics provider
      final metricsProvider = context.read<PzMetricsProvider>();

      // Track the activity completion
      await metricsProvider.trackActivityCompletion(
        parentUid: parentUid,
        childUid: childUid,
        topicName: storyTitle,
        activityType: ActivityType.story,
      );

      logger.d('Story completion tracked: $storyId ($storyTitle)');
    } catch (e) {
      logger.e('Error tracking story completion: $e');
    }
  }

  // Track story answer for interactive stories
  Future<void> trackStoryAnswer({
    required String parentUid,
    required String childUid,
    required bool isCorrect,
    required String storyTitle,
    required BuildContext context,
  }) async {
    try {
      // Get the metrics provider
      final metricsProvider = context.read<PzMetricsProvider>();

      // Track the answer
      await metricsProvider.trackAnswer(
        parentUid: parentUid,
        childUid: childUid,
        isCorrect: isCorrect,
        topicName: storyTitle,
      );

      logger.d(
        'Story answer tracked: ${isCorrect ? 'Correct' : 'Incorrect'} in $storyTitle',
      );
    } catch (e) {
      logger.e('Error tracking story answer: $e');
    }
  }
}
