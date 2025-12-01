# Kiến trúc Dịch vụ Module Xác thực (Auth)

## 1. Tổng quan

Dịch vụ Module Xác thực chịu trách nhiệm quản lý danh tính người dùng, xác thực và ủy quyền. Nó tuân theo các nguyên tắc **Clean Architecture** để đảm bảo sự tách biệt các mối quan tâm, khả năng kiểm thử và khả năng bảo trì.

## 2. Tech Stack

- **Runtime**: Node.js
- **Ngôn ngữ**: TypeScript
- **Framework**: Express.js (khuyên dùng) hoặc NestJS
- **Cơ sở dữ liệu**: RDS (cho thông tin đăng nhập User) / Redis (cho quản lý Token)
- **Xác thực**: JWT (JSON Web Tokens)

## 3. Cấu trúc dự án

Dự án được tổ chức thành các lớp:

```
src/
├── domain/                 # Quy tắc nghiệp vụ doanh nghiệp (Enterprise Business Rules)
│   ├── entities/           # Các đối tượng nghiệp vụ cốt lõi
│   │   ├── User.ts
│   │   └── Token.ts
│   ├── repositories/       # Các Interface cho repository
│   │   └── IAuthRepository.ts
│   └── usecases/           # Quy tắc nghiệp vụ ứng dụng (Application Business Rules)
│       ├── LoginUseCase.ts
│       ├── RegisterUseCase.ts
│       └── ValidateTokenUseCase.ts
├── data/                   # Bộ điều hợp giao diện (Lớp dữ liệu)
│   ├── datasources/        # Kết nối cơ sở dữ liệu & Models
│   │   ├── UserSchema.ts   # ORM Model
│   │   └── RedisClient.ts
│   └── repositories/       # Triển khai các repository của domain
│       └── AuthRepositoryImpl.ts
├── presentation/           # Bộ điều hợp giao diện (Lớp Web)
│   ├── controllers/        # Xử lý request
│   │   └── AuthController.ts
│   ├── routes/             # Định nghĩa route
│   │   └── auth.routes.ts
│   └── dtos/               # Các đối tượng chuyển giao dữ liệu (Data Transfer Objects)
│       ├── LoginRequestDto.ts
│       └── RegisterRequestDto.ts
└── infrastructure/         # Frameworks & Drivers
    ├── config/             # Biến môi trường
    ├── database/           # Thiết lập kết nối DB
    └── server.ts           # Điểm khởi chạy ứng dụng
```

## 4. Thiết kế chi tiết thành phần

### 4.1. Lớp Domain (Domain Layer)

**Entities**:

- `User`: Đại diện cho một người dùng trong hệ thống (id, username, passwordHash, role).
- `Token`: Đại diện cho một access/refresh token.

**Use Cases**:

- `LoginUseCase`: Xác thực thông tin đăng nhập, tạo JWT.
- `RegisterUseCase`: Tạo người dùng mới, băm mật khẩu.
- `ValidateTokenUseCase`: Xác minh chữ ký và thời hạn của JWT.

### 4.2. Lớp Dữ liệu (Data Layer)

**Repositories**:

- `AuthRepositoryImpl`: Triển khai `IAuthRepository`. Tương tác với cơ sở dữ liệu (RDS) để tìm người dùng và Redis để lưu/kiểm tra các token bị thu hồi.

### 4.3. Lớp Giao diện (Presentation Layer)

**Controllers**:

- `AuthController`: Xử lý các HTTP request, phân tích DTO, gọi Use Cases, và trả về HTTP response.

## 5. Luồng dữ liệu (Data Flow)

1. **Request**: Client gửi `POST /login` với thông tin đăng nhập.
2. **Controller**: `AuthController` nhận request, validate DTO.
3. **Use Case**: Gọi `LoginUseCase.execute(credentials)`.
4. **Repository**: `AuthRepositoryImpl` lấy thông tin user từ DB.
5. **Logic**: `LoginUseCase` xác minh mật khẩu, tạo JWT.
6. **Response**: Trả về Token cho Client.
