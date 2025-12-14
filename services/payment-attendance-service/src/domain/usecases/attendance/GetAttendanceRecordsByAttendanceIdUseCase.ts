import { IAttendanceRecordRepository } from "../../repositories/IAttendanceRecordRepository";
import { AttendanceRecord } from "../../entities/AttendanceRecord";

export class GetAttendanceRecordsByAttendanceIdUseCase {
    constructor(private attendanceRecordRepository: IAttendanceRecordRepository) { }

    async execute(attendanceId: string): Promise<AttendanceRecord[]> {
        return await this.attendanceRecordRepository.findByAttendanceId(attendanceId);
    }
}
