import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class StoryProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final StoryRepo _repo = StoryRepo();
  final List<StoryModel> _stories = [];
  List<StoryModel> get stories => _stories;

  Future<void> fetchStories() async {
    _status = DataFetchStatus.loading;
    notifyListeners();
    try {
      final result = await _repo.fetchStories();
      _stories.clear();
      _stories.addAll(result);
      logger.d(
        'Fetched ${_stories.length} stories ------ data: ${_stories[0].toJson()}',
      );
      _status = DataFetchStatus.success;
      notifyListeners();
    } catch (e) {
      _status = DataFetchStatus.error;
      notifyListeners();
    }
  }
}
