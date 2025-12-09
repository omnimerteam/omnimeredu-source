# Dịch vụ Module Xác thực (Auth)

## Mô tả

Dịch vụ này xử lý tất cả logic xác thực và ủy quyền cho hệ thống OmniMer EDU. Nó đóng vai trò là nhà cung cấp danh tính tập trung.

## Các tính năng chính

- **Đăng ký người dùng**: Tạo tài khoản mới cho Học sinh, Giáo viên và Phụ huynh.
- **Xác thực**: Đăng nhập bảo mật sử dụng Email/Mật khẩu.
- **Quản lý Token**: Cấp phát và xác thực JWT Access Tokens và Refresh Tokens.
- **Ủy quyền**: Hỗ trợ middleware kiểm soát truy cập dựa trên vai trò (RBAC).
- **Bảo mật**: Băm mật khẩu (bcrypt/argon2), Giới hạn tốc độ (Rate limiting).

## Các API Endpoint (Tổng quan)

- `POST /auth/register`: Đăng ký người dùng mới.
- `POST /auth/login`: Xác thực người dùng và trả về token.
- `POST /auth/refresh`: Làm mới access token.
- `POST /auth/logout`: Vô hiệu hóa token.
- `GET /auth/me`: Lấy thông tin hồ sơ người dùng hiện tại.

## Các phụ thuộc (Dependencies)

- Node.js
- TypeScript
- Thư viện JWT (jsonwebtoken)
- Trình điều khiển cơ sở dữ liệu (TypeORM/Prisma)
