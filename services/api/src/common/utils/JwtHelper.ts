import * as jwt from "jsonwebtoken";
import * as bcrypt from "bcryptjs";
import { v4 as uuidv4 } from "uuid";

// JWT Configuration
const JWT_ACCESS_SECRET: string =
  process.env.JWT_ACCESS_SECRET || "your-access-secret-key";
const JWT_REFRESH_SECRET: string =
  process.env.JWT_REFRESH_SECRET || "your-refresh-secret-key";
const JWT_ACCESS_EXPIRY: string = process.env.JWT_ACCESS_EXPIRY || "15m";
const JWT_REFRESH_EXPIRY: string = process.env.JWT_REFRESH_EXPIRY || "7d";

/**
 * Token Payload Interface
 * Includes necessary user info to minimize DB lookups
 */
export interface TokenPayload {
  userId: string; // Maps to BaseUser._id
  email: string; // Maps to Account.email
  roleName: string;
  roleId: string; // Maps to Role.name
  schoolId?: string; // Maps to BaseUser.schoolId
  classId?: string; // Maps to BaseUser.classId
}

/**
 * Hash a password using bcrypt
 */
export const hashPassword = async (password: string): Promise<string> => {
  const saltRounds = 10;
  return await bcrypt.hash(password, saltRounds);
};

/**
 * Compare a plain text password with a hashed password
 */
export const comparePassword = async (
  password: string,
  hashedPassword: string
): Promise<boolean> => {
  return await bcrypt.compare(password, hashedPassword);
};

/**
 * Generate an access token (short-lived)
 */
export const generateAccessToken = (payload: TokenPayload): string => {
  return jwt.sign(payload, JWT_ACCESS_SECRET, {
    expiresIn: JWT_ACCESS_EXPIRY as any,
  });
};

/**
 * Generate a refresh token (long-lived)
 */
export const generateRefreshToken = (payload: TokenPayload): string => {
  return jwt.sign(payload, JWT_REFRESH_SECRET, {
    expiresIn: JWT_REFRESH_EXPIRY as any,
  });
};

/**
 * Verify and decode an access token
 */
export const verifyAccessToken = (token: string): TokenPayload => {
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
 * Verify and decode a refresh token
 */
export const verifyRefreshToken = (token: string): TokenPayload => {
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
};

/**
 * Generate both access and refresh tokens
 */
export const generateTokenPair = (
  payload: TokenPayload
): {
  accessToken: string;
  refreshToken: string;
} => {
  return {
    accessToken: generateAccessToken(payload),
    refreshToken: generateRefreshToken(payload),
  };
};

/**
 * Extract Bearer token from Authorization header
 */
export const extractBearerToken = (authHeader?: string): string | null => {
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return null;
  }
  return authHeader.substring(7);
};

/**
 * Decode token without verification
 */
export const decodeToken = (token: string): TokenPayload | null => {
  try {
    return jwt.decode(token) as TokenPayload;
  } catch {
    return null;
  }
};
