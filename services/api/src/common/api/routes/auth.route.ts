import { Router } from "express";
import { AuthController } from "../../../domain/controllers";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import {
  changePasswordSchema,
  createAccountBodySchema,
  updatePasswordSchema,
} from "../../validators/account/account.validator";
import { authHeaderSchema } from "../../validators/header/header.validator";

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
 * @route GET /api/users/login
 * header: Bearer idToken
 * Lấy thông tin user + role theo Firebase UID.
 * Yêu cầu xác thực Firebase token.
 */
router.get("/login", verifyFirebaseToken, verifyRole(), AuthController.login);

/**
 * @route GET /api/users/change-password
 * Đổi mật khẩu người dùng khi còn nhớ mật khẩu
 * Yêu cầu xác thực Firebase token.
 */
router.patch(
  "/change-password",
  validateData({ headers: authHeaderSchema, body: changePasswordSchema }),
  verifyFirebaseToken,
  AuthController.changePassword
);

router.patch(
  "/forget-password",
  validateData({ headers: authHeaderSchema, body: updatePasswordSchema }),
  verifyFirebaseToken,
  AuthController.forgetPassword
);

export default router;
