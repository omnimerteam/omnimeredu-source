# Kế hoạch Triển khai Hệ thống Microservices (OmniMer EDU)

Dựa trên kiến trúc hệ thống đã định nghĩa trong `docs/architecture/system_architecture/architecture.md`, dưới đây là kế hoạch triển khai chi tiết theo từng giai đoạn.

## Giai đoạn 1: Chuẩn bị Hạ tầng & Môi trường (Infrastructure & Setup)

**Mục tiêu:** Thiết lập môi trường phát triển và cấu hình cơ sở dữ liệu cơ bản.

1.  **Cấu trúc Dự án (Monorepo/Microservices):**

    - [x] Khởi tạo cấu trúc thư mục cho các services: `services/user-service` cho auth và các thông tin người dùng và thông tin trường học, `services/payment-attendance-service` cho các thông tin thanh toán và điểm danh,
    - [x] Thiết lập `shared-lib` (thư viện dùng chung) chứa:
      - Cấu hình Database (Sequelize, Mongoose/DynamoDB wrapper).
      - Các Utils, Constants, Types/Interfaces chung.
      - Middleware (Auth, Error Handling).

2.  **Database Setup:**

    - [x] **PostgreSQL (Write DB):**
      - Cài đặt PostgreSQL (Local/Docker).
      - Tạo Database: `omnimeredu_user_db`, `omnimeredu_payment_db`.
    - [x] **MongoDB (Read DB):**
      - Cài đặt MongoDB (Local/Docker).
      - Tạo Database: `omnimeredu_read_db`.
    - [x] **Redis (Cache):**
      - Cài đặt Redis.

3.  **Environment Configuration:**
    - [x] Thiết lập biến môi trường (`.env`) để chuyển đổi linh hoạt giữa MongoDB (VPS) và DynamoDB (AWS).
    - [x] Cấu hình Docker Compose để chạy toàn bộ hệ thống local.

## Giai đoạn 2: Phát triển Core & Shared Modules

**Mục tiêu:** Xây dựng nền tảng kỹ thuật và cơ chế đồng bộ CQRS.

1.  **Database Connectors:**

    - [x] **Sequelize Client:** Module kết nối Postgres, cấu hình migration, seeder.
    - [x] **NoSQL Client Factory:** Module Factory Pattern để trả về instance của MongoDB Client hoặc DynamoDB Client dựa trên config.

2.  **Cơ chế CQRS Sync (Synchronization Logic):**
    - [x] Xây dựng `SyncService`:
      - Input: Dữ liệu vừa ghi vào RDS.
      - Process: Transform dữ liệu sang định dạng NoSQL (Denormalization nếu cần).
      - Output: Ghi vào MongoDB/DynamoDB.
    - [x] Implement `Hooks` trong Sequelize (afterCreate, afterUpdate, afterDestroy) để tự động kích hoạt `SyncService`.

## Giai đoạn 3: Phát triển User Module

**Mục tiêu:** Quản lý thông tin người dùng, trường học, lớp học.

1.  **Authentication \u0026 Authorization:**

    - [x] Implement JWT-based authentication (thay thế Firebase Auth)
    - [x] Register user với bcryptjs password hashing
    - [x] Login với JWT token generation
    - [x] Refresh access token functionality
    - [x] Get authenticated user info (getAuth)
    - [x] Upload avatar to Amazon S3 với naming convention `avatar-{userId}`
    - [x] Auth utilities: hashPassword, comparePassword, generateToken, verifyToken
    - [x] S3 utilities: uploadAvatar, deleteAvatar

2.  **Write Side (PostgreSQL + Sequelize):**

    - [x] Define Models:
      - `Account`: Quản lý thông tin đăng ký, đăng nhập
      - `User` (Thông tin tài khoản, profile).
      - `School` (Thông tin trường).
      - `Grade` (Khối).
      - `Class` (Lớp học - quan hệ với Grade, School).
      - `MembershipRequest` (Yêu cầu tham gia trường/lớp).
    - [x] Implement Auth Use Cases: RegisterUserUseCase, LoginUseCase, RefreshAccessTokenUseCase, GetAuthUseCase
    - [x] Implement Auth Controller & Routes with transaction support
    - [x] Implement CRUD Services & Controllers for School, Grade, Class.
    - [x] Tích hợp `SyncService` vào các Models trên.

3.  **Read Side (MongoDB):**
    - [x] Define Enhanced Schema: `users_full` với denormalized data (join account, school, role-specific info)
    - [x] Implement UserReadRepository với các query methods
    - [x] Define Schemas (Collections): `schools`, `classes`, `grades`.
    - [x] Implement Read APIs:
      - API lấy danh sách học sinh theo lớp (tối ưu query từ Mongo).
      - API xem profile, lịch sử hoạt động.

## Giai đoạn 4: Phát triển Payment & Attendance Module

**Mục tiêu:** Quản lý điểm danh và thanh toán.

1.  **Write Side (PostgreSQL + Sequelize):**

    - [ ] Define Models:
      - `Attendance` (Dữ liệu điểm danh hàng ngày).
      - `Tuition` (Thông tin học phí).
      - `Payment` (Giao dịch thanh toán).
      - `Holiday` (Ngày nghỉ).
    - [ ] Implement Logic nghiệp vụ:
      - Điểm danh (Check-in/Check-out).
      - Tạo hóa đơn học phí.
      - Xử lý callback thanh toán.
    - [ ] Tích hợp `SyncService`.

2.  **Read Side (MongoDB):**
    - Đồng bộ: Dữ liệu từ Write DB sẽ được đồng bộ sang Read DB qua Events (sử dụng Message Broker như Kafka, RabbitMQ).
    - `ActivityLog` (Lịch sử hoạt động).
    - [ ] Define Schemas: `attendances`, `tuitions`, `payments`.
    - [ ] Implement Read APIs:
      - API báo cáo điểm danh tháng (Aggregate dữ liệu từ Mongo).
      - API lịch sử thanh toán.

## Giai đoạn 5: API Gateway & Auth Integration

**Mục tiêu:** Hợp nhất các services và bảo mật.

1.  **User Service:**

    - [ ] Đảm bảo Auth Service cấp phát JWT chuẩn.
    - [ ] Share Public Key hoặc Secret cho User/Payment modules để verify token.

2.  **API Gateway / Routing:**
    - [ ] Cấu hình Nginx hoặc Application Gateway để route request:
      - `/api/users/*` -> User Service.
      - `/api/payments/*`, `/api/attendance/*` -> Payment Service.

## Giai đoạn 6: Deployment & Testing

**Mục tiêu:** Đưa hệ thống lên môi trường Staging/Production.

1.  **Containerization:**

    - [ ] Viết `Dockerfile` cho từng service.
    - [ ] Tối ưu image size (Multi-stage build).

2.  **CI/CD & AWS/VPS Setup:**

    - [ ] **VPS Case:** Setup Script deploy MongoDB, Postgres, Redis và Docker Compose app.
    - [ ] **AWS Case:**
      - Setup RDS (Postgres).
      - Setup DynamoDB (hoặc DocumentDB).
      - Push images lên ECR.
      - Deploy Fargate.

3.  **Testing:**
    - [ ] Unit Test cho Logic tính toán (Payment).
    - [ ] Integration Test cho luồng CQRS (Ghi RDS -> Check Mongo).
    - [ ] Load Test để kiểm chứng hiệu năng Read từ Mongo.
