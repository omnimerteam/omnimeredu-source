import 'package:flutter_dotenv/flutter_dotenv.dart';

/// AppConfig - Quản lý cấu hình cho kiến trúc Microservice
///
/// Cách sử dụng:
/// 1. Định nghĩa các service URLs trong .env file
/// 2. Thêm getter tương ứng trong class này
/// 3. Sử dụng trong Endpoints class để build full URL
class AppConfig {
  // ==================== ENVIRONMENT ====================
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'DEV';

  static bool get isDev => environment.toUpperCase() == "DEV";
  static bool get isProd => environment.toUpperCase() == "PROD";

  // ==================== MICROSERVICES URLs ====================

  /// User Service - Xử lý user, authentication, authorization, profile
  static String get userServiceUrl {
    return dotenv.env['USER_SERVICE_URL'] ?? 'http://localhost:3001';
  }

  /// Payment & Attendance Service - Quản lý thanh toán và điểm danh
  static String get paymentAttendanceServiceUrl {
    return dotenv.env['PAYMENT_ATTENDANCE_SERVICE_URL'] ??
        'http://localhost:3002';
  }

  /// MongoDB Service - Quản lý dữ liệu từ MongoDB (courses, content, etc.)
  static String get mongodbServiceUrl {
    return dotenv.env['MONGODB_SERVICE_URL'] ?? 'http://localhost:3003';
  }

  // ==================== API GATEWAY (Optional) ====================

  /// API Gateway URL - Nếu sử dụng API Gateway
  /// Uncomment nếu muốn route tất cả request qua gateway
  // static String get apiGatewayUrl {
  //   return dotenv.env['API_GATEWAY_URL'] ?? 'http://localhost:8080';
  // }

  // ==================== OTHER CONFIGS ====================

  /// API timeout (milliseconds)
  static int get apiTimeout {
    final timeout = dotenv.env['API_TIMEOUT'];
    return timeout != null ? int.tryParse(timeout) ?? 30000 : 30000;
  }

  /// Enable API logging
  static bool get enableApiLogging {
    final logging = dotenv.env['ENABLE_API_LOGGING'];
    return logging?.toLowerCase() == 'true';
  }
}
