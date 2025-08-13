// Tests for pzone_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/pzone/pzone_model.dart';

void main() {
  group('PZServiceModel', () {
    test('should create PZServiceModel with required properties', () {
      final model = PZServiceModel(
        label: 'Test Service',
        icon: 'test_icon.svg',
        route: '/test',
      );

      expect(model.label, 'Test Service');
      expect(model.icon, 'test_icon.svg');
      expect(model.route, '/test');
    });

    test('should throw assertion error for empty label', () {
      expect(
        () => PZServiceModel(label: '', icon: 'test_icon.svg', route: '/test'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw assertion error for empty icon', () {
      expect(
        () => PZServiceModel(label: 'Test Service', icon: '', route: '/test'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw assertion error for empty route', () {
      expect(
        () => PZServiceModel(
          label: 'Test Service',
          icon: 'test_icon.svg',
          route: '',
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('pzoneBottomModel', () {
    test('should contain expected number of services', () {
      expect(pzoneBottomModel, isA<List<PZServiceModel>>());
      expect(pzoneBottomModel.length, 3);
    });

    test('should have valid service configurations', () {
      for (final service in pzoneBottomModel) {
        expect(service.label, isNotEmpty);
        expect(service.icon, isNotEmpty);
        expect(service.route, isNotEmpty);
        expect(
          service.route.startsWith('/') || service.route.contains('Screen'),
          isTrue,
        );
      }
    });

    test('should contain expected services', () {
      final labels = pzoneBottomModel.map((e) => e.label).toList();
      expect(labels, contains('Progress Report'));
      expect(labels, contains('Community'));
      expect(labels, contains('Settings'));
    });

    test('should have unique routes', () {
      final routes = pzoneBottomModel.map((e) => e.route).toList();
      final uniqueRoutes = routes.toSet();
      expect(routes.length, equals(uniqueRoutes.length));
    });

    test('should have unique labels', () {
      final labels = pzoneBottomModel.map((e) => e.label).toList();
      final uniqueLabels = labels.toSet();
      expect(labels.length, equals(uniqueLabels.length));
    });
  });
}
