import { IAttendanceRepository } from "../../repositories/IAttendanceRepository";
import { CreateAttendanceDto } from "../../../presentation/dtos/CreateAttendanceDto";
import { Attendance } from "../../entities/Attendance";

export class CreateAttendanceUseCase {
  constructor(private attendanceRepository: IAttendanceRepository) {}

  async execute(dto: CreateAttendanceDto): Promise<Attendance> {
    // Check if attendance already exists for this class and date
    const existing = await this.attendanceRepository.findByClassAndDate(
      dto.classId,
      dto.date
    );

    if (existing) {
      throw new Error("Attendance already exists for this class and date");
    }

    const attendance = new Attendance(
      "", // ID will be generated
      dto.classId,
      dto.schoolId,
      dto.date,
      dto.sessionType || "regular"
    );

    return await this.attendanceRepository.create(attendance);
  }
}
