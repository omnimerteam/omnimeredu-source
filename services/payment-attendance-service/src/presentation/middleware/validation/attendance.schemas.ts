import { body, param, query, ValidationChain } from "express-validator";

/**
 * Attendance Status Enum Values
 */
const ATTENDANCE_STATUS = [
  "Present",
  "AbsentWithLeave",
  "Absent",
  "Late",
  "LeftEarly",
];

/**
 * Session Type Enum Values
 */
const SESSION_TYPES = ["regular", "weekend", "holiday", "extra"];

/**
 * Validation Schemas for Attendance APIs
 */

// =============================================================================
// Create Attendance
// =============================================================================
export const createAttendanceSchema: ValidationChain[] = [
  body("classId")
    .notEmpty()
    .withMessage("classId is required")
    .isString()
    .withMessage("classId must be a string"),
  body("schoolId")
    .notEmpty()
    .withMessage("schoolId is required")
    .isString()
    .withMessage("schoolId must be a string"),
  body("date")
    .notEmpty()
    .withMessage("date is required")
    .isISO8601()
    .withMessage("date must be a valid ISO 8601 date"),
  body("sessionType")
    .optional()
    .isIn(SESSION_TYPES)
    .withMessage(`sessionType must be one of: ${SESSION_TYPES.join(", ")}`),
];

// =============================================================================
// Initialize Class Attendance
// =============================================================================
export const initializeClassAttendanceSchema: ValidationChain[] = [
  body("classId")
    .notEmpty()
    .withMessage("classId is required")
    .isString()
    .withMessage("classId must be a string"),
  body("schoolId")
    .notEmpty()
    .withMessage("schoolId is required")
    .isString()
    .withMessage("schoolId must be a string"),
  body("date")
    .notEmpty()
    .withMessage("date is required")
    .isISO8601()
    .withMessage("date must be a valid ISO 8601 date"),
  body("sessionType")
    .optional()
    .isIn(SESSION_TYPES)
    .withMessage(`sessionType must be one of: ${SESSION_TYPES.join(", ")}`),
  body("studentIds")
    .notEmpty()
    .withMessage("studentIds is required")
    .isArray({ min: 1 })
    .withMessage("studentIds must be a non-empty array"),
  body("studentIds.*")
    .isString()
    .withMessage("Each studentId must be a string"),
];

// =============================================================================
// Manual Attendance (Single Student)
// =============================================================================
export const manualAttendanceSchema: ValidationChain[] = [
  param("id")
    .notEmpty()
    .withMessage("Attendance ID is required")
    .isString()
    .withMessage("Attendance ID must be a string"),
  body("studentId")
    .notEmpty()
    .withMessage("studentId is required")
    .isString()
    .withMessage("studentId must be a string"),
  body("status")
    .notEmpty()
    .withMessage("status is required")
    .isIn(ATTENDANCE_STATUS)
    .withMessage(`status must be one of: ${ATTENDANCE_STATUS.join(", ")}`),
  body("note")
    .optional()
    .isString()
    .withMessage("note must be a string")
    .isLength({ max: 500 })
    .withMessage("note must not exceed 500 characters"),
];

// =============================================================================
// Bulk Manual Attendance
// =============================================================================
export const bulkManualAttendanceSchema: ValidationChain[] = [
  param("id")
    .notEmpty()
    .withMessage("Attendance ID is required")
    .isString()
    .withMessage("Attendance ID must be a string"),
  body("records")
    .notEmpty()
    .withMessage("records is required")
    .isArray({ min: 1 })
    .withMessage("records must be a non-empty array"),
  body("records.*.studentId")
    .notEmpty()
    .withMessage("Each record must have a studentId")
    .isString()
    .withMessage("studentId must be a string"),
  body("records.*.status")
    .notEmpty()
    .withMessage("Each record must have a status")
    .isIn(ATTENDANCE_STATUS)
    .withMessage(`status must be one of: ${ATTENDANCE_STATUS.join(", ")}`),
  body("records.*.note")
    .optional()
    .isString()
    .withMessage("note must be a string"),
];

// =============================================================================
// Update Attendance Status
// =============================================================================
export const updateAttendanceStatusSchema: ValidationChain[] = [
  param("recordId")
    .notEmpty()
    .withMessage("Record ID is required")
    .isString()
    .withMessage("Record ID must be a string"),
  body("status")
    .notEmpty()
    .withMessage("status is required")
    .isIn(ATTENDANCE_STATUS)
    .withMessage(`status must be one of: ${ATTENDANCE_STATUS.join(", ")}`),
  body("note")
    .optional()
    .isString()
    .withMessage("note must be a string")
    .isLength({ max: 500 })
    .withMessage("note must not exceed 500 characters"),
];

// =============================================================================
// Verify QR Attendance
// =============================================================================
export const verifyQRAttendanceSchema: ValidationChain[] = [
  body("qrData")
    .notEmpty()
    .withMessage("qrData is required")
    .isString()
    .withMessage("qrData must be a string (base64 encoded)"),
  body("studentId")
    .notEmpty()
    .withMessage("studentId is required")
    .isString()
    .withMessage("studentId must be a string"),
  body("dynamicCode")
    .optional()
    .isString()
    .withMessage("dynamicCode must be a string")
    .isLength({ min: 6, max: 6 })
    .withMessage("dynamicCode must be exactly 6 characters"),
];

// =============================================================================
// Common Param Schemas
// =============================================================================
export const attendanceIdParamSchema: ValidationChain[] = [
  param("id")
    .notEmpty()
    .withMessage("Attendance ID is required")
    .isString()
    .withMessage("Attendance ID must be a string"),
];

export const recordIdParamSchema: ValidationChain[] = [
  param("recordId")
    .notEmpty()
    .withMessage("Record ID is required")
    .isString()
    .withMessage("Record ID must be a string"),
];

// =============================================================================
// Bulk Create Records
// =============================================================================
export const bulkCreateRecordsSchema: ValidationChain[] = [
  param("id")
    .notEmpty()
    .withMessage("Attendance ID is required")
    .isString()
    .withMessage("Attendance ID must be a string"),
  body("attendanceId")
    .optional()
    .isString()
    .withMessage("attendanceId must be a string"),
  body("records")
    .notEmpty()
    .withMessage("records is required")
    .isArray({ min: 1 })
    .withMessage("records must be a non-empty array"),
  body("records.*.studentId")
    .notEmpty()
    .withMessage("Each record must have a studentId")
    .isString()
    .withMessage("studentId must be a string"),
  body("records.*.status")
    .notEmpty()
    .withMessage("Each record must have a status")
    .isIn(ATTENDANCE_STATUS)
    .withMessage(`status must be one of: ${ATTENDANCE_STATUS.join(", ")}`),
  body("records.*.note")
    .optional()
    .isString()
    .withMessage("note must be a string"),
];
