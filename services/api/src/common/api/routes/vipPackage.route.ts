import { Request, Response, NextFunction, Router } from "express";
import { VipPackage } from "../../../domain/models";

// Import các model, repository, service và controller cần thiết
import {
  VipPackageRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";
import { VipPackageService } from "../../../domain/services";
import { VipPackageController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";

// Validator
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import { objectIdParamSchema } from "../../validators/common/params/params.validator";
import {
  createVipPackageBodySchema,
  updateVipPackageBodySchema,
} from "../../validators/system/vipPackage/vipPackage.validator";

// Khởi tạo và truyền giá trị vào các constructor
const logger = new DefaultLogger(new ActivityLogRepository());
const vipPackageRepository = new VipPackageRepository(VipPackage);
const vipPackageService = new VipPackageService(vipPackageRepository, logger);
const vipPackageController = new VipPackageController(vipPackageService);

const router = Router();

router.get("/", async (req: Request, res: Response, next: NextFunction) =>
  vipPackageController.getAllVipPackages(req, res, next)
);

router.get(
  "/:id",
  validateData({ params: objectIdParamSchema }),
  async (req: Request, res: Response, next: NextFunction) =>
    vipPackageController.getVipPackageById(req, res, next)
);

router.post(
  "/",
  validateData({ headers: authHeaderSchema, body: createVipPackageBodySchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    vipPackageController.createVipPackage(req, res, next)
);

router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    body: updateVipPackageBodySchema,
    params: objectIdParamSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    vipPackageController.updateVipPackage(req, res, next)
);

router.delete(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    vipPackageController.deleteVipPackage(req, res, next)
);

export default router;
