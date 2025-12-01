# Kiến trúc Dịch vụ Module RDS (Ghi & Logic Cốt lõi)

## 1. Tổng quan

Dịch vụ Module RDS là thành phần **Ghi nhiều (Write-heavy)** của hệ thống. Nó xử lý tất cả các hoạt động thay đổi trạng thái, thực thi các quy tắc nghiệp vụ và đảm bảo tính nhất quán của dữ liệu (ACID). Nó đóng vai trò là "Nguồn sự thật" (Source of Truth).

## 2. Tech Stack

- **Runtime**: Node.js
- **Ngôn ngữ**: TypeScript
- **Cơ sở dữ liệu**: PostgreSQL / MySQL (AWS RDS)
- **ORM**: TypeORM hoặc Prisma
- **Message Queue**: RabbitMQ / Kafka / AWS SNS+SQS (để đồng bộ sang Mongo)

## 3. Cấu trúc dự án

Tuân theo Clean Architecture:

```
src/
├── domain/
│   ├── entities/
│   │   ├── Student.ts
│   │   ├── Class.ts
│   │   ├── Payment.ts
│   │   └── Attendance.ts
│   ├── repositories/
│   │   ├── IStudentRepository.ts
│   │   ├── IPaymentRepository.ts
│   │   └── IAttendanceRepository.ts
│   ├── services/           # Domain Services (logic chéo giữa các entity)
│   │   └── PaymentProcessor.ts
│   └── usecases/
│       ├── student/
│       │   └── CreateStudentUseCase.ts
│       ├── payment/
│       │   └── ProcessPaymentUseCase.ts
│       └── attendance/
│           └── MarkAttendanceUseCase.ts
├── data/
│   ├── datasources/
│   │   └── postgres/       # SQL Models
│   ├── repositories/
│   │   ├── StudentRepositoryImpl.ts
│   │   └── PaymentRepositoryImpl.ts
│   └── messaging/          # Để publish sự kiện
│       └── EventPublisher.ts
├── presentation/
│   ├── controllers/
│   │   ├── StudentController.ts
│   │   └── PaymentController.ts
│   └── consumers/          # Nếu có consume sự kiện (tùy chọn)
└── infrastructure/
    ├── database/           # Kết nối DB
    └── di/                 # Dependency Injection container
```

## 4. Thiết kế chi tiết thành phần

### 4.1. Lớp Domain (Domain Layer)

**Các tính năng cốt lõi**:

- **Thanh toán**: Xử lý tạo QR, xử lý callback từ cổng thanh toán (MoMo, ZaloPay).
- **Điểm danh**: Xác thực mã QR để điểm danh học sinh.

**Cơ chế đồng bộ (Sync Mechanism)**:

- Sau khi thao tác Ghi thành công (ví dụ: `CreateStudent`), hệ thống phải phát ra một sự kiện (ví dụ: `StudentCreated`).
- Sự kiện này được publish vào Message Queue để **Module Mongo** tiêu thụ nhằm mục đích đồng bộ hóa.

### 4.2. Lớp Dữ liệu (Data Layer)

- **Repositories**: Thực hiện CRUD trên cơ sở dữ liệu SQL.
- **EventPublisher**: Trừu tượng hóa để gửi tin nhắn đến message broker.

### 4.3. Lớp Giao diện (Presentation Layer)

- **Controllers**: Xử lý các REST API request để tạo/cập nhật tài nguyên.

## 5. Luồng dữ liệu (Luồng Ghi)

1. **Request**: `POST /payments` (Xử lý thanh toán).
2. **Controller**: `PaymentController` validate đầu vào.
3. **Use Case**: `ProcessPaymentUseCase` thực thi logic nghiệp vụ (kiểm tra số dư, xác thực user).
4. **Repository**: Lưu giao dịch vào RDS (giao dịch ACID).
5. **Event**: Khi thành công, `EventPublisher` publish sự kiện `PaymentCompleted`.
6. **Response**: Trả về trạng thái thành công cho Client.
