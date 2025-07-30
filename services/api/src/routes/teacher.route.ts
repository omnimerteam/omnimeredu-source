import { Request, Response, NextFunction, Router } from "express";
import Teacher from "../models/Teacher";

// Import các model, repository, service và controller cần thiết
import TeacherRepository from "../repositories/teacher.repository";
import TeacherService from "../services/teacher.service";
import TeacherController from "../controllers/teacher.controller";

// Logger & Activity Log
import { ActivityLogRepository } from "../repositories/activityLog.repository";
import { DefaultLogger } from "../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

// Khởi tạo và truyền giá trị vào các constructor
const logger = new DefaultLogger(new ActivityLogRepository());
const teacherRepository = new TeacherRepository(Teacher);
const teacherService = new TeacherService(teacherRepository, logger);
const teacherController = new TeacherController(teacherService);

const router = Router();

router.get(
  "/teachers",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.getAllTeachers(req, res, next)
);
router.get(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.getAllTeachers(req, res, next)
);

router.get(
  "/teachers/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.getTeacherById(req, res, next)
);
router.get(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.getTeacherById(req, res, next)
);

router.post(
  "/teachers",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.createTeacher(req, res, next)
);
router.post(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.createTeacher(req, res, next)
);

router.put(
  "/teachers/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.updateTeacher(req, res, next)
);
router.put(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.updateTeacher(req, res, next)
);

router.delete(
  "/teachers/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.deleteTeacher(req, res, next)
);

router.delete(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.deleteTeacher(req, res, next)
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
