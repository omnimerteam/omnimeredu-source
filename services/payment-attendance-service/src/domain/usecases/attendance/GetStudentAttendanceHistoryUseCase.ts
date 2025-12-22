import {
  IAttendanceReadRepository,
  StudentAttendanceDetail,
} from "../../repositories/IAttendanceReadRepository";

export class GetStudentAttendanceHistoryUseCase {
  constructor(private attendanceReadRepo: IAttendanceReadRepository) {}

  async execute(
    studentId: string,
    startDate: Date,
    endDate: Date
  ): Promise<StudentAttendanceDetail[]> {
    // Validate input
    if (!studentId) {
      throw new Error("Student ID is required");
    }

    if (startDate > endDate) {
      throw new Error("Start date must be before or equal to end date");
    }

    return this.attendanceReadRepo.getStudentAttendanceHistory(
      studentId,
      startDate,
      endDate
    );
  }
}
