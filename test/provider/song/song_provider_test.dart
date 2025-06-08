// Tests for song_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/provider/song/song_provider.dart';

void main() {
  group('SongProvider', () {
    test('should create SongProvider instance', () {
      final provider = SongProvider();
      expect(provider, isA<SongProvider>());
    });
  });
}
