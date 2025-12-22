import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/utils/logger.dart';

/// Service để theo dõi trạng thái kết nối mạng
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _connectivityController;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Stream để lắng nghe thay đổi kết nối
  Stream<bool> get onConnectivityChanged {
    _connectivityController ??= StreamController<bool>.broadcast();
    
    _subscription ??= _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final isConnected = results.any((result) => 
          result == ConnectivityResult.mobile || 
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet
        );
        
        AppLogger.info('Connectivity changed: $isConnected');
        _connectivityController?.add(isConnected);
      },
    );
    
    return _connectivityController!.stream;
  }

  /// Check if device has internet connection
  Future<bool> hasConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final isConnected = results.any((result) => 
        result == ConnectivityResult.mobile || 
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet
      );
      
      AppLogger.info('Connection status: $isConnected');
      return isConnected;
    } catch (e) {
      AppLogger.error('Failed to check connectivity', e);
      return false;
    }
  }

  /// Get connection type
  Future<String> getConnectionType() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isEmpty) return 'none';
      
      // Get the first active connection
      final result = results.first;
      switch (result) {
        case ConnectivityResult.wifi:
          return 'wifi';
        case ConnectivityResult.mobile:
          return 'mobile';
        case ConnectivityResult.ethernet:
          return 'ethernet';
        default:
          return 'none';
      }
    } catch (e) {
      AppLogger.error('Failed to get connection type', e);
      return 'unknown';
    }
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
    _connectivityController?.close();
    _subscription = null;
    _connectivityController = null;
    AppLogger.info('ConnectivityService disposed');
  }
}

