# 📘 OmniMer EDU - Frontend Architecture

## 1. Giới thiệu

Đây là phần frontend của dự án **OmniMer EDU**, được xây dựng bằng
**Flutter** theo kiến trúc **Clean Architecture + Bloc Pattern**. Mục
tiêu là đảm bảo: - Code dễ bảo trì, dễ mở rộng - Tách biệt rõ ràng các
tầng - Hỗ trợ đa nền tảng (Android, iOS, Web, Desktop)

---

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
     ├── service/
     │    ├── firebase_storage_uploader.dart
     │
     ├── presentation/             # UI + State Management
     │    ├── screens/             # Màn hình (UI)
     │    │     ├── auth/          # chia theo module
     │    │     │   ├── login/     # Chức năng
     │    │     │         ├── bloc/      # Bloc của chức năng
     │    │     │         ├── widgets/   # Widget riêng của chức năng
     │    │     │         └── login_screen.dart   # Screen chính của ứng dụng
     │    │     ├── app_view.dart
     │    │     └── app.dart
     │    │
     │    └── widgets/             # Thành phần tái sử dụng chung
     │
     ├── injection_container.dart
     │
     └── main.dart                 # Điểm khởi chạy ứng dụng

---

## 3. Workflow xử lý dữ liệu

1.  **UI (presentation/screens)** gửi event đến **Bloc**
2.  **Bloc** gọi **UseCase (domain/usecases)**
3.  **UseCase** gọi **Repository (domain/repositories)**
4.  **Repository** triển khai trong `data/repositories`, gọi đến
    **Datasource**
5.  **Datasource (remote)** gọi API qua `ApiClient (Dio)`
6.  Kết quả trả về theo chiều ngược lại: API → Datasource → Repository →
    UseCase → Bloc → UI

---

## 4. Quy trình Authentication (Ví dụ)

- Người dùng nhập tài khoản → **UI**
- Bloc bắn event `LoginRequested`
- UseCase `LoginUser` gọi `AuthRepository`
- `AuthRepositoryImpl` dùng `AuthRemoteDataSource` để gọi
  `auth_api.dart`
- `ApiClient` gửi request tới Backend Node.js
- Trả về `UserModel` → convert sang `UserEntity`
- Bloc emit state `Authenticated(user)`
- UI hiển thị màn hình Home

---

## 5. Ưu điểm của kiến trúc này

- **Tách biệt rõ ràng** giữa UI, Logic và Data
- **Dễ test** từng phần độc lập
- **Dễ mở rộng**: thêm nguồn dữ liệu mới (ví dụ Local DB) mà không ảnh
  hưởng UI
- **Đồng bộ** với backend qua `Endpoints` và `ApiClient`

---

## 6. Giải thích kiến trúc

### Data Models (data/models)

**Định nghĩa theo cách dữ liệu được lưu trữ hoặc nhận từ API.**

- Thường dùng để parse JSON, gửi request/response.
- Có thể chứa các helper như fromJson, toJson, copyWith.
- Liên quan trực tiếp tới data source (API, DB).

  => Dùng khi gọi API → parse JSON về model.

### Domain Entities (domain/entities)

**Là lõi của business logic, không quan tâm API hay DB.**

- Được dùng trong use case, business logic, state management.
- Chỉ chứa thuộc tính thuần túy (không có fromJson, toJson).
- Giúp code tách biệt data layer và domain layer, dễ test.

  => Dùng trong Bloc, Provider, UseCase → không lo về API hoặc DB.

1️⃣ Bước 1: Xác định dữ liệu và API

Xem API trả về gì (JSON response).

Xem app cần dùng gì trong business logic.

Ví dụ: API /roles trả về:

{
"\_id": "r01",
"name": "Admin",
"description": "Quản trị hệ thống"
}

Data layer: cần \_id, name, description.

Domain layer: chỉ cần id, name, description.

2️⃣ Bước 2: Viết Entity (Domain Layer)

Entity là business object, immutable.

Dùng trong Bloc, UseCase, UI.

Không cần JSON, không cần DB code.

class RoleEntity {
final String id;
final String name;
final String description;

const RoleEntity({
required this.id,
required this.name,
required this.description,
});
}

✅ Khi viết: ngay khi biết app cần loại dữ liệu này để xử lý logic.

3️⃣ Bước 3: Viết Model (Data Layer)

Model đại diện cấu trúc JSON từ API hoặc DB.

Có fromJson() / toJson().

Có thể kế thừa Entity để tiện mapping.

class RoleModel extends RoleEntity {
const RoleModel({required super.id, required super.name, required super.description});

factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
id: json['_id'] ?? '',
name: json['name'] ?? '',
description: json['description'] ?? '',
);

Map<String, dynamic> toJson() => {
'\_id': id,
'name': name,
'description': description,
};

RoleEntity toEntity() => RoleEntity(id: id, name: name, description: description);
}

✅ Khi viết: khi cần parse JSON từ API hoặc lưu vào DB.

4️⃣ Bước 4: Mapping Model → Entity

Khi nhận data từ API, parse JSON → Model → Entity.

Entity dùng cho business logic / Bloc / UI.

final json = {...};
final roleEntity = RoleModel.fromJson(json).toEntity();

5️⃣ Bước 5: Dùng Entity trong Bloc / UseCase

Entity là dữ liệu “clean”, immutable, không phụ thuộc API hay DB.

Bloc, Provider, State, UseCase chỉ làm việc với Entity.

6️⃣ Bước 6: Khi gửi dữ liệu lên API

Entity → Model → JSON → gửi API.

Không gửi Entity trực tiếp, vì entity không biết JSON structure.
