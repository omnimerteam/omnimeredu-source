# OmniMer EDU - School Management Ecosystem

OmniMer EDU là một hệ thống quản lý trường học đa nền tảng, giúp tối ưu hóa công tác quản lý học sinh, lớp học, điểm danh, học phí và nhiều tính năng khác. Hệ thống bao gồm:

- **Ứng dụng Mobile**: Flutter đa nền tảng cho iOS & Android  
- **Web Dashboard**: Flutter web / ReactJS dành cho quản trị viên  
- **Backend API**: Node.js / Express.js cung cấp RESTful API  
- **Dịch vụ AI**: Module AI nâng cao (phát triển sau)  
- **Module Thanh toán & Gói VIP**: Quản lý thanh toán học phí và nâng cấp dịch vụ (phát triển sau)

---

## 1. Cấu trúc thư mục dự án

```bash
omnimeredu-source/
│
├── apps/            # Frontend applications
│   ├── mobile/      # Flutter app cho iOS và Android
│   ├── web/         # Web dashboard (ReactJS / Flutter web)
│
├── services/        # Backend services
│   ├── api/         # Node.js/Express.js - API chính
│   ├── ai/          # Module AI (đang phát triển)
│   ├── payments/    # Service riêng xử lý thanh toán (đang phát triển)
│
├── configs/         # Cấu hình môi trường, Docker, Nginx, Env files
├── scripts/         # Script build, deploy, seed data
├── docs/            # Tài liệu kiến trúc, API Swagger, hướng dẫn
├── .gitignore       # Các file và thư mục bị git ignore
└── README.md        # File này
```

---

## 2. Hướng dẫn chạy nhanh (Development Local)

### Chạy Frontend Mobile

```bash
cd apps/mobile
flutter run
```

### Chạy Backend API

```bash
cd services/api
npm install
npm run dev
```

---

## 3. Nguyên tắc phát triển và coding standards

### 3.1 Đặt tên

| Thành phần      | Quy tắc đặt tên                     |
|-----------------|----------------------------------|
| Thư mục         | snake_case                       |
| File            | snake_case                       |
| Class, Model    | PascalCase                      |
| Biến, Hàm       | camelCase                       |
| Hằng số         | UPPER_SNAKE_CASE                |
| API endpoint    | Danh từ số nhiều, lowercase (vd: `/students/`) |

**Lưu ý:** Tên đặt rõ ràng, ngắn gọn, dùng tiếng Anh, tránh viết tắt khó hiểu.

### 3.2 Clean Code & Module

- Viết code rõ ràng, dễ hiểu, tách module logic.
- Tránh hard-code magic numbers, dùng biến hằng số.
- Comment ngắn gọn, chú thích các logic phức tạp.

### 3.3 Quản lý cấu hình

- Sử dụng file `.env` để quản lý thông tin nhạy cảm như token, URI database, API key.
- Tuyệt đối không commit file `.env` lên Git. Chỉ commit `.env.example`.

### 3.4 Quy ước API

- Thiết kế API theo chuẩn RESTful.
- Tài liệu API đầy đủ, dùng Swagger, lưu trong thư mục `docs/`.

### 3.5 Quy trình làm việc

- Mỗi feature hoặc task được phát triển trên một branch riêng.
- Không merge thẳng vào `main` hoặc `master`.
- Pull Request (PR) phải có mô tả chi tiết, rõ ràng về thay đổi.
- Commit message theo chuẩn:  
  `feat:` tính năng mới,  
  `fix:` sửa lỗi,  
  `chore:` thay đổi nhỏ,  
  `docs:` tài liệu,  
  `test:` thêm hoặc sửa test, ...
- PR phải được review và chạy test trước khi merge.

### 3.6 Quy tắc repository

- Không commit thư mục `node_modules/`, `build/`, hay file tạm.
- Không commit các file sensitive như `.env`.
- Luôn cập nhật README và tài liệu khi có thay đổi lớn.

### 3.7 Quy tắc teamwork

- Luôn review code lẫn nhau để đảm bảo chất lượng.
- Tôn trọng coding style đã thống nhất.
- Chủ động báo cáo tiến độ và các vấn đề khó khăn trong nhóm.

---

## 4. Tài liệu tham khảo & Hỗ trợ

- Tài liệu kiến trúc và API Swagger nằm trong thư mục `docs/`.
- Hướng dẫn deploy backend và mobile có trong `docs/deploy-backend.md`, `docs/deploy-android.md`, `docs/deploy-ios.md`.
- Mọi thắc mắc liên hệ team leader hoặc xem các issues trên repository.

---

Cảm ơn bạn đã sử dụng OmniMer EDU!  
Chúng tôi cam kết phát triển và hoàn thiện hệ thống để phục vụ tối ưu cho việc quản lý giáo dục.
