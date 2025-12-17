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
  body("roleName")
    .notEmpty()
    .isIn(["Student", "Teacher", "Parent", "SchoolAdmin", "SuperAdmin"])
    .withMessage("Invalid role"),
  body("baseUserInfo.fullName")
    .notEmpty()
    .isLength({ min: 1, max: 100 })
    .withMessage("Full name is required"),
  body("baseUserInfo.phone")
    .optional()
    .isMobilePhone("any")
    .withMessage("Invalid phone number format"),
  body("baseUserInfo.birthday")
    .optional()
    .isISO8601()
    .toDate()
    .withMessage("Invalid date format"),
  body("baseUserInfo.address")
    .optional()
    .isString()
    .withMessage("Address must be a string"),
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
