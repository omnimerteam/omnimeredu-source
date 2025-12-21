// Thư viện
import { Request, Response, NextFunction } from "express";
import chalk from "chalk";

// Helper function
import { sendForbidden, sendUnauthorized } from "../../utils/ResponseHelper";

// JWT Utils
import { verifyAccessToken, TokenPayload } from "../../utils/JwtHelper";

/**
 * Middleware: Xác thực JWT Access Token.
 * Gán req.user và req.role nếu hợp lệ.
 */
export const verifyJWTToken = async (
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

    const token = authHeader.split("Bearer ")[1].trim();
    let decodedToken: TokenPayload;

    try {
      decodedToken = verifyAccessToken(token);
    } catch (err: any) {
      sendUnauthorized(res, err.message || "Token không hợp lệ");
      return;
    }

    if (!decodedToken) {
      sendUnauthorized(res, "Token không hợp lệ");
      return;
    }

    req.user = {
      _id: decodedToken.userId,
      id: decodedToken.userId,
      email: decodedToken.email,
      roleId: decodedToken.roleId,
      schoolId: decodedToken.schoolId,
      classId: decodedToken.classId,
    };

    req.role = decodedToken.roleName;

    // Log giống verifyFirebaseToken
    console.log(
      chalk.greenBright(
        `[AUTH JWT ✅] User: ${decodedToken.userId}, Role: ${req.role}`
      )
    );

    return next();
  } catch (err: any) {
    console.error("❌ verifyJWTToken error:", err.message);
    sendUnauthorized(res, "Token không hợp lệ hoặc hết hạn");
    return;
  }
};
