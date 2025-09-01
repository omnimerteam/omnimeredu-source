import { NextFunction, Request, Response, Router } from "express";
import DiscountPolicyModel  from "../../../domain/models/school/tuition/DiscountPolicy";
import SchoolAdminModel from "../../../domain/models/user/SchoolAdmin";


import DiscountPolicyRepository from "../../../domain/repositories/school/tuition/discountPolicy.repository";
import SchoolAdminRepository from "../../../domain/repositories/user/schoolAdmin.repository";
import DiscountPolicyService from "../../../domain/services/school/tuition/dicountPolicy.service";
import DiscountPolicyController from "../../../domain/controllers/school/tuition/discountPolicy.controller";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";
import {ActivityLogRepository} from "../../../domain/repositories";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

// Initialize and pass values to constructors
const logger = new DefaultLogger(new ActivityLogRepository());
const discountPolicyRepository = new DiscountPolicyRepository(DiscountPolicyModel);
const schoolAdminRepository = new SchoolAdminRepository(SchoolAdminModel);
const discountPolicyService = new DiscountPolicyService(
    discountPolicyRepository,
    schoolAdminRepository,
    logger
);
const discountPolicyController = new DiscountPolicyController(
    discountPolicyService
);

const router = Router();

router.get(
    "/",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        discountPolicyController.getAllDiscountPolicy(req, res, next)
);

router.get(
    "/:id",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        discountPolicyController.getDiscountPolicyById(req, res, next)
);

router.post(
    "/",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        discountPolicyController.createDiscountPolicy(req, res, next)
);

router.put(
    "/:id",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        discountPolicyController.updateDiscountPolicy(req, res, next)
);

router.delete(
    "/:id",
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) =>
        discountPolicyController.deleteDiscountPolicy(req, res, next)
);

export default router;
