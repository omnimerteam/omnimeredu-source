import { Request, Response, NextFunction, Router } from "express";
import TeachingAssignmentModel from "../models/TeachingAssignment";
import ClassModel from "../models/Class";
import { Teacher } from "../models/Teacher";
import { SchoolAdmin } from "../models/SchoolAdmin";

// Import các model, repository, service và controller cần thiết
import ClassRepository from "../repositories/class.repository";
import TeacherRepository from "../repositories/teacher.repository";
import TeachingAssignmentRepository from "../repositories/teachingAssignment.repository";
import TeachingAssignmentService from "../services/teachingAssignment.service";
import TeachingAssignmentController from "../controllers/teachingAssignment.controller";
import SchoolAdminRepository from "../repositories/schoolAdmin.repository";

// Logger & Activity Log
import { ActivityLogRepository } from "../repositories/activityLog.repository";
import { DefaultLogger } from "../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

const logger = new DefaultLogger(new ActivityLogRepository());
const classRepository = new ClassRepository(ClassModel);
const teacherRepository = new TeacherRepository(Teacher);
const schoolAdminRepository = new SchoolAdminRepository(SchoolAdmin);
const teachingAssignmentRepository = new TeachingAssignmentRepository(
  TeachingAssignmentModel
);
const teachingAssignmentService = new TeachingAssignmentService(
  logger,
  teachingAssignmentRepository,
  teacherRepository,
  classRepository,
  schoolAdminRepository
);
const teachingAssignmentController = new TeachingAssignmentController(
  teachingAssignmentService
);

const router = Router();

router.get(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teachingAssignmentController.getAllTeachingAssignments(req, res, next)
);

router.get(
  "/:id",
  verifyFirebaseToken,
  verifyRole([
    "SuperAdmin",
    "SchoolAdmin",
    "Teacher",
    "Parent",
    "SchoolStaff",
    "SchoolManager",
    "Nurse",
    "CanteenStaff",
  ]),
  async (req: Request, res: Response, next: NextFunction) =>
    teachingAssignmentController.getTeachingAssignmentById(req, res, next)
);

router.post(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teachingAssignmentController.createTeachingAssignment(req, res, next)
);

router.put(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teachingAssignmentController.updateTeachingAssignment(req, res, next)
);

router.delete(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teachingAssignmentController.deleteTeachingAssignment(req, res, next)
);

export default router;

/** example request body for creating a teacher assignment
 * {
    "fullName": "Nguyễn Văn BNA",
    "roleId": "6885e31812e74de500041b56",  
    "gender": "Male",
    "birthday": "2000-10-13",
    "phone": "0909032",
    "address": "Thủ Đức",
    "isVerified": true, 
    "schoolId": "6885e31812e74de500041b51"
}
 */
