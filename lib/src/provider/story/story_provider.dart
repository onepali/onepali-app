import 'package:flutter/material.dart';
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
      } else {
        logger.d(
          '[StoryProvider] No childId found, not updating recommended story progress.',
        );
      }
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
    dynamic url, {
    AudioSourceType audioSourceType = AudioSourceType.asset,
  }) async {
    if (_isPlaying ||
        url == null ||
        (url is String && url.isEmpty) ||
        (url is List && url.isEmpty))
      return;
    _isPlaying = true;
    notifyListeners();
    try {
      if (url is List) {
        for (final u in url) {
          if (u is String && u.isNotEmpty) {
            final audioWidget = CustomAudioWidget(
              audioPath: u,
              audioSourceType: audioSourceType,
            );
            await audioWidget.play();
            await audioWidget.dispose();
          }
        }
      } else if (url is String && url.isNotEmpty) {
        final audioWidget = CustomAudioWidget(
          audioPath: url,
          audioSourceType: audioSourceType,
        );
        await audioWidget.play();
        await audioWidget.dispose();
      }
    } catch (e) {
      logger.e('Audio play error: \\${e.toString()}');
    }
    _isPlaying = false;
    notifyListeners();
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
}
