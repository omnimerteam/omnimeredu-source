# Validation Specification Document

## 1. Account Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| email | String | Yes | Yes | Yes | Valid email format | Email format, required | Email format, unique check | |
| password | String | Yes | No | No | Min 8 chars, contain special chars | Min length, complexity | Hash before save, complexity | Cần hash trước khi lưu |
| uid | String | Yes | Yes | Yes | Unique identifier format | Required, format check | Unique check, format | Logic tạo uid cần xác nhận |
| token | String | No | No | No | JWT format if present | N/A | JWT validation | Token refresh logic? |
| userId | ObjectId | Yes | No | Yes | Valid ObjectId, exists in User | Required | Foreign key check | Quan hệ với User |

## 2. ActivityLog Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| userId | ObjectId | Yes | No | No | Valid ObjectId, exists in User | Required | Foreign key check | Người thực hiện action |
| action | String | Yes | No | No | Predefined action list | Required, enum check | Enum validation | Cần define list actions |
| targetId | ObjectId | No | No | No | Valid ObjectId if present | ObjectId format | Exists check if provided | Đối tượng bị tác động |
| roleSnapshot | String | No | No | No | Valid role name | Role format | Role exists check | Vai trò tại thời điểm đó |
| timestamp | Date | Auto | No | No | Valid date | N/A | Auto set to now | Tự động set |
| metadata | Mixed | No | No | No | Valid JSON object | JSON format | JSON validation | Dữ liệu bổ sung |

## 3. Attendance Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| classId | ObjectId | Yes | No | No | Valid ObjectId, exists in Class | Required | Foreign key check | Lớp học |
| date | Date | Yes | No | No | Valid date, not future | Required, date format | Date validation | Ngày điểm danh |

## 4. BaseUser Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| fullName | String | Yes | No | Yes | Min 2 chars, max 100 chars | Required, length | Length, special chars | Họ tên đầy đủ |
| roleId | ObjectId | Yes | No | Yes | Valid ObjectId, exists in Role | Required | Foreign key check | Vai trò người dùng |
| gender | String | No | No | No | Male/Female/Other | Enum selection | Enum validation | Giới tính |
| birthday | Date | No | No | No | Valid date, not future | Date format | Date validation | Ngày sinh |
| phone | String | No | No | Yes | Valid phone format | Phone format | Phone format, unique | Số điện thoại |
| address | String | No | No | No | Max 500 chars | Length check | Length validation | Địa chỉ |
| isVerified | Boolean | No | No | Yes | Boolean value | Boolean | Boolean | Trạng thái xác thực |

## 5. BillPackage Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| schoolId | ObjectId | Yes | No | No | Valid ObjectId, exists in School | Required | Foreign key check | Trường học |
| packageId | ObjectId | Yes | No | No | Valid ObjectId, exists in VipPackage | Required | Foreign key check | Gói dịch vụ |
| activatedAt | Date | Auto | No | No | Valid date | N/A | Auto set to now | Ngày kích hoạt |
| expiresAt | Date | No | No | No | Valid date, after activatedAt | Date format | Date logic check | Ngày hết hạn |
| isActive | Boolean | No | No | No | Boolean value | Boolean | Boolean | Trạng thái hoạt động |

## 6. Class Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| name | String | Yes | No | No | Min 1 char, max 100 chars | Required, length | Length validation | Tên lớp |
| code | String | Yes | Yes | No | Unique class code format | Required, format | Unique check, format | Mã lớp |
| schoolId | ObjectId | Yes | No | No | Valid ObjectId, exists in School | Required | Foreign key check | Trường học |
| teacherId | ObjectId | No | No | No | Valid ObjectId, exists in User | ObjectId format | Foreign key check | Giáo viên chủ nhiệm |
| students | [ObjectId] | No | No | No | Array of valid ObjectIds | Array format | Foreign key checks | Danh sách học sinh |
| baseFee | Number | Yes | No | No | Positive number | Required, positive | Positive validation | Học phí cơ bản |

## 7. DetailsRecord Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| studentId | ObjectId | Yes | No | No | Valid ObjectId, exists in User | Required | Foreign key check | Học sinh |
| attendanceId | ObjectId | Yes | No | No | Valid ObjectId, exists in Attendance | Required | Foreign key check | Phiên điểm danh |
| status | String | Yes | No | No | Present/AbsentWithLeave/Absent | Required, enum | Enum validation | Trạng thái điểm danh |
| note | String | No | No | No | Max 500 chars | Length check | Length validation | Ghi chú |

## 8. DiscountPolicy Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| name | String | Yes | No | No | Min 1 char, max 100 chars | Required, length | Length validation | Tên chính sách |
| type | String | Yes | No | No | percentage/fixed | Required, enum | Enum validation | Loại giảm giá |
| value | Number | Yes | No | No | Positive number, % ≤ 100 | Required, range | Range validation | Giá trị giảm |
| applicableTo | [ObjectId] | No | No | No | Array of valid ObjectIds | Array format | Foreign key checks | Áp dụng cho ai |

## 9. ExtraFee Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| name | String | Yes | No | No | Min 1 char, max 100 chars | Required, length | Length validation | Tên phí phụ |
| amount | Number | Yes | No | No | Positive number | Required, positive | Positive validation | Số tiền phí |
| applicableTo | [ObjectId] | No | No | No | Array of valid ObjectIds | Array format | Foreign key checks | Áp dụng cho học sinh nào |

## 10. News Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| title | String | Yes | No | No | Min 1 char, max 200 chars | Required, length | Length validation | Tiêu đề tin tức |
| content | String | Yes | No | No | Min 1 char, max 10000 chars | Required, length | Length validation | Nội dung tin |
| imageUrl | String | No | No | No | Valid URL format | URL format | URL validation | Ảnh đại diện |
| schoolId | ObjectId | No | No | No | Valid ObjectId, exists in School | ObjectId format | Foreign key check | Tin của trường nào |
| publishedAt | Date | Auto | No | No | Valid date | N/A | Auto set to now | Ngày đăng |
| isPublic | Boolean | No | No | No | Boolean value | Boolean | Boolean | Công khai hay không |
| tags | [String] | No | No | No | Array of strings | Array format | Array validation | Tags cho tin tức |

## 11. Notification Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| userId | ObjectId | Yes | No | No | Valid ObjectId, exists in User | Required | Foreign key check | Người nhận thông báo |
| content | String | No | No | No | Max 1000 chars | Length check | Length validation | Nội dung thông báo |
| type | String | No | No | No | system/reminder/warning | Enum selection | Enum validation | Loại thông báo |
| isRead | Boolean | No | No | No | Boolean value | Boolean | Boolean | Đã đọc chưa |
| createdAt | Date | Auto | No | No | Valid date | N/A | Auto set to now | Thời gian tạo |

## 12. PaymentMethod Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| name | String | Yes | Yes | No | Momo/ZaloPay/Bank/QRCode | Required, enum | Enum, unique check | Tên phương thức |
| description | String | No | No | No | Max 500 chars | Length check | Length validation | Mô tả |

## 13. Role Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| name | String | Yes | Yes | Yes | SuperAdmin/SchoolAdmin/Teacher/Student/CanteenStaff/Nurse/Security | Required, enum | Enum, unique check | Tên vai trò |
| description | String | No | No | No | Max 500 chars | Length check | Length validation | Mô tả vai trò |
| permissions | [String] | No | No | No | Array of permission strings | Array format | Permission validation | Quyền hạn |

## 14. School Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| name | String | Yes | No | No | Min 1 char, max 200 chars | Required, length | Length validation | Tên trường |
| code | String | Yes | Yes | No | Unique school code format | Required, format | Unique check, format | Mã trường |
| address | String | Yes | No | No | Min 10 chars, max 500 chars | Required, length | Length validation | Địa chỉ trường |
| phone | String | No | No | No | Valid phone format | Phone format | Phone validation | Số điện thoại |
| description | String | No | No | No | Max 1000 chars | Length check | Length validation | Mô tả trường |
| level | String | Yes | No | No | Preschool/Primary/Secondary/HighSchool/University | Required, enum | Enum validation | Cấp học |
| adminId | ObjectId | No | No | No | Valid ObjectId, exists in User | ObjectId format | Foreign key check | Admin trường |
| logoUrl | String | No | No | No | Valid URL format | URL format | URL validation | Logo trường |
| customTheme | Object | No | No | No | Valid JSON object | JSON format | JSON validation | Theme tùy chỉnh |

## 15. SchoolAdmin Schema (Discriminator)

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| schoolId | ObjectId | Yes | No | No | Valid ObjectId, exists in School | Required | Foreign key check | Trường quản lý |

*Kế thừa tất cả field từ BaseUser*

## 16. Student Schema (Discriminator)

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| schoolId | ObjectId | Yes | No | No | Valid ObjectId, exists in School | Required | Foreign key check | Trường học |
| classId | ObjectId | Yes | No | No | Valid ObjectId, exists in Class | Required | Foreign key check | Lớp học |

*Kế thừa tất cả field từ BaseUser*

## 17. SuperAdmin Schema (Discriminator)

*Không có field bổ sung - kế thừa hoàn toàn từ BaseUser*

## 18. Teacher Schema (Discriminator)

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| literacy | String | No | No | No | Max 200 chars | Length check | Length validation | Trình độ học vấn |
| subjects | [String] | No | No | No | Array of subject names | Array format | Array validation | Môn học dạy |
| schoolId | ObjectId | Yes | No | No | Valid ObjectId, exists in School | Required | Foreign key check | Trường công tác |

*Kế thừa tất cả field từ BaseUser*

## 19. TeachingAssignment Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| teacherId | ObjectId | Yes | No | No | Valid ObjectId, exists in User | Required | Foreign key check | Giáo viên |
| classId | ObjectId | Yes | No | No | Valid ObjectId, exists in Class | Required | Foreign key check | Lớp dạy |
| subject | String | No | No | No | Max 100 chars | Length check | Length validation | Môn học |
| isMain | Boolean | No | No | No | Boolean value | Boolean | Boolean | Giáo viên chủ nhiệm |

## 20. Tuition Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| studentId | ObjectId | Yes | No | No | Valid ObjectId, exists in User | Required | Foreign key check | Học sinh |
| month | String | Yes | No | No | Format YYYY-MM | Required, format | Date format check | Tháng học phí |
| extraFeeIds | [ObjectId] | No | No | No | Array of valid ObjectIds | Array format | Foreign key checks | Các phí phụ |
| discountId | ObjectId | No | No | No | Valid ObjectId, exists in DiscountPolicy | ObjectId format | Foreign key check | Chính sách giảm giá |
| totalAmount | Number | Yes | No | No | Positive number | Required, positive | Positive validation | Tổng tiền |
| attendedDays | Number | No | No | No | Non-negative integer | Number format | Range validation | Số ngày đi học |
| status | String | No | No | No | paid/pending | Enum selection | Enum validation | Trạng thái thanh toán |

## 21. TuitionInvoice Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| studentId | ObjectId | Yes | No | No | Valid ObjectId, exists in User | Required | Foreign key check | Học sinh |
| tuitionId | ObjectId | Yes | No | No | Valid ObjectId, exists in Tuition | Required | Foreign key check | Học phí |
| paymentMethodId | ObjectId | Yes | No | No | Valid ObjectId, exists in PaymentMethod | Required | Foreign key check | Phương thức thanh toán |
| amount | Number | Yes | No | No | Positive number | Required, positive | Positive validation | Số tiền thanh toán |
| transactionId | String | Yes | No | No | Unique transaction ID | Required, format | Unique validation | Mã giao dịch |
| status | String | Yes | No | No | Success/Failed | Required, enum | Enum validation | Trạng thái |
| paidAt | Date | Yes | No | No | Valid date | Required, date | Date validation | Thời gian thanh toán |

## 22. VipInvoice Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| schoolId | ObjectId | Yes | No | No | Valid ObjectId, exists in School | Required | Foreign key check | Trường học |
| packageId | ObjectId | Yes | No | No | Valid ObjectId, exists in VipPackage | Required | Foreign key check | Gói VIP |
| subscriptionId | ObjectId | Yes | No | No | Valid ObjectId, exists in Subscription | Required | Foreign key check | Đăng ký |
| paymentMethodId | ObjectId | Yes | No | No | Valid ObjectId, exists in PaymentMethod | Required | Foreign key check | Phương thức thanh toán |
| amount | Number | Yes | No | No | Positive number | Required, positive | Positive validation | Số tiền |
| transactionId | String | Yes | No | No | Unique transaction ID | Required, format | Unique validation | Mã giao dịch |
| status | String | Yes | No | No | Success/Failed | Required, enum | Enum validation | Trạng thái |
| paidAt | Date | Yes | No | No | Valid date | Required, date | Date validation | Thời gian thanh toán |

## 23. VipPackage Schema

| Field | Type | Required | Unique | Index | Validation Rules | FE Validation | BE Validation | Notes |
|-------|------|----------|--------|-------|------------------|---------------|---------------|-------|
| _id | ObjectId | Auto | Yes | Yes | MongoDB auto-generated | N/A | N/A | Tự động tạo |
| name | String | Yes | Yes | No | Basic/Pro/Enterprise | Required, enum | Enum, unique check | Tên gói |
| price | Number | No | No | No | Non-negative number | Positive/zero | Range validation | Giá gói |
| maxStudents | Number | No | No | No | Positive integer | Positive integer | Range validation | Giới hạn học sinh |
| maxInvoices | Number | No | No | No | Positive integer | Positive integer | Range validation | Giới hạn hóa đơn |
| features | [String] | No | No | No | Array of feature names | Array format | Array validation | Tính năng |

---

## Ghi chú và Nghi vấn

### 🔍 Cần xác nhận logic:

1. **Account.uid**: Logic tạo mã định danh riêng này như thế nào?
2. **Account.token**: Có phải là JWT token? Cần refresh token riêng không?
3. **ActivityLog.action**: Cần define danh sách các action cụ thể
4. **BaseUser.phone**: Có cần unique không? Hiện tại chỉ có index
5. **BillPackage.expiresAt**: Logic tính toán thời gian hết hạn?
6. **Class.code**: Format của mã lớp như thế nào?
7. **DiscountPolicy.value**: Với type "percentage", value có giới hạn 0-100?
8. **News.schoolId**: Có thể null - có nghĩa là tin tức hệ thống?
9. **Notification.content**: Có thể null - logic hiển thị như thế nào?
10. **Tuition.month**: Format "YYYY-MM" có đúng không? Cần validate range?
11. **TuitionInvoice.transactionId**: Có cần unique globally hay chỉ per school?
12. **VipInvoice.subscriptionId**: Reference đến model "Subscription" nhưng chưa thấy?
13. **VipPackage.price**: Có thể null - gói miễn phí?
14. **TeachingAssignment**: Có cần unique constraint (teacherId + classId + subject)?

### ⚠️ Lưu ý quan trọng:

- **Indexes**: Đã thêm index cho các field quan trọng để tối ưu query
- **Foreign Keys**: Cần implement validation để đảm bảo tính toàn vẹn dữ liệu
- **Security**: Password cần hash, sensitive data cần encrypt
- **Performance**: Cân nhắc pagination cho các array lớn (students, applicableTo, features)
- **Discriminators**: BaseUser với các subclasses cần validate đúng roleKey
- **Transaction IDs**: Cần đảm bảo unique và format đúng cho payment processing
- **Date Logic**: Các field date cần validate logic nghiệp vụ (publishedAt, paidAt, expiresAt)
- **Enum Values**: Tất cả enum values cần sync giữa FE/BE và database

### 📋 Validation tổng quát:

- **Frontend**: Focus vào UX validation (format, required, length)
- **Backend**: Focus vào business logic, security, data integrity
- **Database**: Constraints, indexes, unique checks

### 🚀 Khuyến nghị triển khai:

1. **Ưu tiên cao**: Account, Role, BaseUser, School - foundation models
2. **Ưu tiên trung**: Class, Student, Teacher - core educational models  
3. **Ưu tiên thấp**: News, Notification - supporting features
4. **Cuối cùng**: Payment related models - complex business logic

### 📊 Thống kê schemas:

- **Tổng số schemas**: 23
- **Models chính**: 19
- **Discriminators**: 4
- **Payment related**: 5
- **Core educational**: 8
- **Supporting features**: 6