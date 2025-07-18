import { Response, NextFunction } from "express";
import { Request } from "express";
import { findUserByUid } from "../repositories/account.repository";
import { IRole } from "../models/Role";

/**
 * Middleware: Phân quyền
 * Nếu `requiredRoles` rỗng => mọi role đều được qua
 * Nếu có => role user phải nằm trong danh sách
 */
export const verifyRole = (requiredRoles: string[] = []) => {
  return async (
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const roleName = req.role;

      if (!roleName) {
        res.status(404).json({ message: "Người dùng chưa được cấp vai trò" });
        return;
      }

      if (requiredRoles.length > 0 && !requiredRoles.includes(roleName)) {
        res.status(403).json({ message: "Access denied" });
        return;
      }

      next();
    } catch (error) {
      console.error("❌ verifyRole error:", error);
      res.status(500).json({ message: "Internal server error" });
      return;
    }
  };
};
