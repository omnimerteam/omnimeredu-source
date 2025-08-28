# 📘 OmniMer EDU - Frontend Architecture

## 1. Giới thiệu

Đây là phần frontend của dự án **OmniMer EDU**, được xây dựng bằng
**Flutter** theo kiến trúc **Clean Architecture + Bloc Pattern**. Mục
tiêu là đảm bảo: - Code dễ bảo trì, dễ mở rộng - Tách biệt rõ ràng các
tầng - Hỗ trợ đa nền tảng (Android, iOS, Web, Desktop)

------------------------------------------------------------------------

## 2. Cấu trúc thư mục

    lib/
     ├── core/                     # Configs & tiện ích dùng chung
     │    ├── network/             # API client, endpoints, exception
     │    ├── utils/               # Helper, logger, validator
     │    └── error/               # Định nghĩa error handling
     │
     ├── domain/                   # Tầng nghiệp vụ (Business rules)
     │    ├── entities/            # Định nghĩa entity thuần (model business)
     │    ├── repositories/        # Abstraction repository (interface)
     │    └── usecases/            # Business logic (ứng dụng)
     │
     ├── data/                     # Tầng xử lý dữ liệu
     │    ├── models/              # Model ánh xạ JSON <-> Entity
     │    ├── repositories/        # Triển khai repository (implements)
     │    └── datasources/         # Nguồn dữ liệu
     │         └── remote/         # Gọi API qua Dio
     │
     ├── presentation/             # UI + State Management
     │    ├── blocs/               # Bloc / Cubit quản lý state
     │    ├── screens/             # Màn hình (UI)
     │    └── widgets/             # Thành phần tái sử dụng
     │
     └── main.dart                 # Điểm khởi chạy ứng dụng

------------------------------------------------------------------------

## 3. Workflow xử lý dữ liệu

1.  **UI (presentation/screens)** gửi event đến **Bloc**
2.  **Bloc** gọi **UseCase (domain/usecases)**
3.  **UseCase** gọi **Repository (domain/repositories)**
4.  **Repository** triển khai trong `data/repositories`, gọi đến
    **Datasource**
5.  **Datasource (remote)** gọi API qua `ApiClient (Dio)`
6.  Kết quả trả về theo chiều ngược lại: API → Datasource → Repository →
    UseCase → Bloc → UI

------------------------------------------------------------------------

## 4. Quy trình Authentication (Ví dụ)

-   Người dùng nhập tài khoản → **UI**
-   Bloc bắn event `LoginRequested`
-   UseCase `LoginUser` gọi `AuthRepository`
-   `AuthRepositoryImpl` dùng `AuthRemoteDataSource` để gọi
    `auth_api.dart`
-   `ApiClient` gửi request tới Backend Node.js
-   Trả về `UserModel` → convert sang `UserEntity`
-   Bloc emit state `Authenticated(user)`
-   UI hiển thị màn hình Home

------------------------------------------------------------------------

## 5. Ưu điểm của kiến trúc này

-   **Tách biệt rõ ràng** giữa UI, Logic và Data
-   **Dễ test** từng phần độc lập
-   **Dễ mở rộng**: thêm nguồn dữ liệu mới (ví dụ Local DB) mà không ảnh
    hưởng UI
-   **Đồng bộ** với backend qua `Endpoints` và `ApiClient`
