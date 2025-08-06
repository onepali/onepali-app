// Tests for guest_provider.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:onepali/src/provider/guest/guest_provider.dart';

void main() {
  group('GuestProvider', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock SharedPreferences
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('plugins.flutter.io/shared_preferences', (
            message,
          ) async {
            return const StandardMessageCodec().encodeMessage(<String, dynamic>{
              'flutter.guest_logged': false,
            });
          });
    });

    test('should create GuestProvider instance', () {
      final provider = GuestProvider();
      expect(provider, isA<GuestProvider>());
    });
  });
}
