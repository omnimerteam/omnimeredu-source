import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../../../models/qr_attendance/qr_data_model.dart';
import '../../../models/qr_attendance/scan_request_model.dart';
import '../../../models/qr_attendance/scan_response_model.dart';

/// Remote datasource cho QR Attendance
class QRAttendanceRemoteDatasource {
  final ApiClient _apiClient;

  QRAttendanceRemoteDatasource(this._apiClient);

  /// Generate QR code data from server
  Future<QRDataModel> generateQRCode(String attendanceId) async {
    final endpoint = Endpoints.paymentAttendance.generateQRCode(attendanceId);
    try {
      final response = await _apiClient.get<QRDataModel>(
        endpoint,
        parser: (data) => QRDataModel.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        AppLogger.info('QR code generated: $attendanceId');
        return response.data!;
      } else {
        final errorMsg = response.message;
        throw Exception(errorMsg);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Submit attendance scan to server
  Future<ScanResponseModel> submitAttendanceScan(
    ScanRequestModel request,
  ) async {
    try {
      AppLogger.info('Submitting attendance scan');

      final response = await _apiClient.post(
        Endpoints.paymentAttendance.submitAttendanceScan,
        data: request.toJson(),
      );

      if (response.success && response.data != null) {
        AppLogger.info('Attendance scan submitted successfully');
        return ScanResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      AppLogger.error('Error submitting attendance scan', e);
      rethrow;
    }
  }
}
