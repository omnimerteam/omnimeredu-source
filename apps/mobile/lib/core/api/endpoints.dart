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
/// final loginUrl = Endpoints.user.login; // http://localhost:3001/api/v1/auth/login
/// final paymentUrl = Endpoints.paymentAttendance.createPayment; // http://localhost:3002/api/v1/payments
/// final coursesUrl = Endpoints.mongodb.courses; // http://localhost:3003/api/v1/courses
/// ```
class Endpoints {
  // ==================== USER SERVICE ====================
  /// User Service Endpoints - User, Authentication, Authorization, Profile
  static UserEndpoints get user => UserEndpoints();

  // ==================== PAYMENT & ATTENDANCE SERVICE ====================
  /// Payment & Attendance Service Endpoints - Thanh toán và điểm danh
  static PaymentAttendanceEndpoints get paymentAttendance =>
      PaymentAttendanceEndpoints();

  // ==================== MONGODB SERVICE ====================
  /// MongoDB Service Endpoints - Courses, Content từ MongoDB
  static MongoDBEndpoints get mongodb => MongoDBEndpoints();
}

// ==================== USER SERVICE ENDPOINTS ====================
class UserEndpoints {
  static String get baseUrl => '${AppConfig.userServiceUrl}/api';

  // ===== Authentication endpoints =====
  String get login => '$baseUrl/v1/auth/login';
  String get register => '$baseUrl/v1/auth/register';
  String get logout => '$baseUrl/v1/auth/logout';
  String get refreshToken => '$baseUrl/v1/auth/refresh-token';
  String get createNewAccessToken => '$baseUrl/v1/auth/new-access-token';
  String get forgotPassword => '$baseUrl/v1/auth/forgot-password';
  String get resetPassword => '$baseUrl/v1/auth/reset-password';
  String get verifyEmail => '$baseUrl/v1/auth/verify-email';

  // ===== User profile endpoints =====
  String get profile => '$baseUrl/v1/users/profile';
  String get updateProfile => '$baseUrl/v1/users/profile';
  String get changePassword => '$baseUrl/v1/users/change-password';
  String get uploadAvatar => '$baseUrl/v1/users/avatar';
  String get settings => '$baseUrl/v1/users/settings';

  // ===== User management endpoints =====
  /// Get users list with query params
  String users({Map<String, String>? queryParams}) {
    final uri = Uri.parse('$baseUrl/v1/users');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams).toString();
    }
    return uri.toString();
  }

  /// Get user detail by ID
  String userById(String userId) => '$baseUrl/v1/users/$userId';

  /// Update user by ID
  String updateUserById(String userId) => '$baseUrl/v1/users/$userId';

  /// Delete user by ID
  String deleteUserById(String userId) => '$baseUrl/v1/users/$userId';

  // ===== Role & Permission endpoints =====
  String get roles => '$baseUrl/v1/roles';
  String roleById(String roleId) => '$baseUrl/v1/roles/$roleId';

  // ===== School endpoints =====
  String get getSchools => '$baseUrl/v1/schools';

  /// Get school detail by ID
  String schoolById(String schoolId) => '$baseUrl/v1/schools/$schoolId';

  /// Get classes by school ID
  String getClassesBySchool(String schoolId) => '$baseUrl/v1/schools/$schoolId/classes';

  // TODO: Thêm các user endpoints khác
}

// ==================== PAYMENT & ATTENDANCE SERVICE ENDPOINTS ====================
class PaymentAttendanceEndpoints {
  static String get baseUrl => '${AppConfig.paymentAttendanceServiceUrl}/api';

  // ===== Payment endpoints =====
  String get payments => '$baseUrl/v1/payments';
  String get createPayment => '$baseUrl/v1/payments';
  String get processPayment => '$baseUrl/v1/payments/process';
  String get paymentHistory => '$baseUrl/v1/payments/history';

  /// Get payment detail by ID
  String paymentById(String paymentId) => '$baseUrl/v1/payments/$paymentId';

  /// Cancel payment
  String cancelPayment(String paymentId) =>
      '$baseUrl/v1/payments/$paymentId/cancel';

  /// Refund payment
  String refundPayment(String paymentId) =>
      '$baseUrl/v1/payments/$paymentId/refund';

  // ===== Attendance endpoints =====
  String get attendances => '$baseUrl/v1/attendances';
  String get checkIn => '$baseUrl/v1/attendances/check-in';
  String get checkOut => '$baseUrl/v1/attendances/check-out';
  String get attendanceHistory => '$baseUrl/v1/attendances/history';

  /// Get attendance by ID
  String attendanceById(String attendanceId) =>
      '$baseUrl/v1/attendances/$attendanceId';

  /// Get attendance by user
  String attendanceByUser(String userId, {Map<String, String>? queryParams}) {
    final uri = Uri.parse('$baseUrl/v1/attendances/user/$userId');
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
    final uri = Uri.parse('$baseUrl/v1/attendances/course/$courseId');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams).toString();
    }
    return uri.toString();
  }

  /// Get attendance statistics
  String get attendanceStats => '$baseUrl/v1/attendances/statistics';

  // TODO: Thêm các payment & attendance endpoints khác
}

// ==================== MONGODB SERVICE ENDPOINTS ====================
class MongoDBEndpoints {
  static String get baseUrl => '${AppConfig.mongodbServiceUrl}/api';

  // ===== Course endpoints =====
  String get courses => '$baseUrl/v1/courses';
  String get createCourse => '$baseUrl/v1/courses';

  /// Get course detail by ID
  String courseById(String courseId) => '$baseUrl/v1/courses/$courseId';

  /// Update course by ID
  String updateCourse(String courseId) => '$baseUrl/v1/courses/$courseId';

  /// Delete course by ID
  String deleteCourse(String courseId) => '$baseUrl/v1/courses/$courseId';

  /// Get courses with query params (pagination, filter, search)
  String coursesWithQuery({Map<String, String>? queryParams}) {
    final uri = Uri.parse('$baseUrl/v1/courses');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams).toString();
    }
    return uri.toString();
  }

  // ===== Lesson endpoints =====
  String lessonsOfCourse(String courseId) =>
      '$baseUrl/v1/courses/$courseId/lessons';
  String lessonById(String courseId, String lessonId) =>
      '$baseUrl/v1/courses/$courseId/lessons/$lessonId';

  // ===== Category endpoints =====
  String get categories => '$baseUrl/v1/categories';
  String categoryById(String categoryId) =>
      '$baseUrl/v1/categories/$categoryId';

  // ===== Content endpoints =====
  String get contents => '$baseUrl/v1/contents';
  String contentById(String contentId) => '$baseUrl/v1/contents/$contentId';

  // ===== Post/Article endpoints =====
  String get posts => '$baseUrl/v1/posts';
  String postById(String postId) => '$baseUrl/v1/posts/$postId';

  // ===== Assignment endpoints =====
  String assignmentsOfCourse(String courseId) =>
      '$baseUrl/v1/courses/$courseId/assignments';
  String assignmentById(String assignmentId) =>
      '$baseUrl/v1/assignments/$assignmentId';

  // ===== Submission endpoints =====
  String submissionsOfAssignment(String assignmentId) =>
      '$baseUrl/v1/assignments/$assignmentId/submissions';
  String submissionById(String submissionId) =>
      '$baseUrl/v1/submissions/$submissionId';

  // TODO: Thêm các MongoDB endpoints khác
}

// ==================== HELPER METHODS ====================

/// Helper để build URL với query parameters
///
/// Ví dụ:
/// ```dart
/// final url = buildUrlWithQuery(
///   'http://localhost:3001/api/v1/users',
///   {'page': '1', 'limit': '10'}
/// );
/// // Result: http://localhost:3001/api/v1/users?page=1&limit=10
/// ```
String buildUrlWithQuery(String baseUrl, Map<String, String> queryParams) {
  final uri = Uri.parse(baseUrl);
  return uri.replace(queryParameters: queryParams).toString();
}
