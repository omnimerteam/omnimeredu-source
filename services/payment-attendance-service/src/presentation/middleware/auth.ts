/**
 * Auth Middleware Wrapper for Payment-Attendance Service
 * Re-exports auth utilities from shared-lib for easy import
 *
 * Usage:
 * import { authMiddleware, roleMiddleware, AuthenticatedRequest } from "../middleware/auth";
 */

// Note: shared-lib needs to be built with auth module before this will work
// For now, we provide a local implementation that mirrors shared-lib

import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

// JWT Configuration
const JWT_ACCESS_SECRET: string =
  process.env.JWT_ACCESS_SECRET || "your-access-secret-key";

/**
 * Token Payload Interface
 */
export interface TokenPayload {
  userId: string;
  email: string;
  roleKey: string;
  schoolId?: string;
  tokenId?: string;
}

/**
 * Extended Request interface with user information
 */
export interface AuthenticatedRequest extends Request {
  user?: TokenPayload;
}

/**
 * Extract Bearer token from Authorization header
 */
const extractBearerToken = (authHeader?: string): string | null => {
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return null;
  }
  return authHeader.substring(7);
};

/**
 * Verify and decode an access token
 */
const verifyAccessToken = (token: string): TokenPayload => {
  try {
    return jwt.verify(token, JWT_ACCESS_SECRET) as TokenPayload;
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      throw new Error("Access token has expired");
    } else if (error instanceof jwt.JsonWebTokenError) {
      throw new Error("Invalid access token");
    }
    throw error;
  }
};

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

    const token = extractBearerToken(authHeader);

    if (!token) {
      res.status(401).json({
        success: false,
        error: "Invalid authorization format",
        code: "INVALID_TOKEN_FORMAT",
      });
      return;
    }

    const decoded = verifyAccessToken(token);
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
      next();
      return;
    }

    const token = extractBearerToken(authHeader);

    if (token) {
      try {
        const decoded = verifyAccessToken(token);
        req.user = decoded;
      } catch {
        // Invalid token, continue without user
      }
    }

    next();
  } catch {
    next();
  }
};

/**
 * School-specific Authorization Middleware
 * Ensures user can only access resources from their own school
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
