import { Request, Response, NextFunction } from 'express';
import { ResponseUtil } from '../../../infrastructure/utils/ResponseUtil';

// Activity log interface
export interface ActivityLog {
  userId?: string;
  userRole?: string;
  action: string;
  resource: string;
  resourceId?: string;
  method: string;
  url: string;
  ip: string;
  userAgent?: string;
  statusCode?: number;
  duration?: number;
  timestamp: Date;
  metadata?: any;
}

// Activity logging middleware
export const activityLogger = (action: string, resource: string) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const startTime = Date.now();

    // Store original end function
    const originalEnd = res.end;

    // Override end function to log after response
    res.end = function(chunk?: any, encoding?: any) {
      // Calculate duration
      const duration = Date.now() - startTime;

      // Create activity log
      const log: ActivityLog = {
        userId: req.user?.id,
        userRole: req.user?.role,
        action,
        resource,
        resourceId: req.params.id || req.body.id,
        method: req.method,
        url: req.originalUrl,
        ip: req.ip,
        userAgent: req.get('User-Agent'),
        statusCode: res.statusCode,
        duration,
        timestamp: new Date(),
        metadata: {
          query: req.query,
          params: req.params,
          body: sanitizeRequestBody(req.body)
        }
      };

      // Log the activity (in production, this would go to a database or logging service)
      console.log('Activity Log:', JSON.stringify(log, null, 2));

      // Store log for potential use in audit trails
      if (!req.activityLogs) {
        req.activityLogs = [];
      }
      req.activityLogs.push(log);

      // Call original end
      originalEnd.call(this, chunk, encoding);
    };

    next();
  };
};

// Sanitize request body to remove sensitive information
const sanitizeRequestBody = (body: any): any => {
  if (!body || typeof body !== 'object') {
    return body;
  }

  const sensitiveFields = ['password', 'token', 'secret', 'key', 'authorization'];
  const sanitized: any = {};

  for (const [key, value] of Object.entries(body)) {
    if (sensitiveFields.some(field => key.toLowerCase().includes(field))) {
      sanitized[key] = '[REDACTED]';
    } else if (typeof value === 'object' && value !== null) {
      sanitized[key] = sanitizeRequestBody(value);
    } else {
      sanitized[key] = value;
    }
  }

  return sanitized;
};

// Request logger middleware for debugging
export const requestLogger = (req: Request, res: Response, next: NextFunction) => {
  const startTime = Date.now();

  console.log('Incoming Request:', {
    method: req.method,
    url: req.originalUrl,
    ip: req.ip,
    userAgent: req.get('User-Agent'),
    timestamp: new Date().toISOString(),
    user: req.user ? {
      id: req.user.id,
      email: req.user.email,
      role: req.user.role
    } : null
  });

  // Log response
  res.on('finish', () => {
    const duration = Date.now() - startTime;
    console.log('Response:', {
      method: req.method,
      url: req.originalUrl,
      statusCode: res.statusCode,
      duration: `${duration}ms`,
      timestamp: new Date().toISOString()
    });
  });

  next();
};

// Audit trail for critical operations
export const auditTrail = (req: Request, res: Response, next: NextFunction) => {
  const criticalOperations = [
    'DELETE',
    'POST',
    'PUT',
    'PATCH'
  ];

  if (criticalOperations.includes(req.method)) {
    // Store original json function
    const originalJson = res.json;

    // Override json to capture response data
    res.json = function(data: any) {
      // Create audit log
      const auditLog = {
        timestamp: new Date().toISOString(),
        user: req.user ? {
          id: req.user.id,
          email: req.user.email,
          role: req.user.role
        } : null,
        operation: {
          method: req.method,
          url: req.originalUrl,
          params: req.params,
          body: sanitizeRequestBody(req.body)
        },
        response: {
          statusCode: res.statusCode,
          data: data?.success ? undefined : data // Don't log successful response data to save space
        },
        ip: req.ip,
        userAgent: req.get('User-Agent')
      };

      // In production, this would be stored in a secure audit log system
      console.log('Audit Trail:', JSON.stringify(auditLog, null, 2));

      // Call original json
      return originalJson.call(this, data);
    };
  }

  next();
};

// Extend Express Request type to include activityLogs
declare global {
  namespace Express {
    interface Request {
      activityLogs?: ActivityLog[];
    }
  }
}