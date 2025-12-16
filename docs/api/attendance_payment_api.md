# Payment-Attendance Service API Documentation

This document lists the available API endpoints for the Payment-Attendance Service, including input parameters and response structures.

**Base URL**: `/api`

---

## Table of Contents

1. [Attendance APIs](#1-attendance-apis)
   - [Write APIs (PostgreSQL)](#11-write-apis-postgresql)
   - [Read APIs (MongoDB)](#12-read-apis-mongodb)
2. [Tuition APIs](#2-tuition-apis)
3. [Payment APIs](#3-payment-apis)
   - [Write APIs (PostgreSQL)](#31-write-apis-postgresql)
   - [Read APIs (MongoDB)](#32-read-apis-mongodb)
4. [Holiday APIs](#4-holiday-apis)

---

## 1. Attendance APIs

### 1.1 Write APIs (PostgreSQL)

#### Create Attendance Session

- **Endpoint**: `POST /api/attendance`
- **Description**: Create a new attendance session for a class
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "classId": "string (required)",
    "schoolId": "string (required)",
    "date": "ISO 8601 date string (required)",
    "sessionType": "regular | weekend | holiday | extra (optional, default: regular)"
  }
  ```
- **Output**:
  ```json
  {
    "success": true,
    "message": "Attendance created successfully",
    "data": {
      "id": "string",
      "classId": "string",
      "schoolId": "string",
      "date": "ISO date",
      "sessionType": "regular",
      "createdAt": "ISO date",
      "updatedAt": "ISO date"
    }
  }
  ```

#### Initialize Class Attendance

- **Endpoint**: `POST /api/attendance/initialize`
- **Description**: Create or retrieve attendance for a class and initialize default "Present" records for all students
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "classId": "string (required)",
    "schoolId": "string (required)",
    "date": "ISO 8601 date string (required)",
    "sessionType": "regular | weekend | holiday | extra (optional)",
    "studentIds": ["string"] // Required: Array of student IDs
  }
  ```
- **Output**:
  ```json
  {
    "success": true,
    "message": "Attendance initialized successfully",
    "data": {
      "attendance": { ... },
      "records": [
        {
          "id": "string",
          "studentId": "string",
          "attendanceId": "string",
          "status": "Present",
          "note": null
        }
      ],
      "isNewAttendance": true
    }
  }
  ```

#### Get Attendance by ID

- **Endpoint**: `GET /api/attendance/:id`
- **Description**: Retrieve attendance details by ID
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input**: `id` (URL parameter)
- **Output**:
  ```json
  {
    "success": true,
    "message": "Attendance retrieved successfully",
    "data": {
      "id": "string",
      "classId": "string",
      "schoolId": "string",
      "date": "ISO date",
      "sessionType": "regular"
    }
  }
  ```

#### Generate QR Code

- **Endpoint**: `GET /api/attendance/:id/qr`
- **Description**: Generate QR code data for attendance session (valid for 3 minutes)
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input**: `id` (URL parameter)
- **Output**:
  ```json
  {
    "success": true,
    "message": "QR code generated successfully",
    "data": {
      "attendanceId": "string",
      "qrData": "base64 encoded string",
      "expiry": "ISO date (3 minutes from now)",
      "dynamicCode": "6-digit string"
    }
  }
  ```

#### Verify QR Attendance

- **Endpoint**: `POST /api/attendance/qr/verify`
- **Description**: Verify QR code scan and mark student attendance
- **Access**: Private (All authenticated users)
- **Input (JSON)**:
  ```json
  {
    "qrData": "string (required) - base64 encoded QR payload",
    "studentId": "string (required)",
    "dynamicCode": "string (optional) - 6-digit verification code"
  }
  ```
- **Output**:
  ```json
  {
    "success": true,
    "message": "Attendance marked successfully via QR code.",
    "data": {
      "id": "string",
      "studentId": "string",
      "attendanceId": "string",
      "status": "Present",
      "note": "Checked in via QR at ..."
    }
  }
  ```

#### Mark Manual Attendance (Single)

- **Endpoint**: `POST /api/attendance/:id/manual`
- **Description**: Mark attendance manually for a single student
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "studentId": "string (required)",
    "status": "Present | AbsentWithLeave | Absent | Late | LeftEarly (required)",
    "note": "string (optional, max 500 chars)"
  }
  ```
- **Output**:
  ```json
  {
    "success": true,
    "message": "Manual attendance marked successfully",
    "data": {
      "id": "string",
      "studentId": "string",
      "attendanceId": "string",
      "status": "Present",
      "note": "string"
    }
  }
  ```

#### Mark Manual Attendance (Bulk)

- **Endpoint**: `POST /api/attendance/:id/manual/bulk`
- **Description**: Mark attendance manually for multiple students at once
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "records": [
      {
        "studentId": "string (required)",
        "status": "Present | AbsentWithLeave | Absent | Late | LeftEarly (required)",
        "note": "string (optional)"
      }
    ]
  }
  ```
- **Output**:
  ```json
  {
    "success": true,
    "message": "Bulk manual attendance marked successfully",
    "data": [ { ... record objects } ]
  }
  ```

#### Get Attendance Records

- **Endpoint**: `GET /api/attendance/:id/records`
- **Description**: Get all attendance records for a specific attendance session
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input**: `id` (URL parameter)
- **Output**:
  ```json
  {
    "success": true,
    "message": "Attendance records retrieved successfully",
    "data": [
      {
        "id": "string",
        "studentId": "string",
        "attendanceId": "string",
        "status": "Present",
        "note": "string"
      }
    ]
  }
  ```

#### Bulk Create Attendance Records

- **Endpoint**: `POST /api/attendance/:id/records/bulk`
- **Description**: Create multiple attendance records at once
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "attendanceId": "string (optional, taken from URL)",
    "records": [
      {
        "studentId": "string (required)",
        "status": "Present | AbsentWithLeave | Absent | Late | LeftEarly (required)",
        "note": "string (optional)"
      }
    ]
  }
  ```
- **Output**:
  ```json
  {
    "success": true,
    "message": "Attendance records created successfully",
    "data": [ { ... record objects } ]
  }
  ```

#### Update Attendance Record

- **Endpoint**: `PATCH /api/attendance/records/:recordId`
- **Description**: Update a single attendance record
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "status": "Present | AbsentWithLeave | Absent | Late | LeftEarly (optional)",
    "note": "string (optional)"
  }
  ```
- **Output**: Updated record object

#### Update Attendance Status

- **Endpoint**: `PATCH /api/attendance/records/:recordId/status`
- **Description**: Update only the status of an attendance record
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "status": "Present | AbsentWithLeave | Absent | Late | LeftEarly (required)",
    "note": "string (optional)"
  }
  ```
- **Output**: Updated record object

---

### 1.2 Read APIs (MongoDB)

#### Get Monthly Attendance Report

- **Endpoint**: `GET /api/attendance/reports/monthly/:classId`
- **Description**: Get monthly attendance report for a class
- **Access**: Private (Teacher, SchoolAdmin, SuperAdmin)
- **Input**:
  - `classId` (URL parameter)
  - Query params: `month` (1-12), `year` (YYYY)
- **Output**: Monthly attendance statistics and records

#### Get Student Attendance History

- **Endpoint**: `GET /api/attendance/history/student/:studentId`
- **Description**: Get attendance history for a specific student
- **Access**: Private (All authenticated - students can see own history)
- **Input**:
  - `studentId` (URL parameter)
  - Query params: `startDate`, `endDate` (ISO dates)
- **Output**: List of attendance records for the student

---

## 2. Tuition APIs

#### Create Tuition

- **Endpoint**: `POST /api/tuition`
- **Description**: Create a new tuition record for a student
- **Access**: Private (SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "studentId": "string (required)",
    "schoolId": "string (required)",
    "classId": "string (required)",
    "periodStart": "ISO date (required)",
    "periodEnd": "ISO date (required)",
    "baseFeeSnapshot": "number (required)",
    "attendedDays": "number (optional)",
    "extraFeeDetails": [
      {
        "name": "string",
        "amount": "number"
      }
    ],
    "discountDetails": [
      {
        "name": "string",
        "amount": "number",
        "isPercentage": "boolean"
      }
    ],
    "month": "string (optional, e.g., '2024-01')",
    "dueDate": "ISO date (optional)"
  }
  ```
- **Output**: Created tuition object

#### Get Tuition by ID

- **Endpoint**: `GET /api/tuition/:id`
- **Description**: Get tuition details by ID
- **Access**: Private (Authenticated)
- **Input**: `id` (URL parameter)
- **Output**: Tuition object

#### Get Tuitions by Period

- **Endpoint**: `GET /api/tuition`
- **Description**: Get tuitions filtered by period
- **Access**: Private (Authenticated)
- **Input (Query params)**:
  - `studentId` (optional)
  - `schoolId` (optional)
  - `periodStart` (ISO date)
  - `periodEnd` (ISO date)
  - `status` (optional): Draft | Pending | Paid | Cancelled | Failed
- **Output**: List of tuition objects

#### Confirm Tuition

- **Endpoint**: `POST /api/tuition/:id/confirm`
- **Description**: Confirm a tuition record (change status from Draft to Pending)
- **Access**: Private (SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "confirmedBy": "string (required) - User ID who confirms"
  }
  ```
- **Output**: Updated tuition object

---

## 3. Payment APIs

### 3.1 Write APIs (PostgreSQL)

#### Create Payment

- **Endpoint**: `POST /api/payments`
- **Description**: Create a new payment record
- **Access**: Private (SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "studentId": "string (required)",
    "tuitionId": "string (required)",
    "paymentMethodId": "string (required)",
    "amount": "number (required)",
    "transactionId": "string (required)",
    "status": "Success | Failed (required)",
    "paidAt": "ISO date (required)"
  }
  ```
- **Output**: Created payment object

#### Get Payments by Student

- **Endpoint**: `GET /api/payments/student/:studentId`
- **Description**: Get all payments for a student
- **Access**: Private (Authenticated - students can see own payments)
- **Input**: `studentId` (URL parameter)
- **Output**: List of payment objects

#### Payment Callback (Webhook)

- **Endpoint**: `POST /api/payments/callback`
- **Description**: Handle payment gateway webhook callbacks
- **Access**: Public (uses webhook signature verification)
- **Input (JSON)**:
  ```json
  {
    "transactionId": "string (required)",
    "status": "Success | Failed (required)",
    "amount": "number (optional)",
    "metadata": "object (optional)"
  }
  ```
- **Output**: Acknowledgment response

---

### 3.2 Read APIs (MongoDB)

#### Get Payment History

- **Endpoint**: `GET /api/payments/history`
- **Description**: Get paginated payment history with filters
- **Access**: Private (SchoolAdmin, SuperAdmin)
- **Input (Query params)**:
  - `studentId` (optional)
  - `status` (optional): Success | Failed
  - `startDate` (ISO date)
  - `endDate` (ISO date)
  - `page` (number, default: 1)
  - `limit` (number, default: 20)
- **Output**: Paginated payment history

#### Get Student Payment Summary

- **Endpoint**: `GET /api/payments/summary/student/:studentId`
- **Description**: Get payment summary statistics for a student
- **Access**: Private (Authenticated - students can see own summary)
- **Input**: `studentId` (URL parameter)
- **Output**: Payment summary with totals and statistics

---

## 4. Holiday APIs

#### Create Holiday

- **Endpoint**: `POST /api/holidays`
- **Description**: Create a new holiday entry
- **Access**: Private (SchoolAdmin, SuperAdmin)
- **Input (JSON)**:
  ```json
  {
    "name": "string (required)",
    "date": "ISO date (required)",
    "isRecurring": "boolean (optional, default: false)",
    "type": "national | school (required)",
    "schoolId": "string (optional - required for school-specific holidays)"
  }
  ```
- **Output**: Created holiday object

#### Get Holidays by Date Range

- **Endpoint**: `GET /api/holidays`
- **Description**: Get holidays within a date range
- **Access**: Private (Authenticated)
- **Input (Query params)**:
  - `startDate` (ISO date, required)
  - `endDate` (ISO date, required)
  - `schoolId` (optional)
  - `type` (optional): national | school
- **Output**: List of holiday objects

#### Check if Date is Holiday

- **Endpoint**: `GET /api/holidays/check`
- **Description**: Check if a specific date is a holiday
- **Access**: Private (Authenticated)
- **Input (Query params)**:
  - `date` (ISO date, required)
  - `schoolId` (optional)
- **Output**:
  ```json
  {
    "success": true,
    "data": {
      "isHoliday": true,
      "holiday": { ... } // If is holiday
    }
  }
  ```

---

## Common Response Formats

### Success Response

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

### Error Response

```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error message"
}
```

### Validation Error Response

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "fieldName",
      "message": "Error message",
      "value": "Invalid value"
    }
  ]
}
```

---

## Attendance Status Types

| Status            | Description                           |
| ----------------- | ------------------------------------- |
| `Present`         | Student is present (default)          |
| `Absent`          | Student is absent without leave       |
| `AbsentWithLeave` | Student is absent with approved leave |
| `Late`            | Student arrived late                  |
| `LeftEarly`       | Student left before end of session    |

## Session Types

| Type      | Description                  |
| --------- | ---------------------------- |
| `regular` | Regular school day (default) |
| `weekend` | Weekend session              |
| `holiday` | Holiday session              |
| `extra`   | Extra/additional session     |

## Tuition Status Types

| Status      | Description                         |
| ----------- | ----------------------------------- |
| `Draft`     | Tuition is being prepared           |
| `Pending`   | Tuition confirmed, awaiting payment |
| `Paid`      | Payment completed                   |
| `Cancelled` | Tuition cancelled                   |
| `Failed`    | Payment failed                      |
