# Hướng dẫn Chuyển đổi từ Firebase Auth sang JWT (Access Token + Refresh Token)

Tài liệu này hướng dẫn chi tiết các bước chuyển đổi hệ thống xác thực từ Firebase Auth sang sử dụng cặp **Access Token** (ngắn hạn) và **Refresh Token** (dài hạn).

## 1. Cài đặt thư viện

Hệ thống hiện tại đã có sẵn các thư viện cần thiết trong `package.json`.

- `jsonwebtoken`
- `bcryptjs`

## 2. Cấu hình Environment

Cập nhật file `.env` với các secret key riêng biệt cho Access và Refresh token:

```env
JWT_ACCESS_SECRET=your_access_token_secret_here
JWT_ACCESS_EXPIRES_IN=15m

JWT_REFRESH_SECRET=your_refresh_token_secret_here
JWT_REFRESH_EXPIRES_IN=7d
```

## 3. Cập nhật JwtHelper

Cập nhật `services/api/src/common/utils/JwtHelper.ts` để hỗ trợ cả 2 loại token.

```typescript
import jwt from "jsonwebtoken";

const ACCESS_SECRET = process.env.JWT_ACCESS_SECRET || "access_secret";
const ACCESS_EXPIRES = process.env.JWT_ACCESS_EXPIRES_IN || "15m";

const REFRESH_SECRET = process.env.JWT_REFRESH_SECRET || "refresh_secret";
const REFRESH_EXPIRES = process.env.JWT_REFRESH_EXPIRES_IN || "7d";

export const generateAccessToken = (payload: object): string => {
  return jwt.sign(payload, ACCESS_SECRET, { expiresIn: ACCESS_EXPIRES as any });
};

export const generateRefreshToken = (payload: object): string => {
  return jwt.sign(payload, REFRESH_SECRET, {
    expiresIn: REFRESH_EXPIRES as any,
  });
};

export const verifyAccessToken = (token: string): any => {
  try {
    return jwt.verify(token, ACCESS_SECRET);
  } catch (error) {
    return null;
  }
};

export const verifyRefreshToken = (token: string): any => {
  try {
    return jwt.verify(token, REFRESH_SECRET);
  } catch (error) {
    return null;
  }
};
```

## 4. Cập nhật AccountRepository

Cần thêm method `findByEmail` và đảm bảo có thể lưu/update Refresh Token vào DB để quản lý phiên đăng nhập (logout, revoke).

File: `services/api/src/domain/repositories/user/account.repository.ts`

```typescript
// Thêm vào AccountRepository

async findByEmail(email: string) {
  return this.model.findOne({ email }).populate({
    path: "userId",
    select: "roleId isActive fullName avatarUrl",
    populate: { path: "roleId", select: "name" }
  });
}

// Hàm lưu refresh token (tận dụng field 'token' đã có trong model Account hoặc tạo field mới 'refreshToken' nếu cần schema clear hơn)
async updateRefreshToken(userId: string, refreshToken: string | null) {
  // Ở đây giả sử dùng field 'token' trong Account model để lưu refreshToken
  return this.model.updateOne({ userId }, { token: refreshToken });
}
```

## 5. Tạo Middleware verify Access Token

File: `services/api/src/common/api/middlewares/verifyJwtToken.ts`

Logic verify token dùng `verifyAccessToken`.

```typescript
import { Request, Response, NextFunction } from "express";
import { verifyAccessToken } from "../../utils/JwtHelper";
import { sendUnauthorized } from "../../utils/ResponseHelper";

export const verifyJwtToken = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const authHeader = req.headers.authorization;

  if (!authHeader?.startsWith("Bearer ")) {
    sendUnauthorized(res, "Token không hợp lệ hoặc không được cung cấp");
    return;
  }

  const token = authHeader.split("Bearer ")[1].trim();
  const decoded: any = verifyAccessToken(token);

  if (!decoded) {
    sendUnauthorized(res, "Access Token hết hạn hoặc không hợp lệ");
    return;
  }

  req.user = { id: decoded.userId };
  req.role = decoded.role;
  next();
};
```

## 6. Cập nhật AuthService

File: `services/api/src/domain/services/user/auth.service.ts`

Cần triển khai:

1.  **Login**: Trả về Access Token + Refresh Token. Lưu Refresh Token vào DB.
2.  **RefreshToken**: Nhận Refresh Token từ client -> Verify -> Check DB -> Cấp Access Token mới.
3.  **Logout**: Xóa Refresh Token trong DB.

```typescript
import { generateAccessToken, generateRefreshToken, verifyRefreshToken } from "../../../common/utils/JwtHelper";

// ... Trong AuthService Class

// Sửa lại hàm Login
async login(email: string, password: string) {
    // 1. Tìm user & Verify password (như cũ)
    const account = await this.accountRepository.findByEmail(email);
    // ... check valid password

    const user = account.userId as any;
    const roleName = user?.roleId?.name;

    // 2. Generate Tokens
    const payload = { userId: user._id, role: roleName, email: account.email };

    const accessToken = generateAccessToken(payload);
    const refreshToken = generateRefreshToken(payload);

    // 3. Lưu refresh token vào DB
    await this.accountRepository.updateRefreshToken(user._id, refreshToken);

    return {
        user,
        accessToken,
        refreshToken,
        role: roleName
    };
}

// Thêm hàm làm mới token
async refreshToken(clientRefreshToken: string) {
    // 1. Verify token signature
    const decoded: any = verifyRefreshToken(clientRefreshToken);
    if (!decoded) {
        throw new HttpError(403, "Refresh Token không hợp lệ hoặc hết hạn");
    }

    // 2. Check token trong DB (phòng trường hợp user đã logout hoặc bị revoke)
    const account = await this.accountRepository.findAccountByUserId(decoded.userId);
    if (!account || account.token !== clientRefreshToken) {
        throw new HttpError(403, "Refresh Token đã bị thu hồi hoặc không khớp");
    }

    // 3. Issue Access Token mới
    const payload = { userId: decoded.userId, role: decoded.role, email: decoded.email };
    const newAccessToken = generateAccessToken(payload);

    // (Optional) Có thể cấp mới cả Refresh Token nếu muốn cơ chế Refresh Token Rotation

    return {
        accessToken: newAccessToken
    };
}

// Thêm hàm Logout
async logout(userId: string) {
    await this.accountRepository.updateRefreshToken(userId, null);
}
```

## 7. Cập nhật AuthController

Thêm method `refreshToken` và `logout`.

```typescript
// services/api/src/domain/controllers/user/auth.controller.ts

async refreshToken(req: Request, res: Response, next: NextFunction) {
    try {
        const { refreshToken } = req.body;
        if (!refreshToken) {
             sendError(res, "Thiếu refreshToken", 400); return;
        }
        const result = await this.authService.refreshToken(refreshToken);
        sendSuccess(res, result, "Làm mới token thành công");
    } catch (error) {
        next(error);
    }
}

async logout(req: Request, res: Response, next: NextFunction) {
    try {
        const userId = req.user?.id; // Lấy từ middleware verifyJwtToken
        if (userId) {
            await this.authService.logout(userId);
        }
        sendSuccess(res, null, "Đăng xuất thành công");
    } catch(err) { next(err); }
}
```

## 8. Cập nhật Routes

Thêm routes mới.

```typescript
// POST /api/users/refresh-token
router.post(
  "/refresh-token",
  // validateData({ body: ... }), // Nên có schema validate body { refreshToken }
  (req, res, next) => authController.refreshToken(req, res, next)
);

// POST /api/users/logout
router.post(
  "/logout",
  verifyJwtToken, // Yêu cầu đăng nhập trước khi logout
  (req, res, next) => authController.logout(req, res, next)
);
```
