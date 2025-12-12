# Microservice Architecture - Hướng dẫn sử dụng

## 📋 Tổng quan

Dự án sử dụng kiến trúc **Microservice** với 3 services độc lập:

1. **User Service** (Port 3001)
   - Authentication & Authorization (Login, Register, JWT)
   - User Management (Profile, Settings, Roles)
2. **Payment & Attendance Service** (Port 3002)
   - Payment Processing (Thanh toán, lịch sử, hoàn tiền)
   - Attendance Tracking (Điểm danh, thống kê)
3. **MongoDB Service** (Port 3003)
   - Courses Management (Khóa học, bài giảng)
   - Content Management (Nội dung, bài viết, assignments)

## 🏗️ Cấu trúc

```
apps/mobile/lib/core/api/
├── app_config.dart          # Quản lý URLs của 3 microservices
├── endpoints.dart           # Định nghĩa endpoints cho từng service
├── api_client.dart          # HTTP client để gọi API
├── api_response.dart        # Response wrapper
└── api_exception.dart       # Exception handling
```

## 🚀 Cách sử dụng

### 1. Cấu hình Environment (.env)

Tạo file `.env` từ `.env.example`:

```bash
cp .env.example .env
```

Cập nhật URLs cho 3 microservices:

```env
# Development
USER_SERVICE_URL=http://localhost:3001
PAYMENT_ATTENDANCE_SERVICE_URL=http://localhost:3002
MONGODB_SERVICE_URL=http://localhost:3003

# Production
# USER_SERVICE_URL=https://user.yourdomain.com
# PAYMENT_ATTENDANCE_SERVICE_URL=https://payment.yourdomain.com
# MONGODB_SERVICE_URL=https://mongodb.yourdomain.com
```

### 2. Sử dụng Endpoints

#### 📌 Ví dụ 1: User Service - Authentication

```dart
import 'package:mobile/core/api/endpoints.dart';
import 'package:mobile/core/api/api_client.dart';

// Login
final response = await apiClient.post(
  Endpoints.user.login,
  data: {
    'email': 'user@example.com',
    'password': 'password123',
  },
);

// Register
final registerResponse = await apiClient.post(
  Endpoints.user.register,
  data: {
    'email': 'newuser@example.com',
    'password': 'password123',
    'name': 'John Doe',
  },
);

// Refresh token (tự động xử lý bởi ApiClient)
// Không cần gọi trực tiếp
```

#### 📌 Ví dụ 2: User Service - User Management

```dart
// Get user profile
final profile = await apiClient.get(Endpoints.user.profile);

// Update profile
final updated = await apiClient.put(
  Endpoints.user.updateProfile,
  data: {
    'name': 'John Doe Updated',
    'phone': '0123456789',
  },
);

// Change password
await apiClient.post(
  Endpoints.user.changePassword,
  data: {
    'oldPassword': 'old123',
    'newPassword': 'new123',
  },
);

// Get user by ID
final user = await apiClient.get(
  Endpoints.user.userById('user-id-123'),
);

// Get users list with pagination
final users = await apiClient.get(
  Endpoints.user.users(
    queryParams: {
      'page': '1',
      'limit': '10',
      'search': 'john',
    },
  ),
);

// Upload avatar
final avatarResponse = await apiClient.uploadFile(
  Endpoints.user.uploadAvatar,
  file: imageFile,
  fieldName: 'avatar',
);
```

#### 📌 Ví dụ 3: Payment & Attendance Service - Payments

```dart
// Create payment
final payment = await apiClient.post(
  Endpoints.paymentAttendance.createPayment,
  data: {
    'amount': 500000,
    'currency': 'VND',
    'courseId': 'course-123',
    'method': 'credit_card',
  },
);

// Get payment history
final history = await apiClient.get(
  Endpoints.paymentAttendance.paymentHistory,
);

// Get payment by ID
final paymentDetail = await apiClient.get(
  Endpoints.paymentAttendance.paymentById('payment-id-123'),
);

// Cancel payment
await apiClient.post(
  Endpoints.paymentAttendance.cancelPayment('payment-id-123'),
);

// Refund payment
await apiClient.post(
  Endpoints.paymentAttendance.refundPayment('payment-id-123'),
  data: {
    'reason': 'Customer request',
    'amount': 500000,
  },
);
```

#### 📌 Ví dụ 4: Payment & Attendance Service - Attendance

```dart
// Check in
final checkIn = await apiClient.post(
  Endpoints.paymentAttendance.checkIn,
  data: {
    'courseId': 'course-123',
    'sessionId': 'session-456',
    'timestamp': DateTime.now().toIso8601String(),
  },
);

// Check out
await apiClient.post(
  Endpoints.paymentAttendance.checkOut,
  data: {
    'attendanceId': 'attendance-id-123',
    'timestamp': DateTime.now().toIso8601String(),
  },
);

// Get attendance history
final attendanceHistory = await apiClient.get(
  Endpoints.paymentAttendance.attendanceHistory,
);

// Get attendance by user
final userAttendance = await apiClient.get(
  Endpoints.paymentAttendance.attendanceByUser(
    'user-id-123',
    queryParams: {
      'startDate': '2024-01-01',
      'endDate': '2024-12-31',
    },
  ),
);

// Get attendance by course
final courseAttendance = await apiClient.get(
  Endpoints.paymentAttendance.attendanceByCourse(
    'course-id-123',
    queryParams: {
      'page': '1',
      'limit': '20',
    },
  ),
);

// Get attendance statistics
final stats = await apiClient.get(
  Endpoints.paymentAttendance.attendanceStats,
);
```

#### 📌 Ví dụ 5: MongoDB Service - Courses

```dart
// Get all courses
final courses = await apiClient.get(Endpoints.mongodb.courses);

// Get courses with filters
final filteredCourses = await apiClient.get(
  Endpoints.mongodb.coursesWithQuery(
    queryParams: {
      'page': '1',
      'limit': '10',
      'category': 'programming',
      'level': 'beginner',
    },
  ),
);

// Get course by ID
final course = await apiClient.get(
  Endpoints.mongodb.courseById('course-id-123'),
);

// Create course
final newCourse = await apiClient.post(
  Endpoints.mongodb.createCourse,
  data: {
    'title': 'Flutter Advanced',
    'description': 'Learn advanced Flutter concepts',
    'price': 1000000,
    'categoryId': 'cat-123',
  },
);

// Update course
await apiClient.put(
  Endpoints.mongodb.updateCourse('course-id-123'),
  data: {
    'title': 'Flutter Advanced Updated',
    'price': 1200000,
  },
);

// Delete course
await apiClient.delete(
  Endpoints.mongodb.deleteCourse('course-id-123'),
);
```

#### 📌 Ví dụ 6: MongoDB Service - Lessons & Content

```dart
// Get lessons of a course
final lessons = await apiClient.get(
  Endpoints.mongodb.lessonsOfCourse('course-id-123'),
);

// Get lesson by ID
final lesson = await apiClient.get(
  Endpoints.mongodb.lessonById('course-id-123', 'lesson-id-456'),
);

// Get categories
final categories = await apiClient.get(Endpoints.mongodb.categories);

// Get posts/articles
final posts = await apiClient.get(Endpoints.mongodb.posts);

// Get post by ID
final post = await apiClient.get(
  Endpoints.mongodb.postById('post-id-123'),
);

// Get assignments of a course
final assignments = await apiClient.get(
  Endpoints.mongodb.assignmentsOfCourse('course-id-123'),
);

// Get submissions of an assignment
final submissions = await apiClient.get(
  Endpoints.mongodb.submissionsOfAssignment('assignment-id-123'),
);
```

### 3. Thêm Endpoint mới

#### Ví dụ: Thêm endpoint "Get User Statistics" vào User Service

**Bước 1:** Thêm endpoint vào `UserEndpoints` trong `endpoints.dart`

```dart
class UserEndpoints {
  static String get baseUrl => '${AppConfig.userServiceUrl}/api';

  // ... existing endpoints ...

  // ===== Statistics endpoints =====
  String get userStatistics => '$baseUrl/v1/users/statistics';
  String userStatisticsById(String userId) => '$baseUrl/v1/users/$userId/statistics';
}
```

**Bước 2:** Sử dụng endpoint mới

```dart
// Get current user statistics
final stats = await apiClient.get(Endpoints.user.userStatistics);

// Get statistics of specific user
final userStats = await apiClient.get(
  Endpoints.user.userStatisticsById('user-id-123'),
);
```

### 4. Sử dụng API Gateway (Optional)

Nếu muốn route tất cả requests qua API Gateway:

#### Bước 1: Uncomment trong `.env`

```env
API_GATEWAY_URL=http://localhost:8080
```

#### Bước 2: Uncomment trong `app_config.dart`

```dart
static String get apiGatewayUrl {
  return dotenv.env['API_GATEWAY_URL'] ?? 'http://localhost:8080';
}
```

#### Bước 3: Sửa endpoints để sử dụng gateway

```dart
class UserEndpoints {
  static String get baseUrl => '${AppConfig.apiGatewayUrl}/user';
  // Gateway sẽ route /user/* đến User Service
}

class PaymentAttendanceEndpoints {
  static String get baseUrl => '${AppConfig.apiGatewayUrl}/payment';
  // Gateway sẽ route /payment/* đến Payment & Attendance Service
}

class MongoDBEndpoints {
  static String get baseUrl => '${AppConfig.apiGatewayUrl}/mongodb';
  // Gateway sẽ route /mongodb/* đến MongoDB Service
}
```

## 🔧 Best Practices

### 1. Tổ chức Endpoints theo Resource

```dart
class UserEndpoints {
  // ✅ Good - Rõ ràng, dễ maintain
  String get profile => '$baseUrl/v1/users/profile';
  String userById(String id) => '$baseUrl/v1/users/$id';

  // ❌ Bad - Hard-coded, khó maintain
  String get getUser => 'http://localhost:3001/api/v1/users/profile';
}
```

### 2. Sử dụng Query Parameters

```dart
// ✅ Good - Flexible
String attendanceByUser(String userId, {Map<String, String>? queryParams}) {
  final uri = Uri.parse('$baseUrl/v1/attendances/user/$userId');
  if (queryParams != null && queryParams.isNotEmpty) {
    return uri.replace(queryParameters: queryParams).toString();
  }
  return uri.toString();
}

// Usage
Endpoints.paymentAttendance.attendanceByUser(
  'user-123',
  queryParams: {'startDate': '2024-01-01', 'endDate': '2024-12-31'},
);
```

### 3. Versioning API

```dart
// ✅ Good - Có version trong URL
String get login => '$baseUrl/v1/auth/login';

// Khi cần upgrade
String get loginV2 => '$baseUrl/v2/auth/login';
```

### 4. Error Handling

```dart
try {
  final response = await apiClient.get(Endpoints.user.profile);
  // Handle success
  print('User: ${response.data}');
} on UnauthorizedException catch (e) {
  // Handle 401 - redirect to login
  print('Unauthorized: ${e.message}');
} on NotFoundException catch (e) {
  // Handle 404
  print('Not found: ${e.message}');
} on ApiException catch (e) {
  // Handle other API errors
  print('API Error: ${e.message}');
} catch (e) {
  // Handle unexpected errors
  print('Unexpected error: $e');
}
```

### 5. Authentication

```dart
// Endpoints yêu cầu authentication (mặc định)
final profile = await apiClient.get(
  Endpoints.user.profile,
  requiresAuth: true, // Default
);

// Endpoints không yêu cầu authentication
final publicCourses = await apiClient.get(
  Endpoints.mongodb.courses,
  requiresAuth: false,
);
```

## 📊 Kiến trúc Microservice

```
┌─────────────────┐
│  Mobile App     │
│  (Flutter)      │
└────────┬────────┘
         │
         ├──────────────────────────────────────────┐
         │                                          │
         ▼                                          ▼
┌────────────────────┐                    ┌─────────────────┐
│  API Gateway       │                    │  Direct Calls   │
│  (Optional)        │                    │  (Default)      │
│  Port: 8080        │                    └─────────────────┘
└────────┬───────────┘                              │
         │                                          │
         └──────────────┬───────────────────────────┘
                        │
         ┌──────────────┼──────────────┐
         │              │              │
         ▼              ▼              ▼
┌─────────────┐  ┌──────────────┐  ┌──────────────┐
│ User        │  │ Payment &    │  │ MongoDB      │
│ Service     │  │ Attendance   │  │ Service      │
│ Port: 3001  │  │ Service      │  │ Port: 3003   │
│             │  │ Port: 3002   │  │              │
│ - Auth      │  │              │  │ - Courses    │
│ - Users     │  │ - Payments   │  │ - Lessons    │
│ - Roles     │  │ - Attendance │  │ - Content    │
└─────────────┘  └──────────────┘  └──────────────┘
```

## 📝 Notes

- **3 Microservices độc lập**: User, Payment & Attendance, MongoDB
- Mỗi service có base URL riêng và port riêng
- Endpoints được tổ chức theo service để dễ quản lý
- Hỗ trợ cả direct service calls và API Gateway
- ApiClient tự động xử lý authentication và refresh token
- Dễ dàng mở rộng thêm endpoints mà không ảnh hưởng code khác

## 🔗 Related Files

- `app_config.dart` - Service URLs configuration
- `endpoints.dart` - API endpoints definition
- `api_client.dart` - HTTP client with auto-refresh token
- `.env.example` - Environment variables template
