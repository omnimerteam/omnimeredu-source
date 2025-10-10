import { Request, Response, NextFunction, Router } from "express";

import {
  Attendance,
  SchoolAdmin,
  Class,
  Teacher,
} from "../../../domain/models";

import {
  AttendanceRepository,
  SchoolAdminRepository,
  ClassRepository,
  TeacherRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";

import { AttendanceService } from "../../../domain/services";

import { AttendanceController } from "../../../domain/controllers";

import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

const logger = new DefaultLogger(new ActivityLogRepository());
const schoolAdminRepository = new SchoolAdminRepository(SchoolAdmin);
const classRepository = new ClassRepository(Class);
const teacherRepository = new TeacherRepository(Teacher);
const attendanceRepository = new AttendanceRepository(Attendance);
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
