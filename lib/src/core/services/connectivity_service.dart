import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../src.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkType> _networkTypeController =
      StreamController<NetworkType>.broadcast();
  StreamSubscription? _subscription;

  /// Listen to network changes
  Stream<NetworkType> get onNetworkTypeChanged => _networkTypeController.stream;

  /// Get current network type
  Future<NetworkType> getCurrentNetworkType() async {
    final List<ConnectivityResult> result =
        await _connectivity.checkConnectivity();
    if (result.isEmpty) return NetworkType.none;
    // Prefer wifi > mobile > others
    if (result.contains(ConnectivityResult.wifi)) return NetworkType.wifi;
    if (result.contains(ConnectivityResult.mobile)) return NetworkType.mobile;
    if (result.contains(ConnectivityResult.ethernet)) {
      return NetworkType.ethernet;
    }
    if (result.contains(ConnectivityResult.bluetooth)) {
      return NetworkType.bluetooth;
    }
    if (result.contains(ConnectivityResult.vpn)) return NetworkType.vpn;
    if (result.contains(ConnectivityResult.other)) return NetworkType.other;
    return NetworkType.none;
  }

  /// Start listening to network changes
  void startListening() {
    _subscription ??= _connectivity.onConnectivityChanged.listen((list) {
      if (list.isEmpty) {
        _networkTypeController.add(NetworkType.none);
      } else if (list.contains(ConnectivityResult.wifi)) {
        _networkTypeController.add(NetworkType.wifi);
      } else if (list.contains(ConnectivityResult.mobile)) {
        _networkTypeController.add(NetworkType.mobile);
      } else if (list.contains(ConnectivityResult.ethernet)) {
        _networkTypeController.add(NetworkType.ethernet);
      } else if (list.contains(ConnectivityResult.bluetooth)) {
        _networkTypeController.add(NetworkType.bluetooth);
      } else if (list.contains(ConnectivityResult.vpn)) {
        _networkTypeController.add(NetworkType.vpn);
      } else if (list.contains(ConnectivityResult.other)) {
        _networkTypeController.add(NetworkType.other);
      } else {
        _networkTypeController.add(NetworkType.none);
      }
    });
  }

  Future<bool> isConnected() async {
    final NetworkType networkType = await getCurrentNetworkType();
    return networkType != NetworkType.none;
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Dispose the controller
  void dispose() {
    stopListening();
    _networkTypeController.close();
  }
}
