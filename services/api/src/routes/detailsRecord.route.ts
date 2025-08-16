import { NextFunction, Request, Response, Router } from "express";
import DetailsRecord from "../models/DetailsRecord";
import AttendanceModel from "../models/Attendance";

import DetailsRecordRepository from "../repositories/detailsRecord.repository";
import DetailsRecordService from "../services/detailsRecord.service";
import DetailsRecordController from "../controllers/detailsRecord.controller";
import AttendanceRepository from "../repositories/attendance.repository";

// Logger & Activity Log
import { ActivityLogRepository } from "../repositories/activityLog.repository";
import { DefaultLogger } from "../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

// Initialize and pass values to constructors
const logger = new DefaultLogger(new ActivityLogRepository());
const detailsRecordRepository = new DetailsRecordRepository(DetailsRecord);
const attendanceRepository = new AttendanceRepository(AttendanceModel);
const detailsRecordService = new DetailsRecordService(
  detailsRecordRepository,
  attendanceRepository,
  logger
);
const detailsRecordController = new DetailsRecordController(
  detailsRecordService
);

const router = Router();

router.get(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.getAllDetailsRecords(req, res, next)
);

router.get(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.getDetailsRecordById(req, res, next)
);

router.post(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.createDetailsRecord(req, res, next)
);

router.put(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.updateDetailsRecord(req, res, next)
);

router.delete(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response, next: NextFunction) =>
    detailsRecordController.deleteDetailsRecord(req, res, next)
);

export default router;
