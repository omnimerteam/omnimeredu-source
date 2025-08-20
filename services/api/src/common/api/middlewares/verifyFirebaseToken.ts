// Thư viện
import { Request, Response, NextFunction } from "express";
import chalk from "chalk";

// Config
import admin from "../../configs/firebaseAdminConfig";

// Repositories
import { AccountRepository } from "../../../domain/repositories";

// Helper function
import {
  sendForbidden,
  sendNotFound,
  sendUnauthorized,
} from "../../utils/ResponseHelper";
import { extractRoleName } from "../../utils/RoleHelper";

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

    // Tìm user trong hệ thống backend
    const profile = await AccountRepository.findUserByUid(decodedToken.uid);

    if (!profile) {
      sendNotFound(res, "Người dùng chưa đăng ký tài khoản");
      return;
    }

    const user = profile.userId as any;

    const roleName = extractRoleName(user);

    if (!roleName) {
      sendForbidden(res, "Tài khoản chưa được cấp quyền");
      return;
    }

    // Gán lại vào req
    req.user = user;
    req.role = roleName;

    console.log(
      chalk.greenBright(`[AUTH ✅] User: ${req.user}, Role: ${req.role}`)
    );
    return next();
  } catch (err: any) {
    console.error("❌ verifyFirebaseToken error:", err.message);
    sendUnauthorized(res, "Token không hợp lệ hoặc hết hạn");
    return;
  }
};
