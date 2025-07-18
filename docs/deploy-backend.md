# DEPLOY_BACKEND.md - OmniMer EDU

## Mục tiêu

Triển khai hệ thống backend Node.js để phục vụ ứng dụng Android. Trong giai đoạn đầu, backend sẽ được **deploy trên Render** (dễ test, miễn phí), sau đó có thể chuyển sang VPS (tối ưu hơn, toàn quyền kiểm soát).

---

## 1. Deploy backend Node.js trên Render (Giai đoạn test)

### Yêu cầu

| Thành phần         | Ghi chú |
|--------------------|--------|
| Backend source     | Node.js + Express, có repo trên GitHub |
| Database           | MongoDB Atlas |
| Tài khoản Render   | Đăng ký tại [https://render.com](https://render.com) |
| Android app        | Gọi API từ Render URL |

---

### Bước 1: Chuẩn bị backend

- Đảm bảo project có:
  - `package.json` có script `"start": "node index.js"`
  - Kết nối MongoDB Atlas qua `.env`
  - Không commit `.env` (`.gitignore`)

### Bước 2: Tạo Dockerfile (tuỳ chọn nếu muốn dockerize)

```dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

Lưu ý: Nếu không sử dụng docker, Render sẽ chạy "npm install" và "npm start" mặc định.

### Bước 3: Push lên GitHub

- git init
- git add .
- git commit -m "initial backend"
- git remote add origin https://github.com/<your-username>/<your-repo>.git
- git push -u origin main

### Bước 4: Deploy lên Render

- Truy cập https://render.com
- Chọn "New" → "Web Service"
- Chọn repository từ GitHub
- Cấu hình:
    1. Branch: main
    2. Build command: npm install 
    3. Start command: npm start
    4. Root directory: (Nếu backend còn nằm trong một folder nữa)
    5. Environment variables: 
        . Port = 3000
        . DATABASE_URL= ...
        . JWT_SECRET=...
    6. Bấm "Create Web Service"

### Bước 5: Lấy API URL

- Sau khi Render build xong, sẽ có URL ví dụ như: "https://backend-omnimer.onrender.com/api"
và sử dụng URL trong ứng dụng ANDROID.

