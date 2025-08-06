import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper class to initialize Firebase for testing
class FirebaseTestSetup {
  static void setupFirebaseMocks() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock Firebase Core
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/firebase_core', (
          message,
        ) async {
          return const StandardMessageCodec().encodeMessage(<String, dynamic>{
            'name': '[DEFAULT]',
            'options': <String, dynamic>{
              'apiKey': 'test',
              'appId': 'test',
              'messagingSenderId': 'test',
              'projectId': 'test',
            },
            'pluginConstants': <String, dynamic>{},
            'isAutomaticDataCollectionEnabled': false,
          });
        });

    // Mock Firebase Auth
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/firebase_auth', (
          message,
        ) async {
          return const StandardMessageCodec().encodeMessage(<String, dynamic>{
            'user': null,
          });
        });

    // Mock Firestore
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/cloud_firestore', (
          message,
        ) async {
          return const StandardMessageCodec().encodeMessage(<String, dynamic>{
            'documents': [],
          });
        });

    // Mock Firebase Storage
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/firebase_storage', (
          message,
        ) async {
          return const StandardMessageCodec().encodeMessage(
            <String, dynamic>{},
          );
        });

    // Mock Firebase Messaging
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/firebase_messaging', (
          message,
        ) async {
          return const StandardMessageCodec().encodeMessage(<String, dynamic>{
            'token': 'mock_token',
          });
        });

    // Mock SharedPreferences
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/shared_preferences', (
          message,
        ) async {
          return const StandardMessageCodec().encodeMessage(<String, dynamic>{
            'flutter.guest_logged': false,
            'flutter.child_logged': false,
            'flutter.parent_logged': false,
          });
        });
  }

  static void cleanupFirebaseMocks() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/firebase_core', null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/firebase_auth', null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/cloud_firestore', null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/firebase_storage', null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/firebase_messaging', null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/shared_preferences', null);
  }
}
