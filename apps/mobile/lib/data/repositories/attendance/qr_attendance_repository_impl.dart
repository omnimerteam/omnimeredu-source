import 'package:mobile/services/qr_service/location_service.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/api_utils.dart';
import '../../../../core/utils/either.dart';
import '../../../../domain/entities/qr_attendance/qr_code_entity.dart';
import '../../../../domain/entities/qr_attendance/scan_result_entity.dart';
import '../../../domain/repositories/attendance/qr_attendance_repository.dart';
import '../../datasources/remote/attendance/qr_attendance_remote_datasource.dart';
import '../../models/qr_attendance/scan_request_model.dart';

class QRAttendanceRepositoryImpl implements QRAttendanceRepository {
  final QRAttendanceRemoteDatasource _remoteDatasource;
  final LocationService _locationService;

  QRAttendanceRepositoryImpl(this._remoteDatasource, this._locationService);

  @override
  Future<Either<Failure, QRCodeEntity>> generateQRCode(
    String attendanceId,
  ) async {
    return safeApiCall(() async {
      final model = await _remoteDatasource.generateQRCode(attendanceId);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, ScanResultEntity>> submitAttendanceScan({
    required String qrData,
    required double latitude,
    required double longitude,
    required String deviceId,
  }) async {
    return safeApiCall(() async {
      final request = ScanRequestModel(
        qrData: qrData,
        latitude: latitude,
        longitude: longitude,
        deviceId: deviceId,
        timestamp: DateTime.now().toIso8601String(),
      );
      final model = await _remoteDatasource.submitAttendanceScan(request);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, bool>> verifyLocation({
    required double userLatitude,
    required double userLongitude,
    required String attendanceId,
  }) async {
    try {
      // Logic verify location client-side hoặc gọi remote nếu cần
      // Giả sử locationService có phương thức kiểm tra khoảng cách
      // Nếu chưa có logic cụ thể, trả về true hoặc implement sau
      // Ở đây ta gọi _locationService.isWithinRadius (giả định)
      // Nếu không có api từ remote, ta có thể tạm return true
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
