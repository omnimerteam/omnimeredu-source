# Luồng Dữ Liệu Trong Hệ Thống OmniMer EDU

Dựa trên phân tích mã nguồn từ các service và tài liệu kế hoạch, tài liệu này mô tả chi tiết luồng di chuyển của dữ liệu (Data Flow) trong hệ thống Microservices của OmniMer EDU, áp dụng mô hình CQRS (Command Query Responsibility Segregation).

## 1. Tổng Quan Kiến Trúc

Hệ thống sử dụng cơ chế **CQRS** để tách biệt luồng Ghi (Write) và luồng Đọc (Read):

*   **Write Side (Command):** Sử dụng **PostgreSQL** để đảm bảo tính toàn vẹn dữ liệu, quan hệ chặt chẽ (Relational Integrity). Framework sử dụng là **Sequelize**.
*   **Read Side (Query):** Sử dụng **MongoDB** để tối ưu hóa tốc độ truy vấn đọc, báo cáo. Dữ liệu được đồng bộ từ PostgreSQL sang MongoDB.
*   **Synchronization:** Cơ chế đồng bộ được kích hoạt ngay sau khi dữ liệu được ghi vào PostgreSQL thông qua `Sequelize Hooks`.

## 2. Chi Tiết Luồng Dữ Liệu (Data Flow)

### 2.1. Luồng Ghi Dữ Liệu (Write Flow)
Khi Client (Frontend) gửi yêu cầu tạo hoặc cập nhật dữ liệu (ví dụ: Đăng ký user, Điểm danh):

1.  **Request** đi qua API Gateway (hoặc gọi trực tiếp) vào Controller của Service tương ứng (`user_service` hoặc `payment-attendance-service`).
2.  **Business Logic:** Controller gọi UseCase/Service layer để xử lý nghiệp vụ.
3.  **Persistance:** Service gọi Repository/Model (Sequelize) để lưu dữ liệu vào **PostgreSQL**.
    *   *Ví dụ:* `UserModel.create(data)` lưu vào bảng `Users` trong `omnimeredu_user_db`.
    *   *Ví dụ:* `AttendanceModel.create(data)` lưu vào bảng `Attendances` trong `omnimeredu_payment_db`.

### 2.2. Luồng Đồng Bộ Dữ Liệu (Sync Flow)
Ngay sau khi dữ liệu được ghi thành công vào PostgreSQL, cơ chế đồng bộ tự động được kích hoạt:

1.  **Sequelize Hooks:** Mỗi Model (User, School, Payment,...) được đăng ký các hooks `afterCreate`, `afterUpdate`, `afterDestroy` thông qua hàm `registerSyncHooks` (từ `shared-lib`).
2.  **Sync Service Trigger:**
    *   Hooks gọi đến `SyncService.sync(data, operation, collectionName)`.
    *   `operation`: 'CREATE', 'UPDATE', hoặc 'DELETE'.
    *   `collectionName`: Tên collection đích trong MongoDB (ví dụ: 'users', 'payments').
3.  **Write to NoSQL:** `SyncService` thực hiện ghi dữ liệu sang **MongoDB**.

> **Lưu ý sự khác biệt giữa các services:**
> *   **User Service:** Sử dụng `BaseSyncService` từ `shared-lib` và `NoSQLClientFactory` (trừu tượng hóa việc kết nối DB). Nó cũng thực hiện `transform` dữ liệu (ví dụ: loại bỏ passwordHash) trước khi sync.
> *   **Payment Service:** Hiện tại đang sử dụng implementation riêng của `SyncService` kết nối trực tiếp qua `mongoose` connection, thực hiện `updateOne` với tùy chọn `upsert: true`.

### 2.3. Luồng Đọc Dữ Liệu (Read Flow)
Khi Client cần xem dữ liệu (ví dụ: Xem danh sách học sinh, lịch sử giao dịch):

1.  Request vào Controller (Read API).
2.  Controller gọi Repository/Service chuyên trách cho việc đọc.
3.  Dữ liệu được truy vấn trực tiếp từ **MongoDB** (`omnimeredu_read_db`) để đảm bảo tốc độ cao và cấu trúc dữ liệu đã được denormalize (nếu có).

## 3. Phân Tích Mã Nguồn Chi Tiết

### 3.1. `services/shared-lib`
Đóng vai trò Core Framework cho việc đồng bộ:
*   `database/sequelize-hooks.ts`: Định nghĩa hàm `registerSyncHooks` để gắn logic đồng bộ vào vòng đời của Sequelize Model.
*   `database/sync-service.ts`: Định nghĩa interface `ISyncService` và lớp trừu tượng `BaseSyncService` xử lý logic `transform` và gọi `NoSQLClient`.

### 3.2. `services/user_service`
*   **Models:** Các model như `UserModel`, `SchoolModel` lưu trong Postgres.
*   **Sync:** File `src/data/datasources/sync-setup.ts` đăng ký hooks cho tất cả các models quan trọng (`users`, `schools`, `classes`...).
*   **Transformation:** `SyncService` tại đây loại bỏ các trường nhạy cảm như mật khẩu trước khi đẩy sang Read DB.

### 3.3. `services/payment-attendance-service`
*   **Models:** `AttendanceModel`, `PaymentModel`, `TuitionModel`...
*   **Sync:** Cũng có file `sync-setup.ts` để đăng ký hooks.
*   **Implementation:** Sử dụng `mongoose.connection` trực tiếp để thực hiện thao tác sync (Upsert).

### 3.4. Database Schema Map
| PostgreSQL Table (Write DB) | MongoDB Collection (Read DB) | Service Quản Lý |
| :--- | :--- | :--- |
| `Users` | `users` | User Service |
| `Schools` | `schools` | User Service |
| `Classes` | `classes` | User Service |
| `Attendances` | `attendances` | Payment Service |
| `Payments` | `payments` | Payment Service |
| `Tuitions` | `tuitions` | Payment Service |

## 4. Kết Luận
Hệ thống OmniMer EDU hiện tại đã triển khai thành công mô hình **Event-driven (implicit via Hooks)** để đồng bộ dữ liệu. Luồng dữ liệu đi theo chiều:
**Client -> Write Service -> Postgres -> (Hook -> SyncService) -> MongoDB <- Client Read**

Cách tiếp cận này giúp hệ thống tận dụng sức mạnh ràng buộc dữ liệu của SQL cho các nghiệp vụ cập nhật, đồng thời tận dụng khả năng mở rộng và tốc độ của NoSQL cho các nghiệp vụ truy vấn.
