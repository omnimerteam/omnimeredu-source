import { Request, Response, NextFunction, Router } from "express";
import { SuperAdmin } from "../../../domain/models";

// Import các model, repository, service và controller cần thiết
import {
  SuperAdminRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";
import { SuperAdminService } from "../../../domain/services";
import { SuperAdminController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { authHeaderSchema } from "../../validators/header/header.validator";
import { objectIdParamSchema } from "../../validators/params/params.validator";
import { createSuperAdminSchema } from "../../validators/superAdmin/superAdmin.validator";

// Khởi tạo và truyền giá trị vào các constructor
const logger = new DefaultLogger(new ActivityLogRepository());
const superAdminRepository = new SuperAdminRepository(SuperAdmin);
const superAdminService = new SuperAdminService(superAdminRepository, logger);
const superAdminController = new SuperAdminController(superAdminService);

const router = Router();

router.get(
  "/",
  validateData({ headers: authHeaderSchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    superAdminController.getAllSuperAdmins(req, res, next)
);

router.get(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    superAdminController.getSuperAdminById(req, res, next)
);

router.post(
  "/",
  validateData({ headers: authHeaderSchema, body: createSuperAdminSchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    superAdminController.createSuperAdmin(req, res, next)
);

router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    body: createSuperAdminSchema,
    params: objectIdParamSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    superAdminController.updateSuperAdmin(req, res, next)
);

router.delete(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    superAdminController.deleteSuperAdmin(req, res, next)
);

export default router;
