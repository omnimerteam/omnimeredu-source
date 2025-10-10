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
┌───────────────────────────────┐
│           Client              │
│ ┌────────────┬─────────────┐  │
│ │ Flutter    │ ReactJS Web │  │
│ └────────────┴─────────────┘  │
└──────────────┬────────────────┘
               │ HTTPS/REST
               ▼
┌───────────────────────────────┐
│          API Server           │
│ (Node.js + Express.js + TS)   │
│                               │
│ - Verify Firebase ID Token    │
│ - CRUD Business Logic         │
│ - Call MongoDB Atlas          │
│ - Generate Signed URLs for    │
│   Cloud Storage               │
│ - Serve Swagger Docs          │
└──────────────┬────────────────┘
               │
      ┌────────┴─────────┐
      ▼                  ▼
┌──────────────┐  ┌────────────────┐
│ MongoDB Atlas│  │Cloud Storage   │
│   (User,     │  │(Images, Files) │
│  Data Logic) │  └────────────────┘
└──────────────┘

[Auth]: Firebase Auth quản lý người dùng, cấp ID Token.
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

- Xác thực Firebase Auth.
- API HTTPS, rate limit, SSL, Cloudflare.
- Token secrets trong `.env`.
- Phân quyền SuperAdmin, Quản lý trường, Giáo viên, Học sinh.

---

## 4. DevOps & Triển khai

**Dev & Testing**

- Backend API:

* Railway, Render, hoặc Vercel (Serverless Function nếu nhẹ).
* Tự động deploy branch develop.
* .env.development chứa MONGODB_URI_DEV, FIREBASE_ADMIN_SDK_KEY.

- Frontend Flutter:
  +Mobile build cài .apk hoặc test iOS simulator.
  +ReactJS Web: Vercel, Netlify.
  +Kết nối backend staging.

- MongoDB Atlas: Sử dụng bảng free

- Cloud Storage & Firebase:

**Production**

- Backend API:

* Deploy Railway/Render/EC2 (nếu cần custom infra).
* Chạy NGINX reverse proxy + PM2.
* Sử dụng TLS/SSL (Cloudflare Proxy).

- MongoDB Atlas:

* Cluster M10+ (scale auto).
* Bật IP Whitelist, Database User Access.

- Firebase Auth:

* Cùng project hoặc tách project prod để tách người dùng thật.

- Cloud Storage:

* Tích hợp Google Cloud Storage (hoặc S3).
* Chỉ public URL file qua Signed URL.

- Domain:

* Cloudflare DNS + HTTPS Proxy.

- Monitoring: UptimeRobot.

> File cần update khi thay đổi kiến trúc.
