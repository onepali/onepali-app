import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class StatusHandler extends StatelessWidget {
  final DataFetchStatus status;
  final Widget Function() successBuilder;
  final String? errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool hasData;

  const StatusHandler({
    super.key,
    required this.status,
    required this.successBuilder,
    this.errorTitle,
    this.errorMessage,
    this.onRetry,
    this.hasData = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case DataFetchStatus.initial:
      case DataFetchStatus.loading:
        return CustomLoader();

      case DataFetchStatus.error:
        return ErrorScreen(
          title: errorTitle ?? 'Error Fetching Data',
          message: errorMessage ?? 'Please try again later.',
          onRetry: onRetry,
        );

      case DataFetchStatus.success:
        if (!hasData) {
          return ErrorScreen(
            title: errorTitle ?? 'No Data Available',
            message: errorMessage ?? 'Please check back later.',
            onRetry: onRetry,
          );
        }
        return successBuilder();
    }
  }
}
