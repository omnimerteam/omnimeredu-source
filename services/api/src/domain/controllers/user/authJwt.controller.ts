import { NextFunction, Request, Response } from "express";
import AuthJwtService from "../../services/user/authJwt.service";
import {
  sendCreated,
  sendError,
  sendNotFound,
  sendSuccess,
  sendUnauthorized,
} from "../../../common/utils/ResponseHelper";

/**
 * Controller: JWT Authentication
 * Xử lý các request liên quan đến Auth JWT (register, login, refresh token, đổi mật khẩu...)
 */
class AuthJwtController {
  private readonly authJwtService: AuthJwtService;

  constructor(authJwtService: AuthJwtService) {
    this.authJwtService = authJwtService;
  }

  /**
   * Đăng ký người dùng mới (JWT-based)
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

      const user = await this.authJwtService.registerUser(
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
      console.error("❌ [AuthJwtController.register] Error:", error);
      return next(error);
    }
  }

  /**
   * Đăng nhập bằng email/password
   * Trả về user info + accessToken + refreshToken
   */
  async login(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        sendError(res, "Vui lòng cung cấp email và password", 400);
        return;
      }

      const result = await this.authJwtService.login(email.trim(), password);

      sendSuccess(res, result, "Đăng nhập thành công");
      return;
    } catch (error: any) {
      console.error("❌ [AuthJwtController.login] Error:", error.message);
      return next(error);
    }
  }

  /**
   * Refresh access token
   */
  async refreshToken(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const { refreshToken } = req.body;

      if (!refreshToken) {
        sendError(res, "Vui lòng cung cấp refresh token", 400);
        return;
      }

      const result = await this.authJwtService.refreshToken(refreshToken);

      sendSuccess(res, result, "Làm mới token thành công");
      return;
    } catch (error: any) {
      console.error(
        "❌ [AuthJwtController.refreshToken] Error:",
        error.message
      );
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

      await this.authJwtService.changePassword(
        actorId,
        oldPassword,
        newPassword
      );
      sendSuccess(res, null, "Đổi mật khẩu thành công");
      return;
    } catch (error) {
      console.error("❌ [AuthJwtController.changePassword] Error:", error);
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

      await this.authJwtService.forgetPassword(actorId, newPassword);
      sendSuccess(res, null, "Đặt lại mật khẩu thành công");
      return;
    } catch (error) {
      console.error("❌ [AuthJwtController.forgetPassword] Error:", error);
      return next(error);
    }
  }

  /**
   * Logout - Xóa refresh token
   */
  async logout(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const actorId = req.user?.id;

      if (!actorId) {
        sendError(res, "Không tìm thấy người dùng", 401);
        return;
      }

      await this.authJwtService.logout(actorId);
      sendSuccess(res, null, "Đăng xuất thành công");
      return;
    } catch (error) {
      console.error("❌ [AuthJwtController.logout] Error:", error);
      return next(error);
    }
  }
}

export default AuthJwtController;
