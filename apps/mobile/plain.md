# Plan rà soát và hoàn thiện giao diện Đăng ký / Đăng nhập

Mục tiêu: Đảm bảo giao diện đăng ký (Registration) và đăng nhập (Login) của `apps/mobile` hoạt động đúng và giống với giao diện cũ (`omnimereduapp`), đặc biệt là chức năng tìm kiếm trường/lớp.

## 1. Phân tích hiện trạng

### A. Màn hình Đăng nhập (Login)

- **Reference (`omnimereduapp`)**: Không có chức năng chọn trường/lớp. Chỉ có Email, Password.
- **Target (`apps/mobile`)**: Cũng tương tự, không có chọn trường/lớp.
- **Kết luận**: Không cần thêm selector vào màn hình Login trừ khi có yêu cầu thay đổi logic nghiệp vụ khác.

### B. Màn hình Đăng ký (Registration)

- **Reference (`omnimereduapp`)**:
  - Sử dụng `SchoolSelector` và `ClassSelector` với `DropdownSearch`.
  - Có chức năng tìm kiếm local (`showSearchBox: true`) lọc theo tên/mã trường.
- **Target (`apps/mobile`)**:
  - Code hiện tại đã implement `SchoolSelector` và `ClassSelector` với logic tương tự (client-side filter).
  - Đã sử dụng `DropdownSearch` v6.0.1.

## 2. Các bước thực hiện chi tiết

### Giai đoạn 1: Đồng bộ UI SchoolSelector & ClassSelector [Đã hoàn thành]

Mặc dù logic đã có, cần rà soát lại styling để đảm bảo trải nghiệm người dùng ("wow" factor) và layout:

- **SchoolSelector** (`apps/mobile/.../school_selector.dart`):
  - [x] Đã rename entity `SchoolSearchEntity` -> `SchoolSelectorEntity`
  - [x] Kiểm tra `InputDecoration`: border, colors, icons.
  - [x] Kiểm tra `popupProps`: đảm bảo search box hiển thị đẹp, có hint text tiếng Việt.
- **ClassSelector** (`apps/mobile/.../class_selector.dart`):
  - [x] Đã rename entity `ClassEntity` -> `ClassSelectorEntity`
  - [x] Tương tự SchoolSelector.
- **Entities**:
  - [x] Rename `SchoolSearchEntity` thành `SchoolSelectorEntity`.
  - [x] Rename `ClassEntity` thành `ClassSelectorEntity`.

### Giai đoạn 2: Tích hợp vào StepRole [Đã hoàn thành]

- **StepRole** (`apps/mobile/.../step_role.dart`):
  - [x] Code hiện tại đã gọi `SchoolSelector` và `ClassSelector`.
  - [x] Đã cập nhật `StepRole` để handle sự kiện `onSchoolSelected` và `onClassSelected` với null safety check cho các entity mới.

### Giai đoạn 3: Kiểm thử Logic (Review Only) [Pending]

- **SchoolBloc**: Đã verify event `LoadSchoolsByLevel` load toàn bộ trường để phục vụ search client-side.
- **ClassBloc**: Đã verify logic load lớp theo trường.

## 3. Kết luận

Codebase hiện tại của `apps/mobile` đã có cấu trúc rất sát với yêu cầu (copy từ `omnimereduapp` sang). Công việc chủ yếu là **Verify** (kiểm tra lại) và **Polish** (tinh chỉnh giao diện) nếu cần thiết. Không cần viết lại logic "route tìm kiếm" vì đã có filtering ở client.
