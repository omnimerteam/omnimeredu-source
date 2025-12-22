import { body, param, query, validationResult } from "express-validator";

// Common validation result handler
export const handleValidationErrors = (req: any, res: any, next: any) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      message: "Validation failed",
      errors: errors.array()
    });
  }
  next();
};

// Common validation rules
export const objectIdSchema = param('id').isMongoId().withMessage('Invalid ID format');

export const paginationQuerySchema = [
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
  query('sortBy').optional().isString().withMessage('Sort by must be a string'),
  query('sortOrder').optional().isIn(['asc', 'desc']).withMessage('Sort order must be asc or desc')
];

export const searchQuerySchema = [
  query('search').optional().isString().isLength({ min: 1, max: 100 }).withMessage('Search term must be 1-100 characters'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
  query('offset').optional().isInt({ min: 0 }).withMessage('Offset must be a non-negative integer')
];

// Authentication header validation
export const authHeaderSchema = [
  body('authorization').optional().isString().withMessage('Authorization header must be a string')
];