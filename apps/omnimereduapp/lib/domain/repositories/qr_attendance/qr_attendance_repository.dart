import '../../../domain/entities/qr_attendance/qr_code_entity.dart';
import '../../../domain/entities/qr_attendance/scan_result_entity.dart';

/// Repository interface cho QR Attendance
abstract class QRAttendanceRepository {
  /// Generate QR code data for attendance (Teacher)
  Future<QRCodeEntity> generateQRCode(String attendanceId);

  /// Submit attendance scan (Student)
  Future<ScanResultEntity> submitAttendanceScan({
    required String qrData,
    required double latitude,
    required double longitude,
    required String deviceId,
    DateTime? scanTime,
  });

  /// Verify if location is within allowed radius
  Future<bool> verifyLocation({
    required double userLatitude,
    required double userLongitude,
    required String attendanceId,
  });
}
