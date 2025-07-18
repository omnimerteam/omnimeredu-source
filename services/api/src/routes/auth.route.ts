import { Router } from "express";
import * as AuthController from "../controllers/auth.controller";
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

const router = Router();

/**
 * @route POST /api/users/register
 * Đăng ký tài khoản mới: tạo Account & BaseUser, gán Role.
 * Body: { uid, email, fullName, gender, phone, role }
 */
router.post("/register", AuthController.register);

/**
 * @route GET /api/users/:uid
 * Lấy thông tin user + role theo Firebase UID.
 * Yêu cầu xác thực Firebase token.
 */
router.get(
  "/role",
  verifyFirebaseToken,
  verifyRole(),
  AuthController.getUserRole
);

export default router;
