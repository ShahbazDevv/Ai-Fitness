import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<ConnectivityService> init() async {
    try {
      final results = await _connectivity.checkConnectivity().timeout(const Duration(seconds: 3));
      _updateConnectionStatus(results);
    } catch (e) {
      print('ConnectivityService init error: $e');
      isConnected.value = true; // Assume connected on error
    }
    
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    return this;
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // If list contains any connection type other than none, we are connected
    if (results.contains(ConnectivityResult.none)) {
      isConnected.value = false;
    } else {
      isConnected.value = true;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
