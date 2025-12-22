# Kiến trúc User Service

## 1. Tổng quan

**User Service** là microservice chịu trách nhiệm quản lý thông tin người dùng, cơ cấu tổ chức trường học (Trường, Khối, Lớp) và các yêu cầu tham gia. Dịch vụ này đóng vai trò trung tâm trong việc cung cấp dữ liệu định danh và tổ chức cho toàn bộ hệ thống OmniMer EDU.

Hệ thống tuân theo **Clean Architecture** và áp dụng pattern **CQRS** (Command Query Responsibility Segregation) để tách biệt luồng Ghi (Write) và luồng Đọc (Read), đảm bảo hiệu năng và khả năng mở rộng.

## 2. Tech Stack

- **Runtime**: Node.js
- **Ngôn ngữ**: TypeScript
- **Framework**: NestJS (khuyên dùng) hoặc Express.js
- **Write Database**: PostgreSQL (AWS RDS) + Sequelize ORM
- **Read Database**: MongoDB (VPS) hoặc DynamoDB (AWS)
- **Message Queue**: RabbitMQ / Kafka / AWS SNS+SQS (để đồng bộ dữ liệu CQRS)
- **Caching**: Redis

## 3. Cấu trúc dự án (Clean Architecture)

Dự án được tổ chức phân tầng rõ ràng:

```
src/
├── domain/                 # Enterprise Business Rules (Độc lập với Framework)
│   ├── entities/           # Các đối tượng nghiệp vụ cốt lõi
│   │   ├── User.ts
│   │   ├── School.ts
│   │   ├── Grade.ts
│   │   ├── Class.ts
│   │   └── MembershipRequest.ts
│   ├── repositories/       # Interfaces cho Repository (Write & Read)
│   │   ├── IUserRepository.ts
│   │   ├── ISchoolRepository.ts
│   │   └── IClassRepository.ts
│   └── usecases/           # Application Business Rules
│       ├── user/
│       │   ├── CreateUserUseCase.ts
│       │   └── GetUserProfileUseCase.ts
│       ├── school/
│       │   ├── RegisterSchoolUseCase.ts
│       │   └── GetSchoolDetailsUseCase.ts
│       └── class/
│           ├── CreateClassUseCase.ts
│           └── GetClassStudentsUseCase.ts
├── data/                   # Interface Adapters (Triển khai logic truy cập dữ liệu)
│   ├── datasources/        # Kết nối DB cụ thể
│   │   ├── postgres/       # Sequelize Models (Write Side)
│   │   │   ├── UserModel.ts
│   │   │   └── SchoolModel.ts
│   │   └── mongodb/        # Mongoose Schemas (Read Side)
│   │       ├── UserReadSchema.ts
│   │       └── SchoolReadSchema.ts
│   ├── repositories/       # Triển khai Interfaces từ Domain
│   │   ├── UserRepositoryImpl.ts
│   │   └── SchoolRepositoryImpl.ts
│   └── messaging/          # Xử lý Event Sync
│       ├── EventPublisher.ts   # Gửi event khi Write thành công
│       └── EventConsumer.ts    # (Optional) Nhận event từ service khác
├── presentation/           # Interface Adapters (Lớp giao diện)
│   ├── controllers/        # Xử lý HTTP Request
│   │   ├── UserController.ts
│   │   └── SchoolController.ts
│   ├── dtos/               # Data Transfer Objects
│   │   ├── CreateUserDto.ts
│   │   └── CreateSchoolDto.ts
│   └── consumers/          # Xử lý message từ Queue (nếu cần)
└── infrastructure/         # Frameworks & Drivers
    ├── database/           # Config kết nối Postgres, Mongo
    ├── server.ts           # Entry point
    └── di/                 # Dependency Injection setup
```

## 4. Thiết kế chi tiết thành phần

### 4.1. Lớp Domain (Domain Layer)

**Entities**:

- `User`: Thông tin tài khoản, profile, role (Admin, SchoolAdmin, Teacher, Student, Parent).
- `School`: Thông tin trường học.
- `Grade`: Khối học.
- `Class`: Lớp học (thuộc Grade và School).
- `MembershipRequest`: Yêu cầu tham gia vào trường/lớp.

**Use Cases**:

- Chứa logic nghiệp vụ thuần túy.
- Ví dụ: `CreateClassUseCase` sẽ kiểm tra quyền của user, kiểm tra sự tồn tại của School/Grade trước khi tạo.

### 4.2. Lớp Dữ liệu (Data Layer) & CQRS

**Write Side (PostgreSQL)**:

- Sử dụng **Sequelize** để tương tác với PostgreSQL.
- Đảm bảo tính nhất quán (ACID) cho các thao tác thêm/sửa/xóa.
- **Sync Logic**: Sau khi ghi thành công vào Postgres, `EventPublisher` sẽ gửi event (ví dụ: `UserCreated`, `ClassUpdated`) vào Message Queue.

**Read Side (MongoDB)**:

- Dữ liệu được denormalize (phi chuẩn hóa) để tối ưu cho việc đọc.
- Ví dụ: Document `Class` trong MongoDB có thể chứa luôn thông tin tóm tắt của `School` và danh sách `Student` để không cần join khi query.
- Các Use Case đọc (`Get...`) sẽ gọi Repository đọc dữ liệu từ MongoDB.

### 4.3. Lớp Giao diện (Presentation Layer)

- **Controllers**: Nhận request từ Client/Gateway, validate DTO, gọi Use Case tương ứng.
- **API Response**: Trả về dữ liệu JSON chuẩn hóa.

## 5. Luồng dữ liệu (Data Flow)

### Luồng Ghi (Command)

1. **Client** gọi API `POST /users`.
2. **Controller** nhận request, validate dữ liệu.
3. **Use Case** `CreateUserUseCase` thực thi logic nghiệp vụ.
4. **Repository** `UserRepositoryImpl` lưu User vào **PostgreSQL**.
5. **EventPublisher** bắn event `UserCreated` sang Message Queue.
6. **Sync Worker** (có thể nằm trong service này hoặc service worker riêng) nhận event và cập nhật dữ liệu sang **MongoDB**.

### Luồng Đọc (Query)

1. **Client** gọi API `GET /users/:id`.
2. **Controller** nhận request.
3. **Use Case** `GetUserProfileUseCase` được gọi.
4. **Repository** `UserRepositoryImpl` truy vấn dữ liệu từ **MongoDB** (hoặc Cache Redis).
5. **Response** trả về cho Client.
