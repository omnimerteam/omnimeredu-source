import { Router, Response } from "express";
import { TuitionRepositoryImpl } from "../../data/repositories/TuitionRepositoryImpl";
import { CreateTuitionUseCase } from "../../domain/usecases/tuition/CreateTuitionUseCase";
import { GetTuitionByIdUseCase } from "../../domain/usecases/tuition/GetTuitionByIdUseCase";
import { GetTuitionsByPeriodUseCase } from "../../domain/usecases/tuition/GetTuitionsByPeriodUseCase";
import { ConfirmTuitionUseCase } from "../../domain/usecases/tuition/ConfirmTuitionUseCase";
import { TuitionController } from "../controllers/TuitionController";
import {
  authMiddleware,
  roleMiddleware,
  AuthenticatedRequest,
} from "../middleware/auth";

const router = Router();

const tuitionRepo = new TuitionRepositoryImpl();

const createTuitionUseCase = new CreateTuitionUseCase(tuitionRepo);
const getTuitionByIdUseCase = new GetTuitionByIdUseCase(tuitionRepo);
const getTuitionsByPeriodUseCase = new GetTuitionsByPeriodUseCase(tuitionRepo);
const confirmTuitionUseCase = new ConfirmTuitionUseCase(tuitionRepo);

const tuitionController = new TuitionController(
  createTuitionUseCase,
  getTuitionByIdUseCase,
  getTuitionsByPeriodUseCase,
  confirmTuitionUseCase
);

// ========================================
// Protected Routes (Require Authentication)
// ========================================

// Create tuition - SchoolAdmin, SuperAdmin only
router.post(
  "/",
  authMiddleware,
  roleMiddleware(["SchoolAdmin", "SuperAdmin"]),
  (req: AuthenticatedRequest, res: Response) =>
    tuitionController.create(req, res)
);

// Get tuition by ID - Authenticated users
router.get("/:id", authMiddleware, (req: AuthenticatedRequest, res: Response) =>
  tuitionController.getById(req, res)
);

// Get tuitions by period - Authenticated users
router.get("/", authMiddleware, (req: AuthenticatedRequest, res: Response) =>
  tuitionController.getByPeriod(req, res)
);

// Confirm tuition - SchoolAdmin, SuperAdmin only
router.post(
  "/:id/confirm",
  authMiddleware,
  roleMiddleware(["SchoolAdmin", "SuperAdmin"]),
  (req: AuthenticatedRequest, res: Response) =>
    tuitionController.confirm(req, res)
);

export default router;
