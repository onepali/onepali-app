import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:onepali/src/features/lessons/models/nepali_letter.dart';

/// Service class for loading and managing Nepali letters
class LetterService {
  static List<NepaliLetter>? _cachedLetters;

  /// Load all Nepali letters from JSON file
  /// Uses caching to avoid repeated file reads
  static Future<List<NepaliLetter>> loadLetters() async {
    if (_cachedLetters != null) {
      return _cachedLetters!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/nepali_letters.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      _cachedLetters = jsonList
          .map((json) => NepaliLetter.fromJson(json as Map<String, dynamic>))
          .toList();
      return _cachedLetters!;
    } catch (e) {
      log('Error loading letters: $e');
      return [];
    }
  }

  /// Get a specific letter by name (e.g., "ka", "kha")
  static Future<NepaliLetter?> getLetterByName(String name) async {
    final letters = await loadLetters();
    try {
      return letters.firstWhere((letter) => letter.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Get a specific letter by character (e.g., "क", "ख")
  static Future<NepaliLetter?> getLetterByChar(String char) async {
    final letters = await loadLetters();
    try {
      return letters.firstWhere((letter) => letter.letter == char);
    } catch (e) {
      return null;
    }
  }

  /// Get letters by category (e.g., "consonant", "vowel", "number")
  static Future<List<NepaliLetter>> getLettersByCategory(
    String category,
  ) async {
    final letters = await loadLetters();
    return letters.where((letter) => letter.category == category).toList();
  }

  /// Get letters by difficulty level
  /// [minDifficulty] and [maxDifficulty] are inclusive (1-5)
  static Future<List<NepaliLetter>> getLettersByDifficulty({
    int minDifficulty = 1,
    int maxDifficulty = 5,
  }) async {
    final letters = await loadLetters();
    return letters.where((letter) {
      if (letter.difficulty == null) return false;
      return letter.difficulty! >= minDifficulty &&
          letter.difficulty! <= maxDifficulty;
    }).toList();
  }

  /// Get letters that have a specific tag
  static Future<List<NepaliLetter>> getLettersByTag(String tag) async {
    final letters = await loadLetters();
    return letters.where((letter) {
      return letter.tags?.contains(tag) ?? false;
    }).toList();
  }

  /// Get letters that match all specified tags
  static Future<List<NepaliLetter>> getLettersByTags(List<String> tags) async {
    final letters = await loadLetters();
    return letters.where((letter) {
      if (letter.tags == null || letter.tags!.isEmpty) return false;
      return tags.every((tag) => letter.tags!.contains(tag));
    }).toList();
  }

  /// Get all unique categories from loaded letters
  static Future<List<String>> getAllCategories() async {
    final letters = await loadLetters();
    final categories = letters
        .map((letter) => letter.category)
        .whereType<String>()
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  /// Get all unique tags from loaded letters
  static Future<List<String>> getAllTags() async {
    final letters = await loadLetters();
    final tags = <String>{};
    for (final letter in letters) {
      if (letter.tags != null) {
        tags.addAll(letter.tags!);
      }
    }
    final tagList = tags.toList();
    tagList.sort();
    return tagList;
  }

  /// Get letters grouped by category
  static Future<Map<String, List<NepaliLetter>>>
  getLettersGroupedByCategory() async {
    final letters = await loadLetters();
    final grouped = <String, List<NepaliLetter>>{};

    for (final letter in letters) {
      final category = letter.category ?? 'uncategorized';
      grouped.putIfAbsent(category, () => []);
      grouped[category]!.add(letter);
    }

    return grouped;
  }

  /// Get letters sorted by difficulty (ascending)
  static Future<List<NepaliLetter>> getLettersSortedByDifficulty() async {
    final letters = await loadLetters();
    final sorted = [...letters];
    sorted.sort((a, b) {
      final diffA = a.difficulty ?? 999;
      final diffB = b.difficulty ?? 999;
      return diffA.compareTo(diffB);
    });
    return sorted;
  }

  /// Get random letter (useful for practice mode)
  static Future<NepaliLetter?> getRandomLetter() async {
    final letters = await loadLetters();
    if (letters.isEmpty) return null;

    final random = DateTime.now().millisecondsSinceEpoch % letters.length;
    return letters[random];
  }

  /// Get random letter by difficulty
  static Future<NepaliLetter?> getRandomLetterByDifficulty(
    int difficulty,
  ) async {
    final letters = await getLettersByDifficulty(
      minDifficulty: difficulty,
      maxDifficulty: difficulty,
    );
    if (letters.isEmpty) return null;

    final random = DateTime.now().millisecondsSinceEpoch % letters.length;
    return letters[random];
  }

  /// Search letters by name or character
  static Future<List<NepaliLetter>> searchLetters(String query) async {
    final letters = await loadLetters();
    final lowerQuery = query.toLowerCase();

    return letters.where((letter) {
      return letter.letter.contains(query) ||
          letter.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get count of letters
  static Future<int> getLetterCount() async {
    final letters = await loadLetters();
    return letters.length;
  }

  /// Get count of strokes across all letters
  static Future<int> getTotalStrokeCount() async {
    final letters = await loadLetters();
    return letters.fold<int>(0, (sum, letter) => sum + letter.strokeCount);
  }

  /// Validate all letters
  /// Returns list of invalid letters with reasons
  static Future<Map<String, List<String>>> validateAllLetters() async {
    final letters = await loadLetters();
    final errors = <String, List<String>>{};

    for (final letter in letters) {
      final letterErrors = <String>[];

      if (!letter.isValid()) {
        letterErrors.add('Letter is invalid');
      }

      for (var i = 0; i < letter.strokes.length; i++) {
        if (!letter.strokes[i].isValid()) {
          letterErrors.add('Stroke ${i + 1} is invalid');
        }
      }

      if (letterErrors.isNotEmpty) {
        errors['${letter.letter} (${letter.name})'] = letterErrors;
      }
    }

    return errors;
  }

  /// Get statistics about loaded letters
  static Future<LetterStatistics> getStatistics() async {
    final letters = await loadLetters();

    final categories = await getAllCategories();
    final tags = await getAllTags();

    final difficultyCount = <int, int>{};
    for (final letter in letters) {
      if (letter.difficulty != null) {
        difficultyCount[letter.difficulty!] =
            (difficultyCount[letter.difficulty!] ?? 0) + 1;
      }
    }

    final totalStrokes = await getTotalStrokeCount();
    final avgStrokes = letters.isEmpty ? 0.0 : totalStrokes / letters.length;

    return LetterStatistics(
      totalLetters: letters.length,
      totalStrokes: totalStrokes,
      averageStrokesPerLetter: avgStrokes,
      categories: categories,
      tags: tags,
      difficultyDistribution: difficultyCount,
    );
  }

  /// Clear cache (useful for hot reload during development)
  static void clearCache() {
    _cachedLetters = null;
  }

  /// Reload letters from file (clears cache and reloads)
  static Future<List<NepaliLetter>> reloadLetters() async {
    clearCache();
    return loadLetters();
  }
}

/// Statistics about the loaded letters
class LetterStatistics {
  final int totalLetters;
  final int totalStrokes;
  final double averageStrokesPerLetter;
  final List<String> categories;
  final List<String> tags;
  final Map<int, int> difficultyDistribution;

  LetterStatistics({
    required this.totalLetters,
    required this.totalStrokes,
    required this.averageStrokesPerLetter,
    required this.categories,
    required this.tags,
    required this.difficultyDistribution,
  });

  @override
  String toString() {
    return '''
Letter Statistics:
  Total Letters: $totalLetters
  Total Strokes: $totalStrokes
  Average Strokes per Letter: ${averageStrokesPerLetter.toStringAsFixed(2)}
  Categories: ${categories.join(', ')}
  Tags: ${tags.join(', ')}
  Difficulty Distribution: $difficultyDistribution
''';
  }
}
