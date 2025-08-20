# OmniMer EDU – Project Architecture

## 1. Tổng quan kiến trúc

Dự án sử dụng kiến trúc **Clean Layered Architecture**, trong đó các tầng **Controller → Service → Repository → Model** được tách biệt rõ ràng. Mục tiêu chính:

- Dễ mở rộng (scalability)
- Dễ bảo trì (maintainability)
- Tách biệt trách nhiệm (separation of concerns)

Cấu trúc thư mục:

```
src/
├── common/ # Chứa code dùng chung
│   ├── api/ # Base API response, middleware
│   ├── configs/ # Cấu hình hệ thống
│   ├── interfaces/ # Interface TypeScript dùng chung
│   ├── types/ # Định nghĩa type & augmentation
│   ├── utils/ # Hàm tiện ích (logger, crypto…)
│   └── validators/ # Schema validation (Zod/Joi…)
│
├── domain/ # Business logic chia theo module
│   ├── controllers/ # Điều phối request/response
│   │   ├── user/ # Module User (auth, teacher, student…)
│   │   ├── school/ # Module School (class, news…)
│   │   ├── payment/ # Module Payment
│   │   └── system/ # Module System (role, permission…)
│   │
│   ├── models/ # Mongoose models/schema
│   │   ├── user/ # User, Teacher, Student, Admin
│   │   ├── school/ # School, Class
│   │   └── payment/ # Invoice, Transaction
│   │
│   ├── repositories/ # Data access (CRUD cho model)
│   │   ├── user/ # UserRepository, TeacherRepository
│   │   ├── school/ # SchoolRepository, ClassRepository
│   │   └── payment/ # PaymentRepository
│   │
│   └── services/ # Business logic chính
│       ├── user/ # AuthService, TeacherService, StudentService
│       ├── school/ # SchoolService, ClassService
│       └── payment/ # PaymentService
│
├── app.ts # Khởi tạo app, middleware, routes
├── server.ts # Entry point: chạy server
└── tsconfig.json
```

---

## 2. Vai trò từng tầng

### Controller (domain/controllers)

- Nhận request từ client
- Gọi service phù hợp
- Trả về response JSON thống nhất

Ví dụ:

```ts
async login(req: Request, res: Response) {
  const token = await authService.login(req.body);
  return res.json({ success: true, token });
}
```

### Service (domain/services)

- Xử lý business logic
- Gọi repository để thao tác DB
- Ghi log hoạt động nếu cần

Ví dụ:

```ts
class AuthService {
  async login(credentials: LoginDto) {
    const user = await userRepository.findByEmail(credentials.email);
    if (!user) throw new Error("User not found");
    return jwt.sign({ id: user._id, role: user.role }, process.env.JWT_SECRET!);
  }
}
```

### Repository (domain/repositories)

- Truy xuất dữ liệu (CRUD) từ MongoDB
- Đóng gói query Mongoose
- Tách biệt DB khỏi business logic

Ví dụ:

```ts
class UserRepository {
  async findByEmail(email: string) {
    return UserModel.findOne({ email });
  }
}
```

### Model (domain/models)

- Định nghĩa schema Mongoose
- Khai báo interface TypeScript

Ví dụ:

```ts
const TeacherSchema = new Schema<ITeacher>({
  fullName: String,
  schoolId: { type: Types.ObjectId, ref: "School" },
  subjects: [String],
});
```

---

## 3. Quy tắc chia Module

Mỗi module (user, school, payment, system) sẽ bao gồm đủ bốn tầng: controllers, services, repositories, models.

Ví dụ module User:

```
user/
 ├── controllers/
 │    ├── auth.controller.ts
 │    ├── teacher.controller.ts
 │    └── student.controller.ts
 ├── services/
 │    ├── auth.service.ts
 │    ├── teacher.service.ts
 │    └── student.service.ts
 ├── repositories/
 │    ├── user.repository.ts
 │    └── teacher.repository.ts
 └── models/
      ├── User.ts
      ├── Teacher.ts
      └── Student.ts
```

---

## 4. Flow xử lý request

Ví dụ giáo viên tạo lớp mới:

1. Client gửi **POST /classes**
2. Controller `class.controller.ts` nhận request → gọi `classService.createClass(...)`
3. Service `class.service.ts` kiểm tra business rule (giáo viên có quyền, tên lớp trùng chưa) → gọi `classRepository.create(...)`
4. Repository `class.repository.ts` dùng `ClassModel.create(...)` để lưu DB
5. Service ghi log hoạt động
6. Controller trả response JSON cho client

---

## 5. Cách scale hệ thống

- **Tách module độc lập:** mỗi domain (user, school, payment) có thể tách thành microservice khi hệ thống mở rộng.
- **Repository layer:** cho phép thay đổi cơ sở dữ liệu (MongoDB → PostgreSQL) mà không ảnh hưởng Service.
- **Service layer:** gom business logic để dễ dàng viết unit test.
- **Controller mỏng, Service dày:** controller chỉ điều phối, toàn bộ logic xử lý nằm trong service.
- **Common module:** tận dụng tối đa để giảm lặp code (utils, validators, interfaces).
- **Logging và Monitoring:** tất cả thao tác qua service đều được log lại (ai thực hiện, đối tượng nào, kết quả).
- **CI/CD:** dễ dàng test và triển khai từng module riêng biệt.

---

## 6. Ưu điểm

- Kiến trúc rõ ràng, dễ đọc, dễ onboard developer mới
- Tách biệt trách nhiệm, tránh trùng lặp
- Dễ mở rộng thành microservice khi cần
- Dễ test từng tầng độc lập
