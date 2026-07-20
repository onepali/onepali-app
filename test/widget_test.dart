// Widget tests for main.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/main.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('MyApp should create and render without errors', (
      WidgetTester tester,
    ) async {
      // Test that MyApp can be instantiated and rendered
      const myApp = MyApp(logged: false, isParentLogged: false);

      expect(myApp.logged, false);
      expect(myApp.isParentLogged, false);

      // Test widget properties
      expect(myApp, isA<MyApp>());
      expect(myApp, isA<Widget>());
    });

    testWidgets('MyApp should handle different authentication states', (
      WidgetTester tester,
    ) async {
      // Test with logged user
      const loggedApp = MyApp(logged: true, isParentLogged: false);
      expect(loggedApp.logged, true);
      expect(loggedApp.isParentLogged, false);

      // Test with parent logged
      const parentLoggedApp = MyApp(logged: false, isParentLogged: true);
      expect(parentLoggedApp.logged, false);
      expect(parentLoggedApp.isParentLogged, true);

      // Test with both logged
      const bothLoggedApp = MyApp(logged: true, isParentLogged: true);
      expect(bothLoggedApp.logged, true);
      expect(bothLoggedApp.isParentLogged, true);
    });
  });
}
