# Ứng dụng Di động Flutter

## Mô tả

Ứng dụng Di động OmniMer EDU là giao diện chính cho Học sinh, Phụ huynh và Giáo viên. Nó cung cấp trải nghiệm native mượt mà trên cả hai nền tảng iOS và Android.

## Các tính năng chính

- **Xác thực**: Đăng nhập bảo mật và truy cập dựa trên vai trò.
- **Cổng thông tin Học sinh**: Xem lịch học, điểm số và lịch sử điểm danh.
- **Cổng thông tin Giáo viên**: Quản lý lớp học, điểm danh (Mã QR) và chấm điểm bài tập.
- **Cổng thông tin Phụ huynh**: Theo dõi tiến độ của con và nhận thông báo thời gian thực.
- **Chế độ Ngoại tuyến**: Các chức năng cơ bản khả dụng khi không có kết nối internet (dữ liệu được cache).

## Kiến trúc

Được xây dựng với **Clean Architecture** và **BLoC Pattern**.

- **Domain**: Logic nghiệp vụ (Pure Dart).
- **Data**: Tích hợp API & Lưu trữ cục bộ.
- **Presentation**: UI & Quản lý trạng thái (State Management).

## Các phụ thuộc (Dependencies)

- `flutter_bloc`: Quản lý trạng thái.
- `dio`: HTTP Client.
- `get_it` & `injectable`: Dependency Injection.
- `equatable`: So sánh giá trị cho States/Events.
- `json_annotation`: Serialization JSON.
