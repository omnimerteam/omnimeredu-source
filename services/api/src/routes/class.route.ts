import { Request, Response, Router } from "express";
// Model <- Repo <- Ser <- Control
import Class from "../models/Class";
import ClassRepository from "../repositories/class.repository";
import ClassService from "../services/class.service";
import ClassController from "../controllers/class.controller";

// Import Các Instace cần thiết
import { ActivityLogRepository } from "../repositories/activityLog.repository";
import { DefaultLogger } from "../utils/activity.logger";

// Import các Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken"; // Firebase Auth Token => checking đăng nhập
import { verifyRole } from "../middlewares/verifyRole"; // Kiểm tra Vai trò => checking quyền hạn

// Khởi tạo các lớp phụ thuộc
const classRepository = new ClassRepository(Class);
const logger = new DefaultLogger(new ActivityLogRepository());
const classService = new ClassService(classRepository, logger);
const classController = new ClassController(classService);

// Khởi tạo router
const router = Router();

// Routes
router.get(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  (req: Request, res: Response) => classController.getAllClasses(req, res)
);

router.get(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req: Request, res: Response) => classController.getByIdClass(req, res)
);

router.post(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response) => classController.createClass(req, res)
);

router.put(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response) => classController.updateClass(req, res)
);

router.delete(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response) => classController.removeClass(req, res)
);

// ✅ Export để dùng ở index.ts
export default router;
