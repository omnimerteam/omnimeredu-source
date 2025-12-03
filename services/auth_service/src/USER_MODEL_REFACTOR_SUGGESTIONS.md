# Đánh giá và Đề xuất Cải thiện User Model

Dựa trên việc phân tích các file source code hiện tại trong `services/api/src/domain/models/user/`, dưới đây là đánh giá chi tiết và các đề xuất cải thiện để đảm bảo tính chuẩn xác, dễ bảo trì và mở rộng của hệ thống.

## 1. Đánh giá Tổng quan

**Mô hình hiện tại:**

- **Chiến lược thừa kế (Inheritance):** Sử dụng **Mongoose Discriminators** (`BaseUser.discriminator`). Đây là cách tiếp cận **chuẩn và hiệu quả nhất** trong MongoDB để xử lý tính đa hình (Polymorphism) - tức là lưu tất cả user (Student, Teacher, Admin...) trong cùng một collection `users` nhưng vẫn có schema validation riêng cho từng loại.
- **Tách biệt Auth và Profile:** Việc tách `Account` (chứa login credentials) và `BaseUser` (chứa profile info) là một **best practice**. Nó giúp hệ thống linh hoạt (ví dụ: một user có thể login bằng nhiều cách: Password, Google, Facebook... mà vẫn trỏ về 1 profile).
- **Type Safety:** Sử dụng TypeScript Interfaces và Enums (`RoleEnum`, `GenderEnum`...) rất tốt, giúp code chặt chẽ và tránh lỗi magic string.

## 2. Các điểm cần Cải thiện (Refactor Suggestions)

Mặc dù kiến trúc nền tảng đã tốt, nhưng có một số điểm cần lưu ý để tránh lỗi logic và dư thừa dữ liệu về sau:

### 2.1. Vấn đề dư thừa `roleId` và `roleKey`

- **Hiện trạng:** `BaseUser` chứa cả `roleId` (tham chiếu đến collection `Role`) và `roleKey` (String dùng làm discriminator key).
- **Rủi ro:** Có thể xảy ra tình trạng không nhất quán (Inconsistency). Ví dụ: `roleKey` là "Student" nhưng `roleId` lại trỏ đến Role "Teacher".
- **Giải pháp:**
  - Đảm bảo logic tạo user luôn đồng bộ 2 trường này.
  - Nếu `Role` chỉ dùng để chứa tên (name) mà không có dynamic permissions (quyền động), hãy cân nhắc bỏ `roleId` và chỉ dùng `roleKey`.
  - Tuy nhiên, nếu bạn định làm hệ thống phân quyền động (RBAC) nơi `Role` chứa danh sách `permissions`, thì giữ cả 2 là hợp lý. Khi đó, `roleKey` dùng để xác định **Schema** (cấu trúc dữ liệu), còn `roleId` dùng để xác định **Quyền hạn**.

### 2.2. Đồng bộ Email (`Account` vs `BaseUser`)

- **Hiện trạng:** Cả `Account` và `BaseUser` đều có trường `email`.
- **Vấn đề:** Email nào là chính? Nếu user đổi email đăng nhập (Account), email liên hệ (BaseUser) có đổi theo không?
- **Giải pháp:**
  - Quy định rõ: `Account.email` là duy nhất dùng để đăng nhập. `BaseUser.email` là email liên hệ (có thể giống hoặc khác, hoặc để trống).
  - Nếu nghiệp vụ yêu cầu 2 email này luôn giống nhau, hãy bỏ `email` trong `BaseUser` và populate từ `Account` khi cần, hoặc dùng Database Transaction để luôn update cả 2 cùng lúc.

### 2.3. Quản lý Soft Delete (Xóa mềm)

- **Hiện trạng:** Chưa thấy cơ chế xóa mềm.
- **Đề xuất:** Thêm trường `deletedAt` hoặc `isActive` vào `BaseUser`.
  - `deletedAt: { type: Date, default: null, index: true }`
  - Giúp khôi phục tài khoản lỡ tay xóa và giữ toàn vẹn dữ liệu (referential integrity) cho các báo cáo lịch sử.

### 2.4. Cải thiện Schema `Student`

- **Hiện trạng:** `meta: { type: Schema.Types.Mixed }`.
- **Vấn đề:** Kiểu `Mixed` bỏ qua validation của Mongoose. Dữ liệu rác có thể bị đẩy vào đây.
- **Giải pháp:** Nếu có thể, hãy định nghĩa rõ các trường trong meta (ví dụ: `siblings`, `pickupInfo`...) hoặc tạo một Interface riêng cho Meta thay vì `Record<string, any>`.

## 3. Code Refactor Snippet (Ví dụ minh họa)

Dưới đây là ví dụ cải thiện `BaseUser.ts` để thêm Soft Delete và tối ưu hóa:

```typescript
// services/api/src/domain/models/user/BaseUser.ts

export interface IBaseUser extends Document {
  // ... các trường cũ
  deletedAt?: Date | null; // Thêm trường này
}

const BaseUserSchema = new Schema<IBaseUser>(
  {
    // ... các trường cũ
    email: {
      type: String,
      required: false,
      trim: true,
      lowercase: true, // Nên normalize email
    },
    deletedAt: { type: Date, default: null, index: true }, // Index để query nhanh các user chưa xóa
  },
  {
    discriminatorKey: "roleKey",
    collection: "users",
    timestamps: true,
  }
);

// Middleware để tự động loại bỏ user đã xóa khi find (Optional)
BaseUserSchema.pre(/^find/, function (next) {
  // this.find({ deletedAt: null });
  // Cẩn thận với middleware này nếu bạn cần query user đã xóa ở trang Admin
  next();
});
```

## 4. Kết luận

Cách viết hiện tại của bạn **đã khá chuẩn** cho một kiến trúc Microservices/Monolith sử dụng MongoDB.

- **Điểm cộng:** Dùng Discriminator là lựa chọn chính xác cho User Model đa hình.
- **Cần làm:** Tập trung vào logic **Service Layer** để đảm bảo tính nhất quán dữ liệu giữa `Account` và `BaseUser`, và giữa `roleId` và `roleKey`.
