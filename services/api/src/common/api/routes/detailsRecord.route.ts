import { NextFunction, Request, Response, Router } from "express";
import { Attendance, Class, DetailsRecord } from "../../../domain/models";

import {
  DetailsRecordRepository,
  AttendanceRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";
import { DetailsRecordService } from "../../../domain/services";
import { DetailsRecordController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyJWTToken } from "../middlewares/verifyJWTToken.middleware";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import {
  createDetailsRecordBodySchema,
  updateDetailsRecordBodySchema,
  updateStatusDetailsRecordBodySchema,
} from "../../validators/app/detailsRecord/detailsRecord.validator";
import {
  attendanceIdSchema,
  objectIdParamSchema,
} from "../../validators/common/params/params.validator";

// Initialize and pass values to constructors
const logger = new DefaultLogger(new ActivityLogRepository());
const detailsRecordRepository = new DetailsRecordRepository(DetailsRecord);
const attendanceRepository = new AttendanceRepository(
  Attendance,
  DetailsRecord,
  Class
);
const detailsRecordService = new DetailsRecordService(
  detailsRecordRepository,
  attendanceRepository,
  logger
);
const detailsRecordController = new DetailsRecordController(
  detailsRecordService
);

const router = Router();

//! Chắc không ai dùng đâu :))) Ai mà lấy cái này chắc bản ghi cả tỉ nên làm cho SuperAdmin cũng đừng dùng
router.get(
  "/",
  validateData({
    headers: authHeaderSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.getAllDetailsRecords(req, res, next)
);

router.get(
  "/attendance-records/:attendanceId",
  validateData({
    headers: authHeaderSchema,
    params: attendanceIdSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.getAttendanceRecordsById(req, res, next)
);

router.get(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.getDetailsRecordById(req, res, next)
);

router.post(
  "/",
  validateData({
    headers: authHeaderSchema,
    body: createDetailsRecordBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.createDetailsRecord(req, res, next)
);

router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    body: updateDetailsRecordBodySchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.updateDetailsRecord(req, res, next)
);

router.patch(
  "/update-status/:id",
  validateData({
    headers: authHeaderSchema,
    body: updateStatusDetailsRecordBodySchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.updateStatusDetailRecord(req, res, next)
);

router.delete(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.deleteDetailsRecord(req, res, next)
);

export default router;
