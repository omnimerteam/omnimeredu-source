export {
  requireRole,
  requirePermission,
  requireOwnershipOrAdmin,
  requireSameSchool,
  ROLE_PERMISSIONS,
  type UserRole,
} from "./rbac.middleware";

import { authMiddleware } from "shared-lib";

// Adapter to match previous usage of JWTMiddleware class with static verifyToken method
export const JWTMiddleware = {
  verifyToken: authMiddleware,
};

export type { TokenPayload as JWTPayload } from "shared-lib";
