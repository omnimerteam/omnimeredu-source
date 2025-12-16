/**
 * DTO for initializing class attendance
 * Creates or retrieves attendance for a class and creates default records for all students
 */
export class InitializeClassAttendanceDto {
  classId!: string;
  schoolId!: string;
  date!: Date;
  sessionType?: "regular" | "weekend" | "holiday" | "extra";
  studentIds!: string[]; // List of student IDs in the class
}

/**
 * DTO for manual attendance marking (single student)
 */
export class ManualAttendanceDto {
  attendanceId!: string;
  studentId!: string;
  status!: "Present" | "AbsentWithLeave" | "Absent" | "Late" | "LeftEarly";
  note?: string;
}

/**
 * DTO for bulk manual attendance marking
 */
export class BulkManualAttendanceDto {
  attendanceId!: string;
  records!: {
    studentId: string;
    status: "Present" | "AbsentWithLeave" | "Absent" | "Late" | "LeftEarly";
    note?: string;
  }[];
}

/**
 * DTO for updating attendance record status
 */
export class UpdateAttendanceStatusDto {
  status!: "Present" | "AbsentWithLeave" | "Absent" | "Late" | "LeftEarly";
  note?: string;
}

/**
 * DTO for verifying QR attendance
 */
export class VerifyQRAttendanceDto {
  qrData!: string; // Base64 encoded QR payload
  studentId!: string;
  dynamicCode?: string; // Optional verification code displayed alongside QR
}
