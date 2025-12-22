# Dịch vụ Module RDS

## Mô tả

Dịch vụ này là cốt lõi của hệ thống backend, chịu trách nhiệm cho tất cả các thao tác **Ghi (Write)** và logic nghiệp vụ phức tạp. Nó đảm bảo tính toàn vẹn dữ liệu và đóng vai trò là nguồn sự thật (source of truth) chính.

## Trách nhiệm cốt lõi

- **Tính toàn vẹn dữ liệu**: Đảm bảo các thuộc tính ACID cho tất cả các giao dịch.
- **Người kiểm duyệt (Gatekeeper)**: Xác thực tất cả dữ liệu đầu vào trước khi lưu trữ.
- **Đồng bộ hóa**: Công bố các thay đổi dữ liệu sang Dịch vụ Đọc (Module Mongo).

## Các Module chính

### 1. Module Thanh toán (Payment Module)

- Tích hợp với MoMo, ZaloPay, ViettelPay.
- Tạo mã QR cho học phí.
- Quản lý lịch sử giao dịch.

### 2. Module Điểm danh (Attendance Module)

- Check-in/check-out dựa trên mã QR.
- Thông báo thời gian thực cho phụ huynh.

### 3. Quản lý Người dùng/Lớp học

- Các thao tác CRUD cho Học sinh, Giáo viên, Lớp học.

## Các API Endpoint (Chỉ Ghi)

- `POST /students`: Tạo học sinh mới.
- `PUT /students/:id`: Cập nhật thông tin học sinh.
- `POST /payments/init`: Khởi tạo thanh toán.
- `POST /attendance/check-in`: Đánh dấu điểm danh.

## Các phụ thuộc (Dependencies)

- PostgreSQL/MySQL
- Message Broker (RabbitMQ/Kafka/AWS SNS)
