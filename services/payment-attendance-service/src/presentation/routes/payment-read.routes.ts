import { Router, Response } from "express";
import { PaymentReadRepositoryImpl } from "../../data/repositories/PaymentReadRepositoryImpl";
import { GetPaymentHistoryUseCase } from "../../domain/usecases/payment/GetPaymentHistoryUseCase";
import { GetStudentPaymentSummaryUseCase } from "../../domain/usecases/payment/GetStudentPaymentSummaryUseCase";
import { PaymentReadController } from "../controllers/PaymentReadController";
import {
  authMiddleware,
  roleMiddleware,
  AuthenticatedRequest,
} from "../middleware/auth";

const router = Router();

// Read Repository (MongoDB)
const paymentReadRepo = new PaymentReadRepositoryImpl();

// Use Cases
const getPaymentHistoryUseCase = new GetPaymentHistoryUseCase(paymentReadRepo);
const getStudentPaymentSummaryUseCase = new GetStudentPaymentSummaryUseCase(
  paymentReadRepo
);

// Controller
const paymentReadController = new PaymentReadController(
  getPaymentHistoryUseCase,
  getStudentPaymentSummaryUseCase
);

/**
 * Read APIs for Payment (MongoDB)
 * Optimized for payment history and analytics
 */

// GET /api/v1/payments/history?studentId=X&status=Y&startDate=X&endDate=Y&page=X&limit=Y
// Returns paginated payment history with filters
// SchoolAdmin, SuperAdmin can access all, Students can access own
router.get(
  "/history",
  authMiddleware,
  roleMiddleware(["SchoolAdmin", "SuperAdmin"]),
  (req: AuthenticatedRequest, res: Response) =>
    paymentReadController.getPaymentHistory(req, res)
);

// GET /api/v1/payments/summary/student/:studentId
// Returns payment summary for a specific student
// SchoolAdmin, SuperAdmin can access all, Students can access own
router.get(
  "/summary/student/:studentId",
  authMiddleware,
  (req: AuthenticatedRequest, res: Response) =>
    paymentReadController.getStudentSummary(req, res)
);

export default router;
