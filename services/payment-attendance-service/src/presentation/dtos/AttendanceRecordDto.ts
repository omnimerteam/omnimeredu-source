export class CreateAttendanceRecordDto {
  studentId!: string;
  attendanceId!: string;
  status!: "Present" | "AbsentWithLeave" | "Absent" | "Late" | "LeftEarly";
  note?: string;
}

export class BulkCreateAttendanceRecordsDto {
  attendanceId!: string;
  records!: {
    studentId: string;
    status: "Present" | "AbsentWithLeave" | "Absent" | "Late" | "LeftEarly";
    note?: string;
  }[];
}

export class UpdateAttendanceRecordDto {
  status?: "Present" | "AbsentWithLeave" | "Absent" | "Late" | "LeftEarly";
  note?: string;
}
