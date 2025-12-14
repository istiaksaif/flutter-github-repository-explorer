import 'package:connectivity_plus/connectivity_plus.dart';

/// Provides network connectivity status.
class NetworkInfo {
  NetworkInfo(this._connectivity);

  final Connectivity _connectivity;

  Future<bool> get isConnected async {
    final dynamic result = await _connectivity.checkConnectivity();
    if (result is List<ConnectivityResult>) {
      return result.any((value) => value != ConnectivityResult.none);
    }
    if (result is ConnectivityResult) {
      return result != ConnectivityResult.none;
    }
    return false;
  }
}
