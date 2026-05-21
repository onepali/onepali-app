import 'package:connectivity_plus/connectivity_plus.dart';

import '../../src.dart';

extension ConnectivityResultX on ConnectivityResult {
  NetworkType toNetworkType() {
    switch (this) {
      case ConnectivityResult.wifi:
        return NetworkType.wifi;
      case ConnectivityResult.mobile:
        return NetworkType.mobile;
      case ConnectivityResult.ethernet:
        return NetworkType.ethernet;
      case ConnectivityResult.bluetooth:
        return NetworkType.bluetooth;
      case ConnectivityResult.vpn:
        return NetworkType.vpn;
      case ConnectivityResult.satellite:
      case ConnectivityResult.other:
        return NetworkType.other;
      case ConnectivityResult.satellite:
        return NetworkType.satellite;
      case ConnectivityResult.none:
        return NetworkType.none;
    }
  }
}
