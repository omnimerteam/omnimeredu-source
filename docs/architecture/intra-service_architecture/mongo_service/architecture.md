# Kiến trúc Dịch vụ Module Mongo (Dịch vụ Đọc)

## 1. Tổng quan

Dịch vụ Module Mongo được thiết kế cho các hoạt động **Đọc hiệu năng cao (High Performance Read)**. Nó tuân theo mẫu CQRS (phía Đọc), phục vụ dữ liệu được tối ưu hóa cho hiệu suất truy vấn, thường là dữ liệu phi chuẩn hóa.

## 2. Tech Stack

- **Runtime**: Node.js
- **Ngôn ngữ**: TypeScript
- **Cơ sở dữ liệu**: MongoDB (NoSQL)
- **ODM**: Mongoose
- **Caching**: Redis (tùy chọn, cho dữ liệu nóng)

## 3. Cấu trúc dự án

Tuân theo Clean Architecture, tối ưu hóa cho việc đọc:

```
src/
├── domain/
│   ├── entities/           # Read Models (Views)
│   │   ├── StudentProfileView.ts
│   │   └── ClassScheduleView.ts
│   ├── repositories/
│   │   └── IReadRepository.ts
│   └── usecases/
│       ├── GetStudentProfileUseCase.ts
│       └── GetClassListUseCase.ts
├── data/
│   ├── datasources/
│   │   └── mongo/          # Mongoose Schemas
│   │       └── StudentSchema.ts
│   ├── repositories/
│   │   └── MongoReadRepository.ts
│   └── consumers/          # Event Consumers cho Sync
│       └── DataSyncConsumer.ts
├── presentation/
│   ├── controllers/
│   │   └── ReadController.ts
│   └── graphql/            # Tùy chọn: GraphQL Resolvers
│       └── resolvers.ts
└── infrastructure/
    └── database/
        └── mongo-connection.ts
```

## 4. Thiết kế chi tiết thành phần

### 4.1. Lớp Domain (Domain Layer)

**Read Models**:

- Cấu trúc dữ liệu được thiết kế để khớp với yêu cầu UI (View Models).
- Ví dụ: `StudentProfileView` có thể chứa thông tin Lớp học lồng nhau và tóm tắt Điểm danh, tránh việc join phức tạp khi chạy.

### 4.2. Lớp Dữ liệu (Data Layer)

**Đồng bộ hóa dữ liệu**:

- `DataSyncConsumer`: Lắng nghe các sự kiện (ví dụ: `StudentCreated`, `PaymentCompleted`) từ Dịch vụ RDS.
- Cập nhật các document trong MongoDB để phản ánh trạng thái mới nhất.
- **Tính Idempotency**: Đảm bảo rằng việc xử lý cùng một sự kiện nhiều lần không làm hỏng dữ liệu.

### 4.3. Lớp Giao diện (Presentation Layer)

- **Controllers**: Xử lý các request `GET`.
- **Tối ưu hóa**: Có thể triển khai caching headers, phân trang, và lọc được ánh xạ trực tiếp vào các truy vấn MongoDB.

## 5. Luồng dữ liệu (Luồng Đọc)

1. **Request**: `GET /students/:id/profile`.
2. **Controller**: `ReadController` nhận request.
3. **Use Case**: `GetStudentProfileUseCase` thực thi.
4. **Repository**: Truy vấn MongoDB (tra cứu nhanh, các trường đã đánh index).
5. **Response**: Trả về dữ liệu JSON cho Client.

## 6. Luồng dữ liệu (Luồng Đồng bộ)

1. **Event**: Nhận sự kiện `StudentUpdated` từ Message Queue.
2. **Consumer**: `DataSyncConsumer` phân tích payload.
3. **Action**: Cập nhật document tương ứng trong MongoDB.
