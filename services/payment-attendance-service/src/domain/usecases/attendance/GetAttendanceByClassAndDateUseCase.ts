import { IAttendanceRepository } from "../../repositories/IAttendanceRepository";
import { Attendance } from "../../entities/Attendance";

export class GetAttendanceByClassAndDateUseCase {
  constructor(private attendanceRepository: IAttendanceRepository) {}

  async execute(classId: string, date: Date): Promise<Attendance | null> {
    return this.attendanceRepository.findByClassAndDate(classId, date);
  }
}
