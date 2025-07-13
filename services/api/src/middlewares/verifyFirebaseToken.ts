import { Request, Response, NextFunction } from "express";
import admin from "../configs/firebaseAdminConfig";

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

    req.user = decodedToken;
    console.log("✅ Firebase Token OK:", decodedToken.uid);
    next();
  } catch (err: any) {
    console.error("❌ verifyFirebaseToken error:", err.message);
    res.status(401).json({ message: "Invalid token" });
    return; // ✅
  }
};
