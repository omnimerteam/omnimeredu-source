# Quy tắc Commit Chuẩn (Conventional Commits)

Dự án OmniMer EDU tuân thủ theo chuẩn **Conventional Commits** để đảm bảo lịch sử commit rõ ràng, dễ đọc và hỗ trợ tự động hóa việc tạo changelog.

## 1. Cấu trúc Commit Message

Mỗi commit message bao gồm 3 phần: **Header**, **Body** (tùy chọn), và **Footer** (tùy chọn).

```text
<type>(<scope>): <subject>

<body (optional)>

```

### 1.1. Header (Bắt buộc)

Dòng đầu tiên của commit, không quá 50 ký tự.

- **`<type>`**: Loại thay đổi (xem danh sách bên dưới).
- **`<scope>`** (Tùy chọn): Phạm vi thay đổi (ví dụ: `auth`, `student`, `ui`, `database`). Đặt trong ngoặc đơn.
- **`<subject>`**: Mô tả ngắn gọn, súc tích về thay đổi.
  - Sử dụng động từ ở thể mệnh lệnh (imperative), hiện tại đơn (ví dụ: "add" thay vì "added" hay "adds").
  - Không viết hoa chữ cái đầu (trừ khi là tên riêng).
  - Không có dấu chấm câu ở cuối.

### 1.2. Body (Tùy chọn)

Mô tả chi tiết hơn về thay đổi: "Tại sao lại thay đổi?", "Thay đổi cái gì?", "So với trước đây thì khác thế nào?".

### 1.3. Danh sách Scope (Phạm vi)

Dưới đây là danh sách các scope phổ biến trong dự án OmniMer EDU để team tham khảo và sử dụng thống nhất:

**Backend Services:**

- `auth`: Auth Service (Đăng ký, Đăng nhập, Token).
- `rds`: RDS Service (Write operations, Core logic).
- `mongo`: Mongo Service (Read operations).
- `student`: Student Module.
- `teacher`: Teacher Module.
- `class`: Class Module.
- `attendance`: Attendance Module.
- `payment`: Payment Module.
- `grade`: Grade Module.
- `news`: News Module.
- `school`: School & School Admin Module.

**Frontend (Mobile/Web):**

- `ui`: Các thay đổi chung về giao diện (không gắn với feature cụ thể).
- `screen`: Các màn hình cụ thể (ví dụ: `screen/login`, `screen/home`).
- `widget`: Các widget tái sử dụng.
- `repo`: Frontend repositories.
- `logic`: Các logic gọi và xử lý api trong data/ , domain/, bloc/, services/
- `core`: Các config, utils, constants,... trong core/, utils/

**General/Infrastructure:**

- `docs`: Tài liệu.
- `ci`: CI/CD pipelines.
- `deps`: Dependencies (package.json, pubspec.yaml).
- `config`: Cấu hình hệ thống/môi trường.
- `utils`: Các hàm tiện ích chung.
- `assets`: Các tài nguyên (ảnh, icon, font, ...).
- `shared`: code dùng chung cho các service (như DTO, Types, Utils chung).

---

## 2. Các loại Commit (Types)

| Type         | Mô tả                                                       | Ví dụ                                       |
| :----------- | :---------------------------------------------------------- | :------------------------------------------ |
| **feat**     | Thêm một tính năng mới (Feature).                           | `feat(auth): add google login support`      |
| **fix**      | Sửa lỗi (Bug fix).                                          | `fix(payment): resolve momo callback error` |
| **docs**     | Thay đổi tài liệu (Documentation).                          | `docs: update api endpoint list`            |
| **style**    | Thay đổi về định dạng, format code (không ảnh hưởng logic). | `style(home): format code with prettier`    |
| **refactor** | Tái cấu trúc code (không thêm tính năng, không sửa lỗi).    | `refactor(user): simplify validation logic` |
| **perf**     | Cải thiện hiệu năng.                                        | `perf(db): add index for student search`    |
| **test**     | Thêm hoặc sửa test case.                                    | `test(auth): add unit test for login`       |
| **chore**    | Các thay đổi nhỏ khác (build process, dependencies...).     | `chore: update dependencies`                |
| **ci**       | Thay đổi cấu hình CI/CD.                                    | `ci: update github actions workflow`        |
| **build**    | Thay đổi hệ thống build hoặc external dependencies.         | `build: upgrade typescript version`         |
| **revert**   | Hoàn tác một commit trước đó.                               | `revert: feat(auth): add google login`      |

---

## 3. Ví dụ

### Commit thêm tính năng mới

```text
feat(attendance): add qr code generation for class

Added QR code generation logic in the backend.
The QR code contains classId and timestamp.

Closes #102
```

### Commit sửa lỗi

```text
fix(login): handle invalid token error

Previously, invalid tokens caused a 500 server error.
Now it returns a 401 Unauthorized response.
```

### Commit thay đổi tài liệu

```text
docs(readme): update installation instructions
```

### Commit có Breaking Change

```text
feat(api): change response format for user profile

BREAKING CHANGE: The 'fullName' field is now split into 'firstName' and 'lastName'.
```

---

## 4. Quy tắc chung

1.  **Một commit, một vấn đề**: Không gộp nhiều thay đổi không liên quan vào một commit.
2.  **Kiểm tra trước khi commit**: Đảm bảo code đã được format, lint và chạy test (nếu có).
3.  **Tiếng Anh**: Khuyến khích viết commit bằng tiếng Anh để thống nhất với cộng đồng quốc tế (hoặc theo quy định riêng của team là Tiếng Việt nếu thống nhất). _Trong dự án này, ưu tiên Tiếng Anh._
