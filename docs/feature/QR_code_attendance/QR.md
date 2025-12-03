# QR Code Attendance Feature Specification

## 1. Chi tiết tính năng

Tính năng điểm danh bằng QR Code cho phép giáo viên tạo mã QR cho buổi học và sinh viên quét mã để điểm danh.

### Các chức năng cơ bản:
*   **Hiển thị & Quét QR**:
    *   **Giáo viên**: Tạo mã QR động hoặc tĩnh cho buổi học. Mã QR chứa thông tin mã hóa của buổi điểm danh.
    *   **Sinh viên**: Sử dụng camera trên ứng dụng mobile để quét mã QR.
*   **QR chứa Logo (Branding)**: Mã QR được tạo ra sẽ tích hợp logo của trường hoặc ứng dụng ở chính giữa để tăng tính nhận diện thương hiệu.
*   **Geo-fencing (Khoanh vùng vị trí)**:
    *   Hệ thống kiểm tra vị trí GPS của sinh viên khi quét mã.
    *   Chỉ cho phép điểm danh nếu sinh viên nằm trong bán kính cho phép (ví dụ: 100m) so với vị trí của lớp học/trường học.
*   **Tự động tăng độ sáng**: Khi mở màn hình mã QR trên thiết bị của giáo viên, ứng dụng tự động tăng độ sáng màn hình lên mức tối đa để dễ dàng quét.
*   **Chế độ Offline (Offline Packet)**:
    *   Nếu sinh viên mất mạng, thông tin quét mã (mã QR + thời gian + vị trí) sẽ được lưu tạm dưới local.
    *   Khi có mạng lại, ứng dụng sẽ tự động gửi gói tin (packet) này lên server để xử lý điểm danh.

## 2. API Cần thiết

### Mobile / Client APIs

#### 1. Generate QR Code (Teacher)
*   **Endpoint**: `GET /api/v1/attendance/:attendanceId/qr`
*   **Method**: `GET`
*   **Description**: Lấy dữ liệu để tạo mã QR hoặc lấy hình ảnh mã QR đã tạo.
*   **Response**:
    ```json
    {
      "qrData": "encrypted_string_containing_attendance_id_timestamp_signature",
      "expiry": "2023-10-27T10:00:00Z"
    }
    ```

#### 2. Submit Attendance (Student)
*   **Endpoint**: `POST /api/v1/attendance/scan`
*   **Method**: `POST`
*   **Body**:
    ```json
    {
      "qrData": "string",
      "latitude": 10.762622,
      "longitude": 106.660172,
      "deviceId": "string",
      "timestamp": "2023-10-27T09:00:00Z"
    }
    ```
*   **Description**: Gửi dữ liệu quét được và vị trí hiện tại lên server.

### Backend Internal APIs (Optional if logic is embedded)
*   **Verify Location**: Hàm nội bộ để tính khoảng cách.

## 3. Cơ sở dữ liệu (Database Schema)

### Các bảng hiện tại (Existing Models)
*   **School**: `services/api/src/domain/models/school/School.ts`
*   **Class**: `services/api/src/domain/models/school/class/Class.ts`
*   **Attendance**: `services/api/src/domain/models/school/attendance/Attendance.ts`
*   **DetailsRecord**: `services/api/src/domain/models/school/attendance/DetailsRecord.ts`

### Cập nhật Schema (Proposed Changes)

#### 1. Update `School` Model
Thêm trường tọa độ để phục vụ Geo-fencing.
```typescript
// services/api/src/domain/models/school/School.ts
{
  // ... existing fields
  location: {
    type: { type: String, default: 'Point' },
    coordinates: { type: [Number], index: '2dsphere' } // [longitude, latitude]
  },
  allowedRadius: { type: Number, default: 100 } // meters
}
```

#### 2. Update `Attendance` Model
Lưu cấu hình QR cho buổi điểm danh (nếu cần mã động).
```typescript
// services/api/src/domain/models/school/attendance/Attendance.ts
{
  // ... existing fields
  qrConfig: {
    isEnabled: { type: Boolean, default: true },
    dynamicCode: String, // Secret key for generating dynamic QR
    expiryTime: Date
  }
}
```

## 4. Thư viện cần thiết

### Backend (Node.js/TypeScript)
*   **qrcode**: Để tạo mã QR (nếu tạo từ server gửi về image/base64).
*   **qrcode-with-logos**: Để chèn logo vào QR code.
*   **geolib**: Để tính khoảng cách giữa 2 tọa độ GPS (Haversine formula).
    *   `getDistance(start, end)`
*   **crypto**: (Built-in) Để mã hóa/ký dữ liệu trong QR code.

### Frontend (Mobile/React Native/Flutter - Assumption)
*   **react-native-camera** / **expo-camera**: Để quét QR.
*   **react-native-qrcode-svg**: Để hiển thị QR code.
*   **react-native-geolocation-service**: Lấy tọa độ GPS.
*   **react-native-screen-brightness**: Điều chỉnh độ sáng màn hình.

## 5. Luồng hoạt động (Logic Flow)

### Kịch bản: Điểm danh thành công
1.  **Giáo viên (Teacher)**:
    *   Mở màn hình điểm danh của lớp học.
    *   Chọn "Tạo mã QR".
    *   App gọi API lấy thông tin QR (hoặc sinh offline nếu có secret key).
    *   Màn hình tự động tăng độ sáng tối đa.
    *   Hiển thị QR Code có logo trường ở giữa.

2.  **Sinh viên (Student)**:
    *   Mở chức năng "Quét mã" trên App.
    *   Camera quét được mã QR -> Decode ra chuỗi dữ liệu (chứa `attendanceId`, `timestamp`, `signature`).
    *   App lấy vị trí GPS hiện tại (`lat`, `long`).
    *   App gọi API `POST /scan` với payload: `{ qrData, lat, long }`.

3.  **Server**:
    *   Nhận request.
    *   Validate `qrData`: Kiểm tra chữ ký, kiểm tra hạn sử dụng của mã QR.
    *   Lấy thông tin `Attendance` từ ID trong `qrData`.
    *   Lấy thông tin `School` hoặc `Class` để lấy tọa độ gốc.
    *   **Geo-fencing Check**: Tính khoảng cách giữa (`lat`, `long`) của sinh viên và tọa độ trường.
        *   Nếu khoảng cách <= `allowedRadius`: Hợp lệ.
        *   Nếu > `allowedRadius`: Trả lỗi "Bạn đang ở quá xa lớp học".
    *   Nếu hợp lệ: Tạo/Update `DetailsRecord` với `status = Present`.
    *   Trả về kết quả thành công.

4.  **Client**: Hiển thị thông báo "Điểm danh thành công".

### Kịch bản: Offline Mode
1.  Sinh viên quét mã khi không có mạng.
2.  App lưu thông tin quét (`qrData`, `lat`, `long`, `scanTime`) vào local storage.
3.  Hiển thị "Đã lưu điểm danh offline".
4.  Khi có mạng, App background job gửi danh sách các request đã lưu lên server.
5.  Server xử lý như bình thường (lưu ý kiểm tra `scanTime` thay vì thời gian nhận request).

## 6. Test Cases

| ID | Tên Case | Mô tả | Kết quả mong đợi |
| :--- | :--- | :--- | :--- |
| **TC01** | Quét QR hợp lệ | Sinh viên quét mã đúng, vị trí trong vùng cho phép. | Điểm danh thành công (Present). |
| **TC02** | Quét QR xa vị trí | Sinh viên quét mã đúng, nhưng vị trí GPS > 100m so với trường. | Báo lỗi "Vị trí không hợp lệ". |
| **TC03** | QR hết hạn | Sinh viên quét mã cũ (đã hết hạn). | Báo lỗi "Mã QR đã hết hạn". |
| **TC04** | Fake GPS | Sinh viên sử dụng phần mềm giả lập GPS (nếu detect được). | Báo lỗi hoặc chặn. |
| **TC05** | Offline Scan | Quét mã khi tắt mạng, sau đó bật mạng lại. | Hệ thống tự động đồng bộ và điểm danh thành công. |
| **TC06** | QR Branding | Kiểm tra hiển thị QR code. | QR code hiển thị rõ nét, có logo ở giữa, quét được bình thường. |
| **TC07** | Brightness | Mở màn hình QR giáo viên. | Độ sáng màn hình tự động tăng lên 100%. |
