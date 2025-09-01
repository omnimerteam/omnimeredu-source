import {Request, Response, NextFunction, Router} from "express";
import ExtraFeeModel from "../../../domain/models/school/tuition/ExtraFee";
import SchoolAdminModel from "../../../domain/models/user/SchoolAdmin";

import ExtraFeeRepository from "../../../domain/repositories/school/tuition/extraFee.repository";
import SchoolAdminRepository from "../../../domain/repositories/user/schoolAdmin.repository";
import ExtraFeeService from "../../../domain/services/school/tuition/extraFee.service";
import ExtraFeeController from "../../../domain/controllers/school/tuition/extraFee.controller";

import { DefaultLogger } from "../../utils/DefaultLogger";
import { ActivityLogRepository } from "../../../domain/repositories";

import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

const logger = new DefaultLogger(new ActivityLogRepository());
const extraFeeRepository = new ExtraFeeRepository(ExtraFeeModel);
const schoolAdminRepository = new SchoolAdminRepository(SchoolAdminModel);
const extraFeeService = new ExtraFeeService(extraFeeRepository, schoolAdminRepository, logger);
const extraFeeController = new ExtraFeeController(extraFeeService);

const router = Router();

router.get(
    "/",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        extraFeeController.getAllExtraFee(req, res, next)
);

router.get(
    "/:id",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        extraFeeController.getExtraFeeById(req, res, next)
);

router.post(
    "/",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        extraFeeController.createExtraFee(req, res, next)
);

router.put(
    "/:id",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        extraFeeController.updateExtraFee(req, res, next)
);

router.delete(
    "/:id",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        extraFeeController.deleteExtraFee(req, res, next)
);

export default router;
