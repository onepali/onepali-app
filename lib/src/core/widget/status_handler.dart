import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class StatusHandler extends StatefulWidget {
  final DataFetchStatus status;
  final Widget Function() successBuilder;
  final String? errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool hasData;
  final bool checkConnectivity;

  const StatusHandler({
    super.key,
    required this.status,
    required this.successBuilder,
    this.errorTitle,
    this.errorMessage,
    this.onRetry,
    this.hasData = true,
    this.checkConnectivity = true,
  });

  @override
  State<StatusHandler> createState() => _StatusHandlerState();
}

class _StatusHandlerState extends State<StatusHandler> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    if (widget.checkConnectivity) {
      _checkInitialConnectivity();
      _listenToConnectivityChanges();
    }
  }

  Future<void> _checkInitialConnectivity() async {
    final isConnected = await _connectivityService.isConnected();
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });
    }
  }

  void _listenToConnectivityChanges() {
    _connectivityService.onNetworkTypeChanged.listen((networkType) {
      final isConnected = networkType != NetworkType.none;
      if (mounted && _isConnected != isConnected) {
        setState(() {
          _isConnected = isConnected;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d(
      'Status: ${widget.status}, IsConnected: $_isConnected, HasData: ${widget.hasData}',
    );
    switch (widget.status) {
      case DataFetchStatus.initial:
      case DataFetchStatus.loading:
        return CustomLoader();

      case DataFetchStatus.error:
        return ErrorScreen(
          title: widget.errorTitle ?? 'Error Fetching Data',
          message: widget.errorMessage ?? 'Please try again later.',
          onRetry: widget.onRetry,
          isInternetError: widget.checkConnectivity ? !_isConnected : false,
          isDataError: widget.checkConnectivity ? _isConnected : true,
        );

      case DataFetchStatus.success:
        if (!widget.hasData) {
          if (widget.checkConnectivity && !_isConnected) {
            return ErrorScreen(
              title: "You're offline",
              message: "Oops, please check your connection to get back online.",
              onRetry: widget.onRetry,
              isInternetError: true,
              isDataError: false,
            );
          }
          return ErrorScreen(
            title: widget.errorTitle ?? 'No Data Available',
            message: widget.errorMessage ?? 'Please check back later.',
            onRetry: widget.onRetry,
            isInternetError: false,
            isDataError: true,
          );
        }
        // Show offline banner if not connected and has data
        if (widget.checkConnectivity && !_isConnected) {
          return ErrorScreen(
            title: "You're offline",
            message: "Oops, please check your connection to get back online.",
            onRetry: widget.onRetry,
            isInternetError: true,
            isDataError: false,
          );
        }
        return widget.successBuilder();
    }
  }
}
