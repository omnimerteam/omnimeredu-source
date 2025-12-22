import { Request, Response, NextFunction } from "express";
import { AuthUtils, TokenPayload } from "./AuthUtils";

/**
 * Extended Request interface with user information
 */
export interface AuthenticatedRequest extends Request {
  user?: TokenPayload;
}

/**
 * JWT Authentication Middleware
 * Verifies the access token from Authorization header
 * Attaches user payload to request object
 */
export const authMiddleware = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
): void => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      res.status(401).json({
        success: false,
        error: "Authorization token is required",
        code: "UNAUTHORIZED",
      });
      return;
    }

    const token = AuthUtils.extractBearerToken(authHeader);

    if (!token) {
      res.status(401).json({
        success: false,
        error: "Invalid authorization format",
        code: "INVALID_TOKEN_FORMAT",
      });
      return;
    }

    const decoded = AuthUtils.verifyAccessToken(token);
    req.user = decoded;

    next();
  } catch (error: any) {
    if (error.message === "Access token has expired") {
      res.status(401).json({
        success: false,
        error: "Token has expired",
        code: "TOKEN_EXPIRED",
      });
      return;
    }

    res.status(401).json({
      success: false,
      error: "Invalid token",
      code: "INVALID_TOKEN",
    });
  }
};

/**
 * Role-based Authorization Middleware
 * Must be used after authMiddleware
 * @param allowedRoles - Array of role keys that are allowed
 */
export const roleMiddleware = (allowedRoles: string[]) => {
  return (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): void => {
    if (!req.user) {
      res.status(401).json({
        success: false,
        error: "Authentication required",
        code: "UNAUTHORIZED",
      });
      return;
    }

    const userRole = req.user.roleKey;

    if (!allowedRoles.includes(userRole)) {
      res.status(403).json({
        success: false,
        error: "You do not have permission to access this resource",
        code: "FORBIDDEN",
        requiredRoles: allowedRoles,
        userRole: userRole,
      });
      return;
    }

    next();
  };
};

/**
 * Optional Authentication Middleware
 * Does not fail if token is missing, but attaches user if valid token exists
 */
export const optionalAuthMiddleware = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
): void => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      // No token, continue without user
      next();
      return;
    }

    const token = AuthUtils.extractBearerToken(authHeader);

    if (token) {
      try {
        const decoded = AuthUtils.verifyAccessToken(token);
        req.user = decoded;
      } catch {
        // Invalid token, continue without user
      }
    }

    next();
  } catch {
    // Any error, continue without user
    next();
  }
};

/**
 * School-specific Authorization Middleware
 * Ensures user can only access resources from their own school
 * Must be used after authMiddleware
 * @param schoolIdExtractor - Function to extract schoolId from request
 */
export const schoolAuthMiddleware = (
  schoolIdExtractor: (req: AuthenticatedRequest) => string | undefined
) => {
  return (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): void => {
    if (!req.user) {
      res.status(401).json({
        success: false,
        error: "Authentication required",
        code: "UNAUTHORIZED",
      });
      return;
    }

    const requestedSchoolId = schoolIdExtractor(req);
    const userSchoolId = req.user.schoolId;

    // SuperAdmin can access all schools
    if (req.user.roleKey === "SuperAdmin") {
      next();
      return;
    }

    // Check if user belongs to the requested school
    if (requestedSchoolId && userSchoolId !== requestedSchoolId) {
      res.status(403).json({
        success: false,
        error: "You can only access resources from your own school",
        code: "SCHOOL_FORBIDDEN",
      });
      return;
    }

    next();
  };
};
