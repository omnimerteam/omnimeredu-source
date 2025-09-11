import { NextFunction, Request, Response, Router } from "express";
const router = Router();

// Models → Repo → Service → Controller
import {
  BaseUser,
  Class,
  DetailsRecord,
  MembershipRequest,
} from "../../../domain/models";
import {
  SchoolAdminDashboardRepository,
  ActivityLogRepository,
  AttendanceStatsRepository,
} from "../../../domain/repositories";
import { SchoolAdminDashboardService } from "../../../domain/services";
import { SchoolAdminDashboardController } from "../../../domain/controllers";

// Logger & Activity Log

import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import {
  createPaginationSchemaWithSort,
  getSchoolAttendanceStatsSchema,
} from "../../validators/query/query.validator";

// Validate
import { authHeaderSchema } from "../../validators/header/header.validator";

const schoolAdminDashboardRepository = new SchoolAdminDashboardRepository(
  BaseUser,
  Class,
  MembershipRequest
);
const attendanceStatsRepository = new AttendanceStatsRepository(DetailsRecord);
const logger = new DefaultLogger(new ActivityLogRepository());
const schoolAdminDashboardService = new SchoolAdminDashboardService(
  attendanceStatsRepository,
  schoolAdminDashboardRepository,
  logger
);
const schoolAdminDashboardController = new SchoolAdminDashboardController(
  schoolAdminDashboardService
);

router.get(
  "/get-summary",
  validateData({
    headers: authHeaderSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SchoolAdmin"]),
  (req, res, next) => schoolAdminDashboardController.getSummary(req, res, next)
);

router.get(
  "/get-school-attendance-stats",
  validateData({
    headers: authHeaderSchema,
    query: getSchoolAttendanceStatsSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SchoolAdmin"]),
  (req, res, next) =>
    schoolAdminDashboardController.getSchoolAttendanceStats(req, res, next)
);

export default router;
