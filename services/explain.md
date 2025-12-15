# Kiến Trúc và Cơ Chế Hoạt Động OmniMer Edu Services 
Tài liệu này mô tả chi tiết kiến trúc, cơ chế hoạt động, và đặc tả API Input/Output của hệ thống Microservices OmniMer Edu. Mã nguồn đã được tái cấu trúc theo mô hình CQRS (Command Query Responsibility Segregation) và bảo mật với JWT qua API Gateway.


## 1. Tổng Quan Kiến Trúc Hệ Thống

Hệ thống được chia thành các thành phần chính sau:

1.  **API Gateway (Nginx):** Cổng vào duy nhất, xử lý routing, rate limiting, và forward request tới các service backend.
2.  **User Service:** Quản lý người dùng, trường học, lớp học và Authentication.
3.  **Payment & Attendance Service:** Quản lý điểm danh, học phí, thanh toán.
4.  **Shared Library:** Thư viện dùng chung chứa Authentication logic, Database connections, Constants.
5.  **Databases:**
    - **PostgreSQL (Write DB):** Database quan hệ cho các tác vụ ghi (Command), đảm bảo tính toàn vẹn dữ liệu.
    - **MongoDB (Read DB):** Database NoSQL cho các tác vụ đọc (Query), tối ưu hóa báo cáo và truy vấn phức tạp.

---

## 2. Cơ Chế Authentication & Authorization

Hệ thống sử dụng cơ chế bảo mật tập trung dựa trên **JWT (JSON Web Token)** được chia sẻ giữa các services.

### 2.1. Token Mechanism

- **Access Token:** Thời hạn 15 phút. Dùng để xác thực request.
- **Refresh Token:** Thời hạn 7 ngày. Dùng để lấy Access Token mới mà không cần login lại.
- **JWT Secrets:** Được cấu hình dùng chung trong `.env` của tất cả services để đảm bảo tính nhất quán khi verify/sign.

### 2.2. Auth Flow

1.  **Login:** Client gọi `POST /api/v1/users/auth/login`. User Service trả về Access Token & Refresh Token.
2.  **Request:** Client gửi Access Token trong header `Authorization: Bearer <token>`.
3.  **Gateway Routing:** Nginx route request tới service đích.
4.  **Service Middleware (`authMiddleware`):**
    - Verify Access Token bằng Shared Secret.
    - Decode thông tin User (`userId`, `roleKey`, `schoolId`) và gắn vào `req.user`.
5.  **Role Check (`roleMiddleware`):** Kiểm tra `req.user.roleKey` có nằm trong danh sách được phép không (`Teacher`, `SchoolAdmin`, ...).

---

## 3. Cơ Chế CQRS (Command Query Responsibility Segregation)

Hệ thống tách biệt rõ ràng luồng Ghi và Đọc.

### 3.1. Write Flow (Command)

- **Database:** PostgreSQL.
- **Framework:** Sequelize ORM.
- **Quy trình:**
  1.  Client gửi yêu cầu (vd: `POST /attendance`).
  2.  Server ghi vào PostgreSQL.
  3.  **Sync Hook:** `afterCreate`, `afterUpdate`, `afterDestroy` hooks của Sequelize được kích hoạt.
  4.  **SyncService:** Hook gọi `SyncService` để đồng bộ dữ liệu sang MongoDB (bất đồng bộ).

### 3.2. Read Flow (Query)

- **Database:** MongoDB.
- **Framework:** Mongoose.
- **Quy trình:**
  1.  Client gửi yêu cầu lấy dữ liệu/báo cáo (vd: `GET /attendance/reports`).
  2.  Server truy vấn trực tiếp từ MongoDB.
  3.  Tận dụng Aggregation Pipeline mạnh mẽ của MongoDB để tính toán báo cáo phức tạp (vd: tính % điểm danh) mà không ảnh hưởng hiệu năng DB chính.

---

## 4. Đặc Tả API Input/Output

Dưới đây là mô tả các API endpoints quan trọng nhất.

### 4.1. Authentication APIs (User Service)

#### `POST /api/v1/auth/login`

Đăng nhập người dùng.

- **Input (Body):**
  ```json
  {
    "email": "admin@school.com",
    "password": "securepassword"
  }
  ```
- **Output (success):**
  ```json
  {
    "success": true,
    "data": {
      "accessToken": "eyJhbGcu...",
      "refreshToken": "eyJhbGcu...",
      "user": {
        "id": "uuid-...",
        "email": "admin@school.com",
        "fullName": "Nguyen Van Admin",
        "role": "SchoolAdmin"
      }
    }
  }
  ```

### 4.2. Attendance APIs (Payment & Attendance Service)

#### `POST /api/v1/attendance` (Command)

Tạo phiên điểm danh mới.

- **Input (Body):**
  ```json
  {
    "classId": "uuid-class-...",
    "date": "2024-03-20",
    "sessionType": "Morning", // Morning, Afternoon, AllDay
    "records": [
      {
        "studentId": "uuid-student-1",
        "status": "Present", // Present, Absent, ...
        "note": ""
      },
      {
        "studentId": "uuid-student-2",
        "status": "Absent",
        "note": "Sick leave"
      }
    ]
  }
  ```
- **Output:** Thông tin điểm danh đã tạo.

#### `GET /api/v1/attendance/reports/monthly/:classId` (Query - MongoDB)

Lấy báo cáo điểm danh tháng, có tính toán thống kê.

- **Query Params:** `?month=3&year=2024`
- **Output:**
  ```json
  {
    "success": true,
    "data": {
      "classId": "uuid-...",
      "month": 3,
      "year": 2024,
      "totalSchoolDays": 22,
      "averageAttendanceRate": 95,
      "students": [
        {
          "studentId": "uuid-student-1",
          "presentDays": 20,
          "absentDays": 2,
          "lateDays": 0,
          "attendanceRate": 90
        }
        // ...
      ]
    }
  }
  ```
- **Cơ chế:** Sử dụng MongoDB Aggregation để group và count status từ collection `attendances` và `attendance_records`.

### 4.3. Payment APIs (Payment & Attendance Service)

#### `POST /api/v1/tuition` (Command)

Tạo thông báo học phí.

- **Input (Body):**
  ```json
  {
    "studentId": "uuid-student-1",
    "period": "2024-03",
    "dueDate": "2024-03-15",
    "items": [
      { "name": "Học phí", "amount": 2000000, "isRequired": true },
      { "name": "Tiền ăn", "amount": 500000, "isRequired": true }
    ],
    "discounts": [{ "name": "Con giáo viên", "amount": 200000 }]
  }
  ```
- **Output:** Object Tuition với `totalAmount` đã được tính toán tự động.

#### `POST /api/v1/payments` (Command)

Ghi nhận thanh toán.

- **Input (Body):**
  ```json
  {
    "studentId": "uuid-student-1",
    "tuitionId": "uuid-tuition-1", // Optional
    "amount": 2300000,
    "paymentMethodId": "uuid-method-cash",
    "transactionId": "Optional-Bank-Tran-ID",
    "note": "Đóng tiền tháng 3"
  }
  ```
- **Output:** Object Payment.
- **Side Effect:** Hệ thống tự động kiểm tra, nếu `amount` >= `tuition.totalAmount`, cập nhật trạng thái Tuition thành `Paid`.

#### `GET /api/v1/payments/history` (Query - MongoDB)

Lịch sử thanh toán filter nâng cao.

- **Query Params:** `?studentId=...&status=Success&startDate=...&page=1&limit=10`
- **Output:**
  ```json
  {
    "success": true,
    "data": {
      "items": [
        {
          "id": "uuid-payment-1",
          "amount": 2300000,
          "status": "Success",
          "paidAt": "2024-03-10T10:00:00Z"
        }
      ],
      "total": 50,
      "page": 1,
      "totalPages": 5
    }
  }
  ```

---

## 5. Kết Luận

Kiến trúc này đảm bảo:

1.  **Hiệu năng:** Tách biệt đọc/ghi giúp scale độc lập. MongoDB xử lý tốt các báo cáo nặng.
2.  **Tính toàn vẹn (Integrity):** PostgreSQL đảm bảo dữ liệu tài chính chính xác tuyệt đối.
3.  **Bảo mật:** JWT + Role-based access control bảo vệ từng endpoint.
4.  **Khả năng mở rộng:** API Gateway cho phép thêm services mới dễ dàng mà không đổi cấu trúc client.

## 6. Chi tiết Authentication API (User Service)

Dưới đây là đặc tả chi tiết cho các API: Register, Login, Refresh Token, và GetAuth.

### 6.1. `POST /api/auth/register` (Command)

Đăng ký tài khoản mới.

- **Input (Body):**
  ```json
  {
    "email": "teacher@school.com",
    "password": "strongPassword123",
    "roleName": "Teacher", // Giá trị: "Student", "Teacher", "Staff", "SchoolAdmin"
    "baseUserInfo": {
      "fullName": "Nguyen Van A",
      "gender": "Male", // "Male", "Female", "Other"
      "birthday": "1990-01-01",
      "phone": "0901234567",
      "address": "123 Street, City"
    },
    // Optional
    "schoolId": "uuid-school-id", // Bắt buộc nếu join trường có sẵn
    "classId": "uuid-class-id", // Dành cho Student
    "specificInfo": {
      // Thông tin thêm tùy vào Role
      "qualification": "PhD", // Ví dụ cho Teacher
      "subjects": ["Math", "Physics"]
    },
    "schoolData": {
      // Bắt buộc nếu SchoolAdmin tạo trường mới
      "name": "New School Name",
      "address": "School Address",
      "level": "HighSchool",
      "phone": "028..."
    }
  }
  ```
- **Output (Success - 201):**
  ```json
  {
    "success": true,
    "message": "User registered successfully",
    "data": {
      "user": {
        "email": "teacher@school.com",
        "roleKey": "Teacher",
        "schoolName": "High School A",
        "className": "10A1"
      },
      "accessToken": "eyJhbGci...",
      "refreshToken": "eyJhbGci..."
    }
  }
  ```

### 6.2. `POST /api/auth/login` (Command)

Đăng nhập hệ thống bằng email và password.

- **Input (Body):**
  ```json
  {
    "email": "teacher@school.com",
    "password": "strongPassword123"
  }
  ```
- **Output (Success - 200):**
  ```json
  {
    "success": true,
    "message": "Login successful",
    "data": {
      "user": {
        "id": "uuid-user-id",
        "fullName": "Nguyen Van A",
        "email": "teacher@school.com",
        "roleKey": "Teacher",
        "avatarUrl": "https://s3.bucket...",
        "isVerified": false,
        "schoolId": "uuid-school-id"
      },
      "tokens": {
        "accessToken": "eyJhbGci...",
        "refreshToken": "eyJhbGci..."
      }
    }
  }
  ```

### 6.3. `POST /api/auth/refresh-token` (Command)

Cấp lại Access Token mới khi token cũ hết hạn.

- **Input (Body):**
  ```json
  {
    "refreshToken": "eyJhbGci..."
  }
  ```
- **Output (Success - 200):**
  ```json
  {
    "success": true,
    "message": "Token refreshed successfully",
    "data": {
      "tokens": {
        "accessToken": "new-access-token...",
        "refreshToken": "new-refresh-token..."
      }
    }
  }
  ```

### 6.4. `GET /api/auth/me` (Query)

Lấy thông tin người dùng hiện tại dựa trên Access Token.

- **Headers:**
  - `Authorization`: `Bearer <accessToken>`
- **Output (Success - 200):**
  ```json
  {
    "success": true,
    "message": "User information retrieved successfully",
    "data": {
      "user": {
        "id": "uuid-user-id",
        "fullName": "Nguyen Van A",
        "email": "teacher@school.com",
        "roleKey": "Teacher",
        "avatarUrl": "https://s3...",
        "isVerified": false,
        "schoolId": "uuid-school-id",
        "gender": "Male",
        "birthday": "1990-01-01",
        "phone": "0901234567",
        "address": "123 Street, City"
      },
      "account": {
        "id": "uuid-account-id",
        "email": "teacher@school.com",
        "isActive": true,
        "lastLogin": "2024-01-01T10:00:00Z"
      }
    }
  }
  ```
