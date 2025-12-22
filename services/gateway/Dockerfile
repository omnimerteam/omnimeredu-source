FROM nginx:alpine

# Xóa cấu hình cũ để tránh xung đột
RUN rm  /etc/nginx/nginx.conf

# Copy custom nginx configuration
COPY gateway/nginx.conf /etc/nginx/conf.d/default.conf

# Create custom error page
RUN echo '{"status":"error","message":"Service temporarily unavailable"}' > /usr/share/nginx/html/50x.html

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/health || exit 1

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
