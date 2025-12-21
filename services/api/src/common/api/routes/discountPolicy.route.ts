import { NextFunction, Request, Response, Router } from "express";
import { DiscountPolicy } from "../../../domain/models";

import DiscountPolicyRepository from "../../../domain/repositories/school/tuition/discountPolicy.repository";
import DiscountPolicyService from "../../../domain/services/school/tuition/dicountPolicy.service";
import DiscountPolicyController from "../../../domain/controllers/school/tuition/discountPolicy.controller";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";
import { ActivityLogRepository } from "../../../domain/repositories";

// Middleware
import { verifyJWTToken } from "../middlewares/verifyJWTToken.middleware";
import { verifyRole } from "../middlewares/verifyRole";
import { createPaginationSchemaWithSortAndFilter } from "../../validators/common/query/query.validator";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import { validateData } from "../middlewares/validateData";
import { objectIdParamSchema } from "../../validators/common/params/params.validator";
import {
  createDiscountPolicyBodySchema,
  updateDiscountPolicyBodySchema,
} from "../../validators/app/discountPolicy/discountPolicy.validator";

// Initialize and pass values to constructors
const logger = new DefaultLogger(new ActivityLogRepository());
const discountPolicyRepository = new DiscountPolicyRepository(DiscountPolicy);
const discountPolicyService = new DiscountPolicyService(
  discountPolicyRepository,
  logger
);
const discountPolicyController = new DiscountPolicyController(
  discountPolicyService
);

const queryDiscountPolicy = createPaginationSchemaWithSortAndFilter(
  ["code", "name", "minSubtotal", "maxSubtotal"],
  ["kind", "target", "stackable", "oncePer", "applicabilityScope", "active"]
);

const router = Router();

router.get(
  "/",
  validateData({ headers: authHeaderSchema, query: queryDiscountPolicy }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    discountPolicyController.getAllDiscountPolicy(req, res, next)
);

router.get(
  "/:id",
  validateData({ headers: authHeaderSchema, query: objectIdParamSchema }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    discountPolicyController.getDiscountPolicyById(req, res, next)
);

router.post(
  "/",
  validateData({
    headers: authHeaderSchema,
    query: createDiscountPolicyBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    discountPolicyController.createDiscountPolicy(req, res, next)
);

router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    query: updateDiscountPolicyBodySchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    discountPolicyController.updateDiscountPolicy(req, res, next)
);

router.delete(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    discountPolicyController.deleteDiscountPolicy(req, res, next)
);

export default router;
