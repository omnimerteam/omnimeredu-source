# Dùng Node.js bản chính thức (có thể chọn 20 hoặc 22 nếu code support)
FROM node:24-slim

# Set thư mục làm việc trong container
WORKDIR /usr/src/app

# Copy file package.json và package-lock.json (nếu có)
COPY services/api/package*.json ./

# Cài đặt dependencies (chỉ cài cho production, bỏ devDependencies)
RUN npm install --omit=dev

# Copy toàn bộ source code vào container
COPY . .

# App sẽ đọc PORT từ env. Chỉ là tài liệu.
EXPOSE 3000

# Command để chạy app khi container start
CMD ["npm", "start"]
