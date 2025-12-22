import { IAttendanceRecordRepository } from "../../repositories/IAttendanceRecordRepository";
import { BulkCreateAttendanceRecordsDto } from "../../../presentation/dtos/AttendanceRecordDto";
import { AttendanceRecord } from "../../entities/AttendanceRecord";

export class BulkCreateAttendanceRecordsUseCase {
  constructor(
    private attendanceRecordRepository: IAttendanceRecordRepository
  ) {}

  async execute(
    dto: BulkCreateAttendanceRecordsDto
  ): Promise<AttendanceRecord[]> {
    const records = dto.records.map(
      (r) =>
        new AttendanceRecord(
          "", // ID will be generated
          r.studentId,
          dto.attendanceId,
          r.status,
          r.note
        )
    );

    return await this.attendanceRecordRepository.createBulk(records);
  }
}
