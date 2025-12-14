import { Request, Response } from "express";
import { GetMonthlyAttendanceReportUseCase } from "../../domain/usecases/attendance/GetMonthlyAttendanceReportUseCase";
import { GetStudentAttendanceHistoryUseCase } from "../../domain/usecases/attendance/GetStudentAttendanceHistoryUseCase";

/**
 * Controller for Read-only Attendance APIs (MongoDB)
 * Handles attendance reports and history queries
 */
export class AttendanceReadController {
  constructor(
    private getMonthlyReportUseCase: GetMonthlyAttendanceReportUseCase,
    private getStudentHistoryUseCase: GetStudentAttendanceHistoryUseCase
  ) {}

  /**
   * GET /reports/monthly/:classId
   * Query params: month, year
   * Returns monthly attendance report for a class
   */
  async getMonthlyReport(req: Request, res: Response): Promise<void> {
    try {
      const { classId } = req.params;
      const month =
        parseInt(req.query.month as string) || new Date().getMonth() + 1;
      const year =
        parseInt(req.query.year as string) || new Date().getFullYear();

      const result = await this.getMonthlyReportUseCase.execute(
        classId,
        month,
        year
      );

      res.status(200).json({
        success: true,
        data: result,
      });
    } catch (error: any) {
      res.status(400).json({
        success: false,
        error: error.message,
      });
    }
  }

  /**
   * GET /history/student/:studentId
   * Query params: startDate, endDate
   * Returns attendance history for a specific student
   */
  async getStudentHistory(req: Request, res: Response): Promise<void> {
    try {
      const { studentId } = req.params;

      // Default to last 30 days if not specified
      const endDate = req.query.endDate
        ? new Date(req.query.endDate as string)
        : new Date();

      const startDate = req.query.startDate
        ? new Date(req.query.startDate as string)
        : new Date(endDate.getTime() - 30 * 24 * 60 * 60 * 1000); // 30 days ago

      const result = await this.getStudentHistoryUseCase.execute(
        studentId,
        startDate,
        endDate
      );

      res.status(200).json({
        success: true,
        data: result,
        meta: {
          studentId,
          startDate: startDate.toISOString(),
          endDate: endDate.toISOString(),
          totalRecords: result.length,
        },
      });
    } catch (error: any) {
      res.status(400).json({
        success: false,
        error: error.message,
      });
    }
  }
}
