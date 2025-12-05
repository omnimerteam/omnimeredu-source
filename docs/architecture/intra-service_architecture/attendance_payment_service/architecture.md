# Kiến trúc Payment & Attendance Service

## 1. Tổng quan

**Payment & Attendance Service** là microservice chịu trách nhiệm quản lý các hoạt động tài chính (học phí, thanh toán) và điểm danh của học sinh/giáo viên.

Hệ thống tuân theo **Clean Architecture** và áp dụng pattern **CQRS** (Command Query Responsibility Segregation) để tách biệt luồng Ghi (Write) và luồng Đọc (Read).

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
├── domain/                 # Enterprise Business Rules
│   ├── entities/           # Các đối tượng nghiệp vụ cốt lõi
│   │   ├── Attendance.ts
│   │   ├── Tuition.ts
│   │   ├── Payment.ts
│   │   └── Holiday.ts
│   ├── repositories/       # Interfaces cho Repository
│   │   ├── IAttendanceRepository.ts
│   │   ├── ITuitionRepository.ts
│   │   └── IPaymentRepository.ts
│   └── usecases/           # Application Business Rules
│       ├── attendance/
│       │   ├── CheckInUseCase.ts
│       │   └── GetMonthlyAttendanceUseCase.ts
│       ├── payment/
│       │   ├── CreateTuitionFeeUseCase.ts
│       │   └── ProcessPaymentCallbackUseCase.ts
│       └── holiday/
│           └── CreateHolidayUseCase.ts
├── data/                   # Interface Adapters
│   ├── datasources/        # Kết nối DB cụ thể
│   │   ├── postgres/       # Sequelize Models (Write Side)
│   │   │   ├── AttendanceModel.ts
│   │   │   └── PaymentModel.ts
│   │   └── mongodb/        # Mongoose Schemas (Read Side)
│   │       ├── AttendanceReadSchema.ts
│   │       └── PaymentReadSchema.ts
│   ├── repositories/       # Triển khai Interfaces từ Domain
│   │   ├── AttendanceRepositoryImpl.ts
│   │   └── PaymentRepositoryImpl.ts
│   └── messaging/          # Xử lý Event Sync
│       ├── EventPublisher.ts   # Gửi event khi Write thành công
│       └── EventConsumer.ts    # (Optional)
├── presentation/           # Interface Adapters (Lớp giao diện)
│   ├── controllers/        # Xử lý HTTP Request
│   │   ├── AttendanceController.ts
│   │   └── PaymentController.ts
│   ├── dtos/               # Data Transfer Objects
│   │   ├── CheckInDto.ts
│   │   └── CreatePaymentDto.ts
│   └── consumers/          # Xử lý message từ Queue (nếu cần)
└── infrastructure/         # Frameworks & Drivers
    ├── database/           # Config kết nối Postgres, Mongo
    ├── server.ts           # Entry point
    └── di/                 # Dependency Injection setup
```

## 4. Thiết kế chi tiết thành phần

### 4.1. Lớp Domain (Domain Layer)

**Entities**:

- `Attendance`: Dữ liệu điểm danh (User, Class, Date, Status, CheckInTime, CheckOutTime).
- `Tuition`: Thông tin học phí cần đóng.
- `Payment`: Giao dịch thanh toán (Amount, Method, Status, TransactionId).
- `Holiday`: Ngày nghỉ lễ (ảnh hưởng đến lịch điểm danh).

**Use Cases**:

- `CheckInUseCase`: Xử lý logic điểm danh, kiểm tra ngày nghỉ, kiểm tra trùng lặp.
- `ProcessPaymentCallbackUseCase`: Xử lý callback từ cổng thanh toán (MoMo, ZaloPay), cập nhật trạng thái Tuition.

### 4.2. Lớp Dữ liệu (Data Layer) & CQRS

**Write Side (PostgreSQL)**:

- Sử dụng **Sequelize** để quản lý dữ liệu giao dịch.
- **Sync Logic**: Khi có bản ghi mới (ví dụ: `Attendance` mới, `Payment` thành công), `EventPublisher` gửi event sang Message Queue.

**Read Side (MongoDB)**:

- Lưu trữ dữ liệu phục vụ báo cáo và tra cứu nhanh.
- Ví dụ: Collection `MonthlyAttendanceReports` có thể được aggregate sẵn từ các bản ghi điểm danh lẻ để API lấy báo cáo tháng chạy cực nhanh.

### 4.3. Lớp Giao diện (Presentation Layer)

- **Controllers**: Expose API cho Mobile App và Admin Web.

## 5. Luồng dữ liệu (Data Flow)

### Luồng Ghi (Command) - Ví dụ: Thanh toán

1. **Client** (Mobile App) gọi API `POST /payments`.
2. **Controller** nhận request.
3. **Use Case** `CreatePaymentUseCase` tạo giao dịch pending.
4. **Repository** lưu vào **PostgreSQL**.
5. **EventPublisher** gửi event `PaymentCreated`.
6. Sau khi User thanh toán xong, Webhook từ cổng thanh toán gọi lại API.
7. **Use Case** `ProcessPaymentCallbackUseCase` cập nhật trạng thái thành `Success` trong **PostgreSQL**.
8. **EventPublisher** gửi event `PaymentSuccess`.
9. **Sync Worker** cập nhật trạng thái vào **MongoDB**.

### Luồng Đọc (Query) - Ví dụ: Xem lịch sử điểm danh

1. **Client** gọi API `GET /attendance/history`.
2. **Controller** nhận request.
3. **Use Case** `GetAttendanceHistoryUseCase` được gọi.
4. **Repository** truy vấn từ **MongoDB**.
5. **Response** trả về danh sách điểm danh.
