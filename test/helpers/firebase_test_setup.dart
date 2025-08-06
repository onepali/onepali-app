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
            'options': <String, dynamic>{},
            'pluginConstants': <String, dynamic>{},
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
          return const StandardMessageCodec().encodeMessage(
            <String, dynamic>{},
          );
        });
  }
}
