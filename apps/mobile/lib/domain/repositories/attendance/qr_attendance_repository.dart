import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/qr_attendance/qr_code_entity.dart';
import '../../entities/qr_attendance/scan_result_entity.dart';

/// Repository interface cho QR Attendance
abstract class QRAttendanceRepository {
  /// Generate QR code data for attendance (Teacher)
  Future<Either<Failure, QRCodeEntity>> generateQRCode(String attendanceId);

  /// Submit attendance scan (Student)
  Future<Either<Failure, ScanResultEntity>> submitAttendanceScan({
    required String qrData,
    required double latitude,
    required double longitude,
    required String deviceId,
  });

  /// Verify if location is within allowed radius
  Future<Either<Failure, bool>> verifyLocation({
    required double userLatitude,
    required double userLongitude,
    required String attendanceId,
  });
}
