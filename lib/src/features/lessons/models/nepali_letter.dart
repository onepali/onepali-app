import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

/// Represents a Nepali letter with its strokes and metadata
class NepaliLetter {
  /// The actual Nepali character (e.g., "क", "ख")
  final String letter;

  /// English transliteration/name (e.g., "ka", "kha")
  final String name;

  /// SVG viewBox in format "minX minY width height" (e.g., "0 0 78 86")
  final String viewBox;
  final String viewBoxMobile;

  /// List of strokes that make up this letter
  final Strokes strokes;

  /// Optional category (e.g., "consonant", "vowel", "number")
  final String? category;

  /// Optional difficulty level (1-5)
  final int? difficulty;

  /// Optional tags for filtering (e.g., ["beginner", "common"])
  final List<String>? tags;
  String? outlinePathTb;
  String? outlinePathMb;
  NepaliLetter({
    required this.letter,
    required this.name,
    required this.viewBox,
    required this.viewBoxMobile,
    required this.strokes,
    this.category,
    this.difficulty,
    this.tags,
    this.outlinePathTb,
    this.outlinePathMb,
  });

  /// Create from JSON
  factory NepaliLetter.fromJson(Map<String, dynamic> json) {
    // final strokes = json['strokes'] as Map<String, dynamic>;
    // strokes.sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));
    return NepaliLetter(
      letter: json['letter'] as String,
      name: json['name'] as String,
      viewBox: json['viewBox'] as String,
      viewBoxMobile: json['viewBoxMobile'] as String,
      strokes: Strokes.fromJson(json['strokes'] as Map<String, dynamic>),
      category: json['category'] as String?,
      difficulty: json['difficulty'] as int?,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
      outlinePathTb: json['outlinePathTb'] as String?,
      outlinePathMb: json['outlinePathMb'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'letter': letter,
      'name': name,
      'viewBox': viewBox,
      'viewBoxMobile': viewBoxMobile,
      'strokes': {
        'mb': strokes.mb.map((s) => s.toJson()).toList(),
        'tb': strokes.tb.map((s) => s.toJson()).toList(),
      },
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
      if (tags != null) 'tags': tags,
    };
  }

  /// Parse viewBox to get width and height
  Size getSize(bool isMobile) {
    final parts = isMobile ? viewBoxMobile.split(' ') : viewBox.split(' ');
    if (parts.length != 4) {
      throw FormatException(
        'Invalid viewBox format: ${isMobile ? viewBoxMobile : viewBox}',
      );
    }
    return Size(double.parse(parts[2]), double.parse(parts[3]));
  }

  /// Get viewBox origin (minX, minY)
  Offset getOrigin() {
    final parts = viewBox.split(' ');
    if (parts.length != 4) {
      throw FormatException('Invalid viewBox format: $viewBox');
    }
    return Offset(double.parse(parts[0]), double.parse(parts[1]));
  }

  /// Get aspect ratio (width / height)
  double getAspectRatio(bool isMobile) {
    final size = getSize(isMobile);
    return size.width / size.height;
  }

  /// Get total number of strokes
  int get strokeCount => strokes.tb.length;

  /// Check if this letter is valid`
  bool isValid(bool isMobile) {
    return letter.isNotEmpty && name.isNotEmpty && _isValidViewBox(isMobile);
  }

  bool _isValidViewBox(bool isMobile) {
    try {
      final parts = isMobile ? viewBoxMobile.split(' ') : viewBox.split(' ');
      if (parts.length != 4) return false;

      for (var part in parts) {
        double.parse(part);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Create a copy with modified fields
  NepaliLetter copyWith({
    String? letter,
    String? name,
    String? viewBox,
    String? viewBoxMobile,
    Strokes? strokes,
    String? category,
    int? difficulty,
    List<String>? tags,
  }) {
    return NepaliLetter(
      letter: letter ?? this.letter,
      name: name ?? this.name,
      viewBox: viewBox ?? this.viewBox,
      viewBoxMobile: this.viewBoxMobile,
      strokes: strokes ?? this.strokes,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'NepaliLetter(letter: $letter, name: $name, strokes: ${strokes.tb.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NepaliLetter &&
        other.letter == letter &&
        other.name == name;
  }

  Size getActualSize(bool isMobile) {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;
    final strokes = isMobile ? this.strokes.mb : this.strokes.tb;
    for (var stroke in strokes) {
      Path p = parseSvgPathData(stroke.path);
      Rect bounds = p.getBounds();
      if (bounds.left < minX) minX = bounds.left;
      if (bounds.top < minY) minY = bounds.top;
      if (bounds.right > maxX) maxX = bounds.right;
      if (bounds.bottom > maxY) maxY = bounds.bottom;
    }

    // Return the actual width and height covered by the paths
    // Adding a small padding (10) ensures the letter isn't cut off at the edges
    return Size(maxX + 10, maxY + 10);
  }

  @override
  int get hashCode => letter.hashCode ^ name.hashCode;
}

class Strokes {
  List<LetterStroke> mb;
  List<LetterStroke> tb;
  Strokes({required this.mb, required this.tb});
  factory Strokes.fromJson(Map<String, dynamic> json) {
    return Strokes(
      mb: (json['mb'] as List)
          .map(
            (stroke) => LetterStroke.fromJson(stroke as Map<String, dynamic>),
          )
          .toList(),
      tb: (json['tb'] as List)
          .map(
            (stroke) => LetterStroke.fromJson(stroke as Map<String, dynamic>),
          )
          .toList(),
    );
  }
  Strokes copyWith({List<LetterStroke>? mb, List<LetterStroke>? tb}) {
    return Strokes(mb: mb ?? this.mb, tb: tb ?? this.tb);
  }

  @override
  String toString() {
    return 'Strokes(mb: ${mb.length}, tb: ${tb.length})';
  }
}

/// Represents a single stroke of a Nepali letter
class LetterStroke {
  /// Name/description of this stroke (e.g., "Top horizontal line")
  final String name;

  /// SVG path data (e.g., "M 4 4 H 71.3467")
  final String path;

  /// User-friendly instruction for tracing (e.g., "Trace from left to right")
  final String instruction;

  /// Optional stroke order hint (starting from 1)
  final int? order;

  /// Optional color hint for this stroke (hex string like "#FF0000")
  final String? color;

  final num? strokeWidth;

  LetterStroke({
    required this.name,
    required this.path,
    required this.instruction,
    this.order,
    this.color,
    this.strokeWidth,
  });

  /// Create from JSON
  factory LetterStroke.fromJson(Map<String, dynamic> json) {
    return LetterStroke(
      name: json['name'] as String,
      path: json['path'] as String,
      instruction: json['instruction'] as String,
      order: json['order'] as int?,
      color: json['color'] as String?,
      strokeWidth: json['strokeWidth'] as num?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'instruction': instruction,
      if (order != null) 'order': order,
      if (color != null) 'color': color,
    };
  }

  /// Check if this stroke is valid
  bool isValid() {
    return name.isNotEmpty && path.isNotEmpty && instruction.isNotEmpty;
  }

  /// Get the starting point of this stroke's path
  /// Returns null if path doesn't start with M command
  Offset? getStartPoint() {
    final trimmed = path.trim();
    if (!trimmed.startsWith('M')) return null;

    try {
      final parts = trimmed.substring(1).trim().split(RegExp(r'[\s,]+'));
      if (parts.length < 2) return null;

      return Offset(double.parse(parts[0]), double.parse(parts[1]));
    } catch (e) {
      return null;
    }
  }

  /// Create a copy with modified fields
  LetterStroke copyWith({
    String? name,
    String? path,
    String? instruction,
    int? order,
    String? color,
  }) {
    return LetterStroke(
      name: name ?? this.name,
      path: path ?? this.path,
      instruction: instruction ?? this.instruction,
      order: order ?? this.order,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'LetterStroke(name: $name, order: ${order ?? "auto"})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LetterStroke && other.path == path;
  }

  @override
  int get hashCode => path.hashCode;
}
