import { Router, Response } from "express";
import { AttendanceReadRepositoryImpl } from "../../data/repositories/AttendanceReadRepositoryImpl";
import { GetMonthlyAttendanceReportUseCase } from "../../domain/usecases/attendance/GetMonthlyAttendanceReportUseCase";
import { GetStudentAttendanceHistoryUseCase } from "../../domain/usecases/attendance/GetStudentAttendanceHistoryUseCase";
import { AttendanceReadController } from "../controllers/AttendanceReadController";
import {
  authMiddleware,
  roleMiddleware,
  AuthenticatedRequest,
} from "../middleware/auth";

const router = Router();

// Read Repository (MongoDB)
const attendanceReadRepo = new AttendanceReadRepositoryImpl();

// Use Cases
const getMonthlyReportUseCase = new GetMonthlyAttendanceReportUseCase(
  attendanceReadRepo
);
const getStudentHistoryUseCase = new GetStudentAttendanceHistoryUseCase(
  attendanceReadRepo
);

// Controller
const attendanceReadController = new AttendanceReadController(
  getMonthlyReportUseCase,
  getStudentHistoryUseCase
);

/**
 * Read APIs for Attendance (MongoDB)
 * Optimized for reporting and analytics
 */

// GET /api/v1/attendance/reports/monthly/:classId?month=X&year=Y
// Returns monthly attendance report for a class
// Teachers, SchoolAdmin, SuperAdmin can access
router.get(
  "/reports/monthly/:classId",
  authMiddleware,
  roleMiddleware(["Teacher", "SchoolAdmin", "SuperAdmin"]),
  (req: AuthenticatedRequest, res: Response) =>
    attendanceReadController.getMonthlyReport(req, res)
);

// GET /api/v1/attendance/history/student/:studentId?startDate=X&endDate=Y
// Returns attendance history for a specific student
// All authenticated users can access (students can see own history)
router.get(
  "/history/student/:studentId",
  authMiddleware,
  (req: AuthenticatedRequest, res: Response) =>
    attendanceReadController.getStudentHistory(req, res)
);

export default router;
