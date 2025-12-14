import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../../../models/qr_attendance/qr_data_model.dart';
import '../../../models/qr_attendance/scan_request_model.dart';
import '../../../models/qr_attendance/scan_response_model.dart';

/// Remote datasource cho QR Attendance
class QRAttendanceRemoteDatasource {
  final ApiClient _apiClient;

  QRAttendanceRemoteDatasource(this._apiClient);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  /// Generate QR code data from server
  Future<QRDataModel> generateQRCode(String attendanceId) async {
    final endpoint = Endpoints.generateQRCode(attendanceId);
    try {
      final token = await _getIdToken();
      
      final response = await _apiClient.get<QRDataModel>(
        endpoint,
        headers: {if (token != null) "Authorization": "Bearer $token"},
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
      
      final token = await _getIdToken();
      
      final response = await _apiClient.post(
        Endpoints.submitAttendanceScan,
        headers: {if (token != null) "Authorization": "Bearer $token"},
        data: request.toJson(),
      );

      if (response.success && response.data != null) {
        AppLogger.info('Attendance scan submitted successfully');
        return ScanResponseModel.fromJson(response.data);
      } else {
        throw Exception(response.message ?? 'Failed to submit attendance scan');
      }
    } catch (e) {
      AppLogger.error('Error submitting attendance scan', e);
      rethrow;
    }
  }
}

