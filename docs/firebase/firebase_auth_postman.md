# Firebase Authentication API Test with Postman

Tài liệu này hướng dẫn sử dụng Postman để test các API liên quan đến Firebase Authentication:

- [x] Đăng ký tài khoản (Sign Up)
- [x] Đăng nhập tài khoản (Sign In)
- [x] Đăng xuất (Client tự xử lý token)

## Đăng ký tài khoản (Sign Up)

# Đăng ký tài khoản trên FB_Auth

- **Endpoint:**  
  `POST https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD6uR1sBS9Kz3Q8hKMDWqk2EXs8Auz9tfQ`

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
  "kind": "identitytoolkit#SignupNewUserResponse",
  "idToken": "eyJhbGciOiJSUzbGciOiJSUz...",
  "email": "testuser@example.com",
  "refreshToken": "AMf-vByfZVEJN4I8oHdnK1-_-2xaCbZMu-HP1TsHP1Ts...",
  "expiresIn": "3600",
  "localId": "zF6OQUHjCRNAPx5ozqEAYT4TI6g1" //uid
}
```

# Đăng ký tài khoản trên backend

- **Endpoint:**  
  `POST http://localhost:8888/api/v1/auth/register`

- **Headers:**  
  `Content-Type: application/json`

- **Body (raw - JSON):**

```json
{
  "uid": "3TPHvGXcfEWUb921ppDdQ5uPqpK2",
  "email": "tritesting123@example.com",
  "password": "123456",
  "roleId": "686f95a2e588b615f7aca67e", // RoleId của Teacher
  "fullName": "Tri",
  "gender": "Male",
  "phone": "454353453",
  // Cái này là thêm các trường phù hợp với role
  "schoolId": "6878ae00072ff5aee0099cc2",
  "literacy": "Đại học Sư phạm TP.HCM",
  "subjects": ["Toán", "Lý"]
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
