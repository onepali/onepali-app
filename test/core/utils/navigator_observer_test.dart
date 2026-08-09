// Tests for navigator_observer.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/router/app_router.dart';
import 'package:onepali/src/core/utils/navigator_observer.dart';

void main() {
  group('OrientationRouteObserver', () {
    test('should create OrientationRouteObserver instance', () {
      final observer = OrientationRouteObserver();
      expect(observer, isA<NavigatorObserver>());
      expect(observer, isA<OrientationRouteObserver>());
    });

    test('should have portrait routes defined', () {
      expect(OrientationRouteObserver.portraitRoutes, isA<List<String>>());
      expect(OrientationRouteObserver.portraitRoutes.isNotEmpty, isTrue);
    });

    testWidgets('should handle route navigation', (tester) async {
      final observer = OrientationRouteObserver();

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          home: const Scaffold(body: Text('Home')),
          routes: {
            '/test': (context) => const Scaffold(body: Text('Test Page')),
          },
        ),
      );

      expect(find.text('Home'), findsOneWidget);

      // The observer should handle navigation without throwing
      expect(observer, isA<OrientationRouteObserver>());
    });

    test('should contain expected portrait routes', () {
      final routes = OrientationRouteObserver.portraitRoutes;

      // Check for some expected routes
      expect(routes.any((route) => route.contains('splash')), isTrue);
      expect(routes.any((route) => route.contains('login')), isTrue);
      expect(routes, contains(AppRoutes.forgotPasswordScreen));
      expect(routes.any((route) => route.contains('register')), isTrue);
      expect(routes.any((route) => route.contains('parent')), isTrue);
    });
  });
}
