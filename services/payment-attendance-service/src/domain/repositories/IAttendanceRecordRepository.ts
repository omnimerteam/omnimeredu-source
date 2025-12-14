import { AttendanceRecord } from "../entities/AttendanceRecord";

export interface IAttendanceRecordRepository {
  create(record: AttendanceRecord): Promise<AttendanceRecord>;
  createBulk(records: AttendanceRecord[]): Promise<AttendanceRecord[]>;
  findById(id: string): Promise<AttendanceRecord | null>;
  findByAttendanceId(attendanceId: string): Promise<AttendanceRecord[]>;
  findByStudentAndDateRange(
    studentId: string,
    startDate: Date,
    endDate: Date
  ): Promise<AttendanceRecord[]>;
  update(record: AttendanceRecord): Promise<AttendanceRecord>;
  delete(id: string): Promise<boolean>;
}
