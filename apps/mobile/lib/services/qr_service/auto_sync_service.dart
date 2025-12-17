import 'dart:async';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/core/utils/logger.dart';
import 'package:mobile/domain/usecases/qr_attendance/sync_offline_scans_usecase.dart';
import 'package:mobile/services/qr_service/connectivity_service.dart';

/// Service tự động đồng bộ offline scans khi có mạng
class AutoSyncService {
  final SyncOfflineScansUseCase _syncOfflineScansUsecase;
  final ConnectivityService _connectivityService;

  Timer? _periodicSyncTimer;
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isRunning = false;

  AutoSyncService(this._syncOfflineScansUsecase, this._connectivityService);

  /// Start auto sync service
  void start() {
    if (_isRunning) {
      AppLogger.warning('AutoSyncService already running');
      return;
    }

    _isRunning = true;
    AppLogger.info('Starting AutoSyncService');

    // Listen to connectivity changes
    _connectivitySubscription = _connectivityService.onConnectivityChanged
        .listen((isOnline) {
          if (isOnline) {
            AppLogger.info('Connection restored. Triggering sync...');
            _performSync();
          }
        });

    // Periodic sync every 5 minutes (if online)
    _periodicSyncTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _performSync();
    });

    // Initial sync
    _performSync();
  }

  /// Stop auto sync service
  void stop() {
    if (!_isRunning) return;

    _isRunning = false;
    AppLogger.info('Stopping AutoSyncService');

    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;

    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Perform sync operation
  Future<void> _performSync() async {
    try {
      // Check if online
      final isOnline = await _connectivityService.hasConnection();
      if (!isOnline) {
        AppLogger.info('No connection. Skipping sync.');
        return;
      }

      // Check if there are pending scans
      final pendingCount = await _syncOfflineScansUsecase.getPendingCount();
      if (pendingCount == 0) {
        AppLogger.info('No pending offline scans to sync');
        return;
      }

      AppLogger.info('Starting auto sync for $pendingCount scans...');

      // Perform sync
      final result = await _syncOfflineScansUsecase(NoParams());

      result.fold(
        (failure) {
          AppLogger.error('Auto sync failed: $failure');
        },
        (syncedCount) {
          if (syncedCount > 0) {
            AppLogger.info(
              'Auto sync completed: $syncedCount/$pendingCount successful',
            );
          } else {
            AppLogger.warning('Auto sync completed but no scans were synced');
          }
        },
      );
    } catch (e) {
      AppLogger.error('Auto sync failed', e);
    }
  }

  /// Manually trigger sync
  Future<int> triggerSync() async {
    AppLogger.info('Manual sync triggered');
    final result = await _syncOfflineScansUsecase(NoParams());

    return result.fold(
      (failure) {
        AppLogger.error('Manual sync failed', failure);
        return 0;
      },
      (syncedCount) {
        AppLogger.info('Manual sync completed: $syncedCount scans synced');
        return syncedCount;
      },
    );
  }

  /// Get pending scans count
  Future<int> getPendingCount() async {
    return await _syncOfflineScansUsecase.getPendingCount();
  }

  /// Dispose resources
  void dispose() {
    stop();
  }
}
