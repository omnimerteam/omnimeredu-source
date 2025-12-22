import 'app_config.dart';

/// Endpoints - Quản lý tất cả API endpoints theo kiến trúc Microservice
///
/// Cách sử dụng:
/// 1. Tổ chức endpoints theo từng service (UserEndpoints, PaymentAttendanceEndpoints, MongoDBEndpoints)
/// 2. Mỗi service class có baseUrl riêng từ AppConfig
/// 3. Sử dụng helper method để build full URL
///
/// Ví dụ:
/// ```dart
/// final loginUrl = Endpoints.user.login; // http://localhost:3001/api/auth/login
/// final paymentUrl = Endpoints.paymentAttendance.createPayment; // http://localhost:3002/api/payments
/// final coursesUrl = Endpoints.mongodb.courses; // http://localhost:3003/api/courses
/// ```
class Endpoints {
  // ==================== USER SERVICE ====================
  /// User Service Endpoints - User, Authentication, Authorization, Profile
  static UserEndpoints get user => UserEndpoints();

  // ==================== PAYMENT & ATTENDANCE SERVICE ====================
  /// Payment & Attendance Service Endpoints - Thanh toán và điểm danh
  static PaymentAttendanceEndpoints get paymentAttendance =>
      PaymentAttendanceEndpoints();
}

// ==================== USER SERVICE ENDPOINTS ====================
// ==================== USER SERVICE ENDPOINTS ====================
class UserEndpoints {
  static String get baseUrl => '${AppConfig.userServiceUrl}/api';

  // ===== Authentication endpoints =====
  String get login => '$baseUrl/auth/login';
  String get register => '$baseUrl/auth/register';
  String get refreshToken => '$baseUrl/auth/refresh-token';
  String get me => '$baseUrl/auth/me';

  // ===== School endpoints =====
  String get schools => '$baseUrl/schools'; // GET (List), POST (Create)
  String get schoolAdminDetail => '$baseUrl/schools/school-admin'; // GET

  String schoolById(String id) => '$baseUrl/schools/$id'; // GET, PUT, DELETE
  String classesOnSchool(String schoolId) =>
      '$baseUrl/schools/$schoolId/classes'; // GET

  // ===== Grade endpoints =====
  String get grades => '$baseUrl/grades'; // POST (Create)
  String gradeById(String id) => '$baseUrl/grades/$id'; // GET, PUT, DELETE
  String gradesBySchool(String schoolId) =>
      '$baseUrl/grades/school/$schoolId'; // GET

  // ===== Class endpoints =====
  String get classes => '$baseUrl/classes'; // POST (Create)
  String classById(String id) => '$baseUrl/classes/$id'; // GET, PUT, DELETE
  String studentsInClass(String id) => '$baseUrl/classes/$id/students'; // GET
  String classesBySchool(String schoolId) =>
      '$baseUrl/classes/school/$schoolId'; // GET
  String searchClassesBySchool(String schoolId) =>
      '$baseUrl/classes/search/$schoolId';

  // ===== User endpoints =====
  String get users => '$baseUrl/users'; // POST (Create)

  // ===== Membership Request endpoints =====
  String get membershipRequests => '$baseUrl/membership-requests';
  String membershipRequestId(String id) => '$baseUrl/membership-requests/$id';
  String membershipRequestStatus(String id) =>
      '$baseUrl/membership-requests/$id/status';
}

// ==================== PAYMENT & ATTENDANCE SERVICE ENDPOINTS ====================
class PaymentAttendanceEndpoints {
  static String get baseUrl => '${AppConfig.paymentAttendanceServiceUrl}/api';

  // ===== Payment endpoints =====
  String get payments => '$baseUrl/payments';
  String get createPayment => '$baseUrl/payments';
  String get processPayment => '$baseUrl/payments/process';
  String get paymentHistory => '$baseUrl/payments/history';

  /// Get payment detail by ID
  String paymentById(String paymentId) => '$baseUrl/payments/$paymentId';

  /// Cancel payment
  String cancelPayment(String paymentId) =>
      '$baseUrl/payments/$paymentId/cancel';

  /// Refund payment
  String refundPayment(String paymentId) =>
      '$baseUrl/payments/$paymentId/refund';

  // ===== Attendance endpoints =====
  String get attendances => '$baseUrl/attendances';
  String get checkIn => '$baseUrl/attendances/check-in';
  String get checkOut => '$baseUrl/attendances/check-out';
  String get attendanceHistory => '$baseUrl/attendances/history';

  /// Get attendance by ID
  String attendanceById(String attendanceId) =>
      '$baseUrl/attendances/$attendanceId';

  /// Get attendance by user
  String attendanceByUser(String userId, {Map<String, String>? queryParams}) {
    final uri = Uri.parse('$baseUrl/attendances/user/$userId');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams).toString();
    }
    return uri.toString();
  }

  /// Get attendance by course
  String attendanceByCourse(
    String courseId, {
    Map<String, String>? queryParams,
  }) {
    final uri = Uri.parse('$baseUrl/attendances/course/$courseId');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams).toString();
    }
    return uri.toString();
  }

  /// Get attendance statistics
  String get attendanceStats => '$baseUrl/attendances/statistics';

  // TODO: Thêm các payment & attendance endpoints khác

  // ===== Specific Attendance Operations =====
  String get initializeClassAttendance => '$baseUrl/attendance/initialize';
  String get getClassAttendanceRecordView =>
      '$baseUrl/attendance/find'; // New endpoint we will create
  String exportAttendanceExcel(String id) => '$baseUrl/attendance/$id/export';

  // ===== Detail Record Endpoints =====
  String getAttendanceRecordsById(String attendanceId) =>
      '$baseUrl/attendance/$attendanceId/records';
  String updateStatusDetailRecord(String id) =>
      '$baseUrl/attendance/records/$id/status';

  // ===== QR Attendance Endpoints =====
  String generateQRCode(String attendanceId) =>
      '$baseUrl/attendance/$attendanceId/qr';
  String get submitAttendanceScan => '$baseUrl/attendance/qr/verify';
}

// ==================== HELPER METHODS ====================

/// Helper để build URL với query parameters
///
/// Ví dụ:
/// ```dart
/// final url = buildUrlWithQuery(
///   'http://localhost:3001/api/users',
///   {'page': '1', 'limit': '10'}
/// );
/// // Result: http://localhost:3001/api/users?page=1&limit=10
/// ```
String buildUrlWithQuery(String baseUrl, Map<String, String> queryParams) {
  final uri = Uri.parse(baseUrl);
  return uri.replace(queryParameters: queryParams).toString();
}
