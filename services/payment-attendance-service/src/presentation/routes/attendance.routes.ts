import { Router, Response } from "express";
import { AttendanceRepositoryImpl } from "../../data/repositories/AttendanceRepositoryImpl";
import { AttendanceRecordRepositoryImpl } from "../../data/repositories/AttendanceRecordRepositoryImpl";
import { CreateAttendanceUseCase } from "../../domain/usecases/attendance/CreateAttendanceUseCase";
import { BulkCreateAttendanceRecordsUseCase } from "../../domain/usecases/attendance/BulkCreateAttendanceRecordsUseCase";
import { GetAttendanceByIdUseCase } from "../../domain/usecases/attendance/GetAttendanceByIdUseCase";
import { GetAttendanceRecordsByAttendanceIdUseCase } from "../../domain/usecases/attendance/GetAttendanceRecordsByAttendanceIdUseCase";
import { UpdateAttendanceRecordUseCase } from "../../domain/usecases/attendance/UpdateAttendanceRecordUseCase";
import { AttendanceController } from "../controllers/AttendanceController";
import {
  authMiddleware,
  roleMiddleware,
  AuthenticatedRequest,
} from "../middleware/auth";

const router = Router();

// Repositories
const attendanceRepo = new AttendanceRepositoryImpl();
const attendanceRecordRepo = new AttendanceRecordRepositoryImpl();

// Use Cases
const createAttendanceUseCase = new CreateAttendanceUseCase(attendanceRepo);
const bulkCreateRecordsUseCase = new BulkCreateAttendanceRecordsUseCase(
  attendanceRecordRepo
);
const getAttendanceByIdUseCase = new GetAttendanceByIdUseCase(attendanceRepo);
const getAttendanceRecordsUseCase =
  new GetAttendanceRecordsByAttendanceIdUseCase(attendanceRecordRepo);
const updateAttendanceRecordUseCase = new UpdateAttendanceRecordUseCase(
  attendanceRecordRepo
);

// Controller
const attendanceController = new AttendanceController(
  createAttendanceUseCase,
  bulkCreateRecordsUseCase,
  getAttendanceByIdUseCase,
  getAttendanceRecordsUseCase,
  updateAttendanceRecordUseCase
);

// ========================================
// Protected Routes (Require Authentication)
// ========================================

// Create attendance session - Teachers, SchoolAdmin, SuperAdmin only
router.post(
  "/",
  authMiddleware,
  roleMiddleware(["Teacher", "SchoolAdmin", "SuperAdmin"]),
  (req: AuthenticatedRequest, res: Response) =>
    attendanceController.create(req, res)
);

// Get attendance by ID - Authenticated users
router.get("/:id", authMiddleware, (req: AuthenticatedRequest, res: Response) =>
  attendanceController.getById(req, res)
);

// Bulk create attendance records - Teachers, SchoolAdmin, SuperAdmin only
router.post(
  "/:id/records/bulk",
  authMiddleware,
  roleMiddleware(["Teacher", "SchoolAdmin", "SuperAdmin"]),
  (req: AuthenticatedRequest, res: Response) =>
    attendanceController.bulkCreateRecords(req, res)
);

// Get attendance records - Authenticated users
router.get(
  "/:id/records",
  authMiddleware,
  (req: AuthenticatedRequest, res: Response) =>
    attendanceController.getRecords(req, res)
);

// Update attendance record - Teachers, SchoolAdmin, SuperAdmin only
router.patch(
  "/records/:recordId",
  authMiddleware,
  roleMiddleware(["Teacher", "SchoolAdmin", "SuperAdmin"]),
  (req: AuthenticatedRequest, res: Response) =>
    attendanceController.updateRecord(req, res)
);

export default router;
