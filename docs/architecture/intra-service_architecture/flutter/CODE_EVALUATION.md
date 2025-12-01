# Báo cáo Đánh giá Mã nguồn – Ứng dụng OmniMerEdu

## 📚 Tổng quan

Ứng dụng Flutter **OmniMerEdu** nằm trong thư mục `apps/omnimereduapp`. Nó tuân theo bố cục **Clean Architecture** / **Feature‑first** khá cổ điển:

- **`lib/core`** – các tiện ích cấp thấp, hằng số và các helper dùng chung.
- **`lib/domain`** – entities, use‑cases, và các repository abstraction.
- **`lib/data`** – triển khai cụ thể của các repository (Firebase, REST, local cache).
- **`lib/presentation`** – lớp UI (màn hình, widgets, quản lý trạng thái BLoC / Provider).
- **`lib/services`** – các wrapper mỏng bao quanh các SDK bên ngoài (ví dụ: Firebase Auth, Firestore).
- **`lib/injection_container.dart`** – service‑locator (GetIt) kết nối tất cả các phụ thuộc.

Dự án cũng đi kèm một thư mục **`docs`** chứa các tài liệu thiết kế (`DESIGN.md`, `FRONTEND_ARCH.md`, v.v.) và một tệp **`README.md`** ở thư mục gốc.

## ✅ Điểm mạnh

| Lĩnh vực                 | Điểm tích cực                                                                                    |
| ------------------------ | ------------------------------------------------------------------------------------------------ |
| **Kiến trúc**            | Phân tách rõ ràng các mối quan tâm; mỗi lớp có trách nhiệm riêng.                                |
| **Dependency Injection** | `injection_container.dart` tập trung việc tạo đối tượng, giúp unit‑testing trở nên đơn giản.     |
| **Quản lý trạng thái**   | Sử dụng BLoC / Provider nhất quán trên các màn hình, với events và states được đặt tên tốt.      |
| **Tài liệu**             | Các tài liệu thiết kế hiện có (`DESIGN.md`, `FRONTEND_ARCH.md`) cung cấp cái nhìn tổng quan tốt. |
| **Kiểm thử**             | Thư mục `test` đã hiện diện (mặc dù hiện tại còn ít).                                            |
| **Styling**              | `app_colors.md` định nghĩa bảng màu, cho phép chủ đề UI nhất quán.                               |

## ⚠️ Các vấn đề & Nợ kỹ thuật

| Danh mục                                  | Phát hiện                                                                                                       |
| ----------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| **Firebase Tight‑Coupling**               | Logic xác thực và lưu trữ gắn liền trực tiếp với Firebase SDK, gây khó khăn cho việc di chuyển trong tương lai. |
| **Chuỗi ký tự cứng (Hard‑coded Strings)** | Nhiều văn bản UI và thông báo lỗi là chuỗi in‑line thay vì sử dụng bản địa hóa (`intl`).                        |
| **Tệp lớn**                               | Một số tệp trong `lib/presentation` vượt quá 400 dòng, vi phạm nguyên tắc _single‑responsibility_.              |
| **Thiếu Null‑Safety Guards**              | Một vài nơi vẫn sử dụng `!` force‑unwraps, có thể gây crash runtime.                                            |
| **Unit Tests hạn chế**                    | Chỉ có một số ít unit test; các lớp business‑logic (use‑cases) và repository thiếu độ bao phủ.                  |
| **Import dư thừa**                        | Một số tệp import các package không sử dụng (ví dụ: `dart:io` trong các UI widget).                             |
| **Quản lý Asset**                         | Hình ảnh được lưu trực tiếp dưới `assets/` mà không có quy ước đặt tên, gây khó khăn khi mở rộng.               |
| **Thiếu sót tài liệu**                    | Không có tài liệu chuyên dụng cho **domain layer** (entities, use‑cases) và **biểu đồ phụ thuộc**.              |

## 📈 Các đề xuất

1. **Trừu tượng hóa Dịch vụ Firebase**
   - Tạo các interface (`AuthRepository`, `StorageRepository`) trong `domain/repositories`.
   - Cung cấp triển khai Firebase trong `data/repositories` và triển khai mock cho test.
2. **Giới thiệu Quốc tế hóa (Internationalisation)**
   - Thêm package `flutter_intl` và di chuyển tất cả các chuỗi hiển thị cho người dùng sang các tệp ARB.
3. **Refactor các Widget lớn**
   - Chia nhỏ các widget > 300 dòng thành các component nhỏ hơn, có thể tái sử dụng.
   - Tuân theo cấu trúc thư mục _Feature‑first_ cho các phần UI (`presentation/widgets/...`).
4. **Tăng độ bao phủ kiểm thử (Test Coverage)**
   - Viết unit test cho mọi use‑case và phương thức repository.
   - Thêm widget test cho các màn hình quan trọng (đăng nhập, hồ sơ).
5. **Thực thi Null‑Safety**
   - Thay thế `!` bằng các kiểm tra null hoặc giá trị mặc định phù hợp.
   - Bật quy tắc lint `strict‑raw‑types`.
6. **Cải thiện đặt tên Asset**
   - Áp dụng quy ước như `assets/images/<tính_năng>/<tên>.png`.
   - Cập nhật `pubspec.yaml` tương ứng.
7. **Tài liệu hóa Domain Layer**
   - Thêm `DOMAIN_OVERVIEW.md` mô tả entities, use‑cases, và các hợp đồng repository.
   - Bao gồm một biểu đồ UML đơn giản (có thể tạo bằng `plantuml`).
8. **Tự động hóa Linting & Formatting**
   - Thêm pre‑commit hook (`flutter format . && flutter analyze`) để giữ codebase sạch sẽ.

## 🎨 Cải tiến UI/UX (Tùy chọn)

- Tận dụng **Glassmorphism** và các micro‑animation tinh tế cho chuyển đổi thẻ (phù hợp với hướng dẫn thiết kế cao cấp).
- Hợp nhất việc sử dụng màu sắc với bảng màu được định nghĩa trong `app_colors.md` – thay thế bất kỳ giá trị hex tùy tiện nào.
- Thêm nút chuyển đổi chế độ tối (dark‑mode) sử dụng `ThemeMode.system` và đảm bảo tất cả các màu tùy chỉnh đều thích ứng.

## 📦 Các bước tiếp theo

1. Tạo lớp trừu tượng cho Firebase (bước 1).
2. Thêm khung sườn cho bản địa hóa (bước 2).
3. Soạn thảo `DOMAIN_OVERVIEW.md` và đặt nó trong `apps/omnimereduapp/docs`.
4. Mở PR để refactor widget lớn nhất (ví dụ `profile_screen.dart`).
5. Chạy `flutter test --coverage` và nhắm mục tiêu độ bao phủ **≥80%** cho business logic.

---

_Được tạo bởi Antigravity – trợ lý lập trình AI mạnh mẽ._
