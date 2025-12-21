import { Request, Response, NextFunction, Router } from "express";
import {
  ActivityLogRepository,
  PersonnelRepository,
} from "../../../domain/repositories";
import { PersonnelService } from "../../../domain/services";
import { PersonnelController } from "../../../domain/controllers";
import { DefaultLogger } from "../../utils/DefaultLogger";
import { verifyJWTToken } from "../middlewares/verifyJWTToken.middleware";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import { createPaginationSchemaWithSortFilterAndSearch } from "../../validators/common/query/query.validator";
import { BaseUser } from "../../../domain/models";
import {
  updateAvatar,
  updateRoleId,
  updateVerified,
} from "../../validators/auth/baseUser/baseUser.validator";
import { objectIdParamSchema } from "../../validators/common/params/params.validator";

const logger = new DefaultLogger(new ActivityLogRepository());
const personnelRepository = new PersonnelRepository(BaseUser);
const personnelService = new PersonnelService(personnelRepository, logger);
const personnelController = new PersonnelController(personnelService);

const router = Router();

const personnelQuerySchema = createPaginationSchemaWithSortFilterAndSearch(
  ["fullName", "createdAt", "birthday"],
  ["gender", "roleId", "roleKey", "subjects", "qualification", "position"]
);

// Lấy danh sách nhân sự (gồm teacher + staff)
//? Tuy cái này không ngờ nhưng cái này có thể cập nhật tất cả nha
router.get(
  "/",
  validateData({ headers: authHeaderSchema, query: personnelQuerySchema }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    personnelController.getAllPersonnel(req, res, next)
);

router.patch(
  "/update-role/:id",
  validateData({
    headers: authHeaderSchema,
    body: updateRoleId,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    personnelController.updateRoleId(req, res, next)
);

router.patch(
  "/update-verified/:id",
  validateData({
    headers: authHeaderSchema,
    body: updateVerified,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    personnelController.updateVerified(req, res, next)
);

router.patch(
  "/dismiss/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    personnelController.dismissPersonnel(req, res, next)
);

router.get(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  async (req: Request, res: Response, next: NextFunction) =>
    personnelController.getUserById(req, res, next)
);

router.patch(
  "/update-avatar",
  validateData({
    headers: authHeaderSchema,
    body: updateAvatar,
  }),
  verifyJWTToken,
  async (req: Request, res: Response, next: NextFunction) =>
    personnelController.updateAvatar(req, res, next)
);

export default router;
