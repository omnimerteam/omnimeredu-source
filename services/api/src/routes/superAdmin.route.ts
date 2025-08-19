import { Request, Response, NextFunction, Router } from "express";
import { SuperAdmin } from "../models";

// Import các model, repository, service và controller cần thiết
import SuperAdminRepository from "../repositories/superAdmin.repository";
import SuperAdminService from "../services/superAdmin.service";
import SuperAdminController from "../controllers/superAdmin.controller";

// Logger & Activity Log
import { ActivityLogRepository } from "../repositories/activityLog.repository";
import { DefaultLogger } from "../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

// Khởi tạo và truyền giá trị vào các constructor
const logger = new DefaultLogger(new ActivityLogRepository());
const teacherRepository = new SuperAdminRepository(SuperAdmin);
const teacherService = new SuperAdminService(teacherRepository, logger);
const teacherController = new SuperAdminController(teacherService);

const router = Router();

router.get(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.getAllSuperAdmins(req, res, next)
);

router.get(
  "/teachers/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.getSuperAdminById(req, res, next)
);
router.get(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.getSuperAdminById(req, res, next)
);

router.post(
  "/teachers",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.createSuperAdmin(req, res, next)
);
router.post(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.createSuperAdmin(req, res, next)
);

router.put(
  "/teachers/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.updateSuperAdmin(req, res, next)
);
router.put(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.updateSuperAdmin(req, res, next)
);

router.delete(
  "/teachers/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.deleteSuperAdmin(req, res, next)
);

router.delete(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.deleteSuperAdmin(req, res, next)
);

export default router;
