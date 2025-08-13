import { Router } from "express";
import * as AuthController from "../controllers/auth.controller";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { createAccountBodySchema } from "../validators/account.validator";

const router = Router();

/**
 * @route POST /api/users/register
 * Đăng ký tài khoản mới: tạo Account & BaseUser, gán Role.
 * Body: { uid, email, fullName, gender, phone, role }
 */
router.post(
  "/register",
  validateData({ body: createAccountBodySchema }),
  AuthController.register
);

/**
 * @route GET /api/users/:uid
 * Lấy thông tin user + role theo Firebase UID.
 * Yêu cầu xác thực Firebase token.
 */
router.get("/login", verifyFirebaseToken, verifyRole(), AuthController.login);

export default router;
