import { body, query } from "express-validator";
import { handleValidationErrors } from "./common.schemas";

// School creation validation
export const createSchoolSchema = [
  body("name")
    .notEmpty()
    .isLength({ min: 1, max: 200 })
    .withMessage("Name must be 1-200 characters"),
  body("code")
    .notEmpty()
    .isLength({ min: 1, max: 20 })
    .withMessage("Code must be 1-20 characters"),
  body("address")
    .notEmpty()
    .isLength({ min: 10, max: 500 })
    .withMessage("Address must be 10-500 characters"),
  body("level")
    .isIn(["Primary", "Secondary", "HighSchool", "University"])
    .withMessage("Invalid education level"),
  body("adminId").optional().isMongoId().withMessage("Invalid admin ID format"),
  body("phone")
    .optional()
    .isMobilePhone("any")
    .withMessage("Invalid phone number format"),
  body("description")
    .optional()
    .isLength({ max: 1000 })
    .withMessage("Description must be max 1000 characters"),
  body("logoUrl").optional().isURL().withMessage("Invalid logo URL format"),
  body("customTheme")
    .optional()
    .isObject()
    .withMessage("Custom theme must be an object"),
  handleValidationErrors,
];

// School update validation
export const updateSchoolSchema = [
  body("name")
    .optional()
    .isLength({ min: 1, max: 200 })
    .withMessage("Name must be 1-200 characters"),
  body("code")
    .optional()
    .isLength({ min: 1, max: 20 })
    .withMessage("Code must be 1-20 characters"),
  body("address")
    .optional()
    .isLength({ min: 10, max: 500 })
    .withMessage("Address must be 10-500 characters"),
  body("level")
    .optional()
    .isIn(["Primary", "Secondary", "HighSchool", "University"])
    .withMessage("Invalid education level"),
  body("phone")
    .optional()
    .isMobilePhone("any")
    .withMessage("Invalid phone number format"),
  body("description")
    .optional()
    .isLength({ max: 1000 })
    .withMessage("Description must be max 1000 characters"),
  body("logoUrl").optional().isURL().withMessage("Invalid logo URL format"),
  body("customTheme")
    .optional()
    .isObject()
    .withMessage("Custom theme must be an object"),
  handleValidationErrors,
];

// School search query validation
export const searchSchoolsQuerySchema = [
  query("educationLevel")
    .optional()
    .isIn(["Primary", "Secondary", "HighSchool", "University"])
    .withMessage("Invalid education level"),
  query("search")
    .optional()
    .isLength({ min: 1, max: 100 })
    .withMessage("Search term must be 1-100 characters"),
  query("limit")
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage("Limit must be between 1 and 100"),
  query("offset")
    .optional()
    .isInt({ min: 0 })
    .withMessage("Offset must be a non-negative integer"),
  handleValidationErrors,
];

// School classes query validation
export const getSchoolClassesQuerySchema = [
  query("grade").optional().isMongoId().withMessage("Invalid grade ID format"),
  handleValidationErrors,
];
