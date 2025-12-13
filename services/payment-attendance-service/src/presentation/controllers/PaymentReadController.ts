import { Request, Response } from "express";
import { GetPaymentHistoryUseCase } from "../../domain/usecases/payment/GetPaymentHistoryUseCase";
import { GetStudentPaymentSummaryUseCase } from "../../domain/usecases/payment/GetStudentPaymentSummaryUseCase";
import { PaymentHistoryFilter } from "../../domain/repositories/IPaymentReadRepository";

/**
 * Controller for Read-only Payment APIs (MongoDB)
 * Handles payment history and summary queries
 */
export class PaymentReadController {
  constructor(
    private getPaymentHistoryUseCase: GetPaymentHistoryUseCase,
    private getStudentPaymentSummaryUseCase: GetStudentPaymentSummaryUseCase
  ) {}

  /**
   * GET /history
   * Query params: studentId, tuitionId, status, startDate, endDate, page, limit
   * Returns paginated payment history with filters
   */
  async getPaymentHistory(req: Request, res: Response): Promise<void> {
    try {
      const filter: PaymentHistoryFilter = {};

      if (req.query.studentId) {
        filter.studentId = req.query.studentId as string;
      }
      if (req.query.tuitionId) {
        filter.tuitionId = req.query.tuitionId as string;
      }
      if (req.query.status) {
        filter.status = req.query.status as "Success" | "Failed";
      }
      if (req.query.startDate) {
        filter.startDate = new Date(req.query.startDate as string);
      }
      if (req.query.endDate) {
        filter.endDate = new Date(req.query.endDate as string);
      }

      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;

      const result = await this.getPaymentHistoryUseCase.execute(
        filter,
        page,
        limit
      );

      res.status(200).json({
        success: true,
        data: result.items,
        meta: {
          total: result.total,
          page: result.page,
          limit: result.limit,
          totalPages: result.totalPages,
        },
      });
    } catch (error: any) {
      res.status(400).json({
        success: false,
        error: error.message,
      });
    }
  }

  /**
   * GET /summary/student/:studentId
   * Returns payment summary for a specific student
   */
  async getStudentSummary(req: Request, res: Response): Promise<void> {
    try {
      const { studentId } = req.params;

      const result = await this.getStudentPaymentSummaryUseCase.execute(
        studentId
      );

      res.status(200).json({
        success: true,
        data: result,
        meta: {
          studentId,
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
