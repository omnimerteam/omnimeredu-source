import { Router, Request, Response } from "express";
import { ClassController } from "../controllers/ClassController";
import {
  objectIdSchema,
  handleValidationErrors,
} from "../middleware/validation/common.schemas";
import {
  createClassSchema,
  updateClassSchema,
  getClassesQuerySchema,
  searchClassesQuerySchema,
  modifyStudentsBodySchema,
  transferStudentsBodySchema,
} from "../middleware/validation/class.schemas";
import { RoleGroup } from "shared-lib";
import {
  JWTMiddleware,
  requireRole,
  requirePermission,
  requireSameSchool,
} from "../middleware/auth";

const router = Router();
const classController = new ClassController();

// Create class
router.post(
  "/",
  JWTMiddleware.verifyToken,
  requireRole([RoleGroup.SuperAdmin, RoleGroup.SchoolAdmin]),
  requirePermission("classes:create"),
  requireSameSchool(),
  createClassSchema,
  (req: Request, res: Response) => classController.createClass(req, res)
);

// Get all classes with pagination and filtering
router.get(
  "/",
  JWTMiddleware.verifyToken,
  requirePermission("classes:read"),
  getClassesQuerySchema,
  (req: Request, res: Response) => classController.getAllClasses(req, res)
);

// Search classes within schools
router.get(
  "/schools/search",
  JWTMiddleware.verifyToken,
  requirePermission("classes:search"),
  searchClassesQuerySchema,
  (req: Request, res: Response) =>
    classController.searchClassesInSchool(req, res)
);

// Get classes by school ID
router.get(
  "/school/:schoolId",
  JWTMiddleware.verifyToken,
  requirePermission("classes:read"),
  // param("schoolId").isMongoId().withMessage("Invalid school ID format"),
  handleValidationErrors,
  (req: Request, res: Response) =>
    classController.getClassesBySchoolId(req, res)
);

// Get class by ID
router.get(
  "/:id",
  JWTMiddleware.verifyToken,
  requirePermission("classes:read"),
  objectIdSchema,
  handleValidationErrors,
  (req: Request, res: Response) => classController.getClassById(req, res)
);

// Get students by class ID (Read from MongoDB)
router.get(
  "/:id/students",
  JWTMiddleware.verifyToken,
  requirePermission("classes:read"),
  objectIdSchema,
  handleValidationErrors,
  (req: Request, res: Response) =>
    classController.getStudentsByClassId(req, res)
);

// Add students to class
router.post(
  "/:id/students/add",
  JWTMiddleware.verifyToken,
  requireRole([RoleGroup.SuperAdmin, RoleGroup.SchoolAdmin, RoleGroup.Teacher]),
  requirePermission("classes:addStudents"),
  objectIdSchema,
  modifyStudentsBodySchema,
  (req: Request, res: Response) => classController.addStudentToClass(req, res)
);

// Remove students from class
router.post(
  "/:id/students/remove",
  JWTMiddleware.verifyToken,
  requireRole([RoleGroup.SuperAdmin, RoleGroup.SchoolAdmin, RoleGroup.Teacher]),
  requirePermission("classes:removeStudents"),
  objectIdSchema,
  modifyStudentsBodySchema,
  (req: Request, res: Response) =>
    classController.removeStudentFromClass(req, res)
);

// Transfer students between classes
router.post(
  "/:id/students/transfer",
  JWTMiddleware.verifyToken,
  requireRole([RoleGroup.SuperAdmin, RoleGroup.SchoolAdmin, RoleGroup.Teacher]),
  requirePermission("classes:transferStudents"),
  objectIdSchema,
  transferStudentsBodySchema,
  (req: Request, res: Response) => classController.transferClass(req, res)
);

// Update class
router.put(
  "/:id",
  JWTMiddleware.verifyToken,
  requireRole([RoleGroup.SuperAdmin, RoleGroup.SchoolAdmin]),
  requirePermission("classes:update"),
  objectIdSchema,
  updateClassSchema,
  (req: Request, res: Response) => classController.updateClass(req, res)
);

// Delete class
router.delete(
  "/:id",
  JWTMiddleware.verifyToken,
  requireRole([RoleGroup.SuperAdmin, RoleGroup.SchoolAdmin]),
  requirePermission("classes:delete"),
  objectIdSchema,
  handleValidationErrors,
  (req: Request, res: Response) => classController.deleteClass(req, res)
);

export default router;
