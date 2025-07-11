import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'dart:io';
import '../../../src.dart';

class PzReviewProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == DataFetchStatus.loading;

  static const String _iosAppId = '1234567890';

  Future<void> submitReview({
    required double rating,
    required String title,
    required String description,
  }) async {
    try {
      _status = DataFetchStatus.loading;
      _errorMessage = null;
      notifyListeners();

      // Try native in-app review first (most seamless)
      bool nativeReviewShown = await showNativeReviewDialog();
      logger.i('Native review dialog shown: $nativeReviewShown');

      if (!nativeReviewShown) {
        await _redirectToAppStore();
      }

      _status = DataFetchStatus.success;
      notifyListeners();
    } catch (e) {
      _status = DataFetchStatus.error;
      _errorMessage = e.toString();
      debugPrint('Error submitting review: $e');
      notifyListeners();
      rethrow;
    }
  }

  /// Redirect user to the appropriate app store based on platform
  Future<void> _redirectToAppStore() async {
    String url;

    if (Platform.isAndroid) {
      url = AppConstants.kAppLink;
    } else if (Platform.isIOS) {
      url = 'https://apps.apple.com/app/id$_iosAppId?action=write-review';
    } else {
      throw Exception('Unsupported platform');
    }

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch app store');
    }
  }

  /// Show native app store review dialog (closest to direct posting)
  Future<bool> showNativeReviewDialog() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        logger.i('In-app review is available');
        await inAppReview.requestReview();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error showing native review dialog: $e');
      return false;
    }
  }
}
