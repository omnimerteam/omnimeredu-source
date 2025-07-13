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
      if (!req.user) {
        res.status(401).json({ message: "Unauthorized: No user" });
        return;
      }

      const uid = req.user.uid;

      const account = await findUserByUid(uid);
      if (!account) {
        res.status(404).json({ message: "Account not found" });
        return;
      }

      const user = account.userId as any;
      let roleName: string | undefined;

      if (user && typeof user === "object" && "roleId" in user) {
        const role = user.roleId as IRole;
        roleName =
          typeof role === "object" && role !== null ? role.name : undefined;
      }

      if (!roleName) {
        res.status(403).json({ message: "No role assigned" });
        return;
      }

      // 🟢 ĐỪNG QUÊN: Nếu muốn TypeScript không lỗi, bạn cần mở rộng `Request` để có `.role` & `.accountId`!
      (req as any).role = roleName;
      (req as any).accountId = account._id.toString();

      console.log(`✅ Role: ${roleName} | accountId: ${account._id}`);

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
