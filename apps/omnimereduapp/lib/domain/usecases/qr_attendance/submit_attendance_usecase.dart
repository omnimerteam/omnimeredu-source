import '../../../domain/entities/qr_attendance/scan_result_entity.dart';
import '../../../domain/entities/qr_attendance/location_entity.dart';
import '../../../domain/repositories/qr_attendance/qr_attendance_repository.dart';
import '../../../services/location_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/offline_queue_service.dart';
import '../../../data/models/qr_attendance/offline_scan_model.dart';
import '../../../core/utils/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Usecase để submit attendance scan cho sinh viên
class SubmitAttendanceUsecase {
  final QRAttendanceRepository _repository;
  final LocationService _locationService;
  final ConnectivityService _connectivityService;
  final OfflineQueueService _offlineQueueService;

  SubmitAttendanceUsecase(
    this._repository,
    this._locationService,
    this._connectivityService,
    this._offlineQueueService,
  );

  /// Execute usecase
  Future<ScanResultEntity> call(String qrData) async {
    try {
      AppLogger.info('Usecase: Submitting attendance scan');

      // Get current location
      final LocationEntity location = await _locationService.getCurrentLocation();
      
      // Get device ID
      final String deviceId = await _getDeviceId();

      // Check internet connectivity
      final bool hasConnection = await _connectivityService.hasConnection();

      if (!hasConnection) {
        // Save to offline queue
        AppLogger.info('No internet connection. Saving to offline queue.');
        await _saveToOfflineQueue(qrData, location, deviceId);
        
        return ScanResultEntity(
          status: ScanStatus.offline,
          message: ScanResultEntity.getStatusMessage(ScanStatus.offline),
          attendanceTime: DateTime.now(),
        );
      }

      // Submit to server
      return await _repository.submitAttendanceScan(
        qrData: qrData,
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
        return ScanResultEntity(
          status: ScanStatus.error,
          message: e.toString(),
        );
      }
      
      rethrow;
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

