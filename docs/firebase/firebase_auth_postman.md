
# 📮 Firebase Authentication API Test with Postman

Tài liệu này hướng dẫn sử dụng Postman để test các API liên quan đến Firebase Authentication:

- [x] Đăng ký tài khoản (Sign Up)
- [x] Đăng nhập tài khoản (Sign In)
- [x] Đăng xuất (Client tự xử lý token)

> **Base URL (Firebase Auth REST API):**
> ```
> https://identitytoolkit.googleapis.com/v1
> ```
> **API Key:** (Thay bằng của bạn)  
> ```
> <YOUR_FIREBASE_API_KEY>
> ```

---

## 1️⃣ Đăng ký tài khoản (Sign Up)

- **Endpoint:**  
  `POST https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=<YOUR_FIREBASE_API_KEY>`

- **Headers:**  
  `Content-Type: application/json`

- **Body (raw - JSON):**
```json
{
  "email": "testuser@example.com",
  "password": "12345678",
  "returnSecureToken": true
}
```

- **Response mẫu:**
```json
{
  "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6Ij...",
  "email": "testuser@example.com",
  "refreshToken": "AEu4IL3...",
  "expiresIn": "3600",
  "localId": "rWEx8n..."
}
```

---

## 2️⃣ Đăng nhập (Sign In)

- **Endpoint:**  
  `POST https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=<YOUR_FIREBASE_API_KEY>`

- **Headers:**  
  `Content-Type: application/json`

- **Body (raw - JSON):**
```json
{
  "email": "testuser@example.com",
  "password": "12345678",
  "returnSecureToken": true
}
```

- **Response mẫu:**
```json
{
  "idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6Ij...",
  "email": "testuser@example.com",
  "refreshToken": "AEu4IL3...",
  "expiresIn": "3600",
  "localId": "rWEx8n..."
}
```

---

## 3️⃣ Refresh Token (Làm mới token)

- **Endpoint:**  
  `POST https://securetoken.googleapis.com/v1/token?key=<YOUR_FIREBASE_API_KEY>`

- **Headers:**  
  `Content-Type: application/x-www-form-urlencoded`

- **Body (x-www-form-urlencoded):**
```
grant_type=refresh_token
refresh_token=<REFRESH_TOKEN>
```

- **Response mẫu:**
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6Ij...",
  "expires_in": "3600",
  "token_type": "Bearer",
  "refresh_token": "AEu4IL3...",
  "id_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6Ij...",
  "user_id": "rWEx8n...",
  "project_id": "your-project-id"
}
```

---

## 4️⃣ Đăng xuất (Sign Out)

> Firebase REST API không có endpoint đăng xuất. Việc **sign out** là do client thực hiện bằng cách **xoá `idToken` và `refreshToken`** khỏi bộ nhớ của ứng dụng.

---

## 📌 Lưu ý

- `idToken`: Sử dụng để xác thực các API bảo mật (ví dụ: đọc dữ liệu Firebase Database hoặc Firestore).
- `refreshToken`: Dùng để lấy lại `idToken` khi hết hạn.
- Tất cả các API đều yêu cầu `Content-Type: application/json` trừ khi dùng `x-www-form-urlencoded` trong refresh token.

---

## ✅ Bonus: Cách tạo `Postman Environment`

- **Environment Variables:**
  - `FIREBASE_API_KEY` → `your-firebase-api-key`
  - `REFRESH_TOKEN` → token lưu được sau login
  - `ID_TOKEN` → sau khi đăng nhập thành công

- **Sử dụng trong URL:**
```http
https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={{FIREBASE_API_KEY}}
```
