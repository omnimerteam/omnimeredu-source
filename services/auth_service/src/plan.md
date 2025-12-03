# Kế hoạch Triển khai Auth Service (Clean Architecture + CQRS)

Tài liệu này mô tả kiến trúc và kế hoạch triển khai cho `Auth Service`, tuân thủ nghiêm ngặt **Clean Architecture** và mẫu **CQRS** (Command Query Responsibility Segregation) để tối ưu hóa hiệu năng và tính toàn vẹn dữ liệu.

## 1. Nguyên lý Kiến trúc

### 1.1. Clean Architecture

Hệ thống được chia thành các lớp đồng tâm, với quy tắc phụ thuộc hướng vào trong (Dependency Rule):

- **Domain Layer**: Chứa Entities và Business Logic cốt lõi. Không phụ thuộc vào bất kỳ lớp nào bên ngoài.
- **Use Case Layer**: Chứa các quy tắc nghiệp vụ ứng dụng (Application Business Rules).
- **Interface Adapters (Presentation/Data)**: Chuyển đổi dữ liệu giữa Use Cases và các tác nhân bên ngoài (Web, DB).
- **Infrastructure Layer**: Frameworks, Drivers (DB connection, Server, Redis).

### 1.2. CQRS (Command Query Responsibility Segregation)

Tách biệt luồng Ghi (Command) và luồng Đọc (Query):

- **Command Side (Write Model)**:

  - **Database**: **RDS Amazon (SQL)** (PostgreSQL).
  - **Vai trò**: Source of Truth, đảm bảo tính ACID, xử lý các nghiệp vụ thay đổi trạng thái (Register, Change Password, Update Info).
  - **Output**: Sau khi ghi thành công, phát ra **Domain Event** (ví dụ: `UserRegistered`, `ProfileUpdated`).

- **Query Side (Read Model)**:

  - **Database**: **MongoDB (NoSQL)**.
  - **Vai trò**: Phục vụ truy vấn dữ liệu nhanh (Get Profile, Search), dữ liệu được phi chuẩn hóa (denormalized).
  - **Cơ chế đồng bộ**: Worker/Listener lắng nghe Domain Event từ Command Side và cập nhật MongoDB (Eventual Consistency).

- **Caching & Session Layer (New)**:
  - **Database**: **Redis**.
  - **Vai trò**: Lưu trữ Token Blacklist (cho Logout), Cache User Profile nóng, Rate Limiting. Giúp giảm tải cho DB và tăng tốc độ xác thực (Validate Token).

## 2. Cấu trúc Thư mục (Project Structure)

```text
services/auth_service/src/
├── domain/                         # Lớp Nghiệp vụ Cốt lõi (Enterprise Business Rules)
│   ├── entities/                   # Các đối tượng nghiệp vụ (User, Account, Token)
│   ├── events/                     # Định nghĩa Domain Events (UserCreatedEvent, etc.)
│   └── repositories/               # Interfaces cho Repository (tách biệt Command/Query)
│       ├── IAuthCommandRepository.ts
│       ├── IAuthQueryRepository.ts
│       └── ICacheRepository.ts     # Interface cho Redis
│
├── application/                    # Lớp Ứng dụng (Application Business Rules)
│   ├── use_cases/                  # Các Use Cases cụ thể
│   │   ├── command/                # Xử lý Ghi (Write)
│   │   │   ├── RegisterUserUseCase.ts
│   │   │   ├── LoginUseCase.ts     # Login đọc SQL để đảm bảo nhất quán (Strong Consistency)
│   │   │   ├── LogoutUseCase.ts    # Ghi token vào Redis Blacklist
│   │   │   ├── ChangePasswordUseCase.ts
│   │   │   └── UpdateProfileUseCase.ts
│   │   └── query/                  # Xử lý Đọc (Read)
│   │       ├── GetUserProfileUseCase.ts
│   │       └── ValidateTokenUseCase.ts # Check Redis & JWT Signature
│   ├── dtos/                       # Data Transfer Objects (Input/Output cho Use Case)
│   └── interfaces/                 # Interfaces cho Services (Messaging, TokenProvider)
│
├── infrastructure/                 # Lớp Hạ tầng (Frameworks & Drivers)
│   ├── database/
│   │   ├── sql/                    # Kết nối RDS Amazon (ORM: Sequelize, DB: Postgres SQL)
│   │   │   ├── models/             # SQL Models/Entities
│   │   │   └── repositories/       # Impl IAuthCommandRepository
│   │   ├── nosql/                  # Kết nối MongoDB (ORM: Mongoose)
│   │   │   ├── schemas/            # Mongoose Schemas (Read Models)
│   │   │   └── repositories/       # Impl IAuthQueryRepository
│   │   └── cache/                  # Kết nối Redis
│   │       └── repositories/       # Impl ICacheRepository
│   ├── messaging/                  # Message Queue (RabbitMQ/Kafka)
│   │   ├── publisher/              # Gửi Event đi
│   │   └── consumer/               # Worker nhận Event để sync sang Mongo
│   ├── security/                   # JWT, Hashing (Bcrypt)
│   └── server.ts                   # Entry point
│
├── presentation/                   # Lớp Giao diện (Interface Adapters)
│   ├── controllers/                # HTTP Controllers
│   │   ├── AuthCommandController.ts
│   │   └── AuthQueryController.ts
│   └── routes/                     # API Routes
│
└── common/                         # Utilities, Constants, Helpers
```

## 3. Chi tiết Luồng Dữ liệu (Data Flow)

### 3.1. Luồng Ghi (Command Flow) - Ví dụ: Đăng ký (Register)

1.  **Client** gửi `POST /register`.
2.  **AuthCommandController** nhận request, validate DTO.
3.  **RegisterUserUseCase** thực thi:
    - Kiểm tra logic nghiệp vụ (Email trùng? - Check SQL).
    - Hash password.
    - Gọi `IAuthCommandRepository.createAccount()` lưu vào **RDS Amazon**.
4.  Sau khi lưu thành công, Use Case gọi `MessagePublisher` gửi event `UserRegisteredEvent`.
5.  **Event Bus** (RabbitMQ/Kafka) nhận message.

### 3.2. Luồng Đăng nhập (Login Flow) - Hybrid

1.  **Client** gửi `POST /login`.
2.  **LoginUseCase** thực thi:
    - Gọi `IAuthCommandRepository.findByEmail()` (đọc từ **SQL** để đảm bảo user vừa tạo có thể login ngay).
    - Verify Password.
    - Generate JWT (Access Token & Refresh Token).
    - (Optional) Lưu Refresh Token vào Redis/SQL để quản lý session.
3.  Trả về Token cho Client.

### 3.3. Cơ chế Đồng bộ (Synchronization)

1.  Một **Worker Service** lắng nghe `UserRegisteredEvent` hoặc `ProfileUpdatedEvent`.
2.  Worker nhận data, transform thành cấu trúc Read Model (UserReadModel).
3.  Worker gọi `IAuthQueryRepository.saveUserProfile()` lưu vào **MongoDB**.
    - _Lưu ý_: Có độ trễ nhỏ (Eventual Consistency). API Command nên trả về data mới nhất để Client hiển thị ngay, tránh gọi Query API ngay lập tức.

### 3.4. Luồng Đọc (Query Flow) - Ví dụ: Xem Profile

1.  **Client** gửi `GET /me`.
2.  **GetUserProfileUseCase** thực thi:
    - (Option 1 - Fast): Check Cache **Redis** trước.
    - (Option 2 - Fallback): Gọi `IAuthQueryRepository.findById()` đọc từ **MongoDB**.
3.  Trả về dữ liệu JSON.

## 4. Công nghệ Đề xuất

- **Core**: Node.js, TypeScript.
- **SQL ORM (Command)**: `Sequelize` (kết nối PostgreSQL).
- **NoSQL ODM (Query)**: `Mongoose` (kết nối MongoDB).
- **Cache**: `Redis` (quản lý session, blacklist, cache).
- **Message Queue**: `RabbitMQ` (nhẹ, phổ biến) hoặc `Kafka` (high throughput).
- **Validation**: `class-validator` & `class-transformer`.

## 5. Lộ trình Triển khai (Roadmap)

### Phase 1: Setup Core & Infrastructure

- Khởi tạo cấu trúc thư mục Clean Architecture.
- Cấu hình kết nối PostgreSQL, MongoDB, Redis.
- Cấu hình Message Queue (RabbitMQ).

### Phase 2: Implement Command Side (Write) & Auth Core

- Tạo SQL Entities.
- Implement `RegisterUseCase`, `LoginUseCase` (SQL based).
- Setup JWT & Redis (Token Management).

### Phase 3: Implement Sync Mechanism

- Setup `EventPublisher`.
- Viết `SyncWorker` để consume event và ghi vào MongoDB.

### Phase 4: Implement Query Side (Read)

- Tạo Mongoose Schemas.
- Implement `GetUserProfileUseCase` (kết hợp Redis + Mongo).

### Phase 5: Testing & Optimization

- Unit Test, Integration Test.
- Load Test.
