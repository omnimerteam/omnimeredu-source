import { Router, Request, Response } from "express";
import { GradeController } from "../controllers/GradeController";
import { param } from "express-validator";
import {
  objectIdSchema,
  handleValidationErrors,
} from "../middleware/validation/common.schemas";
import {
  createGradeSchema,
  updateGradeSchema,
  getGradesQuerySchema,
  getGradesSelectQuerySchema,
  getGradesEnhancedQuerySchema,
  bulkCreateGradesSchema,
  bulkUpdateGradesSchema,
  bulkDeleteGradesSchema,
  bulkActivateDeactivateGradesSchema,
} from "../middleware/validation/grade.schemas";
import {
  JWTMiddleware,
  requireRole,
  requirePermission,
  requireSameSchool,
} from "../middleware/auth";
import { activityLogger } from "../middleware/common";

const router = Router();
const gradeController = new GradeController();

// Create grade
router.post(
  "/",
  activityLogger("create", "grade"),
  JWTMiddleware.verifyToken,
  requireRole(["SuperAdmin", "SchoolAdmin"]),
  requirePermission("grades:create"),
  requireSameSchool(),
  createGradeSchema,
  (req: Request, res: Response) => gradeController.createGrade(req, res)
);

// Get all grades with pagination and filtering
router.get(
  "/",
  JWTMiddleware.verifyToken,
  requirePermission("grades:read"),
  getGradesEnhancedQuerySchema,
  (req: Request, res: Response) => gradeController.getAllGrades(req, res)
);

// Get grades for select dropdown
router.get(
  "/select/box",
  JWTMiddleware.verifyToken,
  requirePermission("grades:select"),
  getGradesSelectQuerySchema,
  (req: Request, res: Response) => gradeController.getGradesForSelect(req, res)
);

// Get grade by ID
router.get(
  "/:id",
  JWTMiddleware.verifyToken,
  requirePermission("grades:read"),
  objectIdSchema,
  handleValidationErrors,
  (req: Request, res: Response) => gradeController.getGradeById(req, res)
);

// Get grades by school ID
router.get(
  "/school/:schoolId",
  JWTMiddleware.verifyToken,
  requirePermission("grades:read"),
  param("schoolId").isMongoId().withMessage("Invalid school ID format"),
  handleValidationErrors,
  (req: Request, res: Response) => gradeController.getGradesBySchoolId(req, res)
);

// Update grade
router.put(
  "/:id",
  activityLogger("update", "grade"),
  JWTMiddleware.verifyToken,
  requireRole(["SuperAdmin", "SchoolAdmin"]),
  requirePermission("grades:update"),
  objectIdSchema,
  updateGradeSchema,
  (req: Request, res: Response) => gradeController.updateGrade(req, res)
);

// Delete grade
router.delete(
  "/:id",
  activityLogger("delete", "grade"),
  JWTMiddleware.verifyToken,
  requireRole(["SuperAdmin", "SchoolAdmin"]),
  requirePermission("grades:delete"),
  objectIdSchema,
  handleValidationErrors,
  (req: Request, res: Response) => gradeController.deleteGrade(req, res)
);

// Bulk operations
router.post(
  "/bulk/create",
  activityLogger("bulk-create", "grade"),
  JWTMiddleware.verifyToken,
  requireRole(["SuperAdmin", "SchoolAdmin"]),
  requirePermission("grades:create"),
  bulkCreateGradesSchema,
  (req: Request, res: Response) => gradeController.bulkCreateGrades(req, res)
);

router.put(
  "/bulk/update",
  activityLogger("bulk-update", "grade"),
  JWTMiddleware.verifyToken,
  requireRole(["SuperAdmin", "SchoolAdmin"]),
  requirePermission("grades:update"),
  bulkUpdateGradesSchema,
  (req: Request, res: Response) => gradeController.bulkUpdateGrades(req, res)
);

router.delete(
  "/bulk/delete",
  activityLogger("bulk-delete", "grade"),
  JWTMiddleware.verifyToken,
  requireRole(["SuperAdmin", "SchoolAdmin"]),
  requirePermission("grades:delete"),
  bulkDeleteGradesSchema,
  (req: Request, res: Response) => gradeController.bulkDeleteGrades(req, res)
);

router.post(
  "/bulk/activate",
  activityLogger("bulk-activate", "grade"),
  JWTMiddleware.verifyToken,
  requireRole(["SuperAdmin", "SchoolAdmin"]),
  requirePermission("grades:update"),
  bulkActivateDeactivateGradesSchema,
  (req: Request, res: Response) => gradeController.bulkActivateGrades(req, res)
);

router.post(
  "/bulk/deactivate",
  activityLogger("bulk-deactivate", "grade"),
  JWTMiddleware.verifyToken,
  requireRole(["SuperAdmin", "SchoolAdmin"]),
  requirePermission("grades:update"),
  bulkActivateDeactivateGradesSchema,
  (req: Request, res: Response) =>
    gradeController.bulkDeactivateGrades(req, res)
);

export default router;
