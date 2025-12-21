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
