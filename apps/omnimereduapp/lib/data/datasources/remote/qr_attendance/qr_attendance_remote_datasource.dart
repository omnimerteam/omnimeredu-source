import '../../../../core/add_jwt.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../../../models/qr_attendance/qr_data_model.dart';
import '../../../models/qr_attendance/scan_request_model.dart';
import '../../../models/qr_attendance/scan_response_model.dart';
import '../base_remote_data_source.dart';

/// Remote datasource cho QR Attendance
class QRAttendanceRemoteDatasource extends BaseRemoteDataSource {
  QRAttendanceRemoteDatasource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  /// Generate QR code data from server
  Future<QRDataModel> generateQRCode(String attendanceId) async {
    final endpoint = Endpoints.generateQRCode(attendanceId);
    try {
      final headers = await authHeaders;

      final response = await client.get<QRDataModel>(
        endpoint,
        headers: headers,
        parser: (data) => QRDataModel.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        AppLogger.info('QR code generated: $attendanceId');
        return response.data!;
      } else {
        final errorMsg = response.message ?? 'Failed to generate QR code';
        // Error đã được log ở ApiClient interceptor
        throw Exception(errorMsg);
      }
    } catch (e) {
      // Không log lại vì đã được log ở ApiClient interceptor
      // Chỉ rethrow để layer trên xử lý
      rethrow;
    }
  }

  /// Submit attendance scan to server
  Future<ScanResponseModel> submitAttendanceScan(
    ScanRequestModel request,
  ) async {
    try {
      AppLogger.info('Submitting attendance scan');

      final headers = await authHeaders;

      final response = await client.post(
        Endpoints.submitAttendanceScan,
        headers: headers,
        data: request.toJson(),
      );

      if (response.success && response.data != null) {
        AppLogger.info('Attendance scan submitted successfully');
        return ScanResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.message ?? 'Failed to submit attendance scan');
      }
    } catch (e) {
      AppLogger.error('Error s  ubmitting attendance scan', e);
      rethrow;
    }
  }
}
