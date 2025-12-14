# Giai đoạn 5: API Gateway & Auth Integration - Hoàn thành

## Tổng quan

Giai đoạn này thiết lập xác thực JWT thống nhất và API Gateway cho hệ thống microservices.

## ✅ Các thành phần đã triển khai

### 1. Shared Auth Module (`shared-lib/src/auth/`)

#### AuthUtils.ts

- `hashPassword()` - Hash password với bcrypt
- `comparePassword()` - So sánh password
- `generateAccessToken()` - Tạo JWT access token (15 phút)
- `generateRefreshToken()` - Tạo JWT refresh token (7 ngày)
- `verifyAccessToken()` - Xác thực access token
- `verifyRefreshToken()` - Xác thực refresh token
- `generateTokenPair()` - Tạo cặp tokens
- `extractBearerToken()` - Trích xuất token từ Authorization header

#### authMiddleware.ts

- `authMiddleware` - Middleware xác thực JWT
- `roleMiddleware` - Middleware phân quyền theo role
- `optionalAuthMiddleware` - Middleware xác thực tùy chọn
- `schoolAuthMiddleware` - Middleware giới hạn truy cập theo trường

#### TokenPayload Interface

```typescript
interface TokenPayload {
  userId: string;
  email: string;
  roleKey: string;
  schoolId?: string;
  tokenId?: string;
}
```

### 2. API Gateway (`gateway/`)

#### nginx.conf

- Rate limiting: 10 req/s cho API chung, 5 req/s cho auth endpoints
- Security headers (X-Frame-Options, X-XSS-Protection, etc.)
- Health check endpoint
- Upstream định nghĩa cho user_service và payment_service
- Gzip compression

#### Routing Configuration

| Path Pattern           | Service         | Port |
| ---------------------- | --------------- | ---- |
| `/api/v1/auth/*`       | user_service    | 3001 |
| `/api/v1/users/*`      | user_service    | 3001 |
| `/api/v1/schools/*`    | user_service    | 3001 |
| `/api/v1/classes/*`    | user_service    | 3001 |
| `/api/v1/grades/*`     | user_service    | 3001 |
| `/api/v1/attendance/*` | payment_service | 3002 |
| `/api/v1/payments/*`   | payment_service | 3002 |
| `/api/v1/tuition/*`    | payment_service | 3002 |
| `/api/v1/holidays/*`   | payment_service | 3002 |

### 3. Payment-Attendance Service Auth Integration

#### Protected Routes với Role-Based Access Control:

| Route                                    | Method | Roles Allowed                    |
| ---------------------------------------- | ------ | -------------------------------- |
| `/attendance`                            | POST   | Teacher, SchoolAdmin, SuperAdmin |
| `/attendance/:id`                        | GET    | All authenticated                |
| `/attendance/:id/records/bulk`           | POST   | Teacher, SchoolAdmin, SuperAdmin |
| `/attendance/:id/records`                | GET    | All authenticated                |
| `/attendance/records/:id`                | PATCH  | Teacher, SchoolAdmin, SuperAdmin |
| `/attendance/reports/monthly/:classId`   | GET    | Teacher, SchoolAdmin, SuperAdmin |
| `/attendance/history/student/:studentId` | GET    | All authenticated                |
| `/tuition`                               | POST   | SchoolAdmin, SuperAdmin          |
| `/tuition/:id`                           | GET    | All authenticated                |
| `/tuition/:id/confirm`                   | POST   | SchoolAdmin, SuperAdmin          |
| `/payments`                              | POST   | SchoolAdmin, SuperAdmin          |
| `/payments/student/:studentId`           | GET    | All authenticated                |
| `/payments/callback`                     | POST   | No auth (webhook)                |
| `/payments/history`                      | GET    | SchoolAdmin, SuperAdmin          |
| `/payments/summary/student/:studentId`   | GET    | All authenticated                |
| `/holidays`                              | POST   | SchoolAdmin, SuperAdmin          |
| `/holidays`                              | GET    | All authenticated                |
| `/holidays/check`                        | GET    | All authenticated                |

### 4. Docker Compose Updates

#### Shared Environment Variables

```yaml
JWT_ACCESS_SECRET=${JWT_ACCESS_SECRET:-your-super-secret-access-token-key}
JWT_REFRESH_SECRET=${JWT_REFRESH_SECRET:-your-super-secret-refresh-token-key}
```

#### Network Configuration

- Tất cả services nằm trong `omnimeredu_network`
- API Gateway expose port 80/443
- Internal services không expose trực tiếp ra ngoài (chỉ qua gateway)

## 🔧 Cách sử dụng

### 1. Cài đặt Dependencies

```bash
# Shared Lib
cd services/shared-lib
npm install
npm run build

# Payment Attendance Service
cd ../payment-attendance-service
npm install
```

### 2. Cấu hình Environment Variables

Tạo file `.env` trong thư mục `services/`:

```env
JWT_ACCESS_SECRET=your-super-secure-access-secret-key
JWT_REFRESH_SECRET=your-super-secure-refresh-secret-key
```

### 3. Chạy với Docker Compose

```bash
cd services
docker-compose up -d
```

### 4. Gọi API với Token

```bash
# Đăng nhập để lấy token
TOKEN=$(curl -X POST http://localhost/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password"}' \
  | jq -r '.data.accessToken')

# Gọi protected API
curl -X GET http://localhost/api/v1/attendance \
  -H "Authorization: Bearer $TOKEN"
```

## 📋 Files đã tạo/cập nhật

### Mới tạo:

- `shared-lib/src/auth/AuthUtils.ts`
- `shared-lib/src/auth/authMiddleware.ts`
- `shared-lib/src/auth/index.ts`
- `gateway/nginx.conf`
- `gateway/Dockerfile`
- `payment-attendance-service/src/presentation/middleware/auth.ts`

### Đã cập nhật:

- `shared-lib/package.json` - Thêm dependencies
- `shared-lib/src/index.ts` - Export auth module
- `docker-compose.yml` - Thêm gateway, shared secrets
- `.env.example` - Thêm JWT configuration
- `payment-attendance-service/package.json` - Thêm jsonwebtoken
- `payment-attendance-service/src/presentation/routes/*.ts` - Thêm auth middleware
- `plan.md` - Đánh dấu hoàn thành

## 🔒 Security Notes

1. **Thay đổi JWT secrets trong production** - Các giá trị mặc định chỉ dùng cho development
2. **Rate limiting** đã được cấu hình để chống brute force
3. **HTTPS** cần được enable trong production (đã có comment trong nginx.conf)
4. **Token refresh** nên được implement ở client để tránh gọi lại login

## ➡️ Bước tiếp theo: Giai đoạn 6

- Viết Dockerfile cho từng service
- Setup CI/CD pipeline
- Deploy lên VPS/AWS
- Testing (Unit, Integration, Load)
