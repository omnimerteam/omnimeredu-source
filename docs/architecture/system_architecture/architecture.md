# ARCHITECTURE.md - OmniMer EDU

## 1. Tổng quan Kiến trúc (Overview)

Hệ thống được xây dựng theo kiến trúc **Microservices**, tối ưu hóa cho khả năng mở rộng, hiệu năng đọc/ghi và tính toàn vẹn dữ liệu.

![Design Architecture](./assets/aws_design_architecture.png)

### Nguyên lý hoạt động chính:

- **CQRS (Command Query Responsibility Segregation) pattern (biến thể):** Tách biệt luồng Ghi (Write) và luồng Đọc (Read).
- **RDS Module** đóng vai trò là "Source of Truth" và Gatekeeper, đảm bảo tính ACID cho các giao dịch quan trọng.
- **Mongo Module** đóng vai trò là Read Model, tối ưu cho tốc độ truy xuất dữ liệu của người dùng cuối.
- **Redis** được sử dụng để Caching, tăng tốc độ phản hồi.

---

## 2. Tech Stack

### Frontend

- **Mobile App (User):**
  - **Framework:** Flutter (Dart).
  - **Platform:** iOS, Android.
  - **Mục tiêu:** Giao diện chính cho người dùng cuối (Học sinh, Phụ huynh, Giáo viên).
- **Admin Web:**
  - **Framework:** Next.js (TypeScript).
  - **Mục tiêu:** Giao diện quản trị hệ thống, quản lý dữ liệu.

### Backend

- **Ngôn ngữ:** Node.js.
- **Ngôn ngữ lập trình:** TypeScript.
- **Kiến trúc:** Microservices.

### Database & Caching

- **Primary Database (Write/Transactional):** RDS (SQL) - _Ví dụ: PostgreSQL hoặc MySQL_.
- **Secondary Database (Read/Analytics):** MongoDB (NoSQL).
- **Caching:** Redis.

### Infrastructure

- **Deployment:** AWS Fargate (Serverless Compute for Containers).

---

## 3. Chi tiết các Microservices

Backend được chia thành 3 service chính:

### 3.1. Auth Module Service

- **Chức năng:**
  - Đăng ký (Register).
  - Đăng nhập (Login).
  - Xác thực (Authentication & Authorization).
  - Quản lý Token (JWT/Session).

### 3.2. RDS Module Service (Write & Core Logic)

- **Vai trò:**
  - Là nơi tiếp nhận các yêu cầu **Ghi (Write)** dữ liệu.
  - Đóng vai trò "Người kiểm duyệt" (Gatekeeper/Moderator) dữ liệu đầu vào.
  - Đảm bảo tính **ACID** (Atomicity, Consistency, Isolation, Durability) cho dữ liệu.
- **Quy trình xử lý dữ liệu:**
  1. Nhận request ghi từ Client.
  2. Validate và xử lý logic nghiệp vụ.
  3. Ghi dữ liệu vào **RDS (SQL)**.
  4. Chuẩn hóa dữ liệu và đồng bộ sang **MongoDB** (để phục vụ việc đọc).
- **Tính năng cốt lõi (Core Features):**
  - **Payment (Thanh toán):**
    - Tích hợp QR Code.
    - Ví điện tử: MoMo, ZaloPay, ViettelPay.
  - **Attendance (Điểm danh):**
    - Xử lý logic điểm danh bằng QR Code.

### 3.3. Mongo Module Service (Read Service)

- **Vai trò:**
  - Tập trung xử lý các yêu cầu **Đọc (Read)** từ người dùng.
  - Tối ưu hóa tốc độ truy xuất dữ liệu (High Performance Read).
  - Phân phối dữ liệu nhanh nhất đến Client.
- **Nguồn dữ liệu:**
  - Đọc dữ liệu từ **MongoDB** (đã được đồng bộ và chuẩn hóa từ RDS Module).

---

## 4. Luồng dữ liệu (Data Flow)

### Luồng Ghi (Write Flow)

`Client` -> `RDS Module` -> `RDS (SQL)` -> _(Sync/Normalize)_ -> `MongoDB`

### Luồng Đọc (Read Flow)

`Client` -> `Mongo Module` -> `MongoDB` -> `Client`

---

## 5. Deployment Model

Toàn bộ các service sẽ được deploy trên môi trường **AWS**:

- **Container Orchestration:** AWS Fargate.
- **Database:** AWS RDS (cho SQL) và MongoDB Atlas (hoặc tự host trên EC2/Fargate nếu cần).
- **Cache:** AWS ElastiCache for Redis (hoặc Redis container).

---

## 6. Chi tiết Luồng Hạ tầng AWS (AWS Infrastructure Flow)

Dựa trên sơ đồ kiến trúc triển khai trên AWS, luồng di chuyển của request (Request Flow) được xử lý như sau:

### 1. Entry Point (Điểm truy cập)

- **Client (Mobile/Web):** Gửi request HTTPS đến hệ thống.
- **Application Load Balancer (ALB):**
  - Đóng vai trò là cổng vào duy nhất (Single Entry Point) cho các traffic từ Internet.
  - Thực hiện **SSL Termination** (giải mã HTTPS).
  - Điều hướng (Routing) request đến đúng Service đích (Auth, RDS, hoặc Mongo) dựa trên đường dẫn (path-based routing) hoặc subdomain.

### 2. Compute Layer (Lớp tính toán - AWS Fargate)

Các service chạy dưới dạng **Container** trên nền tảng **AWS Fargate** (Serverless), được đặt trong **Private Subnet** để đảm bảo bảo mật (không truy cập trực tiếp từ Internet):

- **Auth Service:** Xử lý xác thực, cấp phát Token.
- **RDS Service (Write):** Nhận request ghi, xử lý nghiệp vụ phức tạp, giao tiếp với Payment Gateway.
- **Mongo Service (Read):** Nhận request đọc, truy xuất dữ liệu nhanh.

### 3. Data Layer (Lớp dữ liệu)

- **Amazon RDS:** Nằm trong Private Subnet, chỉ cho phép RDS Service truy cập.
- **ElastiCache (Redis):** Nằm trong Private Subnet, cung cấp bộ nhớ đệm tốc độ cao cho các Service.
- **MongoDB Atlas:** Cơ sở dữ liệu NoSQL (Managed Service). Các Service kết nối tới Atlas thông qua **NAT Gateway** (hoặc VPC Peering) để đảm bảo bảo mật đường truyền.

### 4. External Connectivity (Kết nối ra ngoài)

- Các Service trong Private Subnet giao tiếp với các dịch vụ bên ngoài (như MoMo, ZaloPay, Firebase) thông qua **NAT Gateway**.

---
