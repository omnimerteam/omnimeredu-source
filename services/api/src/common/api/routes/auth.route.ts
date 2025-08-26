import { Router } from "express";
const router = Router();

// Models → Repo → Service → Controller
import {
  Account,
  MembershipRequest,
  Role,
  School,
} from "../../../domain/models";
import { AuthController } from "../../../domain/controllers";
import { AuthService } from "../../../domain/services";
import {
  RoleRepository,
  AccountRepository,
  ActivityLogRepository,
  MembershipRequestRepository,
  SchoolRepository,
} from "../../../domain/repositories";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";

// Validator
import {
  changePasswordSchema,
  createAccountBodySchema,
  updatePasswordSchema,
} from "../../validators/account/account.validator";
import { authHeaderSchema } from "../../validators/header/header.validator";
import { DefaultLogger } from "../../utils/DefaultLogger";

const accountRepository = new AccountRepository(Account);
const roleRepository = new RoleRepository(Role);
const membershipRepository = new MembershipRequestRepository(MembershipRequest);
const schoolRepository = new SchoolRepository(School);
const logger = new DefaultLogger(new ActivityLogRepository());
const authService = new AuthService(
  roleRepository,
  accountRepository,
  logger,
  membershipRepository,
  schoolRepository
);
const authController = new AuthController(authService);

/**
 * @route POST /api/users/register
 * Đăng ký tài khoản mới: tạo Account & BaseUser, gán Role.
 * Body: { uid, email, fullName, gender, phone, role }
 */
router.post(
  "/register",
  validateData({ body: createAccountBodySchema }),
  (req, res, next) => authController.register(req, res, next)
);

/**
 * @route GET /api/users/login
 * header: Bearer idToken
 * Lấy thông tin user + role theo Firebase UID.
 * Yêu cầu xác thực Firebase token.
 */
router.get("/login", verifyFirebaseToken, verifyRole(), authController.login);

/**
 * @route GET /api/users/change-password
 * Đổi mật khẩu người dùng khi còn nhớ mật khẩu
 * Yêu cầu xác thực Firebase token.
 */
router.patch(
  "/change-password",
  validateData({ headers: authHeaderSchema, body: changePasswordSchema }),
  verifyFirebaseToken,
  (req, res, next) => authController.changePassword(req, res, next)
);

router.patch(
  "/forget-password",
  validateData({ headers: authHeaderSchema, body: updatePasswordSchema }),
  verifyFirebaseToken,
  (req, res, next) => authController.forgetPassword(req, res, next)
);

export default router;
