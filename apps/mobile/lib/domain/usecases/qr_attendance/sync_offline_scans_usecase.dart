import 'package:mobile/services/qr_service/connectivity_service.dart';
import 'package:mobile/services/qr_service/offline_queue_service.dart';

import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/logger.dart';
import '../../../data/models/qr_attendance/offline_scan_model.dart';
import '../../../domain/entities/qr_attendance/scan_result_entity.dart';
import '../../repositories/attendance/qr_attendance_repository.dart';

/// Usecase để đồng bộ offline scans khi có mạng
class SyncOfflineScansUseCase extends UseCase<Either<Failure, int>, NoParams> {
  final QRAttendanceRepository _repository;
  final OfflineQueueService _offlineQueueService;
  final ConnectivityService _connectivityService;

  SyncOfflineScansUseCase(
    this._repository,
    this._offlineQueueService,
    this._connectivityService,
  );

  /// Execute usecase - sync all unsynced scans
  /// Returns number of successfully synced scans
  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    try {
      AppLogger.info('Usecase: Starting offline scans sync');

      // Check connectivity
      final bool hasConnection = await _connectivityService.hasConnection();
      if (!hasConnection) {
        AppLogger.warning('No internet connection. Cannot sync.');
        return const Right(0);
      }

      // Get all unsynced scans
      final List<OfflineScanModel> unsyncedScans = await _offlineQueueService
          .getUnsyncedScans();

      if (unsyncedScans.isEmpty) {
        AppLogger.info('No offline scans to sync');
        return const Right(0);
      }

      AppLogger.info('Found ${unsyncedScans.length} offline scans to sync');

      int successCount = 0;

      // Sync each scan
      for (final scan in unsyncedScans) {
        try {
          final resultEither = await _repository.submitAttendanceScan(
            qrData: scan.qrData,
            latitude: scan.latitude,
            longitude: scan.longitude,
            deviceId: scan.deviceId,
          );

          await resultEither.fold(
            (failure) async {
              // Update error message
              await _offlineQueueService.updateError(
                scan.id!,
                failure.toString(),
              );
              AppLogger.warning(
                'Failed to sync scan ${scan.id}: ${failure.toString()}',
              );
            },
            (result) async {
              if (result.status == ScanStatus.success ||
                  result.status == ScanStatus.alreadyScanned) {
                // Mark as synced
                await _offlineQueueService.markAsSynced(scan.id!);
                successCount++;
                AppLogger.info('Successfully synced scan ${scan.id}');
              } else {
                // Even if repository returned Right, it might be a business error
                await _offlineQueueService.updateError(
                  scan.id!,
                  result.message,
                );
                AppLogger.warning(
                  'Failed to sync scan ${scan.id}: ${result.message}',
                );
              }
            },
          );
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

      return Right(successCount);
    } catch (e) {
      AppLogger.error('Usecase: Failed to sync offline scans', e);
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Get count of pending offline scans
  Future<int> getPendingCount() async {
    return await _offlineQueueService.getUnsyncedCount();
  }
}
