import { Router, Response } from "express";
import { HolidayRepositoryImpl } from "../../data/repositories/HolidayRepositoryImpl";
import { CreateHolidayUseCase } from "../../domain/usecases/holiday/CreateHolidayUseCase";
import { GetHolidaysByDateRangeUseCase } from "../../domain/usecases/holiday/GetHolidaysByDateRangeUseCase";
import { CheckIsHolidayUseCase } from "../../domain/usecases/holiday/CheckIsHolidayUseCase";
import { HolidayController } from "../controllers/HolidayController";
import {
  authMiddleware,
  roleMiddleware,
  AuthenticatedRequest,
} from "../middleware/auth";

const router = Router();

const holidayRepo = new HolidayRepositoryImpl();

const createHolidayUseCase = new CreateHolidayUseCase(holidayRepo);
const getHolidaysByDateRangeUseCase = new GetHolidaysByDateRangeUseCase(
  holidayRepo
);
const checkIsHolidayUseCase = new CheckIsHolidayUseCase(holidayRepo);

const holidayController = new HolidayController(
  createHolidayUseCase,
  getHolidaysByDateRangeUseCase,
  checkIsHolidayUseCase
);

// ========================================
// Protected Routes (Require Authentication)
// ========================================

// Create holiday - SchoolAdmin, SuperAdmin only
router.post(
  "/",
  authMiddleware,
  roleMiddleware(["SchoolAdmin", "SuperAdmin"]),
  (req: AuthenticatedRequest, res: Response) =>
    holidayController.create(req, res)
);

// Get holidays by date range - Authenticated users
router.get("/", authMiddleware, (req: AuthenticatedRequest, res: Response) =>
  holidayController.getByDateRange(req, res)
);

// Check if date is holiday - Authenticated users
router.get(
  "/check",
  authMiddleware,
  (req: AuthenticatedRequest, res: Response) =>
    holidayController.checkIsHoliday(req, res)
);

export default router;
