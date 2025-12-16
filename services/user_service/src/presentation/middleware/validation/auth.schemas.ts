import { body } from "express-validator";
import { handleValidationErrors } from "./common.schemas";

// User registration validation
export const registerUserSchema = [
  body("email")
    .isEmail()
    .normalizeEmail()
    .withMessage("Valid email is required"),
  body("password")
    .isLength({ min: 6 })
    .withMessage("Password must be at least 6 characters long"),
  body("firstName")
    .notEmpty()
    .isLength({ min: 1, max: 50 })
    .withMessage("First name must be 1-50 characters"),
  body("lastName")
    .notEmpty()
    .isLength({ min: 1, max: 50 })
    .withMessage("Last name must be 1-50 characters"),
  body("role")
    .optional()
    .isIn(["Student", "Teacher", "Parent", "SchoolAdmin", "SuperAdmin"])
    .withMessage("Invalid role"),
  body("phone")
    .optional()
    .isMobilePhone("any")
    .withMessage("Invalid phone number format"),
  body("dateOfBirth")
    .optional()
    .isISO8601()
    .toDate()
    .withMessage("Invalid date format"),
  body("address").optional().isString().withMessage("Address must be a string"),
  handleValidationErrors,
];

// User login validation
export const loginUserSchema = [
  body("email")
    .isEmail()
    .normalizeEmail()
    .withMessage("Valid email is required"),
  body("password").notEmpty().withMessage("Password is required"),
  handleValidationErrors,
];

// Refresh token validation
export const refreshTokenSchema = [
  body("refreshToken").notEmpty().withMessage("Refresh token is required"),
  handleValidationErrors,
];
