# ARCHITECTURE.md - OmniMer EDU

## Mục tiêu hệ thống

- Quản lý trường học, lớp học, giáo viên, học sinh.
- Quản lý điểm danh, tính học phí, báo cáo.
- Triển khai đa nền tảng: Mobile (Flutter), Web (Flutter Web/Next.js).
- Tích hợp AI & thanh toán trong giai đoạn mở rộng.
- Dễ mở rộng, dễ bảo trì, DevOps-friendly.

---

## 1. Sơ đồ tổng quan

```
┌──────────────┐       ┌─────────────┐        ┌───────────────┐
│  Flutter App │<----->│ API Service │<------>│  MongoDB Atlas│
│  (Web/Mobile)│       │ (Node/Express) │     │ (Database)    │
└──────────────┘       └─────────────┘        └───────────────┘
                               │
                          ┌───────────────┐
                          │  AI Service   │ (FastAPI/Node)
                          └───────────────┘
                               │
                       ┌──────────────┐
                       │   Payments   │ (Momo/ZaloPay)
                       └──────────────┘
```

---

## 2. Thành phần chính

### 🧩 Frontend (apps/)

- `mobile/`: Flutter App (Android/iOS).
- `web/`: Flutter Web hoặc Next.js.
- Giao diện người dùng, auth, gọi API, hiển thị dữ liệu.

### 🧩 Backend (services/api/)

- Node.js + Express.js, cấu trúc MVC.
- Mongoose schemas, routes, controllers, services.
- Quản lý session, JWT auth, phân quyền.
- Swagger Docs (`docs/`).

### 🧩 AI Service (services/ai/)

- Mô hình ML (phân tích, gợi ý).
- FastAPI/Python hoặc Node.

### 🧩 Database

- MongoDB Atlas Cloud, Mongoose ODM.
- Sử dụng Index, Aggregation.

### 🧩 Payment Gateways

- Tích hợp Momo, ZaloPay, Bank.
- Quản lý giao dịch, log thanh toán.

---

## 3. Bảo mật

- Xác thực JWT/OAuth2/Firebase Auth.
- API HTTPS, rate limit, SSL, Cloudflare.
- Token secrets trong `.env`.
- Phân quyền SuperAdmin, Quản lý trường, Giáo viên, Học sinh.

---

## 4. DevOps & Triển khai

- Railway, Render, Vercel, Firebase Hosting.
- NGINX/Cloudflare proxy.
- Docker, docker-compose.yml.
- Theo dõi uptime với UptimeRobot.

---

> File cần update khi thay đổi kiến trúc.
