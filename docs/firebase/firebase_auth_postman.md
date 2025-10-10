# Firebase Authentication API Test with Postman

Tài liệu này hướng dẫn sử dụng Postman để test các API liên quan đến Firebase Authentication:

- [x] Đăng ký tài khoản (Sign Up)
- [x] Đăng nhập tài khoản (Sign In)
- [x] Đăng xuất (Client tự xử lý token)

## Đăng ký tài khoản (Sign Up)

# Đăng ký tài khoản trên

- **Endpoint:**  
  `POST http://localhost:8888/api/v1/auth/register`

- **Headers:**  
  `Content-Type: application/json`

- **Body (raw - JSON):**

```json
{
  "email": "schooladmin3@gmail.com",
  "password": "Tri@110911",
  // Đây là các dữ liệu có trong BaseUser Models
  "baseUserInfo": {
    "roleId": "686f95a2e588b615f7aca67d",
    "fullName": "Tri",
    "gender": "Male",
    "phone": "0982294937",
    "schoolId": "6894c51a306dac6ceab89f3c"
  },
  // Đây là các biến có trong từng role models
  "specificInfo": {
    "position": "Hiệu trưởng"
  }
}
```

---

## 2️⃣ Đăng nhập (Sign In)

- **Endpoint:**  
  `POST https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD6uR1sBS9Kz3Q8hKMDWqk2EXs8Auz9tfQ`

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
  "kind": "identitytoolkit#VerifyPasswordResponse",
  "localId": "zF6OQUHjCRNAPx5ozqEAYT4TI6g1",
  "email": "testuser@example.com",
  "displayName": "",
  "idToken": "eyJhbGciOiJSUzI...",
  "registered": true,
  "refreshToken": "AMf-vBxY0AhcZK2s_VcwykVdnoj_6...",
  "expiresIn": "3600"
}
```

---

## 3️⃣ Refresh Token (Làm mới token)

- **Endpoint:**  
  `POST https://securetoken.googleapis.com/v1/token?key=AIzaSyD6uR1sBS9Kz3Q8hKMDWqk2EXs8Auz9tfQ`

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
