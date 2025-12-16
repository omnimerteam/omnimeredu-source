import { Request, Response, NextFunction } from "express";
import { ResponseUtil } from "../../../infrastructure/utils/ResponseUtil";

import { RoleGroup } from "shared-lib";

// Define user roles
export type UserRole = RoleGroup;

// Define permissions for each role
export const ROLE_PERMISSIONS = {
  SuperAdmin: [
    "schools:create",
    "schools:read",
    "schools:update",
    "schools:delete",
    "schools:search",
    "grades:create",
    "grades:read",
    "grades:update",
    "grades:delete",
    "grades:select",
    "classes:create",
    "classes:read",
    "classes:update",
    "classes:delete",
    "classes:search",
    "classes:addStudents",
    "classes:removeStudents",
    "classes:transferStudents",
    "users:create",
    "users:read",
    "users:update",
    "users:delete",
  ],
  SchoolAdmin: [
    "schools:read",
    "schools:update",
    "grades:create",
    "grades:read",
    "grades:update",
    "grades:delete",
    "grades:select",
    "classes:create",
    "classes:read",
    "classes:update",
    "classes:delete",
    "classes:search",
    "classes:addStudents",
    "classes:removeStudents",
    "classes:transferStudents",
    "users:read",
    "users:create", // Limited to students/teachers in their school
  ],
  Teacher: [
    "classes:read",
    "classes:search",
    "grades:read",
    "grades:select",
    "users:read", // Limited to students in their classes
  ],
  Parent: [
    "classes:read",
    "grades:read",
    "grades:select",
    "users:read", // Limited to their own children
  ],
  Student: [
    "classes:read", // Limited to their own class
    "grades:read",
    "grades:select",
  ],
  Staff: ["classes:read", "grades:read", "users:read"],
};

/**
 * Check if user has required role
 */
export const requireRole = (roles: UserRole | UserRole[]) => {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      ResponseUtil.sendError(res, "Authentication required", null, 401);
      return;
    }

    const allowedRoles = Array.isArray(roles) ? roles : [roles];
    const userRole = req.user.roleKey as UserRole;

    if (!allowedRoles.includes(userRole)) {
      ResponseUtil.sendError(res, "Insufficient permissions", null, 403);
      return;
    }

    next();
  };
};

/**
 * Check if user has required permission
 */
export const requirePermission = (permission: string) => {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      ResponseUtil.sendError(res, "Authentication required", null, 401);
      return;
    }

    const userRole = req.user.roleKey as UserRole;
    const permissions = ROLE_PERMISSIONS[userRole] || [];

    if (!permissions.includes(permission)) {
      ResponseUtil.sendError(res, "Insufficient permissions", null, 403);
      return;
    }

    next();
  };
};

/**
 * Check if user can access their own resource or has admin privileges
 */
export const requireOwnershipOrAdmin = (resourceUserIdField = "userId") => {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      ResponseUtil.sendError(res, "Authentication required", null, 401);
      return;
    }

    const userRole = req.user.roleKey as UserRole;
    const userId = req.user.userId;

    // Admin roles can access any resource
    if (userRole === "SuperAdmin" || userRole === "SchoolAdmin") {
      next();
      return;
    }

    // Get resource owner ID from params, body, or query
    const resourceUserId =
      req.params[resourceUserIdField] ||
      req.body[resourceUserIdField] ||
      req.query[resourceUserIdField];

    // Check if user is accessing their own resource
    if (resourceUserId === userId) {
      next();
      return;
    }

    ResponseUtil.sendError(res, "Access denied", null, 403);
  };
};

/**
 * Check if user belongs to the same school (for SchoolAdmin, Teacher, etc.)
 */
export const requireSameSchool = () => {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      ResponseUtil.sendError(res, "Authentication required", null, 401);
      return;
    }

    const userRole = req.user.roleKey as UserRole;

    // SuperAdmin can access any school
    if (userRole === "SuperAdmin") {
      next();
      return;
    }

    // Get school ID from params or body
    const schoolId =
      req.params.schoolId || req.body.schoolId || req.query.schoolId;

    if (!schoolId) {
      ResponseUtil.sendError(res, "School ID not provided", null, 400);
      return;
    }

    // Check if user belongs to the specified school
    if (req.user.schoolId && req.user.schoolId !== schoolId) {
      ResponseUtil.sendError(res, "Access denied: Different school", null, 403);
      return;
    }

    next();
  };
};
