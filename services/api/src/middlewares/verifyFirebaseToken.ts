import { Request, Response, NextFunction } from "express";
import admin from "../configs/firebaseAdminConfig";
import { findUserByUid } from "../repositories/account.repository";
import { IRole } from "../models/Role";
import {
  sendError,
  sendForbidden,
  sendUnauthorized,
} from "../utils/ResponseHelper";

/**
 * Middleware: Xác thực Firebase ID Token.
 * Gán req.user và req.role nếu hợp lệ.
 */
export const verifyFirebaseToken = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader?.startsWith("Bearer ")) {
      sendUnauthorized(res, "Token không hợp lệ hoặc không được cung cấp");
      return;
    }

    const idToken = authHeader.split("Bearer ")[1].trim();

    const decodedToken = await admin.auth().verifyIdToken(idToken);
    if (!decodedToken || !decodedToken.uid) {
      sendUnauthorized(res, "ID Token không hợp lệ");
      return;
    }

    console.log("✅ Firebase Token OK:", decodedToken.uid);

    // Tìm user trong hệ thống backend
    const profile = await findUserByUid(decodedToken.uid);

    if (!profile) {
      sendError(res, "Không tìm thấy thông tin người dùng", 404);
      return;
    }

    const user = profile.userId as any;

    // Lấy role từ user.userId.roleId
    let roleName: string | undefined;
    if (user && typeof user === "object" && "roleId" in user) {
      const role = user.roleId as IRole;
      if (role && typeof role === "object" && "name" in role) {
        roleName = role.name;
      }
    }

    if (!roleName) {
      sendForbidden(res, "Tài khoản chưa được gán quyền truy cập");
      return;
    }

    // Gán lại vào req
    req.user = profile.userId;
    req.role = roleName;



    console.log(`[AUTH ✅] User: ${req.user.id}, Role: ${req.role}`);
    return next();
  } catch (err: any) {
    console.error("❌ verifyFirebaseToken error:", err.message);
    sendUnauthorized(res, "Token không hợp lệ hoặc hết hạn");
    return;
  }
};
