import { Router } from "express";
const router = Router();

// Models → Repo → Service → Controller
import {
  Account,
  MembershipRequest,
  Role,
  School,
} from "../../../domain/models";
import AuthJwtController from "../../../domain/controllers/user/authJwt.controller";
import AuthJwtService from "../../../domain/services/user/authJwt.service";
import {
  RoleRepository,
  AccountRepository,
  ActivityLogRepository,
  MembershipRequestRepository,
  SchoolRepository,
} from "../../../domain/repositories";

// Middleware
import { verifyJWTToken } from "../middlewares/verifyJWTToken.middleware";
import { validateData } from "../middlewares/validateData";

// Validator
import {
  changePasswordSchema,
  createAccountBodySchema,
  updatePasswordSchema,
} from "../../validators/auth/account/account.validator";
import { DefaultLogger } from "../../utils/DefaultLogger";

// Initialize repositories and service
const accountRepository = new AccountRepository(Account);
const roleRepository = new RoleRepository(Role);
const membershipRepository = new MembershipRequestRepository(MembershipRequest);
const schoolRepository = new SchoolRepository(School);
const logger = new DefaultLogger(new ActivityLogRepository());

const authJwtService = new AuthJwtService(
  roleRepository,
  accountRepository,
  logger,
  membershipRepository,
  schoolRepository
);
const authJwtController = new AuthJwtController(authJwtService);

/**
 * @route POST /api/auth-jwt/register
 * Đăng ký tài khoản mới: tạo Account & BaseUser, gán Role.
 * Không dùng Firebase Auth, sử dụng UUID làm uid
 * Body: { email, password, schoolId, classId, baseUserInfo, specificInfo, schoolData }
 */
router.post(
  "/register",
  validateData({ body: createAccountBodySchema }),
  (req, res, next) => authJwtController.register(req, res, next)
);

/**
 * @route POST /api/auth-jwt/login
 * Đăng nhập bằng email/password
 * Trả về user info + accessToken + refreshToken
 * Body: { email, password }
 */
router.post("/login", (req, res, next) =>
  authJwtController.login(req, res, next)
);

/**
 * @route POST /api/auth-jwt/refresh-token
 * Làm mới access token bằng refresh token
 * Body: { refreshToken }
 */
router.post("/refresh-token", (req, res, next) =>
  authJwtController.refreshToken(req, res, next)
);

/**
 * @route GET /api/auth-jwt/me
 * Lấy thông tin user hiện tại từ access token
 * Dùng khi reload app để lấy lại dữ liệu đăng nhập
 * Yêu cầu JWT access token
 */
router.get("/me", verifyJWTToken, (req, res, next) =>
  authJwtController.getMe(req, res, next)
);

/**
 * @route PATCH /api/auth-jwt/change-password
 * Đổi mật khẩu người dùng khi còn nhớ mật khẩu
 * Yêu cầu JWT access token
 * Body: { oldPassword, newPassword }
 */
router.patch(
  "/change-password",
  validateData({ body: changePasswordSchema }),
  verifyJWTToken,
  (req, res, next) => authJwtController.changePassword(req, res, next)
);

/**
 * @route PATCH /api/auth-jwt/forget-password
 * Đặt lại mật khẩu khi quên
 * Yêu cầu JWT access token (từ email reset link)
 * Body: { newPassword }
 */
router.patch(
  "/forget-password",
  validateData({ body: updatePasswordSchema }),
  verifyJWTToken,
  (req, res, next) => authJwtController.forgetPassword(req, res, next)
);

/**
 * @route POST /api/auth-jwt/logout
 * Đăng xuất - Xóa refresh token
 * Yêu cầu JWT access token
 */
router.post("/logout", verifyJWTToken, (req, res, next) =>
  authJwtController.logout(req, res, next)
);

export default router;
