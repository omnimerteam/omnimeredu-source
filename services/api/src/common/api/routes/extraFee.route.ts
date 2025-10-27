import { Request, Response, NextFunction, Router } from "express";
import { ExtraFee } from "../../../domain/models";

import ExtraFeeRepository from "../../../domain/repositories/school/tuition/extraFee.repository";
import ExtraFeeService from "../../../domain/services/school/tuition/extraFee.service";
import ExtraFeeController from "../../../domain/controllers/school/tuition/extraFee.controller";

import { DefaultLogger } from "../../utils/DefaultLogger";
import { ActivityLogRepository } from "../../../domain/repositories";

import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { createPaginationSchemaWithSortAndFilter } from "../../validators/common/query/query.validator";
import { validateData } from "../middlewares/validateData";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import { objectIdParamSchema } from "../../validators/common/params/params.validator";
import {
  createExtraFeeBodySchema,
  updateExtraFeeBodySchema,
} from "../../validators/app/extraFee/extraFee.validator";

const logger = new DefaultLogger(new ActivityLogRepository());
const extraFeeRepository = new ExtraFeeRepository(ExtraFee);
const extraFeeService = new ExtraFeeService(extraFeeRepository, logger);
const extraFeeController = new ExtraFeeController(extraFeeService);

const queryExtraFee = createPaginationSchemaWithSortAndFilter(
  ["code", "name", "taxRate"],
  [
    "kind",
    "target",
    "calcType",
    "applicableScope",
    "oncePer",
    "isTaxable",
    "active",
  ]
);

const router = Router();

router.get(
  "/",
  validateData({ headers: authHeaderSchema, query: queryExtraFee }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    extraFeeController.getAllExtraFee(req, res, next)
);

router.get(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    extraFeeController.getExtraFeeById(req, res, next)
);

router.post(
  "/",
  validateData({ headers: authHeaderSchema, body: createExtraFeeBodySchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    extraFeeController.createExtraFee(req, res, next)
);

router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    body: updateExtraFeeBodySchema,
    params: objectIdParamSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    extraFeeController.updateExtraFee(req, res, next)
);

router.delete(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    extraFeeController.deleteExtraFee(req, res, next)
);

export default router;
