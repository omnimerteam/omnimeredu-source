import { NextFunction, Request, Response } from "express";
import { AuthService } from "../../services";
import {
  sendCreated,
  sendError,
  sendNotFound,
  sendSuccess,
  sendUnauthorized,
} from "../../../common/utils/ResponseHelper";
import admin from "../../../common/configs/firebaseAdminConfig";

/**
 * Controller: Authentication
 * Xử lý các request liên quan đến Auth (register, login, đổi mật khẩu...)
 */
class AuthController {
  private readonly authService: AuthService;

  constructor(authService: AuthService) {
    this.authService = authService;
  }
  /**
   * Đăng ký người dùng mới
   */
  async register(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const {
        email,
        password,
        schoolId,
        classId,
        baseUserInfo,
        specificInfo,
        schoolData,
      } = req.body;

      console.log(req.body);

      if (!email || !password || !baseUserInfo?.roleId) {
        sendError(
          res,
          "Thiếu thông tin bắt buộc: email, password hoặc roleId",
          400
        );
        return;
      }

      const user = await this.authService.registerUser(
        email.trim(),
        password,
        schoolId,
        classId,
        baseUserInfo,
        specificInfo,
        schoolData
      );

      sendCreated(res, null, `Đăng ký email ${user.account?.email} thành công`);
      return;
    } catch (error) {
      console.error("❌ [AuthController.register] Error:", error);
      return next(error);
    }
  }

  /**
   * Lấy thông tin user đã đăng nhập
   */
  async login(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const authHeader = req.headers.authorization;

      if (!authHeader?.startsWith("Bearer ")) {
        sendUnauthorized(res, "Token không hợp lệ hoặc không được cung cấp");
        return;
      }

      const idToken = authHeader.split("Bearer ")[1].trim();

      const decodedToken = await admin.auth().verifyIdToken(idToken);

      const user = await this.authService.login(decodedToken.uid);

      if (!user) {
        sendNotFound(res, "Không tìm thấy thông tin người dùng");
        return;
      }

      sendSuccess(res, { user: user.userId }, "Đăng nhập thành công");
      return;
    } catch (error: any) {
      console.error("❌ [AuthController.login] Error:", error.message);
      return next(error);
    }
  }

  /**
   * Đổi mật khẩu khi biết mật khẩu cũ
   */
  async changePassword(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const { oldPassword, newPassword } = req.body;

      if (!actorId) {
        sendError(res, "Không tìm thấy người dùng", 401);
        return;
      }

      await this.authService.changePassword(actorId, oldPassword, newPassword);
      sendSuccess(res, null, "Đổi mật khẩu thành công");
      return;
    } catch (error) {
      console.error("❌ [AuthController.changePassword] Error:", error);
      return next(error);
    }
  }

  /**
   * Đặt lại mật khẩu khi quên
   */
  async forgetPassword(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const { newPassword } = req.body;

      if (!actorId) {
        sendError(res, "Không tìm thấy người dùng", 401);
        return;
      }

      await this.authService.forgetPassword(actorId, newPassword);
      sendSuccess(res, null, "Đặt lại mật khẩu thành công");
      return;
    } catch (error) {
      console.error("❌ [AuthController.forgetPassword] Error:", error);
      return next(error);
    }
  }
}

export default AuthController;
