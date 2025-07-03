# OmniMer EDU - School Management Ecosystem

OmniMer EDU là một hệ thống quản lý trường học đa nền tảng gồm:

- Ứng dụng mobile (Flutter: iOS & Android)
- Web dashboard (Flutter web / Next.js)
- Hệ thống backend API (Node.js / Express)
- Dịch vụ AI (nâng cấp sau)
- Module Thanh toán học phí & nâng cấp gói VIP (scale sau)

---

## **1. Cấu trúc thư mục**

```bash
omnimeredu-source/
│
├── apps/            # Frontend
│   ├── mobile/      # iOS, Android (Flutter)
│   ├── web/         # Web (dành cho SuperAdmin) (ReactJS)
│
├── services/        # Backend
│   ├── api/         # Node.js/Express.js - API chính
│   ├── ai/          # AI module (phát triển sau)
│   ├── payments/    # Service riêng xử lý giao dịch thanh toán (phát triển sau)
│
├── configs/         # Docker, Nginx, Env
├── scripts/         # Build/Deploy/Seed
├── docs/            # Kiến trúc, Swagger
├── .gitignore
└── README.md

```

---

## **2. Cách chạy nhanh (Dev Local)**

_Chạy front-end:_

```bash
cd apps/mobile
flutter run
```

_Chạy back-end:_

```bash
cd services/api
npm install
npm run dev
```

---

## **3. Nguyên tắc phát triển**

**1. Nguyên tắc đặt tên**
Thành phần Quy tắc

- Folder snake_case
- File snake_case
- Class, Model PascalCase
- Biến, Hàm camelCase
- Hằng số UPPER_SNAKE_CASE
- API URL danh từ số nhiều, lowercase (ví dụ: /students/, /schools/)
  Đặt tên ngắn gọn, có ý nghĩa, không viết tắt khó hiểu, viết bằng tiếng anh => dễ đọc hơn khi code

**2. Clean Code & Module**

- Code rõ ràng, dễ đọc, logic tách module.
- Không hard-code magic number, dùng biến hằng số.
- Viết comment ngắn gọn, mô tả logic phức tạp.

**3. Quản lý cấu hình**

- Sử dụng .env để quản lý các giá trị nhạy cảm như token, DB_URI, API_KEY.
- Không push file .env lên Git, chỉ để .env.example.

**4. Quy ước API**

- Thiết kế API RESTful.
- Tài liệu đầy đủ bằng Swagger (lưu trong thư mục docs/).

**5. Quy trình làm việc**

- Mỗi sprint/task có một branch riêng.
- Không merge thẳng vào main/master.
- Pull Request phải có mô tả rõ ràng, ghi chú thay đổi.
- Mọi commit phải rõ ràng: feat:, fix:, chore:, docs:, test:, ...
- Merge code phải qua review, chạy test trước khi lên main.

**6. Quy tắc repository**

- Không push node_modules/ hoặc thư mục build.
- Không push file sensitive (.env).
- Luôn cập nhật README, sơ đồ kiến trúc khi có thay đổi lớn.

**7. Quy tắc teamwork**

- Luôn code review lẫn nhau.
- Tôn trọng coding style đã thống nhất.
- Chủ động báo tiến độ và khó khăn cho cả nhóm.
