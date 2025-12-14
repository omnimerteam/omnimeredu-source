import { Router, Response } from "express";
import { PaymentRepositoryImpl } from "../../data/repositories/PaymentRepositoryImpl";
import { TuitionRepositoryImpl } from "../../data/repositories/TuitionRepositoryImpl";
import { CreatePaymentUseCase } from "../../domain/usecases/payment/CreatePaymentUseCase";
import { GetPaymentsByStudentIdUseCase } from "../../domain/usecases/payment/GetPaymentsByStudentIdUseCase";
import { ProcessPaymentCallbackUseCase } from "../../domain/usecases/payment/ProcessPaymentCallbackUseCase";
import { PaymentController } from "../controllers/PaymentController";
import {
  authMiddleware,
  roleMiddleware,
  AuthenticatedRequest,
} from "../middleware/auth";

const router = Router();

const paymentRepo = new PaymentRepositoryImpl();
const tuitionRepo = new TuitionRepositoryImpl();

const createPaymentUseCase = new CreatePaymentUseCase(paymentRepo, tuitionRepo);
const getPaymentsByStudentIdUseCase = new GetPaymentsByStudentIdUseCase(
  paymentRepo
);
const processPaymentCallbackUseCase = new ProcessPaymentCallbackUseCase(
  paymentRepo,
  tuitionRepo
);

const paymentController = new PaymentController(
  createPaymentUseCase,
  getPaymentsByStudentIdUseCase,
  processPaymentCallbackUseCase
);

// ========================================
// Protected Routes (Require Authentication)
// ========================================

// Create payment - SchoolAdmin, SuperAdmin only
router.post(
  "/",
  authMiddleware,
  roleMiddleware(["SchoolAdmin", "SuperAdmin"]),
  (req: AuthenticatedRequest, res: Response) =>
    paymentController.create(req, res)
);

// Get payments by student - Authenticated users (student can see own, admin can see all)
router.get(
  "/student/:studentId",
  authMiddleware,
  (req: AuthenticatedRequest, res: Response) =>
    paymentController.getByStudent(req, res)
);

// Payment callback (from payment gateway) - No auth required (uses webhook signature)
router.post("/callback", (req, res) => paymentController.callback(req, res));

export default router;
