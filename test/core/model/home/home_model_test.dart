// Tests for home_model.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/home/home_model.dart';

void main() {
  group('HomeServiceModel', () {
    test('should create HomeServiceModel with correct values', () {
      final model = HomeServiceModel(
        name: 'Lessons',
        icon: 'icon.png',
        tooltip: 'Tooltip',
        route: '/lessons',
      );
      expect(model.name, 'Lessons');
      expect(model.icon, 'icon.png');
      expect(model.tooltip, 'Tooltip');
      expect(model.route, '/lessons');
    });
  });
}
