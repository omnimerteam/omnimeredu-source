import { NextFunction, Request, Response, Router } from "express";
import { Attendance, DetailsRecord } from "../../../domain/models";

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
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

// Initialize and pass values to constructors
const logger = new DefaultLogger(new ActivityLogRepository());
const detailsRecordRepository = new DetailsRecordRepository(DetailsRecord);
const attendanceRepository = new AttendanceRepository(Attendance);
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
