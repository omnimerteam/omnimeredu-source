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
      final endpoint = Endpoints.paymentAttendance.submitAttendanceScan;
      final requestData = request.toJson();

      final response = await _apiClient.post<ScanResponseModel>(
        endpoint,
        data: requestData,
        parser: (data) {
          // Handle both cases: data is Map or already parsed
          if (data is Map<String, dynamic>) {
            return ScanResponseModel.fromJson(data);
          } else if (data is ScanResponseModel) {
            return data;
          } else {
            throw Exception('Invalid response data format');
          }
        },
      );

      if (response.success) {
        if (response.data != null) {
          return response.data!;
        } else {
          throw Exception('Phản hồi từ server không có dữ liệu');
        }
      } else {
        // Response is not success - try to get error message
        String errorMsg = response.message.isNotEmpty
            ? response.message
            : 'Không thể quét mã QR. Vui lòng thử lại.';

        // Try to extract error from response.error if available
        if (response.error != null) {
          if (response.error is Map) {
            final errorMap = response.error as Map;
            if (errorMap.containsKey('message')) {
              errorMsg = errorMap['message'].toString();
            } else if (errorMap.containsKey('error')) {
              errorMsg = errorMap['error'].toString();
            }
          } else {
            errorMsg = response.error.toString();
          }
        }

        throw Exception(errorMsg);
      }
    } catch (e) {
      rethrow;
    }
  }
}
