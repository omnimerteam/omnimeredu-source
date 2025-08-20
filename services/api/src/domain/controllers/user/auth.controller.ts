import { NextFunction, Request, Response } from "express";
import { AuthService } from "../../services";
import {
  sendCreated,
  sendError,
  sendNotFound,
  sendSuccess,
} from "../../../common/utils/ResponseHelper";

/**
 * Đăng ký người dùng mới
 */

export const register = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const {
      email,
      password,
      baseUserInfo,
      specificInfo, // object chứa các field riêng của role
    } = req.body;

    if (!email || !password || !baseUserInfo?.roleId) {
      throw new Error("Thiếu thông tin bắt buộc: email, password hoặc roleId");
    }

    // Gọi service
    const user = await AuthService.registerUser(
      email.trim(),
      password,
      baseUserInfo,
      specificInfo || {}
    );

    sendCreated(res, user, "Đăng ký thành công");
  } catch (error: any) {
    console.error("❌ [register] Error:", error);
    next(error);
  }
};

/**
 * Lấy role hiện tại của user đã verify
 * -> Role đã được gán ở middleware verifyRole()
 */
export const login = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const user = req.user;

    if (!user) {
      sendNotFound(res, "Không tìm thấy thông tin người dùng");
      return;
    }

    sendSuccess(res, { user: user });
    return;
  } catch (error: any) {
    console.error("❌ getUserRole error:", error.message);
    return next(error);
  }
};

export const changePassword = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const actorId = req.user?.id;
    const { oldPassword, newPassword } = req.body;

    if (!actorId) {
      sendError(res, "Không tìm thấy người dùng", 401);
      return;
    }

    await AuthService.changePassword(actorId, oldPassword, newPassword);

    sendSuccess(res, null, "Đổi mật khẩu thành công");
    return;
  } catch (err: any) {
    return next(err);
  }
};

export const forgetPassword = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const actorId = req.user?.id;
    const { newPassword } = req.body;

    if (!actorId) {
      sendError(res, "Không tìm thấy người dùng", 401);
      return;
    }

    await AuthService.forgetPassword(actorId, newPassword);

    sendSuccess(res, null, "Đổi mật khẩu thành công");
    return;
  } catch (err: any) {
    return next(err);
  }
};
