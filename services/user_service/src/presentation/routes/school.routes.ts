import { Router, Request, Response } from "express";
import { SchoolController } from "../controllers/SchoolController";
import { param, query } from "express-validator";
import {
  objectIdSchema,
  handleValidationErrors,
} from "../middleware/validation/common.schemas";
import {
  createSchoolSchema,
  updateSchoolSchema,
  searchSchoolsQuerySchema,
  getSchoolClassesQuerySchema,
} from "../middleware/validation/school.schemas";
import {
  JWTMiddleware,
  requireRole,
  requirePermission,
} from "../middleware/auth";

const router = Router();
const schoolController = new SchoolController();

// Search schools by education level (must be before /:id route)
router.get(
  "/search/query",
  searchSchoolsQuerySchema,
  (req: Request, res: Response) =>
    schoolController.searchSchoolByEducationLevel(req, res)
);

// Get school details for school admin
router.get(
  "/school-admin",
  JWTMiddleware.verifyToken,
  requireRole("SchoolAdmin"),
  (req: Request, res: Response) =>
    schoolController.getSchoolDetailForSchoolAdmin(req, res)
);

// Get schools with filters
router.get(
  "/",
  [
    query("educationLevel")
      .notEmpty()
      .withMessage("Education level is required"),
    query("educationLevel")
      .isIn(["Primary", "Secondary", "HighSchool", "University"])
      .withMessage("Invalid education level"),
    query("search")
      .optional()
      .isLength({ min: 1, max: 100 })
      .withMessage("Search term must be 1-100 characters"),
    handleValidationErrors,
  ],
  (req: Request, res: Response) => schoolController.getSchools(req, res)
);

// Get school by ID
router.get(
  "/:id",
  JWTMiddleware.verifyToken,
  requirePermission("schools:read"),
  objectIdSchema,
  handleValidationErrors,
  (req: Request, res: Response) => schoolController.getSchoolById(req, res)
);

// Get classes by school ID
router.get(
  "/:schoolId/classes",
  JWTMiddleware.verifyToken,
  requirePermission("schools:read"),
  param("schoolId").isMongoId().withMessage("Invalid school ID format"),
  getSchoolClassesQuerySchema,
  (req: Request, res: Response) => schoolController.getClassesBySchool(req, res)
);

// Create school
router.post(
  "/",
  JWTMiddleware.verifyToken,
  requireRole("SuperAdmin"),
  requirePermission("schools:create"),
  createSchoolSchema,
  (req: Request, res: Response) => schoolController.registerSchool(req, res)
);

// Update school
router.put(
  "/:id",
  JWTMiddleware.verifyToken,
  requireRole(["SuperAdmin", "SchoolAdmin"]),
  requirePermission("schools:update"),
  objectIdSchema,
  updateSchoolSchema,
  (req: Request, res: Response) => schoolController.updateSchool(req, res)
);

// Delete school
router.delete(
  "/:id",
  JWTMiddleware.verifyToken,
  requireRole("SuperAdmin"),
  requirePermission("schools:delete"),
  objectIdSchema,
  handleValidationErrors,
  (req: Request, res: Response) => schoolController.deleteSchool(req, res)
);

export default router;
