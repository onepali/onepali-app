import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/onboard/onboard_model.dart';

void main() {
  group('OnboardModel', () {
    test('should create OnboardModel with correct values', () {
      final model = OnboardModel(title: 'Test', icon: 'icon.png');
      expect(model.title, 'Test');
      expect(model.icon, 'icon.png');
    });

    test('onboardList should contain OnboardModel items', () {
      expect(onboardList, isA<List<OnboardModel>>());
      expect(onboardList.isNotEmpty, true);
      expect(onboardList.first.title, isNotEmpty);
      expect(onboardList.first.icon, isNotEmpty);
    });
  });
}
