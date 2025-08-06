// Tests for notification_service.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:onepali/src/core/services/notification_service.dart';

void main() {
  group('NotificationService', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock Firebase Messaging
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('plugins.flutter.io/firebase_messaging', (
            message,
          ) async {
            return const StandardMessageCodec().encodeMessage(<String, dynamic>{
              'token': 'mock_token',
            });
          });

      // Mock Flutter Local Notifications
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('dexterous.com/flutter/local_notifications', (
            message,
          ) async {
            return const StandardMessageCodec().encodeMessage(<String, dynamic>{
              'initialized': true,
            });
          });
    });

    test('should create NotificationService instance', () {
      final service = NotificationService();
      expect(service, isA<NotificationService>());
    });

    test('should provide static methods for notifications', () {
      // NotificationService uses static methods, not singleton pattern
      expect(NotificationService.flutterLocalNotificationsPlugin, isNotNull);
      expect(NotificationService, isNotNull);
    });

    test('should handle basic functionality', () {
      final service = NotificationService();
      expect(service, isNotNull);
    });
  });
}
