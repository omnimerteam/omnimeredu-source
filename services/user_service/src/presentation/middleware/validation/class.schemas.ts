import { body, query } from "express-validator";
import { handleValidationErrors } from "./common.schemas";

// Class creation validation
export const createClassSchema = [
  body('name').notEmpty().isLength({ min: 1, max: 100 }).withMessage('Name must be 1-100 characters'),
  body('code').notEmpty().isLength({ min: 1, max: 20 }).withMessage('Code must be 1-20 characters'),
  body('schoolId').notEmpty().withMessage('School ID is required'),
  body('gradeId').notEmpty().withMessage('Grade ID is required'),
  body('maxStudents').isInt({ min: 1, max: 100 }).withMessage('Max students must be between 1 and 100'),
  body('baseFee').optional().isFloat({ min: 0 }).withMessage('Base fee must be a non-negative number'),
  handleValidationErrors
];

// Class update validation
export const updateClassSchema = [
  body('name').optional().isLength({ min: 1, max: 100 }).withMessage('Name must be 1-100 characters'),
  body('code').optional().isLength({ min: 1, max: 20 }).withMessage('Code must be 1-20 characters'),
  body('maxStudents').optional().isInt({ min: 1, max: 100 }).withMessage('Max students must be between 1 and 100'),
  body('baseFee').optional().isFloat({ min: 0 }).withMessage('Base fee must be a non-negative number'),
  handleValidationErrors
];

// Class query validation for pagination
export const getClassesQuerySchema = [
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
  query('sortBy').optional().isIn(['name', 'code', 'maxStudents', 'baseFee']).withMessage('Invalid sort field'),
  query('sortOrder').optional().isIn(['asc', 'desc']).withMessage('Sort order must be asc or desc'),
  query('gradeId').optional().isMongoId().withMessage('Invalid grade ID format'),
  query('maxStudents').optional().isInt({ min: 1 }).withMessage('Max students must be a positive integer'),
  query('active').optional().isBoolean().withMessage('Active must be a boolean'),
  query('schoolId').optional().isMongoId().withMessage('Invalid school ID format'),
  handleValidationErrors
];

// Class search validation
export const searchClassesQuerySchema = [
  query('query').optional().isLength({ min: 1, max: 100 }).withMessage('Search query must be 1-100 characters'),
  query('schoolId').optional().isMongoId().withMessage('Invalid school ID format'),
  query('gradeId').optional().isMongoId().withMessage('Invalid grade ID format'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
  query('offset').optional().isInt({ min: 0 }).withMessage('Offset must be a non-negative integer'),
  handleValidationErrors
];

// Student operations validation
export const modifyStudentsBodySchema = [
  body('studentIds').isArray({ min: 1 }).withMessage('Student IDs must be an array with at least one element'),
  body('studentIds.*').isMongoId().withMessage('Invalid student ID format'),
  handleValidationErrors
];

// Transfer students validation
export const transferStudentsBodySchema = [
  body('toClassId').notEmpty().withMessage('Target class ID is required'),
  body('studentIds').isArray({ min: 1 }).withMessage('Student IDs must be an array with at least one element'),
  body('studentIds.*').isMongoId().withMessage('Invalid student ID format'),
  handleValidationErrors
];