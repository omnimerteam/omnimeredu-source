import { Request, Response, NextFunction, Router } from "express";
import { SchoolAdmin } from "../../../domain/models";

// Import các model, repository, service và controller cần thiết
import {
  SchoolAdminRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";
import { SchoolAdminService } from "../../../domain/services";
import { SchoolAdminController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyJWTToken } from "../middlewares/verifyJWTToken.middleware";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import { objectIdParamSchema } from "../../validators/common/params/params.validator";
import {
  createSchoolAdminBodySchema,
  updatePositionSchoolAdminSchema,
  updateSchoolAdminBodySchema,
} from "../../validators/auth/schoolAdmin/schoolAdmin.validator";

// Khởi tạo và truyền giá trị vào các constructor
const logger = new DefaultLogger(new ActivityLogRepository());
const schoolAdminRepository = new SchoolAdminRepository(SchoolAdmin);
const schoolAdminService = new SchoolAdminService(
  logger,
  schoolAdminRepository
);
const schoolAdminController = new SchoolAdminController(schoolAdminService);

const router = Router();
router.get(
  "/",
  validateData({ headers: authHeaderSchema }),
  verifyJWTToken,
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.getAllSchoolAdmins(req, res, next)
);

router.get(
  "/:id",
  validateData({ headers: authHeaderSchema }),
  verifyJWTToken,
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.getSchoolAdminById(req, res, next)
);

router.post(
  "/",
  validateData({
    headers: authHeaderSchema,
    body: createSchoolAdminBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.createSchoolAdmin(req, res, next)
);

router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
    body: updateSchoolAdminBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.updateSchoolAdmin(req, res, next)
);

router.patch(
  "/update-position/:id",
  validateData({
    headers: authHeaderSchema,
    body: updatePositionSchoolAdminSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.updatePositionSchoolAdmin(req, res, next)
);

router.delete(
  "/:id",
  verifyJWTToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.deleteSchoolAdmin(req, res, next)
);

export default router;
