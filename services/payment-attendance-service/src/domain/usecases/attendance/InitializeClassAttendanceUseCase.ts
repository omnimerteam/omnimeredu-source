import { IAttendanceRepository } from "../../repositories/IAttendanceRepository";
import { IAttendanceRecordRepository } from "../../repositories/IAttendanceRecordRepository";
import { Attendance } from "../../entities/Attendance";
import { AttendanceRecord } from "../../entities/AttendanceRecord";
import {
  userServiceClient,
  StudentInfo,
  ClassInfo,
  SchoolInfo,
} from "../../../data/datasources/external/UserServiceClient";

export interface InitializeClassAttendanceDto {
  classId: string;
  schoolId: string;
  date: Date;
  sessionType?: "regular" | "weekend" | "holiday" | "extra";
  // studentIds is now optional - will be fetched automatically if not provided
  studentIds?: string[];
}

export interface StudentAttendanceInfo {
  id: string;
  name: string;
  phone?: string;
  guardianName: string;
  guardianPhone: string;
  gender?: string;
  birthday?: string;
  detailRecordId: string;
  status: string;
  note?: string;
}

export interface InitializeClassAttendanceResult {
  id: string;
  classId: string;
  schoolId: string;
  date: Date;
  classInfo: ClassInfo;
  schoolInfo: SchoolInfo;
  students: StudentAttendanceInfo[];
  isNewAttendance: boolean;
  studentCount: number;
}

/**
 * Initialize Class Attendance Use Case
 * Creates or retrieves attendance for a class on a specific date
 * and creates default attendance records for all students in the class
 *
 * Returns enriched data including class info, school info, and student attendance details
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

    // Fetch class and school info from User Service
    const [classInfo, schoolInfo, students] = await Promise.all([
      userServiceClient.getClassById(dto.classId),
      userServiceClient.getSchoolById(dto.schoolId),
      userServiceClient.getStudentsByClassId(dto.classId),
    ]);

    // Get student IDs from fetched students or from DTO
    let studentIds = dto.studentIds || [];
    if (studentIds.length === 0 && students.length > 0) {
      studentIds = students.map((s) => s.id);
      console.log(
        `Found ${studentIds.length} students in class ${dto.classId}`
      );
    }

    // Get existing records for this attendance
    const existingRecords =
      await this.attendanceRecordRepository.findByAttendanceId(attendance.id);

    // Find students who don't have records yet
    const existingStudentIds = new Set(existingRecords.map((r) => r.studentId));
    const newStudentIds = studentIds.filter(
      (id) => !existingStudentIds.has(id)
    );

    // Create default records for new students (default status: Absent)
    let newRecords: AttendanceRecord[] = [];
    if (newStudentIds.length > 0) {
      const recordsToCreate = newStudentIds.map(
        (studentId) =>
          new AttendanceRecord(
            "", // ID will be generated
            studentId,
            attendance!.id,
            "Absent" // Default status is now Absent
          )
      );

      newRecords = await this.attendanceRecordRepository.createBulk(
        recordsToCreate
      );
    }

    // Combine all records
    const allRecords = [...existingRecords, ...newRecords];

    // Map records to student info with status
    const recordMap = new Map<string, AttendanceRecord>();
    allRecords.forEach((r) => recordMap.set(r.studentId, r));

    // Build student attendance info list
    const studentAttendanceInfos: StudentAttendanceInfo[] = students.map(
      (student) => {
        const record = recordMap.get(student.id);
        return {
          id: student.id,
          name: student.fullName,
          phone: student.phone,
          guardianName: student.guardianName || "",
          guardianPhone: student.guardianPhone || "",
          gender: student.gender,
          birthday: student.birthday,
          detailRecordId: record?.id || "",
          status: record?.status || "Absent",
          note: record?.note,
        };
      }
    );

    // Return enriched result
    return {
      id: attendance.id,
      classId: attendance.classId,
      schoolId: attendance.schoolId,
      date: attendance.date,
      classInfo: classInfo || { id: dto.classId, name: "", code: "" },
      schoolInfo: schoolInfo || { id: dto.schoolId, name: "", code: "" },
      students: studentAttendanceInfos,
      isNewAttendance,
      studentCount: students.length,
    };
  }
}
