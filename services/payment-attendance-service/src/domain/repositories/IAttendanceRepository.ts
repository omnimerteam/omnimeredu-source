import { Attendance } from "../entities/Attendance";

export interface IAttendanceRepository {
  create(attendance: Attendance): Promise<Attendance>;
  findById(id: string): Promise<Attendance | null>;
  findByClassAndDate(classId: string, date: Date): Promise<Attendance | null>;
  findBySchoolAndDateRange(
    schoolId: string,
    startDate: Date,
    endDate: Date
  ): Promise<Attendance[]>;
  update(attendance: Attendance): Promise<Attendance>;
  delete(id: string): Promise<boolean>;
}
