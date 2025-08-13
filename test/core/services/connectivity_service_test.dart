// Tests for connectivity_service.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:onepali/src/core/services/connectivity_service.dart';

void main() {
  group('ConnectivityService', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock connectivity_plus
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('dev.fluttercommunity.plus/connectivity', (
            message,
          ) async {
            return const StandardMessageCodec().encodeMessage(<String, dynamic>{
              'connectivity': 'wifi',
            });
          });
    });

    test('should create ConnectivityService instance', () {
      final service = ConnectivityService();
      expect(service, isA<ConnectivityService>());
    });

    test('should be singleton', () {
      final service1 = ConnectivityService();
      final service2 = ConnectivityService();
      expect(identical(service1, service2), isTrue);
    });

    test('should have onNetworkTypeChanged stream', () {
      final service = ConnectivityService();
      expect(service.onNetworkTypeChanged, isA<Stream>());
    });

    test('should handle start and stop listening', () {
      final service = ConnectivityService();

      // Should not throw when starting listening
      expect(() => service.startListening(), returnsNormally);

      // Should not throw when stopping listening
      expect(() => service.stopListening(), returnsNormally);

      // Should handle dispose properly
      expect(() => service.dispose(), returnsNormally);
    });
  });
}
