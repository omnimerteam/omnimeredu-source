import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/qr_attendance/qr_code_entity.dart';
import '../../repositories/attendance/qr_attendance_repository.dart';

/// Usecase để generate QR code cho giáo viên
class GenerateQRCodeUseCase
    extends UseCase<Either<Failure, QRCodeEntity>, String> {
  final QRAttendanceRepository _repository;

  GenerateQRCodeUseCase(this._repository);

  /// Execute usecase
  @override
  Future<Either<Failure, QRCodeEntity>> call(String params) async {
    try {
      return await _repository.generateQRCode(params);
    } catch (e) {
      // Error already logged in lower layers with full context
      return Left(ServerFailure("Failed to generate QR Code: $e"));
    }
  }
}
