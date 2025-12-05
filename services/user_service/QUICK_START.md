# Quick Start Guide - User Service Authentication

## Prerequisites

- Node.js (v16 or higher)
- PostgreSQL (v12 or higher)
- MongoDB (v5 or higher)
- AWS Account with S3 bucket (for avatar uploads)

## Setup Steps

### 1. Install Dependencies

```bash
cd services/user_service
npm install
```

**Note**: Việc cài đặt có thể mất vài phút do có nhiều dependencies mới (JWT, bcryptjs, AWS SDK, etc.)

### 2. Configure Environment

Copy file `.env.example` thành `.env` và cập nhật các giá trị:

```bash
cp .env.example .env
```

Sau đó edit `.env`:

```env
# Server
PORT=3001
NODE_ENV=development

# PostgreSQL (Write DB)
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=omnimeredu_user_db

# MongoDB (Read DB)
MONGODB_URI=mongodb://localhost:27017/omnimeredu_read_db

# JWT Secrets (QUAN TRỌNG: Thay đổi trong production!)
JWT_ACCESS_SECRET=change-this-to-a-long-random-secret-key-for-access-token
JWT_REFRESH_SECRET=change-this-to-a-different-long-random-secret-key-for-refresh-token
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d

# AWS S3
AWS_REGION=us-east-1
AWS_S3_BUCKET=your-bucket-name
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
```

### 3. Setup Databases

#### PostgreSQL

```sql
-- Create database
CREATE DATABASE omnimeredu_user_db;

-- Run migrations (nếu có)
-- npm run migrate
```

#### MongoDB

```bash
# Start MongoDB
# MongoDB sẽ tự động tạo database khi connect lần đầu
```

### 4. Start Development Server

```bash
npm run dev
```

Server sẽ chạy tại `http://localhost:3001`

## Testing the APIs

### 1. Register a new user

```bash
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "fullName": "Nguyễn Văn A",
    "roleKey": "Student",
    "phone": "0123456789"
  }'
```

**With Avatar Upload:**

```bash
curl -X POST http://localhost:3001/api/auth/register \
  -F "email=test@example.com" \
  -F "password=password123" \
  -F "fullName=Nguyễn Văn A" \
  -F "roleKey=Student" \
  -F "avatar=@/path/to/avatar.jpg"
```

**Response:**

```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "uuid",
      "fullName": "Nguyễn Văn A",
      "email": "test@example.com",
      "roleKey": "Student",
      "avatarUrl": "https://your-bucket.s3.amazonaws.com/avatars/avatar-uuid.jpg",
      "isVerified": false
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIs...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
    }
  }
}
```

### 2. Login

```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

**Response:**

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "tokens": {
      "accessToken": "...",
      "refreshToken": "..."
    }
  }
}
```

### 3. Get Authenticated User Info

```bash
curl -X GET http://localhost:3001/api/auth/me \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 4. Refresh Token

```bash
curl -X POST http://localhost:3001/api/auth/refresh-token \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "YOUR_REFRESH_TOKEN"
  }'
```

## Using Postman

### Setup

1. Import collection từ file `USER_SERVICE_AUTH.postman_collection.json` (nếu có)
2. Hoặc tạo requests thủ công theo documentation

### Environment Variables

Tạo environment với các biến:

- `baseUrl`: `http://localhost:3001`
- `accessToken`: (sẽ được set tự động sau login)
- `refreshToken`: (sẽ được set tự động sau login)

### Auto-save Tokens

Trong **Tests** tab của Login request, thêm:

```javascript
if (pm.response.code === 200) {
  const response = pm.response.json();
  pm.environment.set("accessToken", response.data.tokens.accessToken);
  pm.environment.set("refreshToken", response.data.tokens.refreshToken);
}
```

## Common Issues

### 1. "Cannot find module '@aws-sdk/client-s3'"

**Solution**: Chạy lại `npm install`

### 2. "Connection refused to PostgreSQL"

**Solution**:

- Kiểm tra PostgreSQL đã chạy: `sudo service postgresql start`
- Kiểm tra credentials trong `.env`

### 3. "Failed to connect to MongoDB"

**Solution**:

- Kiểm tra MongoDB đã chạy: `sudo service mongod start`
- Kiểm tra `MONGODB_URI` trong `.env`

### 4. "S3 Upload Failed"

**Solution**:

- Kiểm tra AWS credentials
- Kiểm tra bucket tồn tại
- Kiểm tra quyền IAM: `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject`

### 5. "Invalid JWT secret"

**Solution**: Đảm bảo `JWT_ACCESS_SECRET` và `JWT_REFRESH_SECRET` đã được set trong `.env`

## Development Workflow

### 1. Development Mode

```bash
npm run dev
```

Server tự động restart khi có thay đổi file (nodemon)

### 2. Build for Production

```bash
npm run build
```

### 3. Start Production

```bash
npm start
```

## File Upload Limits

- **Max file size**: 5MB
- **Allowed formats**: Images only (jpg, jpeg, png, gif, webp)
- **Storage**: Amazon S3
- **Naming**: `avatar-{userId}.{ext}`

## Security Notes

### Development

- OK to use simple JWT secrets
- OK to use local S3 (MinIO) nếu không có AWS

### Production

- **MUST** thay đổi `JWT_ACCESS_SECRET` và `JWT_REFRESH_SECRET`
- **MUST** sử dụng HTTPS
- **MUST** set proper CORS origin
- **SHOULD** use environment-specific S3 buckets
- **SHOULD** enable rate limiting
- **SHOULD** add request logging

## Next Steps

1. ✅ Complete Phase 3 auth implementation
2. [ ] Implement CQRS sync from PostgreSQL to MongoDB
3. [ ] Add middleware for JWT authentication
4. [ ] Add role-based authorization
5. [ ] Write unit tests
6. [ ] Write integration tests
7. [ ] Setup CI/CD pipeline

## Documentation

Xem thêm:

- `AUTH_README.md` - Chi tiết về authentication APIs
- `PHASE3_IMPLEMENTATION_SUMMARY.md` - Tổng kết implementation
- `docs/architecture/` - System architecture

## Support

Nếu gặp vấn đề, check:

1. Server logs: `npm run dev`
2. Database connections
3. Environment variables
4. Dependencies installed correctly

---

**Happy Coding! 🚀**
