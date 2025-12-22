import { Request, Response, NextFunction } from 'express';
import { ResponseUtil } from '../../../infrastructure/utils/ResponseUtil';

// Custom error class
export class AppError extends Error {
  public statusCode: number;
  public isOperational: boolean;
  public errorCode?: string;

  constructor(message: string, statusCode: number, errorCode?: string) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = true;
    this.errorCode = errorCode;

    Error.captureStackTrace(this, this.constructor);
  }
}

// Global error handler middleware
export const errorHandler = (
  error: Error | AppError,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  let statusCode = 500;
  let message = 'Internal Server Error';
  let errorCode = 'INTERNAL_SERVER_ERROR';

  // Handle operational errors
  if (error instanceof AppError) {
    statusCode = error.statusCode;
    message = error.message;
    errorCode = error.errorCode || 'APP_ERROR';
  }
  // Handle validation errors
  else if (error.name === 'ValidationError') {
    statusCode = 400;
    message = 'Validation Error';
    errorCode = 'VALIDATION_ERROR';
  }
  // Handle JWT errors
  else if (error.name === 'JsonWebTokenError') {
    statusCode = 401;
    message = 'Invalid token';
    errorCode = 'INVALID_TOKEN';
  }
  else if (error.name === 'TokenExpiredError') {
    statusCode = 401;
    message = 'Token expired';
    errorCode = 'TOKEN_EXPIRED';
  }
  // Handle database errors
  else if (error.name === 'SequelizeValidationError') {
    statusCode = 400;
    message = 'Database validation error';
    errorCode = 'DB_VALIDATION_ERROR';
  }
  else if (error.name === 'SequelizeUniqueConstraintError') {
    statusCode = 409;
    message = 'Resource already exists';
    errorCode = 'DUPLICATE_RESOURCE';
  }
  else if (error.name === 'SequelizeForeignKeyConstraintError') {
    statusCode = 400;
    message = 'Invalid reference';
    errorCode = 'INVALID_REFERENCE';
  }
  // Handle other known errors
  else if (error.name === 'CastError') {
    statusCode = 400;
    message = 'Invalid ID format';
    errorCode = 'INVALID_ID';
  }

  // Log error for debugging
  console.error('Error:', {
    name: error.name,
    message: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    userAgent: req.get('User-Agent'),
    timestamp: new Date().toISOString()
  });

  // Send error response
  ResponseUtil.sendError(res, message, {
    error: {
      name: error.name,
      message: error.message,
      errorCode
    }
  }, statusCode);
};

// Async error wrapper
export const asyncHandler = (fn: Function) => {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

// Not found handler
export const notFoundHandler = (req: Request, res: Response, next: NextFunction) => {
  const error = new AppError(`Route ${req.originalUrl} not found`, 404, 'ROUTE_NOT_FOUND');
  next(error);
};