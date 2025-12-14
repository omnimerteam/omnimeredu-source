# QR Code Attendance Feature - Implementation Guide

## 📦 Tính năng đã hoàn thành

Đã implement đầy đủ tính năng điểm danh bằng QR Code với các chức năng:

### ✅ Teacher Features (Giáo viên)
- ✅ Generate QR Code động cho buổi học
- ✅ QR Code có logo trường ở giữa
- ✅ Tự động tăng độ sáng màn hình khi hiển thị QR
- ✅ Timer đếm ngược thời gian hết hạn của mã QR
- ✅ Tạo mã QR mới khi hết hạn
- ✅ Hiển thị thông tin buổi học (Lớp, Môn, Ngày)

### ✅ Student Features (Sinh viên)
- ✅ Quét QR Code bằng camera
- ✅ Kiểm tra vị trí GPS (Geo-fencing)
- ✅ Offline mode - lưu điểm danh khi không có mạng
- ✅ Tự động sync khi có mạng trở lại
- ✅ Hiển thị kết quả điểm danh (thành công, lỗi, offline)
- ✅ Thông báo khoảng cách từ trường học

### ✅ Technical Features
- ✅ Clean Architecture (Entity, UseCase, Repository, BLoC)
- ✅ BLoC State Management
- ✅ Dependency Injection với GetIt
- ✅ Offline Queue với SQLite
- ✅ Auto-sync service chạy background
- ✅ Connectivity monitoring
- ✅ Location permission handling
- ✅ Theme-based UI design

---

## 📁 Cấu trúc thư mục

```
lib/
├── core/
│   ├── network/
│   │   └── endpoints.dart                    [UPDATED] ✅
│   └── theme/
│       └── qr_theme.dart                     [NEW] ✅
├── data/
│   ├── datasources/remote/qr_attendance/
│   │   └── qr_attendance_remote_datasource.dart  [NEW] ✅
│   ├── models/qr_attendance/
│   │   ├── qr_data_model.dart                [NEW] ✅
│   │   ├── scan_request_model.dart           [NEW] ✅
│   │   ├── scan_response_model.dart          [NEW] ✅
│   │   └── offline_scan_model.dart           [NEW] ✅
│   └── repositories/qr_attendance/
│       └── qr_attendance_repository_impl.dart [NEW] ✅
├── domain/
│   ├── entities/qr_attendance/
│   │   ├── qr_code_entity.dart               [NEW] ✅
│   │   ├── location_entity.dart              [NEW] ✅
│   │   └── scan_result_entity.dart           [NEW] ✅
│   ├── repositories/qr_attendance/
│   │   └── qr_attendance_repository.dart     [NEW] ✅
│   └── usecases/qr_attendance/
│       ├── generate_qr_code_usecase.dart     [NEW] ✅
│       ├── submit_attendance_usecase.dart    [NEW] ✅
│       ├── verify_location_usecase.dart      [NEW] ✅
│       └── sync_offline_scans_usecase.dart   [NEW] ✅
├── presentation/screens/qr_attendance/
│   ├── teacher/
│   │   ├── bloc/
│   │   │   ├── qr_display_bloc.dart          [NEW] ✅
│   │   │   ├── qr_display_event.dart         [NEW] ✅
│   │   │   └── qr_display_state.dart         [NEW] ✅
│   │   ├── widgets/
│   │   │   ├── qr_code_widget.dart           [NEW] ✅
│   │   │   ├── qr_timer_widget.dart          [NEW] ✅
│   │   │   └── attendance_info_card.dart     [NEW] ✅
│   │   └── qr_display_screen.dart            [NEW] ✅
│   └── student/
│       ├── bloc/
│       │   ├── qr_scanner_bloc.dart          [NEW] ✅
│       │   ├── qr_scanner_event.dart         [NEW] ✅
│       │   └── qr_scanner_state.dart         [NEW] ✅
│       ├── widgets/
│       │   ├── scanner_overlay.dart          [NEW] ✅
│       │   ├── offline_indicator.dart        [NEW] ✅
│       │   └── scan_result_dialog.dart       [NEW] ✅
│       └── qr_scanner_screen.dart            [NEW] ✅
├── services/
│   ├── location_service.dart                 [NEW] ✅
│   ├── brightness_service.dart               [NEW] ✅
│   ├── offline_queue_service.dart            [NEW] ✅
│   ├── connectivity_service.dart             [NEW] ✅
│   └── auto_sync_service.dart                [NEW] ✅
├── injection_container.dart                  [UPDATED] ✅
└── pubspec.yaml                              [UPDATED] ✅
```

---

## 🔧 Cài đặt và Sử dụng

### 1. Cài đặt dependencies

```bash
cd apps/omnimereduapp
flutter pub get
```

### 2. Cấu hình Permissions

#### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<manifest>
    <!-- Internet -->
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <!-- Camera -->
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-feature android:name="android.hardware.camera" android:required="false"/>
    
    <!-- Location -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    
    <!-- Network state -->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    
    <application>
        ...
    </application>
</manifest>
```

#### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSCameraUsageDescription</key>
<string>Ứng dụng cần quyền truy cập camera để quét mã QR điểm danh</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Ứng dụng cần quyền truy cập vị trí để xác nhận bạn đang ở trong lớp học</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>Ứng dụng cần quyền truy cập vị trí để xác nhận bạn đang ở trong lớp học</string>
```

### 3. Generate code cho JSON Serialization

```bash
cd apps/omnimereduapp
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Sử dụng trong code

#### Teacher - Hiển thị QR Code

```dart
import 'package:flutter/material.dart';
import 'presentation/screens/qr_attendance/teacher/qr_display_screen.dart';

// Trong widget của bạn
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => QRDisplayScreen(
      attendanceId: 'attendance_id_123',
      className: '10A1',
      subject: 'Toán',
      date: DateTime.now(),
    ),
  ),
);
```

#### Student - Quét QR Code

```dart
import 'package:flutter/material.dart';
import 'presentation/screens/qr_attendance/student/qr_scanner_screen.dart';

// Trong widget của bạn
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const QRScannerScreen(),
  ),
);
```

---

## 🎯 API Endpoints Required

Backend cần implement các endpoints sau:

### 1. Generate QR Code (Teacher)
```
GET /api/v1/attendance/:attendanceId/qr

Response:
{
  "attendanceId": "string",
  "qrData": "encrypted_string",
  "expiry": "2025-12-13T10:00:00Z",
  "dynamicCode": "optional_string"
}
```

### 2. Submit Attendance (Student)
```
POST /api/v1/attendance/scan

Body:
{
  "qrData": "string",
  "latitude": 10.762622,
  "longitude": 106.660172,
  "deviceId": "string",
  "timestamp": "2025-12-13T09:00:00Z"
}

Response:
{
  "status": "success|expired|out_of_range|invalid|already_scanned",
  "message": "string",
  "attendanceTime": "2025-12-13T09:00:00Z",
  "distance": 50.5,
  "attendanceId": "string"
}
```

---

## 🗄️ Database Schema Updates

### School Model (cần thêm)
```typescript
{
  location: {
    type: { type: String, default: 'Point' },
    coordinates: [Number], // [longitude, latitude]
    index: '2dsphere'
  },
  allowedRadius: { type: Number, default: 100 } // meters
}
```

### Attendance Model (cần thêm)
```typescript
{
  qrConfig: {
    isEnabled: { type: Boolean, default: true },
    dynamicCode: String,
    expiryTime: Date
  }
}
```

---

## 🚀 Next Steps

### Để hoàn thiện tính năng:

1. **Run build_runner để generate code:**
   ```bash
   cd apps/omnimereduapp
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Update Backend API** theo endpoints đã định nghĩa

3. **Test permissions** trên thiết bị thật (Android/iOS)

4. **Add routing** vào màn hình chính:
   - Thêm button "Tạo mã QR" cho Teacher
   - Thêm button "Quét mã" cho Student

5. **Initialize AutoSyncService** trong `main.dart`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await init(); // Dependency injection
     
     // Start auto sync service
     final autoSyncService = sl<AutoSyncService>();
     autoSyncService.start();
     
     runApp(MyApp());
   }
   ```

6. **Test các scenarios:**
   - ✅ Teacher tạo QR code
   - ✅ Student quét QR trong phạm vi
   - ✅ Student quét QR ngoài phạm vi
   - ✅ Student quét khi offline
   - ✅ Auto sync khi có mạng lại
   - ✅ QR code hết hạn

---

## 📱 UI Preview

### Teacher Screen
- QR Code hiển thị ở giữa màn hình với logo
- Timer đếm ngược màu xanh/vàng/đỏ
- Thông tin buổi học (lớp, môn, ngày)
- Button "Tạo mã mới"

### Student Scanner Screen
- Camera scanner với overlay khung quét
- Corner animations
- Offline indicator ở dưới màn hình
- Result dialog với icon và màu sắc theo trạng thái

---

## 🎨 Theme Colors

Tính năng sử dụng theme colors từ `AppColors`:
- **Primary**: `#006a9c` - QR border, buttons
- **Success**: `#4CAF50` - Điểm danh thành công
- **Warning**: `#FF9800` - Cảnh báo vị trí
- **Error**: `#F44336` - Lỗi, hết hạn
- **Info**: `#2196F3` - Offline mode

---

## 🐛 Troubleshooting

### Lỗi permission
- Check AndroidManifest.xml và Info.plist
- Request permission lúc runtime

### Lỗi build_runner
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Lỗi camera không hoạt động
- Test trên thiết bị thật, không dùng emulator
- Check camera permissions

### Lỗi GPS không chính xác
- Bật GPS/Location services
- Test outdoor để có GPS tốt hơn

---

## 📝 Notes

- QR Code sử dụng `qr_flutter` package với logo embedding
- Scanner sử dụng `mobile_scanner` (không cần Google ML Kit)
- Location service sử dụng `geolocator` với high accuracy
- Offline storage sử dụng `sqflite`
- Auto brightness sử dụng `screen_brightness`

---

**Created:** December 13, 2025
**Version:** 1.0.0
**Status:** ✅ Ready for Testing

