import '../../../domain/entities/qr_attendance/qr_code_entity.dart';
import '../../../domain/repositories/qr_attendance/qr_attendance_repository.dart';

/// Usecase để generate QR code cho giáo viên
class GenerateQRCodeUsecase {
  final QRAttendanceRepository _repository;

  GenerateQRCodeUsecase(this._repository);

  /// Execute usecase
  Future<QRCodeEntity> call(String attendanceId) async {
    try {
      return await _repository.generateQRCode(attendanceId);
    } catch (e) {
      // Error already logged in lower layers with full context
      rethrow;
    }
  }
}

