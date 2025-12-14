# 📋 QR Code Attendance - Workflow Documentation

## 📖 Tổng quan

Tài liệu này mô tả chi tiết **workflow hoàn chỉnh** của tính năng điểm danh bằng QR Code, bao gồm tất cả các file liên quan, luồng dữ liệu, và cách các component tương tác với nhau.

---

## 🎯 Mục lục

1. [Tổng quan kiến trúc](#tổng-quan-kiến-trúc)
2. [Workflow Teacher (Giáo viên)](#workflow-teacher-giáo-viên)
3. [Workflow Student (Sinh viên)](#workflow-student-sinh-viên)
4. [Workflow Offline Mode](#workflow-offline-mode)
5. [Chi tiết các file và vai trò](#chi-tiết-các-file-và-vai-trò)
6. [Luồng dữ liệu (Data Flow)](#luồng-dữ-liệu-data-flow)
7. [API Endpoints](#api-endpoints)
8. [Database Schema](#database-schema)
9. [Error Handling](#error-handling)

---

## 🏗️ Tổng quan kiến trúc

### Kiến trúc tổng thể

```
┌─────────────────────────────────────────────────────────────┐
│                    MOBILE APP (Flutter)                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────┐         ┌──────────────────┐         │
│  │  Teacher Flow    │         │  Student Flow     │         │
│  │  (QR Display)    │         │  (QR Scanner)     │         │
│  └────────┬─────────┘         └────────┬─────────┘         │
│           │                             │                    │
│           │                             │                    │
│  ┌────────▼─────────────────────────────▼─────────┐         │
│  │         Presentation Layer (BLoC)              │         │
│  └────────┬───────────────────────────────────────┘         │
│           │                                                 │
│  ┌────────▼───────────────────────────────────────┐         │
│  │         Domain Layer (UseCases)                 │         │
│  └────────┬───────────────────────────────────────┘         │
│           │                                                 │
│  ┌────────▼───────────────────────────────────────┐         │
│  │         Data Layer (Repository/DataSource)    │         │
│  └────────┬───────────────────────────────────────┘         │
│           │                                                 │
│  ┌────────▼───────────────────────────────────────┐         │
│  │         Services (Location, Connectivity, etc) │         │
│  └────────┬───────────────────────────────────────┘         │
│           │                                                 │
└───────────┼─────────────────────────────────────────────────┘
            │
            │ HTTP/REST API
            │
┌───────────▼─────────────────────────────────────────────────┐
│              BACKEND API (Node.js/TypeScript)               │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────┐         ┌──────────────────┐         │
│  │  Controller     │         │   Service        │         │
│  └────────┬─────────┘         └────────┬─────────┘         │
│           │                             │                    │
│  ┌────────▼─────────────────────────────▼─────────┐         │
│  │         Repository Layer                      │         │
│  └────────┬───────────────────────────────────────┘         │
│           │                                                 │
│  ┌────────▼───────────────────────────────────────┐         │
│  │         Database (MongoDB)                      │         │
│  └─────────────────────────────────────────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

### Clean Architecture Layers

**Mobile App (Flutter):**
- **Presentation**: UI, BLoC, Widgets
- **Domain**: Entities, UseCases, Repository Interfaces
- **Data**: Models, Repository Implementations, DataSources
- **Services**: Location, Connectivity, Offline Queue, Brightness, Auto Sync

**Backend (Node.js/TypeScript):**
- **Controllers**: HTTP request handlers
- **Services**: Business logic
- **Repositories**: Data access layer
- **Models**: Database schemas

---

## 👨‍🏫 Workflow Teacher (Giáo viên)

### Mục đích
Giáo viên tạo và hiển thị mã QR code cho buổi điểm danh để sinh viên quét.

### Luồng hoạt động

```
1. Teacher mở màn hình điểm danh
   ↓
2. Teacher nhấn "Tạo mã QR"
   ↓
3. QRDisplayScreen được khởi tạo
   ↓
4. QRDisplayBloc nhận GenerateQRCodeEvent
   ↓
5. GenerateQRCodeUsecase được gọi
   ↓
6. QRAttendanceRepository.generateQRCode()
   ↓
7. QRAttendanceRemoteDatasource.generateQRCode()
   ↓
8. API Call: GET /api/v1/attendance/:attendanceId/qr
   ↓
9. Backend: AttendanceController.generateQRCode()
   ↓
10. Backend: AttendanceService.generateQRCode()
    ↓
11. Backend tạo QR data (base64 encoded JSON)
    - attendanceId
    - timestamp
    - dynamicCode (6 digits)
    - expiry (1 phút từ hiện tại)
    ↓
12. Response trả về cho Mobile App
    ↓
13. QRDataModel.fromJson() parse response
    ↓
14. QRCodeEntity được tạo
    ↓
15. QRDisplayBloc emit QRDisplaySuccess state
    ↓
16. BrightnessService.setMaxBrightness() (tăng độ sáng)
    ↓
17. QRDisplayScreen hiển thị:
    - BrandedQRCodeWidget (QR với logo)
    - QRTimerWidget (đếm ngược)
    - AttendanceInfoCard (thông tin lớp)
    ↓
18. Countdown timer bắt đầu đếm ngược
    ↓
19. Khi hết hạn → QRCodeExpiredEvent → Refresh QR
```

### Chi tiết các bước

#### Bước 1-3: UI Initialization
**File:** `apps/omnimereduapp/lib/presentation/screens/qr_attendance/teacher/qr_display_screen.dart`

```dart
QRDisplayScreen(
  attendanceId: 'attendance_id_123',
  className: '10A1',
  subject: 'Toán',
  date: DateTime.now(),
)
```

**File:** `apps/omnimereduapp/lib/presentation/screens/qr_attendance/teacher/bloc/qr_display_bloc.dart`

BLoC được khởi tạo với:
- `GenerateQRCodeUsecase`
- `BrightnessService`

#### Bước 4-6: Domain Layer
**File:** `apps/omnimereduapp/lib/domain/usecases/qr_attendance/generate_qr_code_usecase.dart`

```dart
Future<QRCodeEntity> call(String attendanceId) async {
  return await _repository.generateQRCode(attendanceId);
}
```

**File:** `apps/omnimereduapp/lib/domain/repositories/qr_attendance/qr_attendance_repository.dart`

Interface định nghĩa:
```dart
Future<QRCodeEntity> generateQRCode(String attendanceId);
```

#### Bước 7-8: Data Layer - API Call
**File:** `apps/omnimereduapp/lib/data/datasources/remote/qr_attendance/qr_attendance_remote_datasource.dart`

```dart
Future<QRDataModel> generateQRCode(String attendanceId) async {
  final endpoint = Endpoints.generateQRCode(attendanceId);
  // GET /v1/attendance/:attendanceId/qr
  final response = await _apiClient.get<QRDataModel>(...);
  return response.data!;
}
```

**File:** `apps/omnimereduapp/lib/core/network/endpoints.dart`

```dart
static String generateQRCode(String attendanceId) => 
    "/v1/attendance/$attendanceId/qr";
```

#### Bước 9-11: Backend Processing
**File:** `services/api/src/domain/controllers/school/attendance/attendance.controller.ts`

```typescript
async generateQRCode(req: Request, res: Response) {
  const attendanceId = req.params.id;
  const qrData = await this.attendanceService.generateQRCode(
    attendanceId, actorSchoolId, actorId, userRole
  );
  sendSuccess(res, qrData, "Tạo mã QR thành công");
}
```

**File:** `services/api/src/domain/services/school/attendance/attendance.service.ts`

```typescript
async generateQRCode(attendanceId: string, ...) {
  // Verify attendance exists
  const attendance = await this.getAttendanceById(...);
  
  // Generate dynamic code (6 digits)
  const dynamicCode = Math.floor(100000 + Math.random() * 900000).toString();
  
  // Create payload
  const payload = {
    attendanceId: attendance._id?.toString(),
    timestamp: new Date().toISOString(),
    dynamicCode: dynamicCode,
  };
  
  // Encode to base64
  const qrData = Buffer.from(JSON.stringify(payload)).toString("base64");
  
  // Set expiry (1 minute)
  const expiry = new Date();
  expiry.setMinutes(expiry.getMinutes() + 1);
  
  return {
    attendanceId: attendance._id?.toString(),
    qrData: qrData,
    expiry: expiry.toISOString(),
    dynamicCode: dynamicCode,
  };
}
```

#### Bước 12-15: Response Processing
**File:** `apps/omnimereduapp/lib/data/models/qr_attendance/qr_data_model.dart`

Model parse JSON response:
```dart
factory QRDataModel.fromJson(Map<String, dynamic> json) {
  return QRDataModel(
    attendanceId: json['attendanceId'],
    qrData: json['qrData'],
    expiry: DateTime.parse(json['expiry']),
    dynamicCode: json['dynamicCode'],
  );
}
```

**File:** `apps/omnimereduapp/lib/domain/entities/qr_attendance/qr_code_entity.dart`

Entity chứa business logic:
```dart
int get remainingSeconds {
  final now = DateTime.now();
  final diff = expiry.difference(now);
  return diff.inSeconds.clamp(0, 999999);
}
```

#### Bước 16-19: UI Display
**File:** `apps/omnimereduapp/lib/presentation/screens/qr_attendance/teacher/widgets/qr_code_widget.dart`

Widget hiển thị QR với logo:
```dart
QrImageView(
  data: data,
  embeddedImage: AssetImage(logoPath),
  size: size,
)
```

**File:** `apps/omnimereduapp/lib/presentation/screens/qr_attendance/teacher/widgets/qr_timer_widget.dart`

Timer đếm ngược với màu sắc thay đổi:
- Xanh: > 30 giây
- Vàng: 10-30 giây
- Đỏ: < 10 giây

---

## 🎓 Workflow Student (Sinh viên)

### Mục đích
Sinh viên quét mã QR để điểm danh, với kiểm tra vị trí GPS và hỗ trợ offline mode.

### Luồng hoạt động

```
1. Student mở QRScannerScreen
   ↓
2. QRScannerBloc nhận InitializeScannerEvent
   ↓
3. Kiểm tra permissions:
   - Camera permission
   - Location permission
   ↓
4. Kiểm tra connectivity
   ↓
5. MobileScannerController khởi tạo camera
   ↓
6. Student quét QR code
   ↓
7. MobileScanner detect QR → QRCodeScannedEvent
   ↓
8. QRScannerBloc xử lý event
   ↓
9. SubmitAttendanceUsecase được gọi
   ↓
10. LocationService.getCurrentLocation()
    ↓
11. Kiểm tra connectivity
    ↓
12a. Nếu OFFLINE:
     - Lưu vào OfflineQueueService (SQLite)
     - Trả về ScanResultEntity(status: offline)
     ↓
12b. Nếu ONLINE:
     - Tạo ScanRequestModel
     - QRAttendanceRepository.submitAttendanceScan()
     ↓
13. QRAttendanceRemoteDatasource.submitAttendanceScan()
    ↓
14. API Call: POST /api/v1/attendance/scan
    Body: {
      qrData: string,
      latitude: number,
      longitude: number,
      deviceId: string,
      timestamp: ISO string
    }
    ↓
15. Backend: (Cần implement endpoint này)
    - Decode QR data
    - Verify expiry
    - Get attendance info
    - Verify location (geo-fencing)
    - Create/Update DetailsRecord
    ↓
16. Response trả về:
    {
      status: "success|expired|out_of_range|invalid|already_scanned",
      message: string,
      attendanceTime: ISO string,
      distance: number,
      attendanceId: string
    }
    ↓
17. ScanResponseModel.fromJson() parse response
    ↓
18. ScanResultEntity được tạo
    ↓
19. QRScannerBloc emit QRScannerSuccess state
    ↓
20. QRScannerScreen hiển thị ScanResultDialog
    - Success: ✅ "Điểm danh thành công"
    - Error: ❌ "Mã QR đã hết hạn" / "Vị trí không hợp lệ"
    ↓
21. Scanner reset để quét tiếp
```

### Chi tiết các bước

#### Bước 1-5: Initialization
**File:** `apps/omnimereduapp/lib/presentation/screens/qr_attendance/student/qr_scanner_screen.dart`

```dart
MobileScannerController(
  detectionSpeed: DetectionSpeed.noDuplicates,
  facing: CameraFacing.back,
)
```

**File:** `apps/omnimereduapp/lib/presentation/screens/qr_attendance/student/bloc/qr_scanner_bloc.dart`

```dart
Future<void> _onInitializeScanner(...) async {
  // Check connectivity
  _isOnline = await _connectivityService.hasConnection();
  
  // Check location permission
  final locationPermission = await _locationService.checkPermission();
  
  emit(QRScannerReady(
    isOnline: _isOnline,
    pendingOfflineScans: pendingCount,
  ));
}
```

#### Bước 6-8: QR Detection
**File:** `apps/omnimereduapp/lib/presentation/screens/qr_attendance/student/qr_scanner_screen.dart`

```dart
MobileScanner(
  controller: _scannerController,
  onDetect: (capture) {
    final qrData = capture.barcodes.first.rawValue;
    if (qrData != null) {
      context.read<QRScannerBloc>().add(
        QRCodeScannedEvent(qrData),
      );
    }
  },
)
```

#### Bước 9-12: UseCase Processing
**File:** `apps/omnimereduapp/lib/domain/usecases/qr_attendance/submit_attendance_usecase.dart`

```dart
Future<ScanResultEntity> call(String qrData) async {
  // Get location
  final location = await _locationService.getCurrentLocation();
  
  // Get device ID
  final deviceId = await _getDeviceId();
  
  // Check connectivity
  final hasConnection = await _connectivityService.hasConnection();
  
  if (!hasConnection) {
    // Save to offline queue
    await _saveToOfflineQueue(qrData, location, deviceId);
    return ScanResultEntity(status: ScanStatus.offline);
  }
  
  // Submit to server
  return await _repository.submitAttendanceScan(
    qrData: qrData,
    latitude: location.latitude,
    longitude: location.longitude,
    deviceId: deviceId,
  );
}
```

#### Bước 13-14: API Call
**File:** `apps/omnimereduapp/lib/data/datasources/remote/qr_attendance/qr_attendance_remote_datasource.dart`

```dart
Future<ScanResponseModel> submitAttendanceScan(
  ScanRequestModel request,
) async {
  final response = await _apiClient.post(
    Endpoints.submitAttendanceScan, // "/v1/attendance/scan"
    data: request.toJson(),
  );
  return ScanResponseModel.fromJson(response.data);
}
```

**File:** `apps/omnimereduapp/lib/data/models/qr_attendance/scan_request_model.dart`

```dart
class ScanRequestModel {
  final String qrData;
  final double latitude;
  final double longitude;
  final String deviceId;
  final String timestamp;
}
```

#### Bước 15: Backend Processing (Cần implement)

**Endpoint cần implement:**
```
POST /api/v1/attendance/scan
```

**Logic cần có:**
1. Decode QR data (base64 → JSON)
2. Verify attendanceId tồn tại
3. Verify QR chưa hết hạn (so sánh timestamp với expiry)
4. Lấy thông tin School để lấy location và allowedRadius
5. Tính khoảng cách giữa student location và school location
6. Nếu distance > allowedRadius → return "out_of_range"
7. Kiểm tra student đã điểm danh chưa (DetailsRecord)
8. Nếu chưa → tạo DetailsRecord với status = "Present"
9. Return success response

**File tham khảo:** `services/api/src/domain/services/school/attendance/attendance.service.ts`

#### Bước 16-20: Response Processing
**File:** `apps/omnimereduapp/lib/data/models/qr_attendance/scan_response_model.dart`

```dart
class ScanResponseModel {
  final String status; // "success" | "expired" | "out_of_range" | ...
  final String message;
  final DateTime? attendanceTime;
  final double? distance;
  final String? attendanceId;
}
```

**File:** `apps/omnimereduapp/lib/presentation/screens/qr_attendance/student/widgets/scan_result_dialog.dart`

Dialog hiển thị kết quả với icon và màu sắc:
- ✅ Success: Xanh lá
- ⚠️ Warning: Vàng
- ❌ Error: Đỏ
- 📶 Offline: Xanh dương

---

## 📴 Workflow Offline Mode

### Mục đích
Lưu điểm danh khi mất mạng và tự động đồng bộ khi có mạng trở lại.

### Luồng hoạt động

```
1. Student quét QR khi OFFLINE
   ↓
2. SubmitAttendanceUsecase phát hiện không có mạng
   ↓
3. OfflineQueueService.addScan() lưu vào SQLite
   ↓
4. ScanResultEntity(status: offline) được trả về
   ↓
5. UI hiển thị "Đã lưu điểm danh offline"
   ↓
6. AutoSyncService đang chạy background
   ↓
7. ConnectivityService phát hiện có mạng lại
   ↓
8. AutoSyncService._performSync() được trigger
   ↓
9. SyncOfflineScansUsecase được gọi
   ↓
10. OfflineQueueService.getUnsyncedScans() lấy danh sách
    ↓
11. Với mỗi scan:
    - Tạo ScanRequestModel từ OfflineScanModel
    - Gọi QRAttendanceRepository.submitAttendanceScan()
    - Nếu thành công → markAsSynced()
    - Nếu lỗi → updateError()
    ↓
12. Trả về số lượng đã sync thành công
```

### Chi tiết các bước

#### Bước 1-5: Save Offline
**File:** `apps/omnimereduapp/lib/domain/usecases/qr_attendance/submit_attendance_usecase.dart`

```dart
if (!hasConnection) {
  await _saveToOfflineQueue(qrData, location, deviceId);
  return ScanResultEntity(status: ScanStatus.offline);
}
```

**File:** `apps/omnimereduapp/lib/services/offline_queue_service.dart`

```dart
Future<int> addScan(OfflineScanModel scan) async {
  final db = await database;
  final id = await db.insert('offline_scans', scan.toDatabase());
  return id;
}
```

**Database Schema (SQLite):**
```sql
CREATE TABLE offline_scans (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  qrData TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  deviceId TEXT NOT NULL,
  scanTime TEXT NOT NULL,
  isSynced INTEGER NOT NULL DEFAULT 0,
  errorMessage TEXT
)
```

#### Bước 6-8: Auto Sync Service
**File:** `apps/omnimereduapp/lib/services/auto_sync_service.dart`

```dart
void start() {
  // Listen to connectivity changes
  _connectivitySubscription = _connectivityService
    .onConnectivityChanged
    .listen((isOnline) {
      if (isOnline) {
        _performSync();
      }
    });
  
  // Periodic sync every 5 minutes
  _periodicSyncTimer = Timer.periodic(
    Duration(minutes: 5),
    (timer) => _performSync(),
  );
}
```

**File:** `apps/omnimereduapp/lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // DI
  
  // Start auto sync
  final autoSyncService = sl<AutoSyncService>();
  autoSyncService.start();
  
  runApp(MyApp());
}
```

#### Bước 9-12: Sync Process
**File:** `apps/omnimereduapp/lib/domain/usecases/qr_attendance/sync_offline_scans_usecase.dart`

```dart
Future<int> call() async {
  final unsyncedScans = await _offlineQueueService.getUnsyncedScans();
  int syncedCount = 0;
  
  for (final scan in unsyncedScans) {
    try {
      final request = ScanRequestModel(
        qrData: scan.qrData,
        latitude: scan.latitude,
        longitude: scan.longitude,
        deviceId: scan.deviceId,
        timestamp: scan.scanTime, // Use original scan time
      );
      
      await _repository.submitAttendanceScan(
        qrData: request.qrData,
        latitude: request.latitude,
        longitude: request.longitude,
        deviceId: request.deviceId,
      );
      
      await _offlineQueueService.markAsSynced(scan.id!);
      syncedCount++;
    } catch (e) {
      await _offlineQueueService.updateError(scan.id!, e.toString());
    }
  }
  
  return syncedCount;
}
```

---

## 📁 Chi tiết các file và vai trò

### Mobile App - Presentation Layer

#### Teacher Side
| File | Vai trò |
|------|---------|
| `qr_display_screen.dart` | Màn hình chính hiển thị QR code |
| `qr_display_bloc.dart` | Quản lý state cho QR display |
| `qr_display_event.dart` | Events: Generate, Refresh, Expired |
| `qr_display_state.dart` | States: Loading, Success, Error |
| `qr_code_widget.dart` | Widget hiển thị QR với logo |
| `qr_timer_widget.dart` | Widget đếm ngược thời gian |
| `attendance_info_card.dart` | Widget hiển thị thông tin lớp |

#### Student Side
| File | Vai trò |
|------|---------|
| `qr_scanner_screen.dart` | Màn hình quét QR với camera |
| `qr_scanner_bloc.dart` | Quản lý state cho QR scanner |
| `qr_scanner_event.dart` | Events: Initialize, Scan, Reset |
| `qr_scanner_state.dart` | States: Ready, Scanning, Success, Error |
| `scanner_overlay.dart` | Overlay khung quét trên camera |
| `offline_indicator.dart` | Widget hiển thị trạng thái offline |
| `scan_result_dialog.dart` | Dialog hiển thị kết quả quét |

### Mobile App - Domain Layer

| File | Vai trò |
|------|---------|
| `qr_code_entity.dart` | Entity chứa QR code data và business logic |
| `location_entity.dart` | Entity chứa thông tin vị trí GPS |
| `scan_result_entity.dart` | Entity chứa kết quả điểm danh |
| `qr_attendance_repository.dart` | Interface repository |
| `generate_qr_code_usecase.dart` | UseCase tạo QR code |
| `submit_attendance_usecase.dart` | UseCase submit điểm danh |
| `verify_location_usecase.dart` | UseCase kiểm tra vị trí (chưa dùng) |
| `sync_offline_scans_usecase.dart` | UseCase đồng bộ offline scans |

### Mobile App - Data Layer

| File | Vai trò |
|------|---------|
| `qr_attendance_repository_impl.dart` | Implementation repository |
| `qr_attendance_remote_datasource.dart` | Remote API calls |
| `qr_data_model.dart` | Model cho QR data response |
| `scan_request_model.dart` | Model cho scan request |
| `scan_response_model.dart` | Model cho scan response |
| `offline_scan_model.dart` | Model cho offline scan data |

### Mobile App - Services

| File | Vai trò |
|------|---------|
| `location_service.dart` | Lấy vị trí GPS, kiểm tra permission |
| `brightness_service.dart` | Điều chỉnh độ sáng màn hình |
| `connectivity_service.dart` | Kiểm tra trạng thái mạng |
| `offline_queue_service.dart` | Quản lý SQLite database cho offline scans |
| `auto_sync_service.dart` | Tự động đồng bộ khi có mạng |

### Mobile App - Core

| File | Vai trò |
|------|---------|
| `endpoints.dart` | Định nghĩa API endpoints |
| `qr_theme.dart` | Theme colors cho QR feature |
| `injection_container.dart` | Dependency injection setup |

### Backend - API Service

| File | Vai trò |
|------|---------|
| `attendance.controller.ts` | HTTP request handlers |
| `attendance.service.ts` | Business logic (generateQRCode) |
| `attendance.repository.ts` | Data access layer |
| `Attendance.ts` | MongoDB model schema |

### Backend - Cần implement

| Endpoint | File cần tạo | Mô tả |
|----------|--------------|-------|
| `POST /api/v1/attendance/scan` | `attendance.controller.ts` | Handler scan request |
| - | `attendance.service.ts` | Logic xử lý scan |
| - | - | Verify QR, location, tạo DetailsRecord |

---

## 🔄 Luồng dữ liệu (Data Flow)

### Teacher Flow - Generate QR

```
User Action
    ↓
QRDisplayScreen
    ↓
QRDisplayBloc (Event: GenerateQRCodeEvent)
    ↓
GenerateQRCodeUsecase
    ↓
QRAttendanceRepository (Interface)
    ↓
QRAttendanceRepositoryImpl
    ↓
QRAttendanceRemoteDatasource
    ↓
API Client → HTTP GET /v1/attendance/:id/qr
    ↓
Backend: AttendanceController.generateQRCode()
    ↓
Backend: AttendanceService.generateQRCode()
    ↓
Response: { attendanceId, qrData, expiry, dynamicCode }
    ↓
QRDataModel.fromJson()
    ↓
QRCodeEntity
    ↓
QRDisplayBloc (State: QRDisplaySuccess)
    ↓
QRDisplayScreen (UI Update)
```

### Student Flow - Scan QR

```
User Action (Scan QR)
    ↓
MobileScanner.onDetect()
    ↓
QRScannerBloc (Event: QRCodeScannedEvent)
    ↓
SubmitAttendanceUsecase
    ↓
LocationService.getCurrentLocation()
    ↓
ConnectivityService.hasConnection()
    ↓
┌─────────────────┬──────────────────┐
│   OFFLINE       │     ONLINE       │
│                 │                  │
│ OfflineQueue    │ QRAttendanceRepo │
│ Service.addScan │ .submitScan()    │
│                 │                  │
│ SQLite DB       │ API Client       │
│                 │ POST /scan       │
│                 │                  │
│                 │ Backend Process  │
│                 │ - Decode QR      │
│                 │ - Verify expiry  │
│                 │ - Check location │
│                 │ - Create Record  │
│                 │                  │
│                 │ Response         │
│                 │                  │
└─────────────────┴──────────────────┘
         ↓                    ↓
    ScanResultEntity    ScanResultEntity
         ↓                    ↓
    QRScannerBloc (State: Success/Error)
         ↓
    ScanResultDialog (UI)
```

### Offline Sync Flow

```
ConnectivityService.onConnectivityChanged
    ↓
AutoSyncService._performSync()
    ↓
SyncOfflineScansUsecase
    ↓
OfflineQueueService.getUnsyncedScans()
    ↓
For each scan:
    ↓
SubmitAttendanceUsecase (với scan data)
    ↓
QRAttendanceRepository.submitAttendanceScan()
    ↓
API Call → Backend
    ↓
┌─────────────┬──────────────┐
│   Success   │    Error     │
│             │              │
│ markAsSynced│ updateError  │
└─────────────┴──────────────┘
```

---

## 🌐 API Endpoints

### 1. Generate QR Code (Teacher)

**Endpoint:** `GET /api/v1/attendance/:attendanceId/qr`

**Request:**
```http
GET /api/v1/attendance/507f1f77bcf86cd799439011/qr
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "message": "Tạo mã QR thành công",
  "data": {
    "attendanceId": "507f1f77bcf86cd799439011",
    "qrData": "eyJhdHRlbmRhbmNlSWQiOiI1MDdmMWY3N2JjZjg2Y2Q3OTk0MzkwMTEiLCJ0aW1lc3RhbXAiOiIyMDI1LTEyLTEzVDEwOjAwOjAwLjAwMFoiLCJkeW5hbWljQ29kZSI6IjEyMzQ1NiJ9",
    "expiry": "2025-12-13T10:01:00.000Z",
    "dynamicCode": "123456"
  }
}
```

**QR Data Decoded:**
```json
{
  "attendanceId": "507f1f77bcf86cd799439011",
  "timestamp": "2025-12-13T10:00:00.000Z",
  "dynamicCode": "123456"
}
```

### 2. Submit Attendance Scan (Student)

**Endpoint:** `POST /api/v1/attendance/scan` ⚠️ **Cần implement**

**Request:**
```http
POST /api/v1/attendance/scan
Authorization: Bearer <token>
Content-Type: application/json

{
  "qrData": "eyJhdHRlbmRhbmNlSWQiOiI1MDdmMWY3N2JjZjg2Y2Q3OTk0MzkwMTEiLCJ0aW1lc3RhbXAiOiIyMDI1LTEyLTEzVDEwOjAwOjAwLjAwMFoiLCJkeW5hbWljQ29kZSI6IjEyMzQ1NiJ9",
  "latitude": 10.762622,
  "longitude": 106.660172,
  "deviceId": "android-device-1234567890",
  "timestamp": "2025-12-13T10:00:30.000Z"
}
```

**Response Success:**
```json
{
  "success": true,
  "message": "Điểm danh thành công",
  "data": {
    "status": "success",
    "message": "Điểm danh thành công",
    "attendanceTime": "2025-12-13T10:00:30.000Z",
    "distance": 45.5,
    "attendanceId": "507f1f77bcf86cd799439011"
  }
}
```

**Response Error - Expired:**
```json
{
  "success": false,
  "message": "Mã QR đã hết hạn",
  "data": {
    "status": "expired",
    "message": "Mã QR đã hết hạn. Vui lòng quét mã mới."
  }
}
```

**Response Error - Out of Range:**
```json
{
  "success": false,
  "message": "Vị trí không hợp lệ",
  "data": {
    "status": "out_of_range",
    "message": "Bạn đang ở quá xa lớp học. Khoảng cách: 150m (cho phép: 100m)",
    "distance": 150.0
  }
}
```

**Response Error - Already Scanned:**
```json
{
  "success": false,
  "message": "Đã điểm danh",
  "data": {
    "status": "already_scanned",
    "message": "Bạn đã điểm danh cho buổi học này rồi."
  }
}
```

---

## 🗄️ Database Schema

### MongoDB - Backend

#### Attendance Collection
```typescript
{
  _id: ObjectId,
  classId: ObjectId,
  schoolId: ObjectId,
  date: Date,
  sessionType: String, // "morning" | "afternoon" | "full_day"
  // ... other fields
}
```

#### DetailsRecord Collection
```typescript
{
  _id: ObjectId,
  attendanceId: ObjectId,
  studentId: ObjectId,
  status: String, // "Present" | "Absent" | "Late"
  scanTime: Date, // Thời gian quét QR
  scanLocation: {
    type: "Point",
    coordinates: [longitude, latitude]
  },
  deviceId: String,
  qrData: String, // QR data đã quét
  // ... other fields
}
```

#### School Collection (Cần update)
```typescript
{
  _id: ObjectId,
  name: String,
  // ... other fields
  location: {
    type: { type: String, default: 'Point' },
    coordinates: [Number], // [longitude, latitude]
    index: '2dsphere'
  },
  allowedRadius: { type: Number, default: 100 } // meters
}
```

### SQLite - Mobile App

#### offline_scans Table
```sql
CREATE TABLE offline_scans (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  qrData TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  deviceId TEXT NOT NULL,
  scanTime TEXT NOT NULL,
  isSynced INTEGER NOT NULL DEFAULT 0,
  errorMessage TEXT
);
```

---

## ⚠️ Error Handling

### Mobile App Error Types

#### 1. Network Errors
- **Timeout**: Request quá lâu
- **No Connection**: Không có mạng → Lưu offline
- **Server Error**: 500, 502, 503 → Retry hoặc lưu offline

**File:** `apps/omnimereduapp/lib/data/datasources/remote/qr_attendance/qr_attendance_remote_datasource.dart`

```dart
try {
  final response = await _apiClient.get<QRDataModel>(...);
  // ...
} catch (e) {
  // Error đã được log ở ApiClient interceptor
  rethrow;
}
```

#### 2. Location Errors
- **Permission Denied**: User từ chối quyền vị trí
- **Service Disabled**: GPS chưa bật
- **Timeout**: Không lấy được vị trí trong thời gian cho phép

**File:** `apps/omnimereduapp/lib/services/location_service.dart`

```dart
if (e is LocationPermissionDeniedException) {
  throw LocationPermissionDeniedException('Quyền truy cập vị trí bị từ chối');
}
```

#### 3. QR Code Errors
- **Invalid QR**: QR không đúng format
- **Expired**: QR đã hết hạn
- **Already Scanned**: Đã điểm danh rồi

**File:** `apps/omnimereduapp/lib/presentation/screens/qr_attendance/student/widgets/scan_result_dialog.dart`

```dart
switch (result.status) {
  case ScanStatus.success:
    // Hiển thị success
    break;
  case ScanStatus.expired:
    // Hiển thị expired
    break;
  case ScanStatus.outOfRange:
    // Hiển thị out of range
    break;
  // ...
}
```

### Backend Error Handling

#### 1. Validation Errors
- **Invalid QR Data**: Không decode được
- **Missing Fields**: Thiếu latitude, longitude
- **Invalid Attendance ID**: Attendance không tồn tại

#### 2. Business Logic Errors
- **QR Expired**: So sánh timestamp với expiry
- **Out of Range**: Distance > allowedRadius
- **Already Scanned**: DetailsRecord đã tồn tại

**Example Implementation:**
```typescript
async submitAttendanceScan(req: Request, res: Response) {
  try {
    const { qrData, latitude, longitude, deviceId, timestamp } = req.body;
    
    // Decode QR
    const decoded = JSON.parse(Buffer.from(qrData, 'base64').toString());
    const { attendanceId, timestamp: qrTimestamp, dynamicCode } = decoded;
    
    // Verify attendance exists
    const attendance = await this.attendanceService.getAttendanceById(...);
    if (!attendance) {
      return sendError(res, "Attendance not found", 404);
    }
    
    // Verify expiry
    const expiry = new Date(attendance.qrConfig?.expiryTime);
    if (new Date() > expiry) {
      return sendSuccess(res, {
        status: "expired",
        message: "Mã QR đã hết hạn"
      });
    }
    
    // Get school location
    const school = await this.schoolRepository.findById(attendance.schoolId);
    const schoolLocation = school.location.coordinates;
    const allowedRadius = school.allowedRadius || 100;
    
    // Calculate distance
    const distance = getDistance(
      { latitude, longitude },
      { latitude: schoolLocation[1], longitude: schoolLocation[0] }
    );
    
    if (distance > allowedRadius) {
      return sendSuccess(res, {
        status: "out_of_range",
        message: `Bạn đang ở quá xa lớp học. Khoảng cách: ${distance}m`,
        distance
      });
    }
    
    // Check if already scanned
    const existingRecord = await this.detailsRecordRepository.findOne({
      attendanceId,
      studentId: req.user.id
    });
    
    if (existingRecord) {
      return sendSuccess(res, {
        status: "already_scanned",
        message: "Bạn đã điểm danh cho buổi học này rồi"
      });
    }
    
    // Create DetailsRecord
    const record = await this.detailsRecordRepository.create({
      attendanceId,
      studentId: req.user.id,
      status: "Present",
      scanTime: new Date(timestamp),
      scanLocation: {
        type: "Point",
        coordinates: [longitude, latitude]
      },
      deviceId,
      qrData
    });
    
    return sendSuccess(res, {
      status: "success",
      message: "Điểm danh thành công",
      attendanceTime: record.scanTime,
      distance,
      attendanceId
    });
    
  } catch (error) {
    return next(error);
  }
}
```

---

## 🔐 Security Considerations

### 1. QR Code Security
- **Base64 Encoding**: Chỉ encode, không encrypt (có thể cải thiện)
- **Dynamic Code**: 6 digits random để tránh reuse
- **Expiry Time**: 1 phút để giảm risk
- **Signature**: Có thể thêm HMAC signature để verify

### 2. Location Verification
- **Geo-fencing**: Kiểm tra trong bán kính cho phép
- **GPS Spoofing**: Khó chặn hoàn toàn, nhưng có thể detect bằng:
  - Accuracy level
  - Speed changes
  - Multiple devices same location

### 3. API Security
- **Authentication**: Bearer token required
- **Rate Limiting**: Giới hạn số lần scan/student
- **Device ID**: Track device để phát hiện abuse

---

## 📊 Performance Considerations

### Mobile App
- **Camera Performance**: MobileScanner optimized
- **Location Caching**: Cache location để giảm API calls
- **Offline Queue**: SQLite efficient cho local storage
- **Auto Sync**: Background sync không block UI

### Backend
- **Database Indexes**: 
  - `attendanceId` index trên DetailsRecord
  - `2dsphere` index trên School.location
- **Caching**: Cache school location data
- **Connection Pooling**: MongoDB connection pool

---

## 🧪 Testing Scenarios

### Teacher Flow
1. ✅ Generate QR code thành công
2. ✅ QR code hiển thị với logo
3. ✅ Timer đếm ngược chính xác
4. ✅ Auto refresh khi hết hạn
5. ✅ Brightness tự động tăng

### Student Flow
1. ✅ Scan QR thành công trong phạm vi
2. ✅ Scan QR ngoài phạm vi → Error
3. ✅ Scan QR hết hạn → Error
4. ✅ Scan QR khi offline → Lưu local
5. ✅ Auto sync khi có mạng lại
6. ✅ Permission denied → Error message

### Edge Cases
1. ✅ Multiple scans cùng lúc
2. ✅ Network timeout
3. ✅ GPS không available
4. ✅ Camera permission denied
5. ✅ Invalid QR format

---

## 📝 Notes & Best Practices

### 1. QR Code Expiry
- Hiện tại: 1 phút
- Có thể điều chỉnh trong `attendance.service.ts`:
  ```typescript
  const QR_EXPIRY_MINUTES = 1; // Thay đổi ở đây
  ```

### 2. Location Accuracy
- Sử dụng `LocationAccuracy.high` cho độ chính xác cao
- Timeout: 10 giây để tránh chờ quá lâu

### 3. Offline Queue
- Cleanup old scans: 7 ngày (có thể config)
- Max queue size: Không giới hạn (có thể thêm)

### 4. Auto Sync
- Interval: 5 phút
- Trigger: Khi có mạng lại
- Retry: Không retry tự động (cần manual)

---

## 🚀 Next Steps / TODO

### Backend
- [ ] Implement `POST /api/v1/attendance/scan` endpoint
- [ ] Add geo-fencing logic
- [ ] Add QR signature verification
- [ ] Add rate limiting
- [ ] Update School model với location fields

### Mobile App
- [ ] Improve device ID generation (use device_info_plus)
- [ ] Add retry mechanism cho failed syncs
- [ ] Add manual sync button
- [ ] Improve error messages
- [ ] Add analytics tracking

### Testing
- [ ] Unit tests cho UseCases
- [ ] Integration tests cho API
- [ ] E2E tests cho full flow
- [ ] Performance tests

---

## 📞 Support & References

- **Documentation Index**: `docs/feature/QR_code_attendance/README.md`
- **Quick Start**: `docs/feature/QR_code_attendance/QUICKSTART.md`
- **Implementation Guide**: `docs/feature/QR_code_attendance/IMPLEMENTATION.md`
- **Permissions**: `docs/feature/QR_code_attendance/PERMISSIONS.md`
- **Feature Spec**: `docs/feature/QR_code_attendance/QR.md`

---

**Last Updated:** December 13, 2025  
**Version:** 1.0.0  
**Author:** AI Assistant

