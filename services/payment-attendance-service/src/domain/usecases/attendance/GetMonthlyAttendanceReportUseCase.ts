import {
  IAttendanceReadRepository,
  ClassMonthlyReport,
} from "../../repositories/IAttendanceReadRepository";

export class GetMonthlyAttendanceReportUseCase {
  constructor(private attendanceReadRepo: IAttendanceReadRepository) {}

  async execute(
    classId: string,
    month: number,
    year: number
  ): Promise<ClassMonthlyReport> {
    // Validate input
    if (!classId) {
      throw new Error("Class ID is required");
    }

    if (month < 1 || month > 12) {
      throw new Error("Month must be between 1 and 12");
    }

    const currentYear = new Date().getFullYear();
    if (year < 2000 || year > currentYear + 1) {
      throw new Error(`Year must be between 2000 and ${currentYear + 1}`);
    }

    return this.attendanceReadRepo.getMonthlyReport(classId, month, year);
  }
}
