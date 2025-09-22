import { Request, Response, NextFunction, Router } from "express";
import {
  ActivityLogRepository,
  PersonnelRepository,
} from "../../../domain/repositories";
import { PersonnelService } from "../../../domain/services";
import { PersonnelController } from "../../../domain/controllers";
import { DefaultLogger } from "../../utils/DefaultLogger";
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import {
  createPaginationSchemaWithSortAndFilter,
  createPaginationSchemaWithSortFilterAndSearch,
} from "../../validators/common/query/query.validator";
import { BaseUser } from "../../../domain/models";

const logger = new DefaultLogger(new ActivityLogRepository());
const personnelRepository = new PersonnelRepository(BaseUser);
const personnelService = new PersonnelService(personnelRepository, logger);
const personnelController = new PersonnelController(personnelService);

const router = Router();

const personnelQuerySchema = createPaginationSchemaWithSortFilterAndSearch(
  ["fullName", "createdAt", "birthday"],
  ["gender", "roleKey", "subjects"]
);

// Lấy danh sách nhân sự (gồm teacher + staff)
router.get(
  "/",
  validateData({ headers: authHeaderSchema, query: personnelQuerySchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    personnelController.getAllPersonnel(req, res, next)
);

export default router;
