import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class StoryProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final StoryRepo _repo;
  final AudioPlayerService _audioPlayerService;

  StoryProvider({StoryRepo? repo, AudioPlayerService? audioPlayerService})
    : _repo = repo ?? StoryRepo(),
      _audioPlayerService = audioPlayerService ?? AudioPlayerServiceImpl();

  final List<StoryModel> _stories = [];
  List<StoryModel> get stories => _stories;

  int _currentContentIndex = 0;
  int get currentContentIndex => _currentContentIndex;

  StoryModel? _currentStory;
  StoryModel? get currentStory => _currentStory;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isAudioCompleted = false;
  bool get isAudioCompleted => _isAudioCompleted;

  int _currentAudioIndex = 0;
  int get currentAudioIndex => _currentAudioIndex;

  int _audioPlaybackGeneration = 0;
  Completer<void>? _audioCancelCompleter;

  bool _storyFinished = false;
  bool get isStoryFinished => _storyFinished;
  bool _hasTrackedStoryCompletion = false;

  Future<void> fetchStories() async {
    _status = DataFetchStatus.loading;
    notifyListeners();
    try {
      // Check if it's a guest user - we'll still fetch stories but log it
      bool isGuest = GuestUtil.isGuestUser();
      if (isGuest) {
        logger.i('Guest user detected. Fetching stories for guest mode.');
      }

      final result = await _repo.fetchStories();
      _stories.clear();
      _stories.addAll(result);
      _status = DataFetchStatus.success;
      notifyListeners();
    } catch (e) {
      logger.e('Error fetching stories: $e');
      _status = DataFetchStatus.error;
      showCustomToaster(e.toString(), isError: true);
      notifyListeners();
    }
  }

  void setCurrentStory(StoryModel story, {int? progress}) {
    unawaited(stopAudioAndResetIndex());
    _currentStory = story;
    // Resume from progress if provided and valid
    // If progress equals content.length, story is completed - restart from beginning
    if (progress != null && progress > 0 && progress < story.content.length) {
      _currentContentIndex = progress;
    } else {
      // Start from beginning (intro) if no progress, invalid progress, or story completed
      _currentContentIndex = 0;
    }
    _currentAudioIndex = 0;
    _isAudioCompleted = false;
    _storyFinished = false;
    _hasTrackedStoryCompletion = false;
    notifyListeners();
  }

  void nextContent(BuildContext context) async {
    if (_currentStory == null) return;
    await stopAudioAndResetIndex();
    if (!context.mounted) return;
    _isAudioCompleted = false;
    notifyListeners();
    if (_currentContentIndex < _currentStory!.content.length) {
      _currentContentIndex++;
      notifyListeners();

      // Skip progress tracking for guest users
      bool isGuest = GuestUtil.isGuestUser();
      if (isGuest) {
        logger.i('Guest user detected. Skipping story progress tracking.');
        // Play audio for the new content after navigation
        if (_currentContentIndex > 0 &&
            _currentContentIndex <= _currentStory!.content.length) {
          final content = _currentStory!.content[_currentContentIndex - 1];
          await _playAudioCached(content.audio);
        }
        return;
      }

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
    } else {
      await completeCurrentStory(context);
    }
  }

  Future<void> completeCurrentStory(BuildContext context) async {
    final currentStory = _currentStory;
    if (currentStory == null || _storyFinished) return;

    _storyFinished = true;
    notifyListeners();

    if (_hasTrackedStoryCompletion || GuestUtil.isGuestUser()) {
      return;
    }
    _hasTrackedStoryCompletion = true;

    String? childId;
    if (context.mounted) {
      final authState = Provider.of<AuthState>(context, listen: false);
      childId = authState.currentChildId;
    }
    childId = childId?.isNotEmpty == true
        ? childId
        : await ChildLocalStorage.getCurrentChildId();

    if (!context.mounted) return;
    await MetricsTrackingHelper.trackStoryCompletion(
      context: context,
      storyId: currentStory.nameEn,
      storyTitle: currentStory.nameNp.isNotEmpty
          ? currentStory.nameNp
          : currentStory.nameEn,
      childUid: childId,
    );
  }

  void previousContent() async {
    if (_currentStory == null) return;
    if (_currentContentIndex > 0) {
      await stopAudioAndResetIndex();
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
    await playAudio(url);
  }

  Future<void> stopAudio() async {
    await _stopAudio(resetIndex: false, invalidatePlayback: true);
  }

  Future<void> stopAudioAndResetIndex() async {
    await _stopAudio(resetIndex: true, invalidatePlayback: true);
  }

  Future<void> playAudio(dynamic url) async {
    logger.d(
      '[StoryProvider] playAudio called with url: $url, isPlaying: $_isPlaying',
    );
    final generation = _startAudioPlayback(resetIndex: true);
    await _audioPlayerService.stop();
    if (!_isCurrentAudioPlayback(generation)) return;
    if (url == null ||
        (url is String && url.isEmpty) ||
        (url is List && url.isEmpty)) {
      logger.d('[StoryProvider] playAudio: Not playing (url empty/null)');
      return;
    }
    if (url is List) {
      final sources = <String>[];
      for (final u in url) {
        if (u is String && u.isNotEmpty) {
          sources.add(u);
        }
      }
      await _playAudioSources(sources, generation);
    } else if (url is String && url.isNotEmpty) {
      await _playAudioSources([url], generation);
    }
  }

  int _startAudioPlayback({required bool resetIndex}) {
    _cancelPendingAudioPlayback();
    _isPlaying = false;
    _isAudioCompleted = false;
    if (resetIndex) {
      _currentAudioIndex = 0;
    }
    notifyListeners();
    return _audioPlaybackGeneration;
  }

  void _cancelPendingAudioPlayback() {
    _audioPlaybackGeneration++;
    final audioCancelCompleter = _audioCancelCompleter;
    if (audioCancelCompleter != null && !audioCancelCompleter.isCompleted) {
      audioCancelCompleter.complete();
    }
    _audioCancelCompleter = Completer<void>();
  }

  bool _isCurrentAudioPlayback(int generation) {
    return generation == _audioPlaybackGeneration;
  }

  Future<void> _stopAudio({
    required bool resetIndex,
    required bool invalidatePlayback,
  }) async {
    if (invalidatePlayback) {
      _cancelPendingAudioPlayback();
    }
    await _audioPlayerService.stop();
    _isPlaying = false;
    if (resetIndex) {
      _currentAudioIndex = 0;
    }
    _isAudioCompleted = false;
    notifyListeners();
  }

  Future<void> _playAudioSources(List<String> sources, int generation) async {
    if (sources.isEmpty || !_isCurrentAudioPlayback(generation)) return;
    _isPlaying = true;
    notifyListeners();

    try {
      for (var i = 0; i < sources.length; i++) {
        if (!_isCurrentAudioPlayback(generation)) return;
        _currentAudioIndex = i;
        notifyListeners();

        logger.d(
          '[StoryProvider] Playing audio from source: ${sources[i]} (index: $i)',
        );
        final completed = await _playSingleAudioSource(sources[i], generation);
        if (!completed) return;
      }
    } catch (e) {
      if (_isCurrentAudioPlayback(generation)) {
        logger.e('Audio play error: $e');
      }
    }

    if (_isCurrentAudioPlayback(generation)) {
      _isPlaying = false;
      _isAudioCompleted = true;
      notifyListeners();
      logger.d('[StoryProvider] playAudio finished, isPlaying: $_isPlaying');
    }
  }

  Future<bool> _playSingleAudioSource(String source, int generation) async {
    if (!_isCurrentAudioPlayback(generation)) return false;
    final playerComplete = _audioPlayerService.onPlayerComplete.first;
    final audioCancel = _audioCancelCompleter?.future;

    await _audioPlayerService.play(source);
    if (audioCancel == null) {
      await playerComplete;
    } else {
      await Future.any([playerComplete, audioCancel]);
    }
    return _isCurrentAudioPlayback(generation);
  }

  Future<void> fetchRecommendedStoriesForActiveChild(
    BuildContext context,
  ) async {
    if (!context.mounted) return;

    // Skip for guest users
    bool isGuest = GuestUtil.isGuestUser();
    if (isGuest) {
      logger.i('Guest user detected. Skipping recommended stories fetch.');
      return;
    }

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
        contentId: storyId,
        contentName: storyTitle,
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

  void resetStoryProvider() {
    unawaited(stopAudioAndResetIndex());
    _currentStory = null;
    _currentContentIndex = 0;
    _currentAudioIndex = 0;
    _isAudioCompleted = false;
    _isPlaying = false;
    _storyFinished = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelPendingAudioPlayback();
    unawaited(_audioPlayerService.dispose());
    super.dispose();
  }
}
