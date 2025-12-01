# Dịch vụ Module Mongo

## Mô tả

Dịch vụ này chịu trách nhiệm xử lý tất cả các yêu cầu **Đọc (Read)** từ ứng dụng client. Nó sử dụng MongoDB để lưu trữ dữ liệu phi chuẩn hóa, đảm bảo độ trễ thấp và tính sẵn sàng cao cho việc truy xuất dữ liệu.

## Trách nhiệm cốt lõi

- **Đọc hiệu năng cao**: Phục vụ dữ liệu cho Mobile App và Admin Web với độ trễ tối thiểu.
- **Đồng bộ hóa dữ liệu**: Tiêu thụ các sự kiện từ Dịch vụ Ghi để giữ dữ liệu luôn cập nhật.
- **Tìm kiếm & Phân tích**: Cung cấp khả năng tìm kiếm nâng cao (tìm kiếm văn bản, lọc).

## Các tính năng chính

- **Hồ sơ học sinh**: Truy xuất nhanh chi tiết đầy đủ của học sinh.
- **Lịch học**: Chế độ xem tổng hợp về thời gian và địa điểm lớp học.
- **Báo cáo**: Dữ liệu được tối ưu hóa cho việc đọc để tạo các báo cáo đơn giản.

## Các API Endpoint (Chỉ Đọc)

- `GET /students`: Danh sách học sinh (có phân trang/tìm kiếm).
- `GET /students/:id`: Lấy chi tiết hồ sơ học sinh.
- `GET /classes`: Danh sách lớp học.
- `GET /attendance/history`: Lấy lịch sử điểm danh.

## Các phụ thuộc (Dependencies)

- MongoDB
- Mongoose
- Message Broker Client (RabbitMQ/Kafka/AWS SNS)
