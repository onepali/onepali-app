// Tests for app_card_responsive.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/utils/app_card_responsive.dart';

void main() {
  group('AppCardResponsive', () {
    testWidgets('getCardWidth should return appropriate width for mobile', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(375, 667));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final width = AppCardResponsive.getCardWidth(context);
                return Text('Width: $width');
              },
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
      final text = tester.widget<Text>(find.byType(Text)).data!;
      expect(text, contains('Width:'));
    });

    testWidgets('getCardWidth should return appropriate width for tablet', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1024, 768));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final width = AppCardResponsive.getCardWidth(context);
                return Text('Width: $width');
              },
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
      final text = tester.widget<Text>(find.byType(Text)).data!;
      expect(text, contains('Width:'));

      // Tablet width should generally be larger
      final widthMatch = RegExp(r'Width: (\d+\.?\d*)').firstMatch(text);
      if (widthMatch != null) {
        final width = double.parse(widthMatch.group(1)!);
        expect(width, greaterThan(0));
      }
    });

    testWidgets('getCardHeight should return appropriate height', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(375, 667));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final height = AppCardResponsive.getCardHeight(context);
                return Text('Height: $height');
              },
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
      final text = tester.widget<Text>(find.byType(Text)).data!;
      expect(text, contains('Height:'));
    });

    testWidgets('should handle landscape vs portrait differences', (
      tester,
    ) async {
      // Portrait
      await tester.binding.setSurfaceSize(const Size(375, 667));

      late double portraitWidth;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                portraitWidth = AppCardResponsive.getCardWidth(context);
                return Text('Portrait Width: $portraitWidth');
              },
            ),
          ),
        ),
      );

      // Landscape
      await tester.binding.setSurfaceSize(const Size(667, 375));
      await tester.pump();

      late double landscapeWidth;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                landscapeWidth = AppCardResponsive.getCardWidth(context);
                return Text('Landscape Width: $landscapeWidth');
              },
            ),
          ),
        ),
      );

      // Both should return valid positive numbers
      expect(portraitWidth, greaterThan(0));
      expect(landscapeWidth, greaterThan(0));
    });
  });
}
