import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';

void main() {
  group('isSvgMediaUrl', () {
    test('detects Firebase Storage SVG download URLs', () {
      const url =
          'https://firebasestorage.googleapis.com/v0/b/o-nepali.firebasestorage.app/o/lesson%2Fcheck.svg?alt=media&token=abc';

      expect(isSvgMediaUrl(url), isTrue);
    });

    test('detects uppercase SVG extensions before query params', () {
      const url = 'https://example.com/media/icon.SVG?alt=media';

      expect(isSvgMediaUrl(url), isTrue);
    });

    test('does not treat raster image URLs as SVGs', () {
      const url = 'https://example.com/media/photo.png?alt=media&token=abc';

      expect(isSvgMediaUrl(url), isFalse);
    });
  });
}
