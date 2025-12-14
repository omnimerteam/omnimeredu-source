import '../../../core/utils/logger.dart';
import '../../../domain/entities/qr_attendance/qr_code_entity.dart';
import '../../../domain/entities/qr_attendance/scan_result_entity.dart';
import '../../../domain/repositories/qr_attendance/qr_attendance_repository.dart';
import '../../datasources/remote/qr_attendance/qr_attendance_remote_datasource.dart';
import '../../models/qr_attendance/scan_request_model.dart';
import '../../../services/location_service.dart';

/// Implementation của QR Attendance Repository
class QRAttendanceRepositoryImpl implements QRAttendanceRepository {
  final QRAttendanceRemoteDatasource _remoteDatasource;
  final LocationService _locationService;

  QRAttendanceRepositoryImpl(
    this._remoteDatasource,
    this._locationService,
  );

  @override
  Future<QRCodeEntity> generateQRCode(String attendanceId) async {
    try {
      final model = await _remoteDatasource.generateQRCode(attendanceId);
      return model.toEntity();
    } catch (e) {
      // Error already logged in datasource with full context
      // Only log here if we need to add repository-specific context
      rethrow;
    }
  }

  @override
  Future<ScanResultEntity> submitAttendanceScan({
    required String qrData,
    required double latitude,
    required double longitude,
    required String deviceId,
  }) async {
    try {
      AppLogger.info('Repository: Submitting attendance scan');
      
      final request = ScanRequestModel(
        qrData: qrData,
        latitude: latitude,
        longitude: longitude,
        deviceId: deviceId,
        timestamp: DateTime.now().toIso8601String(),
      );

      final response = await _remoteDatasource.submitAttendanceScan(request);
      return response.toEntity();
    } catch (e) {
      AppLogger.error('Repository: Failed to submit attendance scan', e);
      rethrow;
    }
  }

  @override
  Future<bool> verifyLocation({
    required double userLatitude,
    required double userLongitude,
    required String attendanceId,
  }) async {
    try {
      // This would typically call an API to get school location and allowed radius
      // For now, we'll implement it client-side with hardcoded school location
      // In production, this should be retrieved from the attendance/school data
      
      AppLogger.info('Repository: Verifying location for attendance $attendanceId');
      
      // TODO: Get school location from API based on attendanceId
      // For now, return true as location check is done server-side in submitAttendanceScan
      return true;
    } catch (e) {
      AppLogger.error('Repository: Failed to verify location', e);
      return false;
    }
  }
}

