import { Router } from "express";
import { AttendanceRepositoryImpl } from "../../data/repositories/AttendanceRepositoryImpl";
import { AttendanceRecordRepositoryImpl } from "../../data/repositories/AttendanceRecordRepositoryImpl";
import { CreateAttendanceUseCase } from "../../domain/usecases/attendance/CreateAttendanceUseCase";
import { BulkCreateAttendanceRecordsUseCase } from "../../domain/usecases/attendance/BulkCreateAttendanceRecordsUseCase";
import { GetAttendanceByIdUseCase } from "../../domain/usecases/attendance/GetAttendanceByIdUseCase";
import { GetAttendanceRecordsByAttendanceIdUseCase } from "../../domain/usecases/attendance/GetAttendanceRecordsByAttendanceIdUseCase";
import { UpdateAttendanceRecordUseCase } from "../../domain/usecases/attendance/UpdateAttendanceRecordUseCase";
import { AttendanceController } from "../controllers/AttendanceController";

const router = Router();

// Repositories
const attendanceRepo = new AttendanceRepositoryImpl();
const attendanceRecordRepo = new AttendanceRecordRepositoryImpl();

// Use Cases
const createAttendanceUseCase = new CreateAttendanceUseCase(attendanceRepo);
const bulkCreateRecordsUseCase = new BulkCreateAttendanceRecordsUseCase(attendanceRecordRepo);
const getAttendanceByIdUseCase = new GetAttendanceByIdUseCase(attendanceRepo);
const getAttendanceRecordsUseCase = new GetAttendanceRecordsByAttendanceIdUseCase(attendanceRecordRepo);
const updateAttendanceRecordUseCase = new UpdateAttendanceRecordUseCase(attendanceRecordRepo);

// Controller
const attendanceController = new AttendanceController(
    createAttendanceUseCase,
    bulkCreateRecordsUseCase,
    getAttendanceByIdUseCase,
    getAttendanceRecordsUseCase,
    updateAttendanceRecordUseCase
);

// Routes
router.post("/", (req, res) => attendanceController.create(req, res));
router.get("/:id", (req, res) => attendanceController.getById(req, res));
router.post("/:id/records/bulk", (req, res) => attendanceController.bulkCreateRecords(req, res));
router.get("/:id/records", (req, res) => attendanceController.getRecords(req, res));
router.patch("/records/:recordId", (req, res) => attendanceController.updateRecord(req, res));

export default router;
