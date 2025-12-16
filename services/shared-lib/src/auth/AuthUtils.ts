import * as jwt from 'jsonwebtoken';
import * as bcrypt from 'bcryptjs';
import { v4 as uuidv4 } from "uuid";

// JWT Configuration - Should be set via environment variables
const JWT_ACCESS_SECRET: string =
  process.env.JWT_ACCESS_SECRET || "your-access-secret-key";
const JWT_REFRESH_SECRET: string =
  process.env.JWT_REFRESH_SECRET || "your-refresh-secret-key";
const JWT_ACCESS_EXPIRY: string = process.env.JWT_ACCESS_EXPIRY || "15m";
const JWT_REFRESH_EXPIRY: string = process.env.JWT_REFRESH_EXPIRY || "7d";

/**
 * Token Payload Interface
 * Shared across all services for consistent JWT structure
 */
export interface TokenPayload {
  userId: string;
  email: string;
  roleKey: string;
  schoolId?: string;
  tokenId?: string; // Unique token identifier for refresh token
}

/**
 * Auth Utilities Class
 * Provides JWT generation, verification, and password hashing
 * Should be used by all services for consistent authentication
 */
export class AuthUtils {
  /**
   * Hash a password using bcrypt
   * @param password - Plain text password
   * @returns Hashed password
   */
  static async hashPassword(password: string): Promise<string> {
    const saltRounds = 10;
    return await bcrypt.hash(password, saltRounds);
  }

  /**
   * Compare a plain text password with a hashed password
   * @param password - Plain text password
   * @param hashedPassword - Hashed password
   * @returns True if passwords match, false otherwise
   */
  static async comparePassword(
    password: string,
    hashedPassword: string
  ): Promise<boolean> {
    return await bcrypt.compare(password, hashedPassword);
  }

  /**
   * Generate an access token (short-lived)
   * @param payload - Token payload containing user information
   * @returns JWT access token
   */
  static generateAccessToken(payload: TokenPayload): string {
    const { tokenId, ...payloadWithoutTokenId } = payload;
    return jwt.sign(payloadWithoutTokenId, JWT_ACCESS_SECRET, {
      expiresIn: JWT_ACCESS_EXPIRY as any,
    });
  }

  /**
   * Generate a refresh token (long-lived)
   * @param payload - Token payload containing user information
   * @returns JWT refresh token
   */
  static generateRefreshToken(payload: TokenPayload): string {
    const tokenWithId = {
      ...payload,
      tokenId: uuidv4(),
    };

    return jwt.sign(tokenWithId, JWT_REFRESH_SECRET, {
      expiresIn: JWT_REFRESH_EXPIRY as any,
    });
  }

  /**
   * Verify and decode an access token
   * @param token - JWT access token
   * @returns Decoded token payload
   */
  static verifyAccessToken(token: string): TokenPayload {
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
  }

  /**
   * Verify and decode a refresh token
   * @param token - JWT refresh token
   * @returns Decoded token payload
   */
  static verifyRefreshToken(token: string): TokenPayload {
    try {
      return jwt.verify(token, JWT_REFRESH_SECRET) as TokenPayload;
    } catch (error) {
      if (error instanceof jwt.TokenExpiredError) {
        throw new Error("Refresh token has expired");
      } else if (error instanceof jwt.JsonWebTokenError) {
        throw new Error("Invalid refresh token");
      }
      throw error;
    }
  }

  /**
   * Generate both access and refresh tokens
   * @param payload - Token payload containing user information
   * @returns Object containing both tokens
   */
  static generateTokenPair(payload: TokenPayload): {
    accessToken: string;
    refreshToken: string;
  } {
    return {
      accessToken: this.generateAccessToken(payload),
      refreshToken: this.generateRefreshToken(payload),
    };
  }

  /**
   * Extract Bearer token from Authorization header
   * @param authHeader - Authorization header value
   * @returns Token string or null
   */
  static extractBearerToken(authHeader?: string): string | null {
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return null;
    }
    return authHeader.substring(7);
  }

  /**
   * Decode token without verification (for debugging)
   * @param token - JWT token
   * @returns Decoded payload or null
   */
  static decodeToken(token: string): TokenPayload | null {
    try {
      return jwt.decode(token) as TokenPayload;
    } catch {
      return null;
    }
  }
}
