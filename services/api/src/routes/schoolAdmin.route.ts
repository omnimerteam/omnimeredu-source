import { Request, Response, NextFunction, Router } from "express";
import SchoolAdmin from "../models/SchoolAdmin";

// Import các model, repository, service và controller cần thiết
import SchoolAdminRepository from "../repositories/schoolAdmin.repository";
import SchoolAdminService from "../services/schoolAdmin.service";
import SchooAdminController from "../controllers/schoolAdmin.controller";

// Logger & Activity Log
import { ActivityLogRepository } from "../repositories/activityLog.repository";
import { DefaultLogger } from "../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

// Khởi tạo và truyền giá trị vào các constructor
const logger = new DefaultLogger(new ActivityLogRepository());
const schoolAdminRepository = new SchoolAdminRepository(SchoolAdmin);
const schoolAdminService = new SchoolAdminService(
  logger,
  schoolAdminRepository
);
const schoolAdminController = new SchooAdminController(schoolAdminService);

const router = Router();
router.get(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.getAllSchoolAdmins(req, res, next)
);

router.get(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.getSchoolAdminById(req, res, next)
);

router.post(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.createSchoolAdmin(req, res, next)
);

router.put(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.updateSchoolAdmin(req, res, next)
);

router.delete(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    schoolAdminController.deleteSchoolAdmin(req, res, next)
);

export default router;

/** example request body for creating a teacher
 * {
        "fullName": "Nguyễn Văn DADA",
        "roleId": "6885e31812e74de500041b53",  
        "gender": "Male",
        "birthday": "2000-10-13",
        "phone": "0909032",
        "address": "Long An",
        "isVerified": true,
        "literacy": "abcbca",
        "subjects": ["Math"],   
        "schoolId": "6885e31812e74de500041b51"
      }
 */
