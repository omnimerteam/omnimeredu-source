# Kiến trúc Ứng dụng Di động Flutter

## 1. Tổng quan

Ứng dụng Di động được xây dựng bằng **Flutter** và tuân theo **Clean Architecture** kết hợp với mẫu **BLoC (Business Logic Component)**. Điều này đảm bảo sự tách biệt các mối quan tâm, khả năng kiểm thử và khả năng mở rộng trên các nền tảng iOS và Android.

## 2. Tech Stack

- **Framework**: Flutter (Dart)
- **Quản lý trạng thái**: BLoC / Cubit (flutter_bloc)
- **Dependency Injection**: get_it
- **Networking**: Dio
- **Lưu trữ cục bộ**: Shared Preferences & Flutter Secure Storage
- **Điều hướng**: Navigator (Custom RouteConfig)

## 3. Cấu trúc dự án

Dự án được tổ chức thành các lớp, tuân thủ nghiêm ngặt Quy tắc Phụ thuộc (Dependency Rule):

lib/
├── core/ # Shared Kernel (Cấu hình, Tiện ích cốt lõi)
│ ├── api/ # API Client, Interceptors
│ ├── bloc/ # Global BLoCs
│ ├── constants/ # Hằng số (Assets, Strings)
│ ├── error/ # Failures & Exceptions
│ ├── routing/ # Cấu hình điều hướng
│ ├── theme/ # App Theme, Colors
│ ├── usecases/ # Base UseCase
│ └── ...
│
├── data/ # Bộ điều hợp giao diện (Data Layer)
│ ├── datasources/ # Nguồn dữ liệu (Remote, Local)
│ ├── models/ # DTOs (Data Transfer Objects) mapping JSON
│ └── repositories/ # Triển khai các Repository của Domain
│
├── domain/ # Quy tắc nghiệp vụ (Domain Layer)
│ ├── entities/ # Các đối tượng nghiệp vụ thuần túy
│ ├── repositories/ # Các Interface trừu tượng (Contracts)
│ └── usecases/ # Logic nghiệp vụ ứng dụng
│
├── presentation/ # UI & Quản lý trạng thái (Presentation Layer)
│ ├── app.dart # Widget Ứng dụng gốc
│ ├── app_view.dart # Cấu hình View (Theme, Router)
│ ├── common/ # Widgets, UI components dùng chung
│ └── screen/ # Các màn hình (tổ chức theo feature)
│ └── auth/ # Ví dụ feature Auth
│ ├── login/
│ │ ├── bloc/
│ │ └── login_screen.dart
│ └── ...
│
├── services/ # Services hệ thống & Local Storage
│ ├── secure_storage_service.dart
│ └── shared_preferences_service.dart
│
├── utils/ # Các tiện ích bổ trợ (Logger, Validator)
│
├── injection_container.dart # Thiết lập DI (Service Locator)
└── main.dart # Điểm khởi chạy

## 4. Thiết kế chi tiết thành phần

### 4.1. Lớp Domain (Pure Dart)

- **Entities**: Các đối tượng nghiệp vụ cốt lõi. Chúng bất biến và độc lập với bất kỳ framework nào.
  - Ví dụ: `UserEntity`, `CourseEntity`.
- **Repositories (Interfaces)**: Định nghĩa hợp đồng cho các hoạt động dữ liệu.
  - Ví dụ: `IAuthRepository` định nghĩa `Future<Either<Failure, UserEntity>> login(String email, String password);`.
- **Use Cases**: Đóng gói một quy tắc nghiệp vụ hoặc hành động người dùng cụ thể.
  - Ví dụ: `LoginUseCase` gọi `repository.login()`.

### 4.2. Lớp Dữ liệu (Triển khai)

- **Models**: Kế thừa Entities để thêm logic serialization (`fromJson`, `toJson`).
  - Ví dụ: `UserModel` kế thừa `UserEntity`.
- **Data Sources**: Truy cập dữ liệu cấp thấp.
  - `RemoteDataSource`: Gọi REST APIs sử dụng Dio.
  - `LocalDataSource`: Cache dữ liệu sử dụng Shared Preferences hoặc Secure Storage.
- **Repositories (Triển khai)**: Triển khai các interface của Domain. Nó điều phối các nguồn dữ liệu (ví dụ: kiểm tra cache trước, sau đó mới gọi network).

### 4.3. Lớp Giao diện (Flutter)

- **BLoC/Cubit**: Quản lý trạng thái. Nhận **Events** từ UI, thực thi **Use Cases**, và phát ra **States**.
- **Screens/common**: Các thành phần "dumb" chỉ render UI dựa trên State và gửi Events đến BLoC.

## 5. Luồng dữ liệu

1. **Hành động người dùng**: Người dùng nhấn nút "Đăng nhập" trên `LoginScreen`.
2. **Event**: `LoginBloc` nhận event `LoginRequested`.
3. **Use Case**: Bloc gọi `LoginUseCase.execute(params)`.
4. **Repository**: Use Case gọi `IAuthRepository.login()`.
5. **Data Source**: `AuthRepositoryImpl` gọi `AuthRemoteDataSource.login()`.
6. **Network**: `Dio` gửi HTTP POST request đến Backend.
7. **Response**: Phản hồi JSON được phân tích thành `UserModel`.
8. **Return**: `UserModel` được map sang `UserEntity` và trả về ngược lại chuỗi gọi.
9. **State Change**: `LoginBloc` phát ra `LoginSuccess(user)`.
10. **UI Update**: `LoginScreen` lắng nghe state và điều hướng đến `HomeScreen`.

## 6. Các nguyên tắc chính

- **Quy tắc Phụ thuộc**: Các phụ thuộc mã nguồn chỉ hướng vào trong. Domain không biết gì về Data hay Presentation.
- **Khả năng kiểm thử**: Use Cases và BLoCs có thể được unit test dễ dàng bằng cách mock Repositories.
- **Tách biệt Model & Entity**: `Model` dành cho API/DB (cấu trúc JSON), `Entity` dành cho App (Logic nghiệp vụ).
