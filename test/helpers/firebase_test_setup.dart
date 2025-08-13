import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

/// Helper class to initialize Firebase for testing
class FirebaseTestSetup {
  static void setupFirebaseMocks() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock Firebase Core
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('plugins.flutter.io/firebase_core', (
          message,
        ) async {
          final methodCall = const StandardMethodCodec().decodeMethodCall(
            message!,
          );
          if (methodCall.method == 'Firebase#initializeCore') {
            return const StandardMethodCodec().encodeSuccessEnvelope(
              <String, dynamic>{
                'name': '[DEFAULT]',
                'options': <String, dynamic>{
                  'apiKey': 'test-api-key',
                  'appId': 'test-app-id',
                  'messagingSenderId': 'test-sender-id',
                  'projectId': 'test-project-id',
                  'storageBucket': 'test-storage-bucket',
                },
                'pluginConstants': <String, dynamic>{},
              },
            );
          } else if (methodCall.method == 'Firebase#initializeApp') {
            return const StandardMethodCodec().encodeSuccessEnvelope(
              <String, dynamic>{
                'name': methodCall.arguments['name'] ?? '[DEFAULT]',
                'options':
                    methodCall.arguments['options'] ??
                    <String, dynamic>{
                      'apiKey': 'test-api-key',
                      'appId': 'test-app-id',
                      'messagingSenderId': 'test-sender-id',
                      'projectId': 'test-project-id',
                      'storageBucket': 'test-storage-bucket',
                    },
                'pluginConstants': <String, dynamic>{},
              },
            );
          }
          return const StandardMethodCodec().encodeSuccessEnvelope(null);
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

  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'test-api-key',
          appId: 'test-app-id',
          messagingSenderId: 'test-sender-id',
          projectId: 'test-project-id',
          storageBucket: 'test-storage-bucket',
        ),
      );
    } catch (e) {
      // Firebase already initialized or other error, ignore
    }
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
