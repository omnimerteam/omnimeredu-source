import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile/services/qr_service/connectivity_service.dart';
import 'package:mobile/services/qr_service/location_service.dart';
import 'package:mobile/services/qr_service/offline_queue_service.dart';
import 'dart:io' show Platform;

import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/logger.dart';
import '../../../core/api/api_exception.dart';
import '../../../data/models/qr_attendance/offline_scan_model.dart';
import '../../../domain/entities/qr_attendance/location_entity.dart';
import '../../../domain/entities/qr_attendance/scan_result_entity.dart';
import '../../repositories/attendance/qr_attendance_repository.dart';

/// Usecase để submit attendance scan cho sinh viên
class SubmitAttendanceUseCase
    extends UseCase<Either<Failure, ScanResultEntity>, String> {
  final QRAttendanceRepository _repository;
  final LocationService _locationService;
  final ConnectivityService _connectivityService;
  final OfflineQueueService _offlineQueueService;

  SubmitAttendanceUseCase(
    this._repository,
    this._locationService,
    this._connectivityService,
    this._offlineQueueService,
  );

  /// Execute usecase
  @override
  Future<Either<Failure, ScanResultEntity>> call(String params) async {
    try {
      AppLogger.info('Usecase: Submitting attendance scan');

      // Get current location
      final LocationEntity location = await _locationService
          .getCurrentLocation();

      // Get device ID
      final String deviceId = await _getDeviceId();

      // Check internet connectivity
      final bool hasConnection = await _connectivityService.hasConnection();

      if (!hasConnection) {
        // Save to offline queue
        AppLogger.info('No internet connection. Saving to offline queue.');
        await _saveToOfflineQueue(params, location, deviceId);

        return Right(
          ScanResultEntity(
            status: ScanStatus.offline,
            message: ScanResultEntity.getStatusMessage(ScanStatus.offline),
            attendanceTime: DateTime.now(),
          ),
        );
      }

      // Submit to server with timeout wrapper
      Either<Failure, ScanResultEntity> result;
      try {
        result = await _repository.submitAttendanceScan(
          qrData: params,
          latitude: location.latitude,
          longitude: location.longitude,
          deviceId: deviceId,
        ).timeout(
          const Duration(seconds: 65), // Slightly longer than API timeout
          onTimeout: () {
            AppLogger.warning('Request timeout in usecase');
            return Left(TimeoutFailure('Yêu cầu quá thời gian'));
          },
        );
      } on TimeoutException catch (e) {
        AppLogger.warning('Request timeout: $e');
        result = Left(TimeoutFailure('Yêu cầu quá thời gian'));
      }

      // Check if result is a failure (timeout or network error)
      return result.fold(
        (failure) {
          // If timeout or network error, save to offline queue
          if (failure is TimeoutFailure || failure is NetworkFailure) {
            AppLogger.info(
              'Network/timeout error. Saving to offline queue.',
            );
            // Save to offline queue (async but don't wait)
            _saveToOfflineQueue(params, location, deviceId).catchError((e) {
              AppLogger.error('Failed to save to offline queue', e);
            });
            return Right(
              ScanResultEntity(
                status: ScanStatus.offline,
                message: 'Đã lưu vào hàng đợi. Sẽ đồng bộ khi có kết nối.',
                attendanceTime: DateTime.now(),
              ),
            );
          }
          // Return the failure for other errors
          return Left(failure);
        },
        (success) => Right(success),
      );
    } catch (e) {
      AppLogger.error('Usecase: Failed to submit attendance scan', e);

      // Check if it's a timeout exception
      if (e is TimeoutException) {
        AppLogger.info('Timeout exception. Saving to offline queue.');
        try {
          final LocationEntity location = await _locationService
              .getCurrentLocation();
          final String deviceId = await _getDeviceId();
          await _saveToOfflineQueue(params, location, deviceId);
          return Right(
            ScanResultEntity(
              status: ScanStatus.offline,
              message: 'Đã lưu vào hàng đợi. Sẽ đồng bộ khi có kết nối.',
              attendanceTime: DateTime.now(),
            ),
          );
        } catch (locationError) {
          AppLogger.error('Failed to save to offline queue', locationError);
          return Left(TimeoutFailure('Yêu cầu quá thời gian và không thể lưu vào hàng đợi'));
        }
      }

      // Check if it's a location error
      if (e is LocationServiceDisabledException ||
          e is LocationPermissionDeniedException ||
          e is LocationPermissionDeniedForeverException) {
        return Right(
          ScanResultEntity(status: ScanStatus.error, message: e.toString()),
        );
      }

      // Check if it's a network error
      if (e is NetworkException) {
        try {
          final LocationEntity location = await _locationService
              .getCurrentLocation();
          final String deviceId = await _getDeviceId();
          await _saveToOfflineQueue(params, location, deviceId);
          return Right(
            ScanResultEntity(
              status: ScanStatus.offline,
              message: 'Đã lưu vào hàng đợi. Sẽ đồng bộ khi có kết nối.',
              attendanceTime: DateTime.now(),
            ),
          );
        } catch (locationError) {
          AppLogger.error('Failed to save to offline queue', locationError);
          return Left(NetworkFailure('Không có kết nối mạng và không thể lưu vào hàng đợi'));
        }
      }

      return Left(ServerFailure(e.toString()));
    }
  }

  /// Save scan to offline queue
  Future<void> _saveToOfflineQueue(
    String qrData,
    LocationEntity location,
    String deviceId,
  ) async {
    final offlineScan = OfflineScanModel(
      qrData: qrData,
      latitude: location.latitude,
      longitude: location.longitude,
      deviceId: deviceId,
      scanTime: DateTime.now().toIso8601String(),
      isSynced: false,
    );

    await _offlineQueueService.addScan(offlineScan);
  }

  /// Get device ID (platform dependent)
  Future<String> _getDeviceId() async {
    // In production, use device_info_plus package
    // For now, return a simple identifier
    try {
      if (kIsWeb) {
        return 'web-device';
      } else if (Platform.isAndroid) {
        return 'android-device-${DateTime.now().millisecondsSinceEpoch}';
      } else if (Platform.isIOS) {
        return 'ios-device-${DateTime.now().millisecondsSinceEpoch}';
      } else {
        return 'unknown-device-${DateTime.now().millisecondsSinceEpoch}';
      }
    } catch (e) {
      return 'device-${DateTime.now().millisecondsSinceEpoch}';
    }
  }
}
