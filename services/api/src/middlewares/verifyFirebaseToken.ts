import { Request, Response, NextFunction } from "express";
import admin from "../configs/firebaseAdminConfig";
import { findUserByUid } from "../repositories/account.repository";
import { IRole } from "../models/Role";

/**
 * Middleware: Xác thực Firebase ID Token.
 * Gán req.user nếu token hợp lệ.
 */
export const verifyFirebaseToken = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) {
      res.status(401).json({ message: "No token provided" });
      return; // ✅
    }

    const idToken = authHeader.split("Bearer ")[1];
    const decodedToken = await admin.auth().verifyIdToken(idToken);

    // Kiểm tra thằng token đăng nhập có đúng của firebase không
    if (!decodedToken) {
      res.status(401).json({ message: "idToken Không chính xác!!!" });
      return;
    }
    console.log("✅ Firebase Token OK:", decodedToken.uid);

    // Đăng ký các thông tin user và role cho các bước tiếp  theo
    const profile = await findUserByUid(decodedToken.uid);
    // Kiểm tra tài khoản có hợp lệ trong tài khoản không
    if (!profile) {
      res.status(404).json({ message: "Không tìm thấy thông tin người dùng" });
      return;
    }

    req.user = profile;

    const user = profile.userId as any;

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

    (req as any).role = roleName;

    console.log(`Profile: ${profile} \n Role: ${roleName} `);

    next();
  } catch (err: any) {
    console.error("❌ verifyFirebaseToken error:", err.message);
    res.status(401).json({ message: "Invalid token" });
    return; // ✅
  }
};
