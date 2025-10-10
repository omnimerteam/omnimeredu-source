import {Request, Response, NextFunction, Router} from "express";
import HolidayModel from "../../../domain/models/system/Holiday";

import HolidayRepository from "../../../domain/repositories/system/Holiday.repository";
import HolidayService from "../../../domain/services/system/Holiday.service";
import HolidayController from "../../../domain/controllers/system/holiday.controller";

import { DefaultLogger } from "../../utils/DefaultLogger";
import { ActivityLogRepository } from "../../../domain/repositories";

import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

const logger = new DefaultLogger(new ActivityLogRepository());
const holidayRepository = new HolidayRepository(HolidayModel);
const holidayService = new HolidayService(holidayRepository, logger);
const holidayController = new HolidayController(holidayService);

const router = Router();

router.get(
    "/",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        holidayController.getAllHolidaies(req, res, next)
);

router.get(
    "/:id",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        holidayController.getHolidayById(req, res, next)
);

router.post(
    "/",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        holidayController.createHoliday(req, res, next)
);

router.put(
    "/:id",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        holidayController.updateHoliday(req, res, next)
);

router.delete(
    "/:id",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        holidayController.deleteHoliday(req, res, next)
);

export default router;

// schoolID nên cần được lấy đúng từ danh sách Schools

// {
//   "schoolId": "6707903f79b2f1a9b82c45e0", 
//   "name": "Nghỉ lễ 30/4 - 1/5",
//   "startDate": "2025-04-30T00:00:00.000Z",
//   "endDate": "2025-05-01T23:59:59.000Z",
//   "isRecurring": true,
//   "type": "national"
// }
