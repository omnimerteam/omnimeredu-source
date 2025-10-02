import { Request, Response, NextFunction, Router } from "express";
import { Role } from "../../../domain/models";

// Import các model, repository, service và controller cần thiết
import {
  RoleRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";
import { RoleService } from "../../../domain/services";
import { RoleController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Khởi tạo và truyền giá trị vào các constructor
const roleRepository = new RoleRepository(Role);
const logger = new DefaultLogger(new ActivityLogRepository());
const roleService = new RoleService(roleRepository, logger);
const roleController = new RoleController(roleService);

const router = Router();

router.get("/", async (req: Request, res: Response, next: NextFunction) =>
  roleController.getAllRoles(req, res, next)
);

router.get(
  "/roles-personnel",
  async (req: Request, res: Response, next: NextFunction) =>
    roleController.getRolesPersonnel(req, res, next)
);

export default router;
