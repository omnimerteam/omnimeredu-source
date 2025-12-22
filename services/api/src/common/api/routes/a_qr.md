# Plan for QR Attendance Implementation

## 1. Context & Objectives

The goal is to implement a robust QR Attendance system where:

- **Teachers** genearte a dynamic QR code for a specific `Attendance` session (class).
- **Students** scan the QR code using their mobile app.
- **System** validates the scan based on:
  - **QR Validity**: Is the code correct and not expired?
  - **Location**: Is the student within the allowed radius of the class?
  - **Device**: Is the student using a unique device (optional security)?
- **Offline Support**: Students can scan offline, and the app syncs later.

## 2. Database Schema Updates

### A. Attendance Schema (`Attendance`)

We need to store the configuration for the QR session.

```typescript
// Add to Attendance Schema
{
  // ... existing fields
  qrConfig: {
    enabled: boolean;          // Is QR attendance active?
    code: string;              // The current active QR string (or seed)
    expiry: Date;              // When this QR code expires
    dynamicCode?: string;      // Rotating code part for security
    location: {
      latitude: number;
      longitude: number;
      radius: number;          // Allowed radius in meters
    };
    allowedDevices?: string[]; // List of allowed device IDs (optional)
  }
}
```

### B. DetailsRecord Schema (`DetailsRecord`)

We need to store the proof of attendance.

```typescript
// Add to DetailsRecord Schema
{
  // ... existing fields
  attendanceProof: {
    method: 'QR' | 'MANUAL';
    scanTime?: Date;
    location?: {
      latitude: number;
      longitude: number;
      distance: number; // Distance from center
    };
    deviceId?: string;
    isOfflineSync?: boolean; // Was this an offline sync record?
  }
}
```

## 3. API Routes Implementation

### A. Generate QR (`GET /api/v1/attendances/:id/qr`)

- **Role**: Teacher, Admin.
- **Logic**:
  1. Check if `Attendance` exists.
  2. Generate a secured QR payload (signed unique string).
  3. Update `Attendance.qrConfig` with the new code and expiry (e.g., 5-15 mins).
  4. Return `QRDataModel` structure expected by frontend.
- **Response**: `{ attendanceId, qrData, expiry, dynamicCode }`.

### B. Submit Scan (`POST /api/v1/attendances/scan`)

- **Role**: Student.
- **Payload**: `ScanRequestModel`

```json
{
  "qrData": "string",
  "latitude": number,
  "longitude": number,
  "deviceId": "string",
  "timestamp": "ISO-Date"
}
```

- **Logic**:
  1. Find `Attendance` based on `qrData` (decrypted/parsed).
  2. **Validate QR**: Check if it matches active code and `timestamp` < `expiry`.
  3. **Validate Location**: Calculate distance between `user location` and `class location`. If > `radius`, reject (created `OUT_OF_RANGE` status).
  4. **Find Student Record**: Find the `DetailsRecord` for this student and `Attendance`.
  5. **Update Status**: Set status to `PRESENT` (or `LATE`).
  6. Update `DetailsRecord` with `attendanceProof`.

### C. Offline Sync (`POST /api/v1/attendances/sync`)

- **Role**: Student.
- **Payload**: List of `OfflineScanModel`.
- **Logic**:
  - Iterate through scans.
  - Perform same validations as `scan` (except expiry might need leniency or strict checking based on `scanTime` captured on device vs server time).
  - Batch update records.

## 4. Backend Implementation Plan

### Step 1: Update Models

- Modify `src/domain/models/Attendance.ts` and `src/domain/models/DetailsRecord.ts`.

### Step 2: Implement Service Logic (`AttendanceService`)

- Add method `generateQR(attendanceId, config)`.
- Add method `processScan(studentId, scanData)`.
- Implement `LocationHelper` with Haversine formula.

### Step 3: Update Controllers (`AttendanceController`)

- Implement `generateQRCode`.
- Implement `submitScan`.

### Step 4: Add Routes (`attendance.route.ts`)

```typescript
router.post('/scan', ..., attendanceController.submitScan);
router.post('/sync', ..., attendanceController.syncScans);
```

### Step 5: Test with Frontend

- Verify `ScanResponseModel` matches the backend response.

---

## 5. Implementation Progress Tracking

### Backend (API)

| Step   | Task                                                               | Status         |
| ------ | ------------------------------------------------------------------ | -------------- |
| Step 1 | Update Models (`Attendance.ts`, `DetailsRecord.ts`) with QR fields | ✅ Done        |
| Step 2 | Implement Service Logic (`AttendanceService`)                      | ✅ Done        |
| Step 3 | Update Controllers (`AttendanceController`)                        | ✅ Done        |
| Step 4 | Add Routes (`attendance.route.ts`)                                 | ✅ Done        |
| Step 5 | Test with Frontend                                                 | ⏳ In Progress |

### Client (Flutter App)

| Layer                    | Component                           | Status   |
| ------------------------ | ----------------------------------- | -------- |
| **Data/Models**          | `ScanRequestModel`                  | ✅ Done  |
|                          | `ScanResponseModel`                 | ✅ Done  |
|                          | `QRDataModel`                       | ✅ Done  |
|                          | `OfflineScanModel`                  | ✅ Done  |
| **Data/Datasources**     | `QRAttendanceRemoteDatasource`      | ✅ Done  |
| **Data/Repositories**    | `QRAttendanceRepositoryImpl`        | ✅ Done  |
| **Domain/Entities**      | `QRCodeEntity`                      | ✅ Done  |
|                          | `ScanResultEntity`                  | ✅ Done  |
|                          | `LocationEntity`                    | ✅ Done  |
| **Domain/Repositories**  | `QRAttendanceRepository` (abstract) | ✅ Done  |
| **Domain/Usecases**      | `GenerateQRCodeUsecase`             | ✅ Done  |
|                          | `SubmitAttendanceUsecase`           | ✅ Done  |
|                          | `SyncOfflineScansUsecase`           | ✅ Done  |
|                          | `VerifyLocationUsecase`             | ✅ Done  |
| **Services**             | `LocationService`                   | ✅ Done  |
|                          | `OfflineQueueService`               | ✅ Done  |
|                          | `ConnectivityService`               | ✅ Done  |
|                          | `BrightnessService`                 | ✅ Done  |
| **Presentation/Blocs**   | `QRDisplayBloc` (Teacher)           | ✅ Done  |
|                          | `QRScannerBloc` (Student)           | ✅ Done  |
| **Presentation/Screens** | `QRDisplayScreen` (Teacher)         | ✅ Done  |
|                          | `QRScannerScreen` (Student)         | ✅ Done  |
| **Core/Network**         | `Endpoints` (QR routes)             | ✅ Fixed |
| **DI**                   | `injection_container.dart`          | ✅ Done  |

### Issues Fixed

| Issue          | Description                                                    | Status   |
| -------------- | -------------------------------------------------------------- | -------- |
| Endpoints typo | Endpoints used `/v1/attendance/` instead of `/v1/attendances/` | ✅ Fixed |

**Last Updated:** 2025-12-22

---

## 6. API Test Examples

### Base URL

```
http://localhost:3000/api/v1/attendances
```

### A. Generate QR Code (Teacher/Admin)

**Endpoint:** `GET /api/v1/attendances/:attendanceId/qr`

**Headers:**

```json
{
  "Authorization": "Bearer <JWT_TOKEN>"
}
```

**Example Request:**

```bash
curl -X GET "http://localhost:3000/api/v1/attendances/6762abc123def456/qr" \
  -H "Authorization: Bearer <YOUR_JWT_TOKEN>"
```

**Expected Response:**

```json
{
  "success": true,
  "message": "Tạo mã QR thành công",
  "data": {
    "attendanceId": "6762abc123def456",
    "qrData": "eyJhdHRlbmRhbmNlSWQiOiI2NzYyYWJjMTIzZGVmNDU2IiwidGltZXN0YW1wIjoiMjAyNS0xMi0yMlQxMTowMDowMC4wMDBaIiwiZHluYW1pY0NvZGUiOiI4NTIzNDEifQ==",
    "expiry": "2025-12-22T11:03:00.000Z",
    "dynamicCode": "852341"
  }
}
```

---

### B. Submit Scan (Student)

**Endpoint:** `POST /api/v1/attendances/scan`

**Headers:**

```json
{
  "Authorization": "Bearer <STUDENT_JWT_TOKEN>",
  "Content-Type": "application/json"
}
```

**Request Body:**

```json
{
  "qrData": "eyJhdHRlbmRhbmNlSWQiOiI2NzYyYWJjMTIzZGVmNDU2IiwidGltZXN0YW1wIjoiMjAyNS0xMi0yMlQxMTowMDowMC4wMDBaIiwiZHluYW1pY0NvZGUiOiI4NTIzNDEifQ==",
  "latitude": 10.762622,
  "longitude": 106.660172,
  "deviceId": "device-uuid-12345",
  "timestamp": "2025-12-22T11:01:30.000Z"
}
```

**Example Request:**

```bash
curl -X POST "http://localhost:3000/api/v1/attendances/scan" \
  -H "Authorization: Bearer <STUDENT_JWT_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "qrData": "eyJhdHRlbmRhbmNlSWQiOiI2NzYyYWJjMTIzZGVmNDU2IiwidGltZXN0YW1wIjoiMjAyNS0xMi0yMlQxMTowMDowMC4wMDBaIiwiZHluYW1pY0NvZGUiOiI4NTIzNDEifQ==",
    "latitude": 10.762622,
    "longitude": 106.660172,
    "deviceId": "device-uuid-12345",
    "timestamp": "2025-12-22T11:01:30.000Z"
  }'
```

**Success Response:**

```json
{
  "success": true,
  "message": "Điểm danh thành công!",
  "data": {
    "status": "success",
    "message": "Điểm danh thành công!",
    "attendanceTime": "2025-12-22T11:01:35.000Z",
    "distance": 15.5,
    "attendanceId": "6762abc123def456"
  }
}
```

**Error Responses:**

- QR không hợp lệ:

```json
{
  "success": false,
  "message": "Mã QR không hợp lệ"
}
```

- QR hết hạn:

```json
{
  "success": false,
  "message": "Mã QR đã hết hạn"
}
```

- Ngoài phạm vi:

```json
{
  "success": false,
  "message": "Bạn đang ở ngoài phạm vi điểm danh",
  "data": {
    "status": "out_of_range",
    "distance": 250.5
  }
}
```

---

### C. Sync Offline Scans (Student)

**Endpoint:** `POST /api/v1/attendances/sync`

**Headers:**

```json
{
  "Authorization": "Bearer <STUDENT_JWT_TOKEN>",
  "Content-Type": "application/json"
}
```

**Request Body:**

```json
{
  "scans": [
    {
      "qrData": "eyJhdHRlbmRhbmNlSWQi...",
      "latitude": 10.762622,
      "longitude": 106.660172,
      "deviceId": "device-uuid-12345",
      "timestamp": "2025-12-22T08:01:30.000Z"
    },
    {
      "qrData": "eyJhdHRlbmRhbmNlSWQy...",
      "latitude": 10.762622,
      "longitude": 106.660172,
      "deviceId": "device-uuid-12345",
      "timestamp": "2025-12-22T09:01:30.000Z"
    }
  ]
}
```

**Example Request:**

```bash
curl -X POST "http://localhost:3000/api/v1/attendances/sync" \
  -H "Authorization: Bearer <STUDENT_JWT_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "scans": [
      {
        "qrData": "eyJhdHRlbmRhbmNlSWQi...",
        "latitude": 10.762622,
        "longitude": 106.660172,
        "deviceId": "device-uuid-12345",
        "timestamp": "2025-12-22T08:01:30.000Z"
      }
    ]
  }'
```

**Success Response:**

```json
{
  "success": true,
  "message": "Đồng bộ thành công",
  "data": {
    "synced": 2,
    "failed": 0,
    "results": [
      { "status": "success", "attendanceId": "..." },
      { "status": "success", "attendanceId": "..." }
    ]
  }
}
```

---

## 7. Notes for Testing

### Prerequisites:

1. Đảm bảo có một `Attendance` record hợp lệ trong database
2. Có student account với JWT token hợp lệ
3. Có teacher/admin account để generate QR

### Testing Flow:

1. **Teacher** gọi `GET /:id/qr` để tạo mã QR
2. Copy `qrData` từ response
3. **Student** gọi `POST /scan` với `qrData` đó
4. Kiểm tra `DetailsRecord` trong database để xác nhận điểm danh thành công
