FROM nginx:alpine

# 1. Copy đè file config của bạn vào vị trí FILE CẤU HÌNH CHÍNH
# Vì context là ".", và file nằm trong thư mục gateway, nên đường dẫn nguồn là gateway/nginx.conf
COPY gateway/nginx.conf /etc/nginx/nginx.conf

# 2. (Tùy chọn) Xóa config mặc định trong conf.d để tránh xung đột nếu có
RUN rm -f /etc/nginx/conf.d/default.conf

# 3. Tạo trang lỗi custom
RUN echo '{"status":"error","message":"Service temporarily unavailable"}' > /usr/share/nginx/html/50x.html

# 4. Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/health || exit 1

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]