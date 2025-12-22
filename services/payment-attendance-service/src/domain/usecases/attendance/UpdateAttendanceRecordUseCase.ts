import { IAttendanceRecordRepository } from "../../repositories/IAttendanceRecordRepository";
import { UpdateAttendanceRecordDto } from "../../../presentation/dtos/AttendanceRecordDto";
import { AttendanceRecord } from "../../entities/AttendanceRecord";

export class UpdateAttendanceRecordUseCase {
    constructor(private attendanceRecordRepository: IAttendanceRecordRepository) { }

    async execute(id: string, dto: UpdateAttendanceRecordDto): Promise<AttendanceRecord> {
        const record = await this.attendanceRecordRepository.findById(id);
        if (!record) {
            throw new Error("Attendance record not found");
        }

        if (dto.status) {
            record.status = dto.status;
        }
        if (dto.note !== undefined) {
            record.note = dto.note;
        }

        return await this.attendanceRecordRepository.update(record);
    }
}
