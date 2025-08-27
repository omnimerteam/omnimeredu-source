# Dùng Node.js bản chính thức (có thể chọn 20 hoặc 22 nếu code support)
FROM node:24-slim

# Set thư mục làm việc trong container
WORKDIR /usr/src/app

# Copy file package.json và package-lock.json (nếu có)
COPY package*.json ./

# Cài đặt dependencies (chỉ cài cho production, bỏ devDependencies)
RUN npm install --only=production

# Copy toàn bộ source code vào container
COPY . .

# App sẽ đọc PORT từ env. Chỉ là tài liệu.
EXPOSE 3000

# Command để chạy app khi container start
CMD ["npm", "start"]
