# Kế hoạch Refactor Backend theo Kiến trúc Microservices

Tài liệu này mô tả chi tiết việc phân chia các API endpoint hiện tại vào các Microservice mới (Auth, RDS, Mongo) dựa trên kiến trúc hệ thống đã đề ra.

## 1. Nguyên tắc phân chia

Dựa trên `docs/architecture/system_architecture/architecture.md`:

1.  **Auth Service**: Quản lý đăng ký, đăng nhập, token, đổi mật khẩu.
2.  **RDS Service (Write & Core Logic)**:
    - Xử lý tất cả các yêu cầu **Ghi** (POST, PUT, PATCH, DELETE).
    - Chứa logic nghiệp vụ phức tạp (Thanh toán, Điểm danh, Phân công).
    - Đảm bảo tính ACID.
    - Sau khi ghi thành công, publish sự kiện để đồng bộ sang Mongo Service.
3.  **Mongo Service (Read Service)**:
    - Xử lý tất cả các yêu cầu **Đọc** (GET).
    - Tối ưu hóa cho tốc độ truy xuất (High Performance Read).
    - Dữ liệu được đồng bộ từ RDS Service.

---

## 2. Chi tiết phân chia API

### 2.1. Auth Module Service

Chịu trách nhiệm hoàn toàn về xác thực và quản lý tài khoản cơ bản.

| Endpoint                       | Method | Chức năng             | Ghi chú                                     |
| :----------------------------- | :----- | :-------------------- | :------------------------------------------ |
| `/api/v1/auth/register`        | POST   | Đăng ký tài khoản     | Tạo User trong RDS & Firebase               |
| `/api/v1/auth/login`           | GET    | Đăng nhập             | Xác thực Firebase Token, trả về JWT/Session |
| `/api/v1/auth/change-password` | PATCH  | Đổi mật khẩu          | Cập nhật mật khẩu                           |
| `/api/v1/auth/forget-password` | PATCH  | Quên mật khẩu         | Xử lý reset mật khẩu                        |
| `/api/v1/roles`                | GET    | Lấy danh sách vai trò | Dùng chung cho Auth/Frontend                |

### 2.2. RDS Module Service (Write Side)

Xử lý các tác vụ thay đổi dữ liệu.

**Student Module**

- `POST /api/v1/students`: Tạo học sinh.
- `PUT /api/v1/students/:id`: Cập nhật học sinh.
- `DELETE /api/v1/students/:id`: Xóa học sinh.

**Teacher Module**

- `POST /api/v1/teachers`: Tạo giáo viên.
- `PUT /api/v1/teachers/:id`: Cập nhật giáo viên.
- `DELETE /api/v1/teachers/:id`: Xóa giáo viên.

**Class Module**

- `POST /api/v1/classes`: Tạo lớp học.
- `PUT /api/v1/classes/:id`: Cập nhật lớp học.
- `DELETE /api/v1/classes/:id`: Xóa lớp học.
- `POST /api/v1/classes/:id/students/add`: Thêm học sinh vào lớp.
- `POST /api/v1/classes/:id/students/remove`: Xóa học sinh khỏi lớp.
- `POST /api/v1/classes/:id/students/transfer`: Chuyển lớp.

**Attendance Module**

- `POST /api/v1/attendances`: Tạo bản điểm danh.
- `POST /api/v1/attendances/initialize-class-attendance`: Khởi tạo điểm danh lớp.
- `PUT /api/v1/attendances/:id`: Cập nhật điểm danh.
- `DELETE /api/v1/attendances/:id`: Xóa điểm danh.

**Details Record Module**

- `POST /api/v1/details-records`: Tạo chi tiết điểm danh.
- `PUT /api/v1/details-records/:id`: Cập nhật chi tiết.
- `PATCH /api/v1/details-records/update-status/:id`: Cập nhật trạng thái (Có mặt/Vắng).
- `DELETE /api/v1/details-records/:id`: Xóa chi tiết.

**School & School Admin Module**

- `POST /api/v1/schools`: Tạo trường.
- `PUT /api/v1/schools`: Cập nhật trường.
- `DELETE /api/v1/schools`: Xóa trường.
- `POST /api/v1/school-admins`: Tạo admin trường.
- `PUT /api/v1/school-admins/:id`: Cập nhật admin trường.
- `PATCH /api/v1/school-admins/update-position/:id`: Cập nhật chức vụ.
- `DELETE /api/v1/school-admins/:id`: Xóa admin trường.

**Teaching Assignment Module**

- `POST /api/v1/teaching-assignment`: Phân công giảng dạy.
- `PUT /api/v1/teaching-assignment/:id`: Cập nhật phân công.
- `DELETE /api/v1/teaching-assignment/:id`: Xóa phân công.

**Other Write Operations**

- `POST /api/v1/grades`: Tạo khối.
- `PUT /api/v1/grades/:id`: Cập nhật khối.
- `DELETE /api/v1/grades/:id`: Xóa khối.
- `POST /api/v1/membership-request`: Tạo yêu cầu tham gia.
- `PUT /api/v1/membership-request/:id`: Cập nhật yêu cầu.
- `PATCH /api/v1/membership-request/:id/status`: Duyệt yêu cầu.
- `DELETE /api/v1/membership-request/:id`: Xóa yêu cầu.
- `POST /api/v1/news`: Đăng tin.
- `PUT /api/v1/news/:id`: Sửa tin.
- `PATCH /api/v1/news/:id`: Ẩn/Hiện tin.
- `DELETE /api/v1/news/:id`: Xóa tin.
- `PATCH /api/v1/personnel/update-role/:id`: Cập nhật vai trò nhân sự.
- `PATCH /api/v1/personnel/update-verified/:id`: Xác thực nhân sự.
- `PATCH /api/v1/personnel/dismiss/:id`: Sa thải.
- `PATCH /api/v1/personnel/update-avatar`: Cập nhật avatar.
- `POST /api/v1/vip-packages`: Tạo gói VIP.
- `PUT /api/v1/vip-packages/:id`: Sửa gói VIP.
- `DELETE /api/v1/vip-packages/:id`: Xóa gói VIP.
- `POST /api/v1/discount-policies`: Tạo chính sách giảm giá.
- `PUT /api/v1/discount-policies/:id`: Sửa chính sách.
- `DELETE /api/v1/discount-policies/:id`: Xóa chính sách.
- `POST /api/v1/extra-fees`: Tạo phí phụ thu.
- `PUT /api/v1/extra-fees/:id`: Sửa phí phụ thu.
- `DELETE /api/v1/extra-fees/:id`: Xóa phí phụ thu.
- `POST /api/v1/upload/avatar-temp`: Upload ảnh.

### 2.3. Mongo Module Service (Read Side)

Xử lý các tác vụ đọc dữ liệu, phục vụ Client (Mobile/Web).

**Student Queries**

- `GET /api/v1/students`: Danh sách học sinh.
- `GET /api/v1/students/student-selector`: Select box học sinh.
- `GET /api/v1/students/:id`: Chi tiết học sinh.

**Teacher Queries**

- `GET /api/v1/teachers`: Danh sách giáo viên.
- `GET /api/v1/teachers/:id`: Chi tiết giáo viên.

**Class Queries**

- `GET /api/v1/classes`: Danh sách lớp.
- `GET /api/v1/classes/view-model/class-detail`: View model danh sách lớp.
- `GET /api/v1/classes/view-model/class-detail/:id`: View model chi tiết lớp.
- `GET /api/v1/classes/:id`: Chi tiết lớp.
- `GET /api/v1/classes/schools/search`: Tìm kiếm lớp.

**Attendance Queries**

- `GET /api/v1/attendances`: Danh sách điểm danh.
- `GET /api/v1/attendances/:id`: Chi tiết điểm danh.
- `GET /api/v1/attendances/attendance-record-view/:id`: View chi tiết bản ghi.
- `GET /api/v1/attendances/class-attendance-record/view`: View điểm danh lớp.
- `GET /api/v1/attendances/:id/export`: Xuất Excel (Có thể cân nhắc để ở RDS nếu cần tính toán nặng, nhưng Mongo đọc dữ liệu nhanh hơn).

**Details Record Queries**

- `GET /api/v1/details-records`: Tất cả chi tiết.
- `GET /api/v1/details-records/attendance-records/:attendanceId`: Theo ID điểm danh.
- `GET /api/v1/details-records/:id`: Theo ID.

**School & Admin Queries**

- `GET /api/v1/schools/search/query`: Tìm kiếm trường.
- `GET /api/v1/schools/school-admin`: Chi tiết trường cho Admin.
- `GET /api/v1/schools`: Danh sách trường.
- `GET /api/v1/school-admins`: Danh sách Admin.
- `GET /api/v1/school-admins/:id`: Chi tiết Admin.
- `GET /api/v1/school-admin-dashboard/get-summary`: Dashboard Summary.
- `GET /api/v1/school-admin-dashboard/get-school-attendance-stats`: Thống kê điểm danh.

**Teaching Assignment Queries**

- `GET /api/v1/teaching-assignment`: Danh sách phân công.
- `GET /api/v1/teaching-assignment/:id`: Chi tiết phân công.
- `GET /api/v1/teaching-assignment/teacherId-schoolId-classId/...`: Tìm kiếm phân công cụ thể.
- `GET /api/v1/teaching-assignment/teacherId-schoolId/...`: Phân công của GV trong trường.
- `GET /api/v1/teaching-assignment/teacherId/...`: Các lớp GV dạy.

**Other Read Operations**

- `GET /api/v1/grades`: Danh sách khối.
- `GET /api/v1/grades/:id`: Chi tiết khối.
- `GET /api/v1/grades/select/box`: Select box khối.
- `GET /api/v1/membership-request`: Danh sách yêu cầu.
- `GET /api/v1/membership-request/:id`: Chi tiết yêu cầu.
- `GET /api/v1/news/:schoolId`: Tin tức theo trường.
- `GET /api/v1/news/:id`: Chi tiết tin tức.
- `GET /api/v1/personnel`: Danh sách nhân sự.
- `GET /api/v1/personnel/:id`: Chi tiết nhân sự.
- `GET /api/v1/roles/roles-personnel`: Vai trò nhân sự.
- `GET /api/v1/vip-packages`: Danh sách gói VIP.
- `GET /api/v1/vip-packages/:id`: Chi tiết gói VIP.
- `GET /api/v1/discount-policies`: Danh sách chính sách.
- `GET /api/v1/discount-policies/:id`: Chi tiết chính sách.
- `GET /api/v1/extra-fees`: Danh sách phí phụ.
- `GET /api/v1/extra-fees/:id`: Chi tiết phí phụ.

---

## 3. Chiến lược Refactor & Di chuyển

### Giai đoạn 1: Tách Database (Database Splitting)

- Thiết lập **RDS (PostgreSQL/MySQL)** cho các bảng quan trọng: `Users`, `Payments`, `Classes`, `Attendances`.
- Thiết lập **MongoDB** làm Read Model.
- Viết script migrate dữ liệu hiện tại sang cấu trúc mới.

### Giai đoạn 2: Xây dựng RDS Service (Write Service)

- Di chuyển toàn bộ logic `POST`, `PUT`, `DELETE`, `PATCH` sang service này.
- Implement **Event Publisher** (RabbitMQ/Kafka) để bắn sự kiện khi dữ liệu thay đổi (e.g., `StudentCreated`, `AttendanceMarked`).

### Giai đoạn 3: Xây dựng Mongo Service (Read Service)

- Implement **Event Consumer** để lắng nghe sự kiện từ RDS Service và cập nhật vào MongoDB.
- Di chuyển toàn bộ logic `GET` sang service này, trỏ query vào MongoDB.

### Giai đoạn 4: Xây dựng Auth Service

- Tách riêng logic xác thực, JWT, và quản lý User cơ bản.

### Giai đoạn 5: API Gateway & Routing

- Cấu hình **API Gateway** (hoặc Load Balancer) để route request:
  - `GET` -> Mongo Service.
  - `POST/PUT/DELETE` -> RDS Service.
  - `/auth` -> Auth Service.
