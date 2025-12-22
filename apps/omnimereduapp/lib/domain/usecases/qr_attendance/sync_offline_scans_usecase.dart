import '../../../domain/repositories/qr_attendance/qr_attendance_repository.dart';
import '../../../services/offline_queue_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../data/models/qr_attendance/offline_scan_model.dart';
import '../../../data/models/qr_attendance/scan_request_model.dart';
import '../../../core/utils/logger.dart';

/// Usecase để đồng bộ offline scans khi có mạng
class SyncOfflineScansUsecase {
  final QRAttendanceRepository _repository;
  final OfflineQueueService _offlineQueueService;
  final ConnectivityService _connectivityService;

  SyncOfflineScansUsecase(
    this._repository,
    this._offlineQueueService,
    this._connectivityService,
  );

  /// Execute usecase - sync all unsynced scans
  /// Returns number of successfully synced scans
  Future<int> call() async {
    try {
      AppLogger.info('Usecase: Starting offline scans sync');

      // Check connectivity
      final bool hasConnection = await _connectivityService.hasConnection();
      if (!hasConnection) {
        AppLogger.warning('No internet connection. Cannot sync.');
        return 0;
      }

      // Get all unsynced scans
      final List<OfflineScanModel> unsyncedScans = await _offlineQueueService
          .getUnsyncedScans();

      if (unsyncedScans.isEmpty) {
        AppLogger.info('No offline scans to sync');
        return 0;
      }

      AppLogger.info('Found ${unsyncedScans.length} offline scans to sync');

      int successCount = 0;

      // Sync each scan
      for (final scan in unsyncedScans) {
        try {
          final result = await _repository.submitAttendanceScan(
            qrData: scan.qrData,
            latitude: scan.latitude,
            longitude: scan.longitude,
            deviceId: scan.deviceId,
            scanTime: DateTime.parse(scan.scanTime),
          );

          if (result.isSuccess) {
            // Mark as synced
            await _offlineQueueService.markAsSynced(scan.id!);
            successCount++;
            AppLogger.info('Successfully synced scan ${scan.id}');
          } else {
            // Update error message
            await _offlineQueueService.updateError(scan.id!, result.message);
            AppLogger.warning(
              'Failed to sync scan ${scan.id}: ${result.message}',
            );
          }
        } catch (e) {
          AppLogger.error('Error syncing scan ${scan.id}', e);
          await _offlineQueueService.updateError(scan.id!, 'Sync error: $e');
        }
      }

      AppLogger.info(
        'Sync completed. $successCount/${unsyncedScans.length} successful',
      );

      // Cleanup old synced scans
      await _offlineQueueService.cleanupOldScans();

      return successCount;
    } catch (e) {
      AppLogger.error('Usecase: Failed to sync offline scans', e);
      return 0;
    }
  }

  /// Get count of pending offline scans
  Future<int> getPendingCount() async {
    return await _offlineQueueService.getUnsyncedCount();
  }
}
