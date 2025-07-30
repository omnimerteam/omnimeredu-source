import { Router } from "express";

// Models → Repo → Service → Controller
import Class from "../models/Class";
import Student from "../models/Student";
import ClassRepository from "../repositories/class.repository";
import ClassService from "../services/class.services";
import ClassController from "../controllers/class.controller";
import StudentRepository from "../repositories/student.repository";

// Logger & Activity Log
import { ActivityLogRepository } from "../repositories/activityLog.repository";
import { DefaultLogger } from "../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

// Init Dependencies
const classRepository = new ClassRepository(Class);
const studentRepository = new StudentRepository(Student);
const logger = new DefaultLogger(new ActivityLogRepository());
const classService = new ClassService(
  classRepository,
  logger,
  studentRepository
);
const classController = new ClassController(classService);

// Router
const router = Router();

/**
 * ROUTE DEFINITIONS
 */

// Lấy tất cả lớp
router.get(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.getAllClasses(req, res, next)
);

// Lấy lớp theo ID
router.get(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.getClassById(req, res, next)
);

// Tạo lớp mới
router.post(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req, res, next) => classController.createClass(req, res, next)
);

// Cập nhật lớp
router.put(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req, res, next) => classController.updateClass(req, res, next)
);

// Xóa lớp
router.delete(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req, res, next) => classController.deleteClass(req, res, next)
);

// Thêm học sinh vào lớp
router.post(
  "/:id/students",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.addStudentToClass(req, res, next)
);

// Xóa học sinh khỏi lớp
router.post(
  "/:id/students",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.removeStudentFromClass(req, res, next)
);

// Trao đổi học sinh giữa các lớp
router.put(
  "/:id/transfer",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.transferClass(req, res, next)
);

export default router;
