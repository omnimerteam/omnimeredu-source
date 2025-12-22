import { body, query } from "express-validator";
import {
  objectIdSchema,
  paginationQuerySchema,
  handleValidationErrors,
} from "./common.schemas";
import { EducationSystemLevelsEnum } from "shared-lib";

// Grade creation validation
export const createGradeSchema = [
  body("schoolId").notEmpty().withMessage("School ID is required"),
  body("name")
    .notEmpty()
    .isLength({ min: 1, max: 100 })
    .withMessage("Name must be 1-100 characters"),
  body("level")
    .isIn(Object.values(EducationSystemLevelsEnum))
    .withMessage("Invalid level"),
  body("gradeGroup")
    .optional()
    .isString()
    .withMessage("Grade group must be a string"),
  body("order")
    .optional()
    .isInt({ min: 1 })
    .withMessage("Order must be a positive integer"),
  body("active").optional().isBoolean().withMessage("Active must be a boolean"),
  body("ageRange")
    .optional()
    .isObject()
    .withMessage("Age range must be an object"),
  body("description")
    .optional()
    .isString()
    .isLength({ max: 500 })
    .withMessage("Description must be max 500 characters"),
  handleValidationErrors,
];

// Grade update validation
export const updateGradeSchema = [
  body("name")
    .optional()
    .isLength({ min: 1, max: 100 })
    .withMessage("Name must be 1-100 characters"),
  body("level")
    .optional()
    .isIn(Object.values(EducationSystemLevelsEnum))
    .withMessage("Invalid level"),
  body("gradeGroup")
    .optional()
    .isString()
    .withMessage("Grade group must be a string"),
  body("order")
    .optional()
    .isInt({ min: 1 })
    .withMessage("Order must be a positive integer"),
  body("active").optional().isBoolean().withMessage("Active must be a boolean"),
  body("ageRange")
    .optional()
    .isObject()
    .withMessage("Age range must be an object"),
  body("description")
    .optional()
    .isString()
    .isLength({ max: 500 })
    .withMessage("Description must be max 500 characters"),
  handleValidationErrors,
];

// Grade query validation for pagination
export const getGradesQuerySchema = [
  ...paginationQuerySchema,
  query("schoolId")
    .optional()
    .isMongoId()
    .withMessage("Invalid school ID format"),
  query("level")
    .optional()
    .isIn(Object.values(EducationSystemLevelsEnum))
    .withMessage("Invalid level"),
  query("active")
    .optional()
    .isBoolean()
    .withMessage("Active must be a boolean"),
  handleValidationErrors,
];

// Grade select query validation
export const getGradesSelectQuerySchema = [
  query("schoolId")
    .optional()
    .isMongoId()
    .withMessage("Invalid school ID format"),
  handleValidationErrors,
];

// Enhanced grades query validation with field selection and advanced filters
export const getGradesEnhancedQuerySchema = [
  query("page")
    .optional()
    .isInt({ min: 1 })
    .withMessage("Page must be a positive integer"),
  query("limit")
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage("Limit must be between 1 and 100"),
  query("sortBy")
    .optional()
    .isIn(["name", "level", "order", "createdAt", "updatedAt"])
    .withMessage("Invalid sort field"),
  query("sortOrder")
    .optional()
    .isIn(["asc", "desc"])
    .withMessage("Sort order must be asc or desc"),
  query("schoolId")
    .optional()
    .isMongoId()
    .withMessage("Invalid school ID format"),
  query("level")
    .optional()
    .isIn(Object.values(EducationSystemLevelsEnum))
    .withMessage("Invalid level"),
  query("active")
    .optional()
    .isBoolean()
    .withMessage("Active must be a boolean"),
  query("search")
    .optional()
    .isLength({ min: 1, max: 100 })
    .withMessage("Search term must be 1-100 characters"),
  query("name")
    .optional()
    .isLength({ min: 1, max: 100 })
    .withMessage("Name filter must be 1-100 characters"),
  query("fields")
    .optional()
    .custom((value) => {
      if (typeof value === "string") {
        const fields = value.split(",");
        const validFields = [
          "id",
          "schoolId",
          "name",
          "level",
          "gradeGroup",
          "order",
          "active",
          "ageRange",
          "description",
          "createdAt",
          "updatedAt",
        ];
        const invalidFields = fields.filter(
          (f) => !validFields.includes(f.trim())
        );
        if (invalidFields.length > 0) {
          throw new Error(`Invalid fields: ${invalidFields.join(", ")}`);
        }
      }
      return true;
    })
    .withMessage("Invalid field selection"),
  handleValidationErrors,
];

// Bulk operations validation
export const bulkCreateGradesSchema = [
  body()
    .isArray({ min: 1, max: 100 })
    .withMessage("Body must be an array with 1-100 items"),
  body("*.schoolId")
    .notEmpty()
    .withMessage("School ID is required for each grade"),
  body("*.name")
    .notEmpty()
    .isLength({ min: 1, max: 100 })
    .withMessage("Name must be 1-100 characters"),
  body("*.level")
    .isIn(Object.values(EducationSystemLevelsEnum))
    .withMessage("Invalid level"),
  body("*.gradeGroup")
    .optional()
    .isString()
    .withMessage("Grade group must be a string"),
  body("*.order")
    .optional()
    .isInt({ min: 1 })
    .withMessage("Order must be a positive integer"),
  body("*.active")
    .optional()
    .isBoolean()
    .withMessage("Active must be a boolean"),
  handleValidationErrors,
];

export const bulkUpdateGradesSchema = [
  body()
    .isArray({ min: 1, max: 100 })
    .withMessage("Body must be an array with 1-100 items"),
  body("*.id").notEmpty().withMessage("ID is required for each grade"),
  body("*.updates")
    .notEmpty()
    .isObject()
    .withMessage("Updates object is required for each grade"),
  handleValidationErrors,
];

export const bulkDeleteGradesSchema = [
  body("ids")
    .isArray({ min: 1, max: 100 })
    .withMessage("IDs must be an array with 1-100 items"),
  body("ids.*").isMongoId().withMessage("Invalid ID format"),
  handleValidationErrors,
];

export const bulkActivateDeactivateGradesSchema = [
  body("ids")
    .isArray({ min: 1, max: 100 })
    .withMessage("IDs must be an array with 1-100 items"),
  body("ids.*").isMongoId().withMessage("Invalid ID format"),
  handleValidationErrors,
];
