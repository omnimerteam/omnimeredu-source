import { Request, Response, NextFunction } from "express";
import admin from "../configs/firebaseAdminConfig";

/**
 * Middleware xác minh Firebase ID Token từ client gửi lên.
 */
export const verifyFirebaseToken = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      res.status(401).json({ message: "No token provided" });
      return;
    }

    const idToken = authHeader.split("Bearer ")[1];
    const decodedToken = await admin.auth().verifyIdToken(idToken);

    // Lưu thông tin user cho downstream
    req.user = decodedToken;

    console.log("✅ Firebase token verified:", decodedToken.uid);
    next();
  } catch (error: any) {
    console.error("❌ Invalid token:", error.message);
    res.status(401).json({ message: "Invalid token" });
  }
};
