import { Router, Request, Response, NextFunction } from "express";
import { AttendanceRepositoryImpl } from "../../data/repositories/AttendanceRepositoryImpl";
import { AttendanceRecordRepositoryImpl } from "../../data/repositories/AttendanceRecordRepositoryImpl";
import { CreateAttendanceUseCase } from "../../domain/usecases/attendance/CreateAttendanceUseCase";
import { BulkCreateAttendanceRecordsUseCase } from "../../domain/usecases/attendance/BulkCreateAttendanceRecordsUseCase";
import { GetAttendanceByIdUseCase } from "../../domain/usecases/attendance/GetAttendanceByIdUseCase";
import { GetAttendanceRecordsByAttendanceIdUseCase } from "../../domain/usecases/attendance/GetAttendanceRecordsByAttendanceIdUseCase";
import { UpdateAttendanceRecordUseCase } from "../../domain/usecases/attendance/UpdateAttendanceRecordUseCase";
import { GenerateQRCodeUseCase } from "../../domain/usecases/attendance/GenerateQRCodeUseCase";
import { InitializeClassAttendanceUseCase } from "../../domain/usecases/attendance/InitializeClassAttendanceUseCase";
import { ManualAttendanceUseCase } from "../../domain/usecases/attendance/ManualAttendanceUseCase";
import { VerifyQRAttendanceUseCase } from "../../domain/usecases/attendance/VerifyQRAttendanceUseCase";
import { AttendanceController } from "../controllers/AttendanceController";
import {
  authMiddleware,
  roleMiddleware,
  AuthenticatedRequest,
} from "../middleware/auth";
import {
  createAttendanceSchema,
  initializeClassAttendanceSchema,
  manualAttendanceSchema,
  bulkManualAttendanceSchema,
  updateAttendanceStatusSchema,
  verifyQRAttendanceSchema,
  attendanceIdParamSchema,
  recordIdParamSchema,
  bulkCreateRecordsSchema,
  handleValidationErrors,
} from "../middleware/validation";

const router = Router();

// =============================================================================
// Repository Initialization
// =============================================================================
const attendanceRepo = new AttendanceRepositoryImpl();
const attendanceRecordRepo = new AttendanceRecordRepositoryImpl();

// =============================================================================
// Use Case Initialization
// =============================================================================

// Basic CRUD Use Cases
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
const generateQRCodeUseCase = new GenerateQRCodeUseCase(attendanceRepo);

// Advanced Use Cases (Initialize, Manual, QR Verify)
const initializeClassAttendanceUseCase = new InitializeClassAttendanceUseCase(
  attendanceRepo,
  attendanceRecordRepo
);
const manualAttendanceUseCase = new ManualAttendanceUseCase(
  attendanceRepo,
  attendanceRecordRepo
);
const verifyQRAttendanceUseCase = new VerifyQRAttendanceUseCase(
  attendanceRepo,
  attendanceRecordRepo
);

// =============================================================================
// Controller Initialization
// =============================================================================
const attendanceController = new AttendanceController(
  createAttendanceUseCase,
  bulkCreateRecordsUseCase,
  getAttendanceByIdUseCase,
  getAttendanceRecordsUseCase,
  updateAttendanceRecordUseCase,
  generateQRCodeUseCase,
  initializeClassAttendanceUseCase,
  manualAttendanceUseCase,
  verifyQRAttendanceUseCase
);

// =============================================================================
// Routes
// =============================================================================

// ---------------------------------------------------------------------------
// Public/Student Routes (require auth only)
// ---------------------------------------------------------------------------

/**
 * @route   POST /api/attendance/qr/verify
 * @desc    Verify QR code and mark attendance (for students)
 * @access  Private (Student, Teacher, SchoolAdmin, SuperAdmin)
 */
router.post(
  "/qr/verify",
  authMiddleware,
  verifyQRAttendanceSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.verifyQRAttendance(req, res)
);

// ---------------------------------------------------------------------------
// Teacher/Admin Routes (require specific roles)
// ---------------------------------------------------------------------------

/**
 * @route   POST /api/attendance
 * @desc    Create a new attendance session
 * @access  Private (Teacher, SchoolAdmin, SuperAdmin)
 */
router.post(
  "/",
  authMiddleware,
  roleMiddleware(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  createAttendanceSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.create(req, res)
);

/**
 * @route   POST /api/attendance/initialize
 * @desc    Initialize attendance for a class with default records for all students
 * @access  Private (Teacher, SchoolAdmin, SuperAdmin)
 */
router.post(
  "/initialize",
  authMiddleware,
  roleMiddleware(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  initializeClassAttendanceSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.initializeClassAttendance(req, res)
);

/**
 * @route   PATCH /api/attendance/records/:recordId
 * @desc    Update single attendance record
 * @access  Private (Teacher, SchoolAdmin, SuperAdmin)
 */
router.patch(
  "/records/:recordId",
  authMiddleware,
  roleMiddleware(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  recordIdParamSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.updateRecord(req, res)
);

/**
 * @route   PATCH /api/attendance/records/:recordId/status
 * @desc    Update attendance status for a specific record
 * @access  Private (Teacher, SchoolAdmin, SuperAdmin)
 */
router.patch(
  "/records/:recordId/status",
  authMiddleware,
  roleMiddleware(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  updateAttendanceStatusSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.updateRecordStatus(req, res)
);

/**
 * @route   GET /api/attendance/:id/qr
 * @desc    Generate QR code for attendance session
 * @access  Private (Teacher, SchoolAdmin, SuperAdmin)
 */
router.get(
  "/:id/qr",
  authMiddleware,
  roleMiddleware(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  attendanceIdParamSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.generateQRCode(req, res)
);

/**
 * @route   POST /api/attendance/:id/records/bulk
 * @desc    Bulk create attendance records
 * @access  Private (Teacher, SchoolAdmin, SuperAdmin)
 */
router.post(
  "/:id/records/bulk",
  authMiddleware,
  roleMiddleware(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  bulkCreateRecordsSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.bulkCreateRecords(req, res)
);

/**
 * @route   GET /api/attendance/:id/records
 * @desc    Get all attendance records for an attendance session
 * @access  Private (Teacher, SchoolAdmin, SuperAdmin)
 */
router.get(
  "/:id/records",
  authMiddleware,
  roleMiddleware(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  attendanceIdParamSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.getRecords(req, res)
);

/**
 * @route   POST /api/attendance/:id/manual
 * @desc    Mark attendance manually for a single student
 * @access  Private (Teacher, SchoolAdmin, SuperAdmin)
 */
router.post(
  "/:id/manual",
  authMiddleware,
  roleMiddleware(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  manualAttendanceSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.markManualAttendance(req, res)
);

/**
 * @route   POST /api/attendance/:id/manual/bulk
 * @desc    Mark attendance manually for multiple students
 * @access  Private (Teacher, SchoolAdmin, SuperAdmin)
 */
router.post(
  "/:id/manual/bulk",
  authMiddleware,
  roleMiddleware(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  bulkManualAttendanceSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.markBulkManualAttendance(req, res)
);

/**
 * @route   GET /api/attendance/:id
 * @desc    Get attendance by ID
 * @access  Private (Teacher, SchoolAdmin, SuperAdmin)
 */
router.get(
  "/:id",
  authMiddleware,
  roleMiddleware(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  attendanceIdParamSchema,
  handleValidationErrors,
  (req: Request, res: Response, next: NextFunction) =>
    attendanceController.getById(req, res)
);

export default router;
