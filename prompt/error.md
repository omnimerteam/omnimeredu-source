# Đánh giá Hiện trạng User Service

## 1. Tổng quan

Hiện tại, `User Service` mới chỉ hoàn thành một phần nhỏ của **Giai đoạn 3 (Phát triển User Module)** trong kế hoạch tổng thể. Cấu trúc dự án đã bắt đầu tuân theo Clean Architecture nhưng còn thiếu rất nhiều thành phần cốt lõi và chưa đồng bộ hoàn toàn với tài liệu kiến trúc.

## 2. Các điểm thiếu sót (Missing Components)

Dựa trên `services/plan.md` và `architecture.md`, các thành phần sau đang bị thiếu:

### A. Domain Layer (`src/domain`)

- **Entities**: Thiếu `School`, `Grade`, `Class`, `MembershipRequest`. Hiện tại chỉ có `User`, `Account`, `Student`.
- **Repositories Interfaces**: Thiếu `ISchoolRepository`, `IClassRepository`.
- **Use Cases**: Thư mục `src/domain/usecases` hoàn toàn **trống**. Cần implement các use cases như `CreateUserUseCase`, `GetUserProfileUseCase`, `RegisterSchoolUseCase`, v.v.

### B. Data Layer (`src/data`)

- **Datasources (PostgreSQL)**: Thiếu `SchoolModel`, `GradeModel`, `ClassModel` trong `src/data/datasources/postgres/models`.
- **Datasources (NoSQL)**: Cấu trúc chưa rõ ràng. Plan đề cập `src/data/datasources/mongodb` nhưng hiện tại code đang nằm rải rác hoặc chưa có.
- **Repositories Impl**: Thiếu `SchoolRepositoryImpl`, `ClassRepositoryImpl`.
- **Sync/Messaging**: Chưa thấy `EventPublisher` hoặc logic `SyncService` để đồng bộ dữ liệu từ Postgres sang MongoDB (CQRS).

### C. Presentation Layer (`src/presentation`)

- Thư mục này hoàn toàn **trống**.
- Thiếu **Controllers** (`UserController`, `SchoolController`).
- Thiếu **DTOs** (`CreateUserDto`, `CreateSchoolDto`).

## 3. Các điểm dư thừa / Cần điều chỉnh (Redundancies & Refactoring)

- **Cấu trúc Database Config**:

  - Hiện tại đang tồn tại song song `src/infrastructure/database/sql` và `src/data/datasources/postgres`.
  - **Đánh giá**: `src/infrastructure/database/sql` là dư thừa và gây nhầm lẫn. Logic kết nối và khởi tạo model đã được chuyển sang `src/data/datasources/postgres/database.ts`.
  - **Hành động**: Cần xóa bỏ hoàn toàn `src/infrastructure/database/sql`.

- **NoSQL Structure**:
  - Hiện tại có `src/infrastructure/database/nosql`.
  - **Đánh giá**: Nên di chuyển logic này vào `src/data/datasources/mongodb` (hoặc `nosql`) để nhất quán với cấu trúc Clean Architecture đã định nghĩa trong `architecture.md`.

## 4. Kế hoạch khắc phục (Action Plan)

Để đưa dự án về đúng quỹ đạo, cần thực hiện các bước sau:

1.  **Dọn dẹp (Cleanup)**: Xóa `src/infrastructure/database/sql`.
2.  **Hoàn thiện Domain**:
    - Định nghĩa đầy đủ Entities (`School`, `Class`, ...).
    - Định nghĩa Repository Interfaces.
3.  **Implement Data Layer**:
    - Tạo các Sequelize Models còn thiếu.
    - Implement Repositories.
    - Cấu hình `SyncService` (CQRS).
4.  **Implement Use Cases**: Viết logic nghiệp vụ.
5.  **Implement Presentation**: Tạo Controller và DTO.

---

_Đánh giá được thực hiện tự động bởi AI Assistant._
