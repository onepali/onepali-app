import 'package:flutter/material.dart';
import '../../../src.dart';

class LessonProvider extends ChangeNotifier {
  final LessonRepo _lessonRepo = LessonRepo();
  DataFetchStatus _status = DataFetchStatus.initial;
  LessonModel? _lessons;

  List<Category> _categories = [];
  List<Category> _subcategories = [];
  List<Lesson> _lessonsList = [];

  DataFetchStatus get status => _status;
  LessonModel? get lessons => _lessons;
  List<Category> get categories => _categories;
  List<Category> get subcategories => _subcategories;
  List<Lesson> get lessonsList => _lessonsList;

  Future<void> fetchLessons(BuildContext context) async {
    _status = DataFetchStatus.loading;
    notifyListeners();

    final response = await _lessonRepo.lessons();

    if (response.status) {
      _lessons = response.data as LessonModel;
      _categories = _lessons?.categories ?? [];
      _subcategories = _categories.expand((cat) => cat.subcategories).toList();
      _lessonsList = _categories.expand((cat) => cat.lessons).toList();

      _status = DataFetchStatus.success;
      notifyListeners();
    } else {
      _status = DataFetchStatus.error;
      notifyListeners();

      if (!context.mounted) return;
    }
  }
}
