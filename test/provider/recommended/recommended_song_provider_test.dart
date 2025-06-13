// Tests for recommended_song_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/src.dart';

void main() {
  group('RecommendedSongProvider', () {
    test('should create RecommendedSongProvider instance', () {
      final provider = RcmSongProvider();
      expect(provider, isA<RcmSongProvider>());
    });
  });
}
