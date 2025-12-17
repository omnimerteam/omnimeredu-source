import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile/services/qr_service/connectivity_service.dart';
import 'package:mobile/services/qr_service/location_service.dart';
import 'package:mobile/services/qr_service/offline_queue_service.dart';
import 'dart:io' show Platform;

import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/logger.dart';
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

      // Submit to server
      return await _repository.submitAttendanceScan(
        qrData: params,
        latitude: location.latitude,
        longitude: location.longitude,
        deviceId: deviceId,
      );
    } catch (e) {
      AppLogger.error('Usecase: Failed to submit attendance scan', e);

      // Check if it's a location error
      if (e is LocationServiceDisabledException ||
          e is LocationPermissionDeniedException ||
          e is LocationPermissionDeniedForeverException) {
        return Right(
          ScanResultEntity(status: ScanStatus.error, message: e.toString()),
        );
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
