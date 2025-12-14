import { Router, Response } from "express";
import { AttendanceRepositoryImpl } from "../../data/repositories/AttendanceRepositoryImpl";
import { AttendanceRecordRepositoryImpl } from "../../data/repositories/AttendanceRecordRepositoryImpl";
import { CreateAttendanceUseCase } from "../../domain/usecases/attendance/CreateAttendanceUseCase";
import { BulkCreateAttendanceRecordsUseCase } from "../../domain/usecases/attendance/BulkCreateAttendanceRecordsUseCase";
import { GetAttendanceByIdUseCase } from "../../domain/usecases/attendance/GetAttendanceByIdUseCase";
import { GetAttendanceRecordsByAttendanceIdUseCase } from "../../domain/usecases/attendance/GetAttendanceRecordsByAttendanceIdUseCase";
import { UpdateAttendanceRecordUseCase } from "../../domain/usecases/attendance/UpdateAttendanceRecordUseCase";
import { GenerateQRCodeUseCase } from "../../domain/usecases/attendance/GenerateQRCodeUseCase";
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
const getAttendanceRecordsUseCase = new GetAttendanceRecordsByAttendanceIdUseCase(attendanceRecordRepo);
const updateAttendanceRecordUseCase = new UpdateAttendanceRecordUseCase(attendanceRecordRepo);
const generateQRCodeUseCase = new GenerateQRCodeUseCase(attendanceRepo);

// Controller
const attendanceController = new AttendanceController(
    createAttendanceUseCase,
    bulkCreateRecordsUseCase,
    getAttendanceByIdUseCase,
    getAttendanceRecordsUseCase,
    updateAttendanceRecordUseCase,
    generateQRCodeUseCase
);

// Routes
// Note: More specific routes must come before generic ones
router.post("/", (req, res) => attendanceController.create(req, res));
router.get("/:id/qr", (req, res) => attendanceController.generateQRCode(req, res)); // Must be before /:id
router.post("/:id/records/bulk", (req, res) => attendanceController.bulkCreateRecords(req, res));
router.get("/:id/records", (req, res) => attendanceController.getRecords(req, res));
router.get("/:id", (req, res) => attendanceController.getById(req, res));
router.patch("/records/:recordId", (req, res) => attendanceController.updateRecord(req, res));

export default router;
