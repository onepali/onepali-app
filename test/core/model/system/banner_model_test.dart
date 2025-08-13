// Tests for banner_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/model/system/banner_model.dart';
import 'package:onepali/src/src.dart';

void main() {
  group('BannerModel', () {
    test('should create BannerModel with required properties', () {
      final banner = BannerModel(
        title: 'Test Banner',
        description: 'Test Description',
        icon: Icons.star,
        color: AppColors.kBlue,
        onTap: () {},
      );

      expect(banner.title, 'Test Banner');
      expect(banner.description, 'Test Description');
      expect(banner.icon, Icons.star);
      expect(banner.color, AppColors.kBlue);
      expect(banner.onTap, isNotNull);
    });

    test('should create BannerModel with default values', () {
      final banner = BannerModel(title: 'Test Banner', icon: Icons.star);

      expect(banner.title, 'Test Banner');
      expect(banner.description, '');
      expect(banner.icon, Icons.star);
      expect(banner.onTap, isNull);
    });

    test('should verify spreadBannerList is not empty', () {
      expect(spreadBannerList, isA<List<BannerModel>>());
      expect(spreadBannerList.isNotEmpty, true);
      expect(spreadBannerList.length, 3);

      // Verify first banner properties
      final firstBanner = spreadBannerList.first;
      expect(firstBanner.title, contains('Spread the word'));
      expect(firstBanner.icon, Icons.volunteer_activism_rounded);
      expect(firstBanner.onTap, isNotNull);
    });

    test(
      'should verify all banners in spreadBannerList have required properties',
      () {
        for (final banner in spreadBannerList) {
          expect(banner.title, isNotEmpty);
          expect(banner.icon, isNotNull);
          expect(banner.color, isNotNull);
          expect(banner.onTap, isNotNull);
        }
      },
    );
  });
}
