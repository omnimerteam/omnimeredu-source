import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { ResponseUtil } from '../../../infrastructure/utils/ResponseUtil';

// Define the structure of JWT payload
export interface JWTPayload {
  id: string;
  email: string;
  role: string;
  schoolId?: string;
  iat?: number;
  exp?: number;
}

// Extend Express Request type to include user
declare global {
  namespace Express {
    interface Request {
      user?: JWTPayload;
    }
  }
}

export class JWTMiddleware {
  private static readonly JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

  /**
   * Verify JWT token and attach user to request
   */
  static verifyToken(req: Request, res: Response, next: NextFunction): void {
    try {
      // Get token from header
      const authHeader = req.headers.authorization;

      if (!authHeader) {
        ResponseUtil.sendError(res, 'No token provided', null, 401);
        return;
      }

      // Extract token from "Bearer <token>" format
      const token = authHeader.split(' ')[1];

      if (!token) {
        ResponseUtil.sendError(res, 'Invalid token format', null, 401);
        return;
      }

      // Verify token
      const decoded = jwt.verify(token, JWTMiddleware.JWT_SECRET) as JWTPayload;

      // Attach user to request
      req.user = decoded;

      next();
    } catch (error: any) {
      if (error.name === 'TokenExpiredError') {
        ResponseUtil.sendError(res, 'Token expired', null, 401);
      } else if (error.name === 'JsonWebTokenError') {
        ResponseUtil.sendError(res, 'Invalid token', null, 401);
      } else {
        ResponseUtil.sendError(res, 'Failed to authenticate token', null, 401);
      }
    }
  }

  /**
   * Generate JWT token
   */
  static generateToken(payload: Omit<JWTPayload, 'iat' | 'exp'>): string {
    return jwt.sign(payload, JWTMiddleware.JWT_SECRET, {
      expiresIn: '24h' // Token expires in 24 hours
    });
  }

  /**
   * Generate refresh token
   */
  static generateRefreshToken(payload: Omit<JWTPayload, 'iat' | 'exp'>): string {
    return jwt.sign(payload, JWTMiddleware.JWT_SECRET, {
      expiresIn: '7d' // Refresh token expires in 7 days
    });
  }
}