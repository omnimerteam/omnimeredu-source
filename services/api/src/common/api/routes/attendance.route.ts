import { Request, Response, NextFunction, Router } from "express";

import {
  Attendance,
  SchoolAdmin,
  Class,
  Teacher,
  DetailsRecord,
  AttendanceRecordView,
} from "../../../domain/models";

import {
  AttendanceRepository,
  ClassRepository,
  ActivityLogRepository,
  AttendanceRecordViewRepository,
} from "../../../domain/repositories";

import { AttendanceService } from "../../../domain/services";

import { AttendanceController } from "../../../domain/controllers";

import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import {
  createAttendanceBodySchema,
  updateAttendanceBodySchema,
} from "../../validators/app/attendance/attendance.validator";
import { objectIdParamSchema } from "../../validators/common/params/params.validator";
import {
  getClassAttendanceRecordView,
  getSchoolAttendanceStatsSchema,
} from "../../validators/common/query/query.validator";

const logger = new DefaultLogger(new ActivityLogRepository());
const classRepository = new ClassRepository(Class);
const attendanceRecordViewRepository = new AttendanceRecordViewRepository(
  AttendanceRecordView
);
const attendanceRepository = new AttendanceRepository(
  Attendance,
  DetailsRecord,
  Class
);
const attendanceService = new AttendanceService(
  attendanceRepository,
  classRepository,
  attendanceRecordViewRepository,
  logger
);
const attendanceController = new AttendanceController(attendanceService);

const router = Router();

router.get(
  "/",
  validateData({
    headers: authHeaderSchema,
    query: getSchoolAttendanceStatsSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.getAllAttendances(req, res, next)
);

router.get(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyFirebaseToken,
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.getAttendanceById(req, res, next)
);

router.get(
  "/attendance-record-view/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyFirebaseToken,
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.getAttendanceRecordViewById(req, res, next)
);

router.get(
  "/class-attendance-record/view",
  validateData({
    headers: authHeaderSchema,
    query: getClassAttendanceRecordView,
  }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.getClassAttendanceRecordView(req, res, next)
);

// Tạo mới một bản điểm danh
router.post(
  "/",
  validateData({ headers: authHeaderSchema, body: createAttendanceBodySchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.createAttendance(req, res, next)
);

// Khởi tạo điểm danh cho một lớp vào một ngày cụ thể và các bản ghi mặc định
router.post(
  "/initialize-class-attendance",
  validateData({ headers: authHeaderSchema, body: createAttendanceBodySchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.initializeClassAttendance(req, res, next)
);

router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    body: updateAttendanceBodySchema,
    params: objectIdParamSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  async (req: Request, res: Response, next: NextFunction) =>
    attendanceController.updateAttendance(req, res, next)
);

router.delete(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
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
