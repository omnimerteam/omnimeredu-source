import { Request, Response, NextFunction, Router } from "express";
import AttendanceModel from "../models/Attendance";
import SchoolAdminModel from "../models/SchoolAdmin";
import ClassModel from "../models/Class";
import TeacherModel from "../models/Teacher";

import AttendanceRepository from "../repositories/attendance.repository";
import AttendanceService from "../services/attendance.service";
import AttendanceController from "../controllers/attendance.controller";
import SchoolAdminRepository from "../repositories/schoolAdmin.repository";
import ClassRepostory from "../repositories/class.repository";
import TeacherRepository from "../repositories/teacher.repository";

import { ActivityLogRepository } from "../repositories/activityLog.repository";
import { DefaultLogger } from "../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

const logger = new DefaultLogger(new ActivityLogRepository());
const schoolAdminRepository = new SchoolAdminRepository(SchoolAdminModel);
const classRepository = new ClassRepostory(ClassModel);
const teacherRepository = new TeacherRepository(TeacherModel);
const attendanceRepository = new AttendanceRepository(AttendanceModel);
const attendanceService = new AttendanceService(
  attendanceRepository,
  schoolAdminRepository,
  classRepository,
  teacherRepository,
  logger
);
const attendanceController = new AttendanceController(attendanceService);

const router = Router();

router.get(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.getAllAttendances(req, res, next)
);

router.get(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.getAttendanceById(req, res, next)
);

router.get(
  "/school/:schoolId",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.getAttendancesBySchoolId(req, res, next)
);

router.get(
  "/class/:classId",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.getAttendancesByClassId(req, res, next)
);

router.post(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.createAttendance(req, res, next)
);

router.put(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.updateAttendance(req, res, next)
);

router.delete(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.deleteAttendance(req, res, next)
);

export default router;

/** example request body for creating a teacher
 * {
    "classId": "687b2c1b08f9ba18bdfaf116",
    "schoolId": "6885e31812e74de500041b51",
    "date": "2025-2-14"
}
 */
