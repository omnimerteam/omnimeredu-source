import { IAttendanceRepository } from "../../repositories/IAttendanceRepository";
import { Attendance } from "../../entities/Attendance";

export class GetAttendanceByIdUseCase {
    constructor(private attendanceRepository: IAttendanceRepository) { }

    async execute(id: string): Promise<Attendance | null> {
        return await this.attendanceRepository.findById(id);
    }
}
