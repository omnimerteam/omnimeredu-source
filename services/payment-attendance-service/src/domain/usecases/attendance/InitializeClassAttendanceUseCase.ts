import { IAttendanceRepository } from "../../repositories/IAttendanceRepository";
import { IAttendanceRecordRepository } from "../../repositories/IAttendanceRecordRepository";
import { Attendance } from "../../entities/Attendance";
import { AttendanceRecord } from "../../entities/AttendanceRecord";

export interface InitializeClassAttendanceDto {
  classId: string;
  schoolId: string;
  date: Date;
  sessionType?: "regular" | "weekend" | "holiday" | "extra";
  studentIds: string[]; // List of student IDs to create default records
}

export interface InitializeClassAttendanceResult {
  attendance: Attendance;
  records: AttendanceRecord[];
  isNewAttendance: boolean;
}

/**
 * Initialize Class Attendance Use Case
 * Creates or retrieves attendance for a class on a specific date
 * and creates default attendance records for all students in the class
 */
export class InitializeClassAttendanceUseCase {
  constructor(
    private attendanceRepository: IAttendanceRepository,
    private attendanceRecordRepository: IAttendanceRecordRepository
  ) {}

  async execute(
    dto: InitializeClassAttendanceDto
  ): Promise<InitializeClassAttendanceResult> {
    // Normalize date to start of day for comparison
    const normalizedDate = new Date(dto.date);
    normalizedDate.setHours(0, 0, 0, 0);

    // Check if attendance already exists for this class and date
    let attendance = await this.attendanceRepository.findByClassAndDate(
      dto.classId,
      normalizedDate
    );

    let isNewAttendance = false;

    if (!attendance) {
      // Create new attendance
      attendance = new Attendance(
        "", // ID will be generated
        dto.classId,
        dto.schoolId,
        normalizedDate,
        dto.sessionType || "regular"
      );

      attendance = await this.attendanceRepository.create(attendance);
      isNewAttendance = true;
    }

    // Get existing records for this attendance
    const existingRecords =
      await this.attendanceRecordRepository.findByAttendanceId(attendance.id);

    // Find students who don't have records yet
    const existingStudentIds = new Set(existingRecords.map((r) => r.studentId));
    const newStudentIds = dto.studentIds.filter(
      (id) => !existingStudentIds.has(id)
    );

    // Create default records for new students (default status: Present)
    let newRecords: AttendanceRecord[] = [];
    if (newStudentIds.length > 0) {
      const recordsToCreate = newStudentIds.map(
        (studentId) =>
          new AttendanceRecord(
            "", // ID will be generated
            studentId,
            attendance!.id,
            "Present" // Default status
          )
      );

      newRecords = await this.attendanceRecordRepository.createBulk(
        recordsToCreate
      );
    }

    // Return combined results
    return {
      attendance,
      records: [...existingRecords, ...newRecords],
      isNewAttendance,
    };
  }
}
