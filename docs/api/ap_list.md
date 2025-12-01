# Danh sách API Endpoints

Tài liệu này liệt kê tất cả các API endpoints đã được triển khai trong hệ thống, dựa trên mã nguồn trong `services/api/src/common/api/routes`.

## 1. Auth Module (Xác thực)

Base URL: `/api/v1/auth`

- `POST /register`: Đăng ký tài khoản mới.
- `GET /login`: Đăng nhập (lấy thông tin user từ Firebase Token).
- `PATCH /change-password`: Đổi mật khẩu.
- `PATCH /forget-password`: Quên mật khẩu.

## 2. Student Module (Học sinh)

Base URL: `/api/v1/students`

- `GET /`: Lấy danh sách học sinh (có phân trang, lọc).
- `GET /student-selector`: Lấy danh sách học sinh cho select box.
- `GET /:id`: Lấy chi tiết học sinh.
- `POST /`: Tạo học sinh mới.
- `PUT /:id`: Cập nhật thông tin học sinh.
- `DELETE /:id`: Xóa học sinh.

## 3. Teacher Module (Giáo viên)

Base URL: `/api/v1/teachers`

- `GET /`: Lấy danh sách giáo viên.
- `GET /:id`: Lấy chi tiết giáo viên.
- `POST /`: Tạo giáo viên mới.
- `PUT /:id`: Cập nhật thông tin giáo viên.
- `DELETE /:id`: Xóa giáo viên.

## 4. Class Module (Lớp học)

Base URL: `/api/v1/classes`

- `GET /`: Lấy danh sách lớp học.
- `GET /view-model/class-detail`: Lấy danh sách lớp dưới dạng view model chi tiết.
- `GET /view-model/class-detail/:id`: Lấy chi tiết lớp dưới dạng view model.
- `GET /:id`: Lấy chi tiết lớp học.
- `POST /`: Tạo lớp học mới.
- `PUT /:id`: Cập nhật lớp học.
- `DELETE /:id`: Xóa lớp học.
- `POST /:id/students/add`: Thêm học sinh vào lớp.
- `POST /:id/students/remove`: Xóa học sinh khỏi lớp.
- `POST /:id/students/transfer`: Chuyển học sinh sang lớp khác.
- `GET /schools/search`: Tìm kiếm lớp học trong trường.

## 5. Attendance Module (Điểm danh)

Base URL: `/api/v1/attendances`

- `GET /`: Lấy danh sách điểm danh.
- `GET /:id`: Lấy chi tiết điểm danh.
- `GET /attendance-record-view/:id`: Lấy view chi tiết bản ghi điểm danh.
- `GET /class-attendance-record/view`: Lấy view điểm danh của lớp.
- `POST /`: Tạo bản điểm danh mới.
- `POST /initialize-class-attendance`: Khởi tạo điểm danh cho lớp.
- `PUT /:id`: Cập nhật điểm danh.
- `DELETE /:id`: Xóa điểm danh.
- `GET /:id/export`: Xuất dữ liệu điểm danh ra Excel.

## 6. Details Record Module (Chi tiết điểm danh)

Base URL: `/api/v1/details-records`

- `GET /`: Lấy tất cả chi tiết điểm danh.
- `GET /attendance-records/:attendanceId`: Lấy chi tiết theo ID điểm danh.
- `GET /:id`: Lấy chi tiết theo ID.
- `POST /`: Tạo chi tiết điểm danh.
- `PUT /:id`: Cập nhật chi tiết điểm danh.
- `PATCH /update-status/:id`: Cập nhật trạng thái điểm danh.
- `DELETE /:id`: Xóa chi tiết điểm danh.

## 7. School Module (Trường học)

Base URL: `/api/v1/schools`

- `GET /search/query`: Tìm kiếm trường học.
- `GET /school-admin`: Lấy chi tiết trường cho School Admin.
- `GET /`: Lấy danh sách trường học.
- `POST /`: Tạo trường học mới.
- `PUT /`: Cập nhật thông tin trường học.
- `DELETE /`: Xóa trường học.

## 8. School Admin Module (Quản trị viên trường)

Base URL: `/api/v1/school-admins`

- `GET /`: Lấy danh sách School Admin.
- `GET /:id`: Lấy chi tiết School Admin.
- `POST /`: Tạo School Admin mới.
- `PUT /:id`: Cập nhật School Admin.
- `PATCH /update-position/:id`: Cập nhật chức vụ.
- `DELETE /:id`: Xóa School Admin.

## 9. School Admin Dashboard Module (Bảng điều khiển School Admin)

Base URL: `/api/v1/school-admin-dashboard`

- `GET /get-summary`: Lấy thông tin tóm tắt.
- `GET /get-school-attendance-stats`: Lấy thống kê điểm danh của trường.

## 10. Teaching Assignment Module (Phân công giảng dạy)

Base URL: `/api/v1/teaching-assignment`

- `GET /`: Lấy danh sách phân công.
- `GET /:id`: Lấy chi tiết phân công.
- `GET /teacherId-schoolId-classId/:teacherId/:schoolId/:classId`: Lấy phân công theo Teacher, School, Class.
- `POST /`: Tạo phân công mới.
- `PUT /:id`: Cập nhật phân công.
- `DELETE /:id`: Xóa phân công.
- `GET /teacherId-schoolId/:teacherId/:schoolId`: Lấy phân công của giáo viên trong trường.
- `GET /teacherId/:teacherId`: Lấy các lớp giáo viên được phân công.

## 11. Grade Module (Khối lớp)

Base URL: `/api/v1/grades`

- `GET /`: Lấy danh sách khối.
- `GET /:id`: Lấy chi tiết khối.
- `POST /`: Tạo khối mới.
- `PUT /:id`: Cập nhật khối.
- `DELETE /:id`: Xóa khối.
- `GET /select/box`: Lấy danh sách khối cho select box.

## 12. Membership Request Module (Yêu cầu tham gia)

Base URL: `/api/v1/membership-request`

- `GET /`: Lấy danh sách yêu cầu.
- `GET /:id`: Lấy chi tiết yêu cầu.
- `POST /`: Tạo yêu cầu mới.
- `PUT /:id`: Cập nhật yêu cầu.
- `DELETE /:id`: Xóa yêu cầu.
- `PATCH /:id/status`: Cập nhật trạng thái yêu cầu.

## 13. News Module (Tin tức)

Base URL: `/api/v1/news`

- `GET /:schoolId`: Lấy tin tức theo trường.
- `GET /:id`: Lấy chi tiết tin tức.
- `POST /`: Tạo tin tức mới.
- `PUT /:id`: Cập nhật tin tức.
- `PATCH /:id`: Cập nhật chế độ hiển thị tin tức.
- `DELETE /:id`: Xóa tin tức.

## 14. Personnel Module (Nhân sự)

Base URL: `/api/v1/personnel`

- `GET /`: Lấy danh sách nhân sự.
- `PATCH /update-role/:id`: Cập nhật vai trò.
- `PATCH /update-verified/:id`: Cập nhật trạng thái xác thực.
- `PATCH /dismiss/:id`: Sa thải nhân sự.
- `GET /:id`: Lấy chi tiết nhân sự.
- `PATCH /update-avatar`: Cập nhật avatar.

## 15. Role Module (Vai trò)

Base URL: `/api/v1/roles`

- `GET /`: Lấy danh sách vai trò.
- `GET /roles-personnel`: Lấy danh sách vai trò nhân sự.

## 16. VIP Package Module (Gói VIP)

Base URL: `/api/v1/vip-packages`

- `GET /`: Lấy danh sách gói VIP.
- `GET /:id`: Lấy chi tiết gói VIP.
- `POST /`: Tạo gói VIP mới.
- `PUT /:id`: Cập nhật gói VIP.
- `DELETE /:id`: Xóa gói VIP.

## 17. Discount Policy Module (Chính sách giảm giá)

Base URL: `/api/v1/discount-policies`

- `GET /`: Lấy danh sách chính sách.
- `GET /:id`: Lấy chi tiết chính sách.
- `POST /`: Tạo chính sách mới.
- `PUT /:id`: Cập nhật chính sách.
- `DELETE /:id`: Xóa chính sách.

## 18. Extra Fee Module (Phí phụ thu)

Base URL: `/api/v1/extra-fees`

- `GET /`: Lấy danh sách phí phụ thu.
- `GET /:id`: Lấy chi tiết phí phụ thu.
- `POST /`: Tạo phí phụ thu mới.
- `PUT /:id`: Cập nhật phí phụ thu.
- `DELETE /:id`: Xóa phí phụ thu.

## 19. Upload Module (Tải lên)

Base URL: `/api/v1/upload`

- `POST /avatar-temp`: Upload ảnh đại diện tạm thời.

## Lưu ý

- **Super Admin Module**: File `superAdmin.route.ts` tồn tại nhưng chưa được đăng ký trong `site.route.ts`.
